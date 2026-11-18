skip_if_no_zarr_py()

cases <- list(
  interop_case(
    name = "scalar",
    dtype = "float64",
    x = 1.5,
    shape = integer(0),
    chunk_dim = integer(0),
    known_issue = list(write = "#293")
  ),
  interop_case(
    name = "empty 1-d array",
    dtype = "int32",
    x = integer(0),
    chunk_dim = 1L
  ),
  interop_case(
    name = "empty 2-d array",
    dtype = "int32",
    x = integer(0),
    shape = c(0L, 3L),
    chunk_dim = c(1L, 2L)
  ),
  interop_case(
    name = "1-d array in a single chunk",
    dtype = "int32",
    x = 1:6,
    chunk_dim = 6L
  ),
  interop_case(
    name = "1-d array, chunks divide the shape",
    dtype = "int32",
    x = 1:6,
    chunk_dim = 2L
  ),
  interop_case(
    name = "1-d array, chunks don't divide the shape",
    dtype = "int32",
    x = 1:7,
    chunk_dim = 3L
  ),
  interop_case(
    name = "1-d array, chunk larger than the shape",
    dtype = "int32",
    x = 1:5,
    chunk_dim = 10L
  ),
  interop_case(
    name = "2-d array",
    dtype = "int32",
    x = 1:12,
    shape = c(3L, 4L),
    chunk_dim = c(3L, 4L)
  ),
  interop_case(
    name = "2-d array, chunks don't divide the shape",
    dtype = "int32",
    x = 1:35,
    shape = c(5L, 7L),
    chunk_dim = c(2L, 3L)
  ),
  interop_case(
    name = "2-d array, chunks larger than the shape",
    dtype = "int32",
    x = 1:6,
    shape = c(2L, 3L),
    chunk_dim = c(4L, 4L)
  ),
  interop_case(
    name = "2-d array with a dimension of length 1",
    dtype = "int32",
    x = 1:5,
    shape = c(1L, 5L),
    chunk_dim = c(1L, 2L)
  ),
  interop_case(
    name = "2-d string array",
    dtype = "string",
    x = c("a", "bb", "", "dddd", "é", "多"),
    shape = c(2L, 3L),
    chunk_dim = c(1L, 2L)
  ),
  interop_case(
    name = "3-d array",
    dtype = "int32",
    x = 1:24,
    shape = c(2L, 3L, 4L),
    chunk_dim = c(1L, 2L, 3L)
  ),
  interop_case(
    name = "5-d array",
    dtype = "int32",
    x = 1:120,
    shape = c(2L, 3L, 1L, 4L, 5L),
    chunk_dim = c(2L, 2L, 1L, 3L, 2L)
  )
)

test_interop_cases(cases)
