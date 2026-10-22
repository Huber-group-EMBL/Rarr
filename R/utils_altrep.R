is.compact <- function(x) {
  .Call("is_compact", x, PACKAGE = "Rarr")
}
is.scalar <- function(x) {
  is.atomic(x) && length(x) == 1L
}
# An increasing run of consecutive integers, such as 5:9. is.compact() alone is
# not enough: it is TRUE for decreasing sequences such as 3:1 and for any ALTREP
# vector, such as the result of sort().
is.consecutive <- function(x) {
  n <- length(x)
  n > 0L &&
    !anyNA(x) &&
    as.double(x[n]) - x[1L] == n - 1L &&
    !is.unsorted(x, strictly = TRUE)
}

reindex <- function(x, from = 1L, to = 0L) {
  offset <- from - to
  if (is.compact(x)) {
    res <- (x[1L] - offset):(x[length(x)] - offset)
  } else {
    res <- x - offset
  }
  return(res)
}
