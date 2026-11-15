# This file regroups the specific conscious spec deviations we have implemented

test_that("chunk_size of 0 can be read", {
  # Chunk dimension of 0 can still be read (not written!), even though it's not
  # in spec, because it doesn't cost us anything
  # https://github.com/zarr-developers/zarr-specs/issues/378
  empty_zarr <- withr::local_tempfile(fileext = ".zarr")
  write_zarr_array(
    array(integer(0)),
    empty_zarr,
    data_type = "int8",
    chunk_dim = 1,
    zarr_version = 2
  )
  jsonlite::read_json(file.path(empty_zarr, ".zarray")) |>
    modifyList(list(chunks = as.list(0L))) |>
    jsonlite::write_json(
      file.path(empty_zarr, ".zarray"),
      auto_unbox = TRUE,
      null = "null"
    )
  expect_identical(read_zarr_array(empty_zarr), array(integer(0)))
})

test_that("dimension_names is written for v2", {
  # TODO: implement reading as well?
  # https://github.com/zarr-developers/zarr-specs/blame/fc7dd9c9beb5a50b87f9b08b00bf50fc0048482f/docs/v2/v2.0.rst#L91-L92
  x <- array(
    1:60,
    c(4, 5, 3),
    dimnames = list(
      x = as.numeric(1:4),
      y = as.numeric(1:5),
      c = c("r", "g", "b")
    )
  )
  z <- tempfile(fileext = ".zarr")
  write_zarr_array(
    x,
    zarr_array_path = z,
    chunk_dim = c(2, 5, 1),
    zarr_version = 2L
  )
  expect_identical(
    jsonlite::read_json(file.path(z, ".zarray"))$dimension_names |> unlist(),
    c("x", "y", "c")
  )
})
