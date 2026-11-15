test_that("scalar can be read", {
  # Not explicitly supported (but still used) in v2.
  # v3 spec says: "A shape can be the empty tuple in the case of zero-dimension arrays (scalars)."
  scalar_v2 <- system.file(
    "extdata",
    "zarr_examples",
    "scalar",
    "scalar_v2.zarr",
    package = "Rarr"
  )
  expect_identical(read_zarr_array(scalar_v2), structure("A string", dim = 1))

  scalar_v3 <- system.file(
    "extdata",
    "zarr_examples",
    "scalar",
    "scalar_v3.zarr",
    package = "Rarr"
  )
  expect_identical(read_zarr_array(scalar_v3), structure(42L, dim = 1))

  expect_identical(
    jsonlite::read_json(file.path(scalar_v3, "zarr.json"))$shape,
    list()
  )
})

test_that("'pseudo-scalar' (dim = 1L) use c/0 chunk key encoding", {
  pseudo_scalar <- withr::local_tempfile(fileext = ".zarr")
  write_zarr_array(array(1.5, 1L), chunk_dim = 1L, pseudo_scalar) |>
    expect_no_condition()
  list.files(pseudo_scalar, recursive = TRUE, include.dirs = FALSE) |>
    expect_identical(c("c/0", "zarr.json"))

  actual_scalar <- withr::local_tempfile(fileext = ".zarr")
  create_empty_zarr_array(
    actual_scalar,
    dim = integer(0L),
    chunk_dim = integer(0L),
    data_type = "double",
    zarr_version = 3L
  )
  update_zarr_array(actual_scalar, x = 1.5, index = list(1L))

  expect_identical(
    list.files(actual_scalar, recursive = TRUE, include.dirs = FALSE),
    c("c", "zarr.json")
  )
})
