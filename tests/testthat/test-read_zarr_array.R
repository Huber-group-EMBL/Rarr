test_that("read_zarr_array() gives an informative error on v3 groups", {
  zarr_group <- withr::local_tempdir(fileext = ".zarr")

  jsonlite::write_json(
    list(
      zarr_format = 3L,
      node_type = "group"
    ),
    file.path(zarr_group, "zarr.json"),
    auto_unbox = TRUE
  )
  expect_error(
    read_zarr_array(zarr_group),
    "The provided path points to a Zarr group, but `read_zarr_array()` can only read arrays.",
    fixed = TRUE
  )
})

test_that("shortcut for single chunk arrays", {
  # https://github.com/Huber-group-EMBL/Rarr/pull/311
  single_chunk <- withr::local_tempfile(fileext = ".zarr")
  write_zarr_array(
    array(c(0L, 0L, 3L, 4L, 5L, 6L), dim = 6L),
    single_chunk,
    chunk_dim = 2L,
    data_type = "int32"
  )
  # The requested indices actually span two chunks
  expect_identical(
    read_zarr_array(single_chunk, index = list(2:3)),
    read_zarr_array(single_chunk)[2:3]
  )
})
