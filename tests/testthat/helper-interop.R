#' Define an interoperability test case
#'
#' @param name Name of the case, used in the test descriptions
#' @param dtype Zarr v3 data type, passed to both zarr-python and
#'   `write_zarr_array()`
#' @param x The values to write, converted to an array
#' @param expected What `read_zarr_array()` should return when reading the
#'   array written by zarr-python, `x` by default
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
  expected = array(x),
  chunk_dim = 2L,
  supported = c("read", "write"),
  known_issue = list()
) {
  list(
    name = name,
    dtype = dtype,
    x = array(x),
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
    shape = reticulate::tuple(as.list(dim(case$x))),
    chunks = reticulate::tuple(as.list(as.integer(case$chunk_dim))),
    dtype = dtype,
    zarr_format = 3L
  )
  reticulate::py_set_item(arr, reticulate::py_ellipsis(), values)

  invisible(arr)
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
        write_zarr_array(
          x = case$x,
          zarr_array_path = path_r,
          chunk_dim = case$chunk_dim,
          data_type = case$dtype,
          zarr_version = 3L
        )

        expect_equal_py(
          zarr$open_array(path_r, mode = "r"),
          zarr$open_array(path_py, mode = "r")
        )
      }
    )
  }
}
