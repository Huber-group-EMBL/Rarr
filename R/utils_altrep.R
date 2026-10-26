is.scalar <- function(x) {
  is.atomic(x) && length(x) == 1L
}

is.consecutive <- function(
  x,
  direction = c("increasing", "decreasing", "either")
) {
  n <- length(x)
  res <- n > 0L &&
    !anyNA(x) &&
    as.double(x[n]) - x[1L] == n - 1L
  direction <- match.arg(direction)
  switch(
    direction,
    increasing = return(res && !is.unsorted(x, strictly = TRUE)),
    decreasing = return(res && !is.unsorted(rev(x), strictly = TRUE)),
    either = return(
      res &&
        (!is.unsorted(x, strictly = TRUE) ||
          !is.unsorted(rev(x), strictly = TRUE))
    )
  )
}

reindex <- function(x, from = 1L, to = 0L) {
  offset <- from - to
  if (is.consecutive(x, direction = "either")) {
    res <- (x[1L] - offset):(x[length(x)] - offset)
  } else {
    res <- x - offset
  }
  return(res)
}
