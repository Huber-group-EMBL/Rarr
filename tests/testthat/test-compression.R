test_that("blosc works with variable length types", {
  blosc_vlen_zarr <- withr::local_tempfile(fileext = ".zarr")

  x <- matrix(
    c("Paris", "London", "Berlin", "Madrid"),
    nrow = 2
  )
  create_empty_zarr_array(
    blosc_vlen_zarr,
    dim = dim(x),
    chunk_dim = c(2, 2),
    data_type = "|O",
    codecs = list(use_vlen_utf8(), use_blosc())
  )

  expect_no_condition(
    update_zarr_array(blosc_vlen_zarr, x, index = list(1:2, 1:2))
  )

  expect_identical(
    read_zarr_array(blosc_vlen_zarr),
    x
  )
})

test_that("error when setting up compressors with invalid level", {
  expect_error(
    use_blosc(clevel = 30),
    "`clevel` must be an integer between 0 and 9"
  )
  expect_warning(
    use_zstd(level = 30),
    "`level` value is ignored"
  )
})
