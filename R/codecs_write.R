#' Define the codecs applied when writing a Zarr array
#'
#' The `codecs` argument of [write_zarr_array()] and
#' [create_empty_zarr_array()] takes a list of codecs, in the order they are
#' applied when writing a chunk: at most one 'array-to-bytes' codec, which
#' turns the array into bytes, followed by any number of 'bytes-to-bytes'
#' codecs (the [compressors]).
#'
#' `use_vlen_utf8()` is the 'array-to-bytes' codec for variable-length UTF-8
#' strings, used with `data_type = "|O"`. When no 'array-to-bytes' codec is
#' given, VLen-UTF8 is used for `"|O"` arrays and `bytes` for all others.
#'
#' Zarr v2 records at most one compressor, so Zarr v2 arrays accept at most
#' one 'bytes-to-bytes' codec.
#'
#' @returns A list describing the codec, in the same form as the
#'   [compressors].
#'
#' @examples
#' x <- array(c("a", "bb", "ccc"), dim = 3)
#' path <- withr::local_tempfile(fileext = ".zarr")
#' write_zarr_array(
#'   x, path,
#'   chunk_dim = 2,
#'   data_type = "|O",
#'   codecs = list(use_vlen_utf8(), use_zstd())
#' )
#' read_zarr_array(path)
#'
#' @name codecs
#' @export
use_vlen_utf8 <- function() {
  list(id = "vlen-utf8")
}

#' Error if both `compressor` and `codecs` are given
#'
#' A `compressor` of `NULL` counts as not given, as `write_zarr_array()` passes
#' `compressor = NULL` on to `create_empty_zarr_array()` when `codecs` is given.
#'
#' @keywords internal
#' @noRd
.check_compressor_or_codecs <- function(
  compressor,
  codecs,
  compressor_missing
) {
  if (!compressor_missing && !is.null(compressor) && !is.null(codecs)) {
    stop(
      "Only one of `compressor` and `codecs` can be given. ",
      "Add the compressor to `codecs` instead.",
      call. = FALSE
    )
  }
}

#' Check a list of codecs given for writing and fill in the defaults
#'
#' @param codecs A list of codecs as returned by `use_*()`, or `NULL`.
#' @param compressor A compressor as returned by `use_*()`, or `NULL`. Only
#'   used when `codecs` is `NULL`.
#' @param data_type The Numpy data type of the array.
#' @param zarr_version The version of the Zarr specification.
#'
#' @returns A list with elements `array_bytes` (one codec) and `bytes_bytes`
#'   (a possibly empty list of codecs), each codec in the `use_*()` form.
#'
#' @keywords internal
#' @noRd
.resolve_codecs <- function(codecs, compressor, data_type, zarr_version) {
  if (is.null(codecs)) {
    codecs <- list()
    if (!is.null(compressor)) {
      if (!is.list(compressor)) {
        stop(
          "`compressor` must be a compressor such as `use_zstd()`, or `NULL`.",
          call. = FALSE
        )
      }
      codecs <- list(compressor)
    }
  }
  kind <- .check_codecs(codecs)

  is_object <- identical(data_type, "|O")
  if (any(kind == "array_bytes")) {
    array_bytes <- codecs[[which(kind == "array_bytes")]]
  } else if (is_object) {
    array_bytes <- use_vlen_utf8()
  } else {
    array_bytes <- list(id = "bytes")
  }
  .check_array_bytes_codec(array_bytes, is_object)

  bytes_bytes <- unname(codecs[kind == "bytes_bytes"])
  if (zarr_version == 2L && length(bytes_bytes) > 1L) {
    stop(
      "Zarr v2 arrays can have at most one compressor, but ",
      length(bytes_bytes),
      " were given. Use `zarr_version = 3L` to chain compressors.",
      call. = FALSE
    )
  }
  nbytes <- parse_npy_datatype(data_type)$nbytes
  bytes_bytes <- lapply(bytes_bytes, function(codec) {
    if (codec$id == "blosc") {
      codec$typesize <- codec$typesize %||% nbytes
      if (is.na(codec$typesize)) {
        # e.g., vlen-utf8
        codec$typesize <- 1L
      }
    }
    codec
  })

  list(array_bytes = array_bytes, bytes_bytes = bytes_bytes)
}

