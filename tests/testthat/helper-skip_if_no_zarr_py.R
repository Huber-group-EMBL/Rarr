# skip tests if reticulate or the python zarr module is not available
#
# Set the `RARR_TEST_REQUIRE_PYTHON` environment variable to `true` to error
# instead of skipping, e.g. in CI
skip_if_no_zarr_py <- function() {
  if (!py_tests_required()) {
    testthat::skip_if_not_installed("reticulate")
  }
  reticulate::py_require("zarr>=3")
  if (py_tests_required()) {
    # import directly, py_module_available() would hide the error
    reticulate::import("zarr")
    return(invisible(TRUE))
  }
  testthat::skip_if_not(
    reticulate::py_module_available("zarr"),
    message = "Python zarr module not available for testing"
  )
}

py_tests_required <- function() {
  isTRUE(as.logical(Sys.getenv("RARR_TEST_REQUIRE_PYTHON", "false")))
}
