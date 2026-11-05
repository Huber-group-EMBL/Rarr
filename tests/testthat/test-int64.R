test_that("int64 zarr arrays can be read correctly", {
  zarr_c <- system.file(
    "extdata",
    "zarr_examples",
    "column-first",
    "int64.zarr",
    package = "Rarr"
  )
  zarr_f <- system.file(
    "extdata",
    "zarr_examples",
    "row-first",
    "int64.zarr",
    package = "Rarr"
  )
  index <- list(1:30, 1:20, 1)

  # Shouldn't be any warnings for this input
  expect_silent(column_major <- read_zarr_array(zarr_c, index = index))
  expect_silent(row_major <- read_zarr_array(zarr_f, index = index))

  # Row and column major should be read the same in R
  expect_identical(column_major, row_major)

  # We return an array
  expect_true(is.array(column_major))

  # Dimensions equal to the index
  expect_identical(dim(column_major), c(30L, 20L, 1L))

  # First row should be sequence 1 to 20
  expect_identical(column_major[1, , ], 1:20)

  # First column should be all 1s
  expect_identical(column_major[, 1, ], rep(1L, 30))
})

test_that("int64 zarr arrays handle out-of-range values", {
  zarr_c <- system.file(
    "extdata",
    "zarr_examples",
    "column-first",
    "int64.zarr",
    package = "Rarr"
  )
  zarr_f <- system.file(
    "extdata",
    "zarr_examples",
    "row-first",
    "int64.zarr",
    package = "Rarr"
  )

  column_major <- read_zarr_array(zarr_c, index = list(30, 20, 10))
  row_major <- read_zarr_array(zarr_f, index = list(30, 20, 10))

  if (packageVersion("grumpy") >= "0.1.1.9005") {
    expect_identical(column_major, array(4294967296, c(1L, 1L, 1L)))
  } else {
    expect_true(all(is.na(column_major)))
  }
  expect_identical(row_major, column_major)

  column_major <- read_zarr_array(zarr_c, index = list(30, 20, 9))
  row_major <- read_zarr_array(zarr_f, index = list(30, 20, 9))

  if (packageVersion("grumpy") >= "0.1.1.9005") {
    expect_identical(column_major, array(-4294967296, c(1L, 1L, 1L)))
  } else {
    expect_true(all(is.na(column_major)))
  }
  expect_identical(row_major, column_major)
})

test_that("v2 and v3 return identical results", {
  zarr_v2 <- system.file(
    "extdata",
    "zarr_examples",
    "column-first",
    "int64.zarr",
    package = "Rarr"
  )
  zarr_v3 <- system.file(
    "extdata",
    "zarr_examples",
    "column-first",
    "int64_v3.zarr",
    package = "Rarr"
  )

  i64_v2 <- read_zarr_array(zarr_v2)
  i64_v3 <- read_zarr_array(zarr_v3)

  expect_identical(i64_v2, i64_v3)
})

test_that("int64 zarr array can be written", {
  int64_zarr <- withr::local_tempfile(fileext = ".zarr")

  content_int64_array <- array(1:24, dim = c(4, 3, 2))

  write_zarr_array(
    content_int64_array,
    int64_zarr,
    data_type = "<i8",
    chunk_dim = c(2, 2, 1),
    compressor = NULL
  )

  roundtrip_int64_array <- read_zarr_array(int64_zarr)

  expect_identical(
    content_int64_array,
    roundtrip_int64_array
  )
})
