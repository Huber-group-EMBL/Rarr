test_that("arrays with dim or chunk_dim larger than integer max", {
  # Test case from https://github.com/Huber-group-EMBL/Rarr/issues/288.
  n <- .Machine$integer.max + 10
  path <- tempfile(fileext = ".zarr")
  create_empty_zarr_array(
    path,
    dim = n,
    chunk_dim = 2^20,
    data_type = "integer",
    fill_value = 0L
  )

  expect_no_condition(update_zarr_array(path, x = 42L, index = list(n)))

  expect_contains(list.files(path, recursive = TRUE), "c/2048")

  # reads the fill value instead of 42
  expect_identical(read_zarr_array(path, index = list(n)), as.array(42L))
})
