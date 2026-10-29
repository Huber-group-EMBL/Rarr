#' @useDynLib Rarr
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

# Backport from R 4.4.0
"%||%" <- function(x, y) {
  if (is.null(x)) y else x # nolint: coalesce_linter.
}

# Backport from R 4.6.0
`%notin%` <- function(x, table) {
  match(x, table, nomatch = 0L) == 0L
}

# "Backport" from R 4.6.0
has_zstd <- function() {
  r_ver <- getRversion()
  if (r_ver >= "4.7.0") {
    return(capabilities("zstd"))
  }
  if (r_ver >= "4.6.0") {
    return(nzchar(extSoftVersion()["zstd"]))
  }
  if (r_ver >= "4.5.0") {
    # From https://bugs.r-project.org/show_bug.cgi?id=18914&_ts=1791986101
    return(tryCatch(
      {
        zstdfile("")
        TRUE
      },
      error = function(e) FALSE
    ))
  }
  return(FALSE)
}

# Backport from R 4.7.0
Partial <- function(f, ...) {
  f <- match.fun(f)
  args <- list(...)
  function(...) {
    do.call(f, c(args, list(...)))
  }
}

Partial_with_splicing <- function(f, ...) {
  f <- match.fun(f)
  args <- rlang::list2(...)
  function(...) {
    do.call(f, c(args, list(...)))
  }
}
