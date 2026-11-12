#' Truncate overflow values and warn about bool NA values before writing
#'
#' Applies the two pre-write data checks that are needed identically in both
#' [write_zarr_array()] and [update_zarr_array()]:
#'
#' 1. If the target type is an integer type narrower than R's native
#'    representation (`int8`, `int16`), clamp out-of-range values via
#'    `.truncate_overflow()`. Floats are not clamped, since `writeBin()`
#'    follows IEEE 754 when narrowing to `float32`, values beyond its range
#'    become `Inf` or `-Inf`.
#' 2. If the target type is `bool`, warn when `x` contains `NA` values (which
#'    the Zarr bool type cannot represent).
#'
#' @param x The R array to be written.
#' @param metadata Array metadata list as returned by [.read_array_metadata()].
#'
#' @returns `x`, possibly with overflow values clamped.
#'
#' @keywords internal
.prepare_write_data <- function(x, metadata) {
  data_type <- metadata$data_type
  # structured data types carry a list here and have no overflow or NA checks
  is_scalar_type <- !is.list(data_type)

  if (
    is_scalar_type &&
      data_type %in% c("int8", "int16", "uint8", "uint16", "uint32", "uint64")
  ) {
    x <- .truncate_overflow(
      x,
      metadata$datatype$nbytes,
      signed = startsWith(data_type, "int")
    )
  }

  if (is_scalar_type && data_type == "bool" && anyNA(x)) {
    warning(
      "Zarr native 'bool' data type does not support NA values. ",
      "NA values will be converted to FALSE. ",
      "To preserve NA values, use 'uint8' datatype in `write_zarr_array()` and `as.logical()` after reading.",
      call. = FALSE
    )
  }
  if (
    is.list(metadata$data_type) &&
      metadata$data_type$name %in%
        c("null_terminated_bytes", "fixed_length_utf32") &&
      anyNA(x)
  ) {
    warning(
      "Zarr 'null_terminated_bytes' and 'fixed_length_utf32' data types do not support NA values. ",
      "NA values will be converted to empty strings. ",
      "Use a known mask value (typically, a string absent from your data) to preserve NA values.",
      call. = FALSE
    )
  }
  return(x)
}

.truncate_overflow <- function(x, nbytes, signed = TRUE) {
  if (signed) {
    max_value <- 2L^(nbytes * 8L - 1L) - 1L
    min_value <- -max_value - 1L
  } else {
    max_value <- 2L^(nbytes * 8L) - 1L
    min_value <- 0L
  }

  # Fast path: min()/max() avoid allocating logical vectors. All-NA input
  # gives Inf/-Inf (with a warning) and correctly takes the early return.
  in_range <- suppressWarnings(
    min(x, na.rm = TRUE) >= min_value && max(x, na.rm = TRUE) <= max_value
  )
  if (in_range) {
    return(x)
  }

  positive_overflow <- x > max_value
  negative_overflow <- x < min_value
  if (any(positive_overflow | negative_overflow)) {
    warning(
      "Some values in 'x' are too large to be represented by the ",
      "specified data type and will be truncated to the type range ",
      "(",
      min_value,
      " to ",
      max_value,
      ") when written. ",
      "To avoid this, use a wider data type or check that 'x' does ",
      "not contain out-of-range values.",
      call. = FALSE
    )
    storage.mode(max_value) <- storage.mode(x)
    storage.mode(min_value) <- storage.mode(x)
    x[positive_overflow] <- max_value
    x[negative_overflow] <- min_value
  }
  return(x)
}

.guess_int_size <- function(x, data_type) {
  if (anyNA(x)) {
    # Lower bitsize types cannot represent NA values.
    return("<i4")
  }
  # There is no situation where we may return i8 or u8 because these large integers cannot exist in R.
  # FIXME: potential optimization, avoid checking for overflow later if we used this function.
  max_value <- max(x, na.rm = TRUE)
  min_value <- min(x, na.rm = TRUE)

  if (min_value < 0L) {
    if (min_value >= -128L && max_value <= 127L) {
      return("|i1")
    } else if (min_value >= -32768L && max_value <= 32767L) {
      return("<i2")
    } else {
      return("<i4")
    }
  }
  if (max_value <= 255L) {
    return("|u1")
  } else if (max_value <= 65535L) {
    return("<u2")
  } else {
    return("<u4")
  }
}

# https://zarr-specs.readthedocs.io/en/latest/v3/core/index.html#node-names
# It's slightly overzealous to apply everything to v2, but it makes our life
# much easier and follows our 'v3 first' philosophy.
.check_node_name <- function(name, allow_root = FALSE) {
  if (!nzchar(name) && !allow_root) {
    stop(
      "`",
      name,
      "` is not a valid Zarr node name. ",
      "Zarr node names cannot be empty strings.",
      call. = FALSE
    )
  }
  if (grepl("/", name, fixed = TRUE)) {
    stop(
      "`",
      name,
      "` is not a valid Zarr node name. ",
      "Zarr node names cannot contain the '/' character.",
      call. = FALSE
    )
  }
  if (grepl("^[.]+$", name)) {
    stop(
      "`",
      name,
      "` is not a valid Zarr node name. ",
      "Zarr node names cannot contain only the '.' character.",
      call. = FALSE
    )
  }
  if (startsWith(name, "__")) {
    stop(
      "`",
      name,
      "` is not a valid Zarr node name. ",
      "Zarr node names cannot start with '__'.",
      call. = FALSE
    )
  }
  if (name %in% c(METADATA_V2_FILES, METADATA_V3_FILES)) {
    stop(
      "`",
      name,
      "` is a reserved name for Zarr metadata. ",
      "Please provide a different node name.",
      call. = FALSE
    )
  }
}

#' Check whether every element of a chunk equals the fill value
#'
#' Implemented in C so it exits at the first mismatch without allocating.
#'
#' @keywords internal
.is_all_fill <- function(x, fill) {
  .Call("is_all_fill", x, fill, PACKAGE = "Rarr")
}


.check_chunk_shape <- function(x_dim, chunk_dim) {
  if (length(x_dim) != length(chunk_dim)) {
    stop(
      "The number of dimensions of the chunk (",
      length(chunk_dim),
      ") must equal the number of dimensions of the ",
      "array (",
      length(x_dim),
      "). ",
      "Please check the `chunk_dim` argument.",
      call. = FALSE
    )
  }

  oversized_chunk <- chunk_dim > x_dim
  # One valid use case is empty arrays in anndata.
  zero_dim <- x_dim == 0L

  if (any(oversized_chunk & !zero_dim)) {
    warning(
      "Chunk dimensions are larger than array dimensions. ",
      "This is allowed by the Zarr specification but may lead to inefficient storage and retrieval.\n",
      "In most cases, this is likely to be a mistake. Please check your `chunk_dim` argument.",
      call. = FALSE
    )
  }

  valid_chunk_dim <- chunk_dim > 0L
  if (!all(valid_chunk_dim)) {
    stop(
      "Chunk dimensions must be strictly positive.",
      call. = FALSE
    )
  }

  return(invisible(all(valid_chunk_dim & !(oversized_chunk & !zero_dim))))
}
