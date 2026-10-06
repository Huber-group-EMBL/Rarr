test_that("read sharded files", {
  sharded <- system.file(
    "extdata",
    "zarr_examples",
    "sharding",
    "int32_sharded.zarr",
    package = "Rarr"
  )

  arr <- read_zarr_array(sharded) |>
    expect_no_condition() |>
    expect_shape(dim = c(30L, 20L, 10L)) |>
    expect_type("integer")

  expect_identical(
    arr[1L, , 1L],
    seq_len(20L)
  )
  expect_identical(
    arr[, 1L, 1L],
    rep_len(1L, 30L)
  )

  expect_identical(
    arr[2L:30L, 2L:20L, 2L:10L],
    array(0L, dim = c(29L, 19L, 9L))
  )

  # Index location doesn't matter
  sharded_index_start <- system.file(
    "extdata",
    "zarr_examples",
    "sharding",
    "int32_sharded_index_at_start.zarr",
    package = "Rarr"
  )

  expect_identical(
    read_zarr_array(sharded_index_start),
    arr
  )
})

test_that("read sharded 1D array with a single inner chunk per shard", {
  sharded <- system.file(
    "extdata",
    "zarr_examples",
    "sharding",
    "int32_sharded_1d.zarr",
    package = "Rarr"
  )

  read_zarr_array(sharded) |>
    expect_identical(array(seq_len(5L), dim = 5L))
})

test_that("read sharded 2D array without explicit transpose codec", {
  sharded <- system.file(
    "extdata",
    "zarr_examples",
    "sharding",
    "int32_sharded_2d.zarr",
    package = "Rarr"
  )

  expected <- matrix(seq_len(24L), nrow = 6L, ncol = 4L, byrow = TRUE)

  read_zarr_array(sharded) |>
    expect_identical(expected)

  read_zarr_array(sharded, index = list(2:5, 2:3)) |>
    expect_identical(expected[2:5, 2:3])
})
