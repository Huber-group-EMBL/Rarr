test_that("reading delta codec is supported", {
  delta_example <- system.file(
    "extdata",
    "zarr_examples",
    "array-array-codecs",
    "delta",
    package = "Rarr"
  )
  res <- read_zarr_array(delta_example) |>
    expect_no_condition()
  expect_identical(
    res,
    array(c(1L, 2L, 3L, 4L, 1L, 0L, 3L, 4L, 2L, 4L, 5L))
  )
})
