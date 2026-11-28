#' Convert the metadata `codecs` elements into functions
#'
#' @param codecs A list containing the Zarr v3 codecs
#' @param operation One of "encode" or "decode"
#'
#' @returns An list of 3 lists containing functions:
#' - `bytes_bytes_codecs`: functions to encode/decode raw bytes
#' - `array_array_codecs`: functions to encode/decode R arrays
#' - `array_bytes_codecs`: functions to encode/decode between R arrays and raw bytes
#'
#' @keywords internal
#' @noRd
.configure_codecs <- function(codecs, operation = c("encode", "decode")) {
  codecs_names <- names(codecs)
  operation <- match.arg(operation)

  bytes_bytes_codecs <- intersect(codecs_names, CODEC_BYTES_BYTES)
  array_array_codecs <- intersect(codecs_names, CODEC_ARRAY_ARRAY)
  array_bytes_codecs <- intersect(codecs_names, CODEC_ARRAY_BYTES)

  if (length(array_bytes_codecs) != 1L) {
    stop(
      "A Zarr array must define exactly one 'array-bytes' codec (",
      toString(CODEC_ARRAY_BYTES),
      "), but found ",
      length(array_bytes_codecs),
      " in the array metadata: ",
      toString(array_bytes_codecs),
      call. = FALSE
    )
  }

  unsupported_codecs <- setdiff(
    codecs_names,
    c(
      bytes_bytes_codecs,
      array_array_codecs,
      array_bytes_codecs
    )
  )
  if (operation == "encode" && "delta" %in% array_array_codecs) {
    # delta does not have a spec so we reject it for writing data
    unsupported_codecs <- c(unsupported_codecs, "delta")
  }
  if (length(unsupported_codecs) > 0L) {
    stop(
      "The following codecs are not supported: ",
      toString(unsupported_codecs),
      ". ",
      "Please open an issue requesting support at ",
      "https://github.com/Huber-group-EMBL/Rarr/issues.",
      call. = FALSE
    )
  }

  bytes_bytes_env <- list()
  array_array_env <- list()
  array_bytes_env <- list()

  for (candidate_codec in array_array_codecs) {
    cfg <- codecs[[candidate_codec]]$configuration
    if (candidate_codec == "delta") {
      # Encoding is already rejected above; only decoding reaches here
      dt <- parse_npy_datatype(cfg$dtype)
      data_type <- .convert_dtype_version(
        dt$base_type,
        dt$nbytes,
        dt$endian,
        2L,
        3L
      )
      array_array_env[["delta"]] <- Partial(
        codec_delta_decode,
        data_type = data_type
      )
    }
    if (candidate_codec == "transpose") {
      # R is already F ordered, so we reverse the order in config
      order <- unlist(cfg$order) + 1L
      if (length(order) > 1L && !is.consecutive(order, direction = "either")) {
        stop(
          "This transpose configuration is currently unsupported. ",
          "Please open an issue requesting support at ",
          "https://github.com/Huber-group-EMBL/Rarr/issues.",
          call. = FALSE
        )
      }
      if ("sharding_indexed" %notin% array_bytes_codecs) {
        # For sharding_indexed, the bytes->array function already transposes the
        # array, so we don't need to reverse the order here.
        # FIXME: I'm probably overcomplicating this. A better process within the
        # sharding codec would avoid the special case here.
        order <- rev(order)
      }
      if (is.unsorted(order)) {
        array_array_env[["transpose"]] <- switch(
          operation,
          "encode" = Partial(codec_transpose_encode, indices = order),
          "decode" = Partial(codec_transpose_decode, indices = order)
        )
      }
    }
  }

  if ("sharding_indexed" %in% array_bytes_codecs) {
    cfg <- codecs[["sharding_indexed"]]$configuration
    inner_codecs <- cfg$codecs
    inner_codecs <- inner_codecs |>
      setNames(vapply(
        inner_codecs,
        function(x) x$name,
        FUN.VALUE = character(1L)
      ))
    # Inner chunks are C-ordered like any other chunk, so inject the same default
    # transpose codec that is added for unsharded arrays.
    if (is.null(inner_codecs[["transpose"]])) {
      inner_codecs <- c(
        list(
          transpose = list(
            name = "transpose",
            # Better than seq_along() - 1L for ALTREP representation
            configuration = list(
              order = seq.int(0L, length(cfg$chunk_shape) - 1L)
            )
          )
        ),
        inner_codecs
      )
    }
    configured_inner_codecs <- .configure_codecs(
      inner_codecs,
      operation = operation
    )
    codecs[[
      "sharding_indexed"
    ]]$configuration$configured_inner_codecs <- configured_inner_codecs
  }

  # No loop here since there is always a single array_bytes codec
  cfg <- codecs[[array_bytes_codecs]]$configuration %||% NA_character_
  func_name <- paste("codec", array_bytes_codecs, operation, sep = "_")
  array_bytes_env[[array_bytes_codecs]] <- Partial_with_splicing(
    func_name,
    !!!cfg
  )

  # Compressors
  for (candidate_codec in bytes_bytes_codecs) {
    cfg <- codecs[[candidate_codec]]$configuration
    # Aliases
    candidate_codec <- switch(
      candidate_codec,
      "numcodecs.lz4" = "lz4",
      "numcodecs.zlib" = "zlib",
      "numcodecs.bz2" = "bz2",
      "numcodecs.lzma" = "lzma",
      "zstd" = if (has_zstd()) {
        "zstd"
      } else {
        "zstd_custom"
      },
      candidate_codec
    )
    if (candidate_codec == "zstd_custom") {
      w <- warningCondition(
        paste0(
          "Rarr now relies on the base R `memCompress()` and `memDecompress()` ",
          "functions for zstd with the expectation it is available everywhere. ",
          "If you are seeing this warning, it means your R installation does ",
          "not have zstd support. Please report at ",
          "https://github.com/Huber-group-EMBL/Rarr/issues.\n",
          "If no reports are received, this support will be removed in a ",
          "future release.\n",
          "You can silence this warning by setting ",
          "`globalCallingHandlers(RarrZstdMissingWarning = ",
          "function(w) invokeRestart(\"muffleWarning\"))`."
        ),
        class = "RarrZstdMissingWarning"
      )
      warning(w)
    }
    func_name <- paste(
      "codec",
      candidate_codec,
      operation,
      sep = "_"
    )
    bytes_bytes_env[[candidate_codec]] <- Partial_with_splicing(
      func_name,
      !!!cfg
    )
  }

  return(
    list(
      array_array = array_array_env,
      bytes_bytes = bytes_bytes_env,
      array_bytes = array_bytes_env
    )
  )
}
