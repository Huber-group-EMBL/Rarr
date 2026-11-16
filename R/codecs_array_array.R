# -- Transpose -------------------
codec_transpose_encode <- function(array, indices = seq_along(dim(array))) {
  # FIXME: we do two copies here (aperm and dim assignment) which can be expensive for large arrays
  inv_indices <- order(indices)
  array <- aperm(array, inv_indices)
  dim(array) <- dim(array)[inv_indices]

  return(array)
}

codec_transpose_decode <- function(array, indices = seq_along(dim(array))) {
  # FIXME: we manually dispatch aperm() to t() but eventually, there should be
  # an aperm.matrix() method.
  # https://bugs.r-project.org/show_bug.cgi?id=19133
  # When this happens, we only have to handle the drop() case.
  to_drop <- dim(array) == 1L

  if (sum(!to_drop) < 2L) {
    # "1D-like" array.
    # R transpose would turn into a column vector, but since Zarr transpose
    # keeps the shape, that's actually identity.
    return(array)
  }

  if (any(to_drop)) {
    final_dim <- dim(array)
    array <- drop(array)
    indices <- order(indices[!to_drop])
  }

  if (is.matrix(array) && all(indices == c(2L, 1L))) {
    dim(array) <- rev(dim(array))
    array <- t(array)
  } else {
    dim(array) <- dim(array)[indices]
    array <- aperm(array, indices)
  }

  # Restore dropped dimensions
  if (any(to_drop)) {
    dim(array) <- final_dim
  }
  return(array)
}

codec_delta_decode <- function(array, data_type = NULL) {
  # as.numeric to avoid integer overflow during cumsum
  res <- cumsum(as.numeric(array))
  if (data_type %in% INT_TYPES_RANGE$data_type) {
    range <- INT_TYPES_RANGE[INT_TYPES_RANGE$data_type %in% data_type, ]
    res <- (res - range$min) %% (range$max - range$min + 1) + range$min
    if (max(res) <= .Machine$integer.max) {
      storage.mode(res) <- "integer"
    }
  }
  dim(res) <- dim(array)
  return(res)
}
