#' Define an interoperability test case
#'
#' @param name Name of the case, used in the test descriptions
#' @param dtype Zarr v3 data type, passed to both zarr-python and
#'   `write_zarr_array()`
#' @param x The values to write, converted to an array of shape `shape`
#' @param shape Shape of the array, `dim(x)` by default, or `length(x)` if `x`
#'   has no dimensions. Use `integer(0)` for a scalar (zero-dimensional array),
#'   which R can't represent as an array, so `x` is kept as is.
#' @param expected What `read_zarr_array()` should return when reading the
#'   array written by zarr-python, `x` as an array by default
#' @param chunk_dim Chunk dimensions
#' @param supported Which directions Rarr supports: `"read"` (Rarr reads what
#'   zarr-python wrote) and/or `"write"` (zarr-python reads what Rarr wrote).
#'   No tests are generated for unsupported directions; check that these fail
#'   with a clear error in the regular tests instead.
#' @param known_issue A named list with elements `read` and/or `write`,
#'   referring to the bug that makes reading or writing this case fail. These
#'   tests are skipped until the bug is fixed.
interop_case <- function(
  name,
  dtype,
  x,
  shape = if (is.null(dim(x))) length(x) else dim(x),
  expected = NULL,
  chunk_dim = 2L,
  supported = c("read", "write"),
  known_issue = list()
) {
  shape <- as.integer(shape)
  if (length(shape) > 0L) {
    x <- array(x, dim = shape)
  }
  if (is.null(expected)) {
    expected <- if (is.array(x)) x else array(x)
  }

  list(
    name = name,
    dtype = dtype,
    x = x,
    shape = shape,
    expected = expected,
    chunk_dim = chunk_dim,
    supported = supported,
    known_issue = known_issue
  )
}

#' Write a test case with zarr-python
py_write_array <- function(path, case) {
  zarr <- reticulate::import("zarr", convert = FALSE)
  np <- reticulate::import("numpy", convert = FALSE)

  if (case$dtype == "string") {
    dtype <- reticulate::import_builtins(convert = FALSE)$str
    values <- np$asarray(case$x, dtype = "T")
  } else {
    dtype <- case$dtype
    values <- np$asarray(case$x, dtype = dtype)
  }

  arr <- zarr$create_array(
    store = path,
    shape = reticulate::tuple(as.list(case$shape)),
    chunks = reticulate::tuple(as.list(as.integer(case$chunk_dim))),
    dtype = dtype,
    zarr_format = 3L
  )
  reticulate::py_set_item(arr, reticulate::py_ellipsis(), values)

  invisible(arr)
}

#' Write a test case with Rarr
#'
#' Rarr warns when the chunks are larger than the array, except along
#' zero-length dimensions. The spec allows this, so expect the warning rather
#' than let it fail the test.
r_write_array <- function(path, case) {
  write <- function() {
    write_zarr_array(
      x = case$x,
      zarr_array_path = path,
      chunk_dim = case$chunk_dim,
      data_type = case$dtype,
      zarr_version = 3L
    )
  }

  if (any(case$chunk_dim > case$shape & case$shape != 0L)) {
    testthat::expect_warning(write(), "Chunk dimensions are larger")
  } else {
    write()
  }
}

#' Expect two zarr-python arrays to have the same shape, dtype and values
#'
#' The comparison happens on the Python side, so it does not depend on how
#' reticulate converts the values to R.
expect_equal_py <- function(actual, expected) {
  np <- reticulate::import("numpy", convert = FALSE)

  testthat::expect_no_error(
    np$testing$assert_array_equal(
      reticulate::py_get_item(actual, reticulate::py_ellipsis()),
      reticulate::py_get_item(expected, reticulate::py_ellipsis()),
      strict = TRUE
    )
  )
}

skip_if_known_issue <- function(case, direction) {
  issue <- case$known_issue[[direction]]
  testthat::skip_if(!is.null(issue), paste("Known issue:", issue))
}

#' Run the interoperability tests for a list of cases
#'
#' For each case, check that Rarr reads the array written by zarr-python, and
#' that zarr-python reads the array written by Rarr.
test_interop_cases <- function(cases) {
  zarr <- reticulate::import("zarr", convert = FALSE)

  for (case in cases) {
    if ("read" %in% case$supported) {
      testthat::test_that(
        paste0("Rarr reads '", case$name, "' written by zarr-python"),
        {
          skip_if_known_issue(case, "read")
          path_py <- withr::local_tempfile(fileext = ".zarr")

          py_write_array(path_py, case)

          testthat::expect_identical(read_zarr_array(path_py), case$expected)
        }
      )
    }

    if (!"write" %in% case$supported) {
      next
    }

    testthat::test_that(
      paste0("zarr-python reads '", case$name, "' written by Rarr"),
      {
        skip_if_known_issue(case, "write")
        path_py <- withr::local_tempfile(fileext = ".zarr")
        path_r <- withr::local_tempfile(fileext = ".zarr")

        py_write_array(path_py, case)
        r_write_array(path_r, case)

        expect_equal_py(
          zarr$open_array(path_r, mode = "r"),
          zarr$open_array(path_py, mode = "r")
        )
      }
    )
  }
}
