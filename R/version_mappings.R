.convert_metadata_version <- function(metadata, version_from, version_to) {
  if (version_from != 2L || version_to != 3L) {
    # nocov start
    stop(
      "Only conversion from version 2 to version 3 is supported.",
      call. = FALSE
    )
    # nocov end
  }

  dt <- metadata$datatype

  if (length(metadata$shape) == 0L) {
    # Empty tuple in shape means we are dealing with a scalar.
    metadata$shape <- metadata$chunks <- 1L
  }

  metadata_v3 <- list(
    node_type = "array",
    zarr_format = metadata$zarr_format,
    datatype = dt,
    data_type = .convert_dtype_version(
      dt$base_type,
      dt$nbytes,
      dt$endian,
      version_from,
      version_to
    ),
    shape = metadata$shape,
    chunk_grid = list(
      name = "regular",
      configuration = list(chunk_shape = metadata$chunks)
    ),
    chunk_key_encoding = if (metadata$zarr_format == 2L) {
      list(
        name = "v2",
        configuration = list(
          separator = metadata$dimension_separator %||% "."
        )
      )
    } else {
      list(
        name = "default",
        configuration = list(
          separator = metadata$dimension_separator %||% "/"
        )
      )
    },
    fill_value = metadata$fill_value,
    codecs = list()
  )

  # Transpose codec only makes sense for more than 1 dimension
  if (length(metadata_v3$shape) > 1L) {
    metadata_v3$codecs$transpose <- list(
      name = "transpose",
      configuration = list(
        order = switch(
          metadata$order,
          # default in numpy is "C"
          "C" = seq_along(metadata$shape) - 1L, # zero indexed
          "F" = rev(seq_along(metadata$shape)) - 1L
        )
      )
    )
  }

  for (filter in metadata$filters) {
    metadata_v3$codecs[[filter$id]] <- list(
      name = filter$id
    )
  }

  if (!is.null(metadata_v3$codecs[["vlen-utf8"]])) {
    # In v3, vlen-utf8 applies to 'string' type
    metadata_v3$data_type <- "string"
    metadata_v3$datatype$base_type <- "string"
  } else {
    metadata_v3$codecs$bytes <- list(
      name = "bytes",
      configuration = list("endian" = dt$endian %||% NA_character_)
    )
  }

  if (!is.null(metadata$compressor$id)) {
    metadata_v3$codecs[[metadata$compressor$id]] <- list(
      name = metadata$compressor$id,
      configuration = metadata$compressor[names(metadata$compressor) != "id"]
    )
  }

  return(metadata_v3)
}

.convert_dtype_version <- function(
  base_type,
  nbytes,
  endian,
  version_from,
  version_to
) {
  if (version_from == 2L && version_to == 3L) {
    if (length(base_type) > 1L) {
      return(
        list(
          name = "struct",
          configuration = list(
            fields = mapply(
              .convert_dtype_version,
              base_type,
              nbytes,
              endian,
              MoreArgs = list(
                version_from = version_from,
                version_to = version_to
              ),
              SIMPLIFY = FALSE
            )
          )
        )
      )
    }
    return(switch(
      base_type,
      "unicode" = list(
        name = "fixed_length_utf32",
        configuration = list(
          length_bytes = 8L * nbytes
        )
      ),
      "string" = list(
        name = "null_terminated_bytes",
        configuration = list(
          length_bytes = nbytes
        )
      ),
      "bool" = "bool",
      paste0(base_type, 8L * nbytes)
    ))
  }
  if (version_from == 3L && version_to == 2L) {
    # We have only implemented mapping for types we want to write
    if (nbytes == 1L) {
      endian_symbol <- "|"
    } else {
      endian_symbol <- "<"
    }
    return(switch(
      base_type,
      "unicode" = "<U",
      "string" = "|S",
      paste0(endian_symbol, substr(base_type, 1L, 1L), nbytes)
    ))
  }
  # nocov start
  stop(
    "Data type mapping from version ",
    version_from,
    " to version ",
    version_to,
    " is not implemented."
  )
  # nocov end
}

.convert_consolidated_metadata_version <- function(
  zmeta,
  version_from,
  version_to
) {
  if (version_from != 2L || version_to != 3L) {
    # nocov start
    stop(
      "Only conversion from version 2 to version 3 is supported.",
      call. = FALSE
    )
    # nocov end
  }

  arrays <- names(zmeta)[endsWith(
    names(zmeta),
    "/.zarray"
  )]
  groups <- names(zmeta)[endsWith(
    names(zmeta),
    "/.zgroup"
  )]

  res <- list()

  for (a in arrays) {
    array_name <- dirname(a)

    # Metadata (.zarray)
    meta <- zmeta[[a]]
    meta$datatype <- parse_npy_datatype(meta$dtype)
    meta <- .convert_metadata_version(
      meta,
      version_from = 2L,
      version_to = 3L
    )
    meta$dt <- NULL

    # Attributes (.zattrs)
    attrs <- zmeta[[file.path(array_name, ".zattrs")]]
    meta$attributes <- attrs

    res[[array_name]] <- meta
  }

  for (g in groups) {
    group_name <- dirname(g)

    # Metadata (.zgroup)
    meta <- zmeta[[g]]
    meta$node_type <- "group"
    meta$zarr_format <- 2L

    # Attributes (.zattrs)
    attrs <- zmeta[[file.path(group_name, ".zattrs")]]
    meta$attributes <- attrs

    res[[group_name]] <- meta
  }

  return(res)
}
