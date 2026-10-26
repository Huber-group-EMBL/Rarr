.create_chunk_names <- function(chunk_indices, metadata) {
  if (nrow(chunk_indices) == 0L) {
    # In the DelayedArray framework, we can have integer(0) indices
    # https://github.com/Huber-group-EMBL/Rarr/issues/112.
    return(character(0L))
  }
  if (metadata$zarr_format == 3L && identical(metadata$shape, 1L)) {
    # Special case for scalar in v3
    return("c")
  }

  dim_separator <- metadata$chunk_key_encoding$configuration$separator %||% "/"

  # Faster and ready for https://github.com/zarr-developers/zarr-extensions/pull/69
  chunk_name_template <- paste(
    rep("%s", ncol(chunk_indices)),
    collapse = dim_separator
  )
  if (metadata$zarr_format == 3L) {
    chunk_name_template <- paste("c", chunk_name_template, sep = dim_separator)
  }

  chunk_names <- do.call(sprintf, c(chunk_name_template, chunk_indices))

  return(chunk_names)
}

#' Precompute index positions grouped by chunk
#'
#' For each chunk touched by `index`, returns the positions (1-based) within
#' each dimension of `index` that fall inside that chunk, together with the
#' within-chunk indices needed to extract values from the chunk array.
#'
#' @param index A list of integer vectors, one per dimension, giving the
#'   requested array indices (1-based).
#' @param metadata List of array metadata as returned by `.read_array_metadata()`.
#'   Used to derive chunk name keys via `.create_chunk_names()`.
#' @param chunk_dim Integer vector of length equal to the number of dimensions
#'   of the array, specifying the size of each chunk in each dimension.
#'
#' @returns A named list keyed by chunk names (same format as
#'   `.create_chunk_names()`, e.g. `"c/0/1/0"` for Zarr V3).  Each element is
#'   a list with two components:
#'   * `positions`: a per-dimension list of integer vectors of positions into
#'     the corresponding `index` vector that map to that chunk.
#'   * `index_in_chunk`: a per-dimension list of 1-based integer vectors
#'     giving the within-chunk coordinates corresponding to `positions`.
#'
#' @keywords internal
#' @noRd
.chunk_positions_by_chunk <- function(
  index,
  metadata,
  chunk_dim = unlist(metadata$chunk_grid$configuration$chunk_shape)
) {
  if (!is.integer(chunk_dim)) {
    chunk_dim <- as.integer(chunk_dim)
  }

  # We try 3 approaches, from the most efficient / most specific to the least
  # efficient / most general:
  # 1. The index is a run of consecutive integers starting at 1: we can chop it
  #    directly into the chunk positions.
  # 2. The index is a run of consecutive integers starting anywhere: we can
  #    compute chunk positions without expanding potentially compact sequences.
  # 3. The index is arbitrary: we fall back to computing the modulus for each
  #    element.
  results_by_dim <- mapply(
    \(dim_index, chunk_size) {
      # FIXME: add a fast path for decreasing consecutive sequences.
      consecutive <- is.consecutive(dim_index, direction = "increasing")
      if (consecutive && dim_index[1L] == 1L) {
        chopped <- .Call("chop_vec", dim_index, chunk_size, PACKAGE = "Rarr")
        positions_by_chunk <- setNames(chopped, 0L:(length(chopped) - 1L))
        list(
          per_dim = positions_by_chunk,
          in_chunk = lapply(positions_by_chunk, seq_along)
        )
      } else if (consecutive) {
        n <- length(dim_index)
        start0 <- dim_index[1L] - 1L
        first_chunk <- start0 %/% chunk_size
        offset <- start0 - first_chunk * chunk_size
        first_len <- min(n, chunk_size - offset)
        rest <- n - first_len
        lens <- c(
          first_len,
          rep.int(chunk_size, rest %/% chunk_size)
        )
        last_len <- rest %% chunk_size
        if (last_len > 0L) {
          lens <- c(lens, last_len)
        }
        starts <- cumsum(c(1L, lens[-length(lens)]))
        ids <- first_chunk + seq_along(lens) - 1L
        list(
          per_dim = setNames(
            mapply(seq.int, starts, length.out = lens, SIMPLIFY = FALSE),
            ids
          ),
          in_chunk = setNames(
            mapply(
              seq.int,
              c(offset + 1L, rep.int(1L, length(lens) - 1L)),
              length.out = lens,
              SIMPLIFY = FALSE
            ),
            ids
          )
        )
      } else {
        index0 <- reindex(dim_index, from = 1L, to = 0L)
        chunk_id <- index0 %/% chunk_size
        # We compute the remainder "manually" to avoid expensive %% call,
        # when %/% did all the work already
        index_in_chunk <- index0 - chunk_id * chunk_size + 1L
        positions_by_chunk <- split(seq_along(chunk_id), chunk_id)
        list(
          per_dim = positions_by_chunk,
          in_chunk = lapply(positions_by_chunk, \(pos) index_in_chunk[pos])
        )
      }
    },
    index,
    chunk_dim,
    SIMPLIFY = FALSE
  )
  per_dim <- lapply(results_by_dim, `[[`, "per_dim")
  in_chunk <- lapply(results_by_dim, `[[`, "in_chunk")

  chunk_keys <- do.call(expand.grid, lapply(per_dim, names))
  key_strings <- .create_chunk_names(chunk_keys, metadata)
  key_pos <- do.call(expand.grid, lapply(per_dim, seq_along))

  # Full cross-product of positions and in-chunk indices for each dimension, grouped by dim.
  by_dim <- mapply(
    \(pd, ic, kk) list(positions = pd[kk], in_chunk = ic[kk]),
    per_dim,
    in_chunk,
    key_pos,
    SIMPLIFY = FALSE
  )
  positions_by_dim <- lapply(by_dim, `[[`, "positions")
  in_chunk_by_dim <- lapply(by_dim, `[[`, "in_chunk")

  # Full cross-product of positions and in-chunk indices for each chunk, grouped by chunk.
  positions_per_chunk <- .mapply(list, positions_by_dim, NULL)
  in_chunk_per_chunk <- .mapply(list, in_chunk_by_dim, NULL)

  setNames(
    mapply(
      \(pos, ic) list(positions = pos, index_in_chunk = ic),
      positions_per_chunk,
      in_chunk_per_chunk,
      SIMPLIFY = FALSE
    ),
    key_strings
  )
}
