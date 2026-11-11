# -- Transpose -------------------
codec_transpose_encode <- function(array, indices = seq_along(dim(array))) {
  # Transpose codec itself
  B <- aperm(array, indices)
  # C<->F order conversion
  array(as.vector(aperm(B, rev(seq_along(indices)))), dim = dim(B))
}

codec_transpose_decode <- function(array, indices = seq_along(dim(array))) {
  # C<->F order conversion
  B <- aperm(
    array(as.vector(array), dim = rev(dim(array)[indices])),
    rev(seq_along(indices))
  )
  # Transpose codec itself
  aperm(B, order(indices))
}
