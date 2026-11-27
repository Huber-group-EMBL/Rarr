test_that("update_zarr_array() removes existing chunk when updated to all fill values", {
  for (zarr_version in c(2L, 3L)) {
    path <- withr::local_tempfile(fileext = ".zarr")
    x <- matrix(1L:8L, nrow = 4L, ncol = 2L)
    write_zarr_array(
      x,
      path,
      chunk_dim = c(2L, 2L),
      fill_value = 0L,
      compressor = NULL,
      zarr_version = zarr_version
    )
    expect_identical(read_zarr_array(path), x)

    expect_true(
      update_zarr_array(path, matrix(0L, 2L, 2L), index = list(1L:2L, 1L:2L))
    )
    expected <- x
    expected[1L:2L, 1L:2L] <- 0L
    expect_identical(read_zarr_array(path), expected)
    chunk_name <- if (zarr_version == 2L) "0.0" else "c/0/0"
    expect_false(file.exists(file.path(path, chunk_name)))

    # Partial update that clears the remaining non-fill elements of a chunk
    expect_true(
      update_zarr_array(path, matrix(0L, 2L, 1L), index = list(3L:4L, 1L))
    )
    expect_true(
      update_zarr_array(path, matrix(0L, 2L, 1L), index = list(3L:4L, 2L))
    )
    expect_identical(read_zarr_array(path), matrix(0L, nrow = 4L, ncol = 2L))
    chunk2_name <- if (zarr_version == 2L) "1.0" else "c/1/0"
    expect_false(file.exists(file.path(path, chunk2_name)))
  }
})