#' Check the form and order of a list of codecs
#'
#' @returns For each codec, whether it is `"array_bytes"` or `"bytes_bytes"`.
#'
#' @keywords internal
#' @noRd
.check_codecs <- function(codecs) {
  if (!is.list(codecs) || !all(vapply(codecs, is.list, logical(1L)))) {
    stop(
      "`codecs` must be a list of codecs, such as ",
      "`list(use_vlen_utf8(), use_zstd())`.",
      call. = FALSE
    )
  }
  ids <- vapply(codecs, function(x) x$id %||% "<unnamed>", character(1L))

  kind <- rep(NA_character_, length(ids))
  kind[ids %in% CODEC_ARRAY_BYTES] <- "array_bytes"
  kind[ids %in% CODEC_BYTES_BYTES] <- "bytes_bytes"
  if ("transpose" %in% ids) {
    stop(
      "The array layout is set with `order`, not with a `transpose` codec.",
      call. = FALSE
    )
  }
  if (anyNA(kind) || "sharding_indexed" %in% ids) {
    unsupported <- ids[is.na(kind) | ids == "sharding_indexed"]
    stop(
      "The following codecs are not supported for writing: ",
      toString(unsupported),
      ". Please open an issue requesting support at ",
      "https://github.com/Huber-group-EMBL/Rarr/issues.",
      call. = FALSE
    )
  }
  # numcodecs.lz4 is an alias of lz4
  canonical_ids <- ids
  canonical_ids[canonical_ids == "numcodecs.lz4"] <- "lz4"
  if (anyDuplicated(canonical_ids)) {
    stop(
      "Each codec can only be given once, but found ",
      toString(unique(canonical_ids[duplicated(canonical_ids)])),
      " more than once.",
      call. = FALSE
    )
  }
  if (sum(kind == "array_bytes") > 1L) {
    stop(
      "At most one 'array-to-bytes' codec can be given, but found ",
      toString(ids[kind == "array_bytes"]),
      ".",
      call. = FALSE
    )
  }
  if (is.unsorted(match(kind, c("array_bytes", "bytes_bytes")))) {
    stop(
      "The 'array-to-bytes' codec must come before the compressors. ",
      "Put `",
      ids[kind == "array_bytes"],
      "` first in `codecs`.",
      call. = FALSE
    )
  }
  kind
}

#' Check that the 'array-to-bytes' codec suits the data type
#'
#' @keywords internal
#' @noRd
.check_array_bytes_codec <- function(codec, is_object) {
  if (length(codec) > 1L) {
    stop(
      "The `",
      codec$id,
      "` codec takes no options when writing. ",
      "The byte order of `bytes` is set by `data_type` (for example \"<i4\").",
      call. = FALSE
    )
  }
  if (is_object && codec$id == "bytes") {
    stop(
      "Arrays of `data_type = \"|O\"` need a variable-length codec, ",
      "such as `use_vlen_utf8()`, not `bytes`.",
      call. = FALSE
    )
  }
  if (!is_object && codec$id == "vlen-utf8") {
    stop(
      "`use_vlen_utf8()` requires `data_type = \"|O\"`.",
      call. = FALSE
    )
  }
}

#' Convert a codec from the `use_*()` form to the Zarr v3 metadata form
#'
#' @keywords internal
#' @noRd
.codec_v3 <- function(codec) {
  configuration <- codec[names(codec) != "id"]
  res <- list(name = codec$id)
  if (length(configuration) > 0L) {
    res$configuration <- configuration
  }
  res
}
