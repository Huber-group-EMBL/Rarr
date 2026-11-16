CODEC_BYTES_BYTES <- c(
  "blosc",
  "zlib",
  "numcodecs.zlib",
  "gzip",
  "bz2",
  "numcodecs.bz2",
  "lzma",
  "numcodecs.lzma",
  "lz4",
  "numcodecs.lz4",
  "zstd"
)
CODEC_ARRAY_ARRAY <- c("transpose", "delta")
CODEC_ARRAY_BYTES <- c("bytes", "vlen-utf8", "sharding_indexed")

SUPPORTED_V3_TYPES <- list(
  "bool" = list(base_type = "bool", nbytes = 1L),
  "int8" = list(base_type = "int", nbytes = 1L),
  "int16" = list(base_type = "int", nbytes = 2L),
  "int32" = list(base_type = "int", nbytes = 4L),
  "int64" = list(base_type = "int", nbytes = 8L),
  "uint8" = list(base_type = "uint", nbytes = 1L),
  "uint16" = list(base_type = "uint", nbytes = 2L),
  "uint32" = list(base_type = "uint", nbytes = 4L),
  "uint64" = list(base_type = "uint", nbytes = 8L),
  "float16" = list(base_type = "float", nbytes = 2L),
  "float32" = list(base_type = "float", nbytes = 4L),
  "float64" = list(base_type = "float", nbytes = 8L),
  "bfloat16" = list(base_type = "bfloat", nbytes = 2L),
  "string" = list(base_type = "string", nbytes = NA_integer_)
) |>
  list2env(hash = TRUE, parent = emptyenv())

SUPPORTED_KEY_ENCODINGS <- c(
  "v2",
  "default"
)

METADATA_V2_FILES <- c(
  ".zarray",
  ".zgroup",
  ".zattrs",
  ".zmetadata"
)
METADATA_V3_FILES <- c(
  "zarr.json"
)

INT_TYPES_RANGE <- data.frame(
  data_type = c(
    "int8",
    "int16",
    "int32",
    "int64",
    "uint8",
    "uint16",
    "uint32",
    "uint64"
  ),
  min = c(
    -2L^(8L - 1L),
    -2L^(16L - 1L),
    -2L^(32L - 1L),
    -2L^(64L - 1L),
    0L,
    0L,
    0L,
    0L
  ),
  max = c(
    2L^(8L - 1L) - 1L,
    2L^(16L - 1L) - 1L,
    2L^(32L - 1L) - 1L,
    2L^(64L - 1L) - 1L,
    2L^8L - 1L,
    2L^16L - 1L,
    2L^32L - 1L,
    2L^64L - 1L
  )
)

usethis::use_data(
  SUPPORTED_V3_TYPES,
  CODEC_BYTES_BYTES,
  CODEC_ARRAY_ARRAY,
  CODEC_ARRAY_BYTES,
  METADATA_V2_FILES,
  METADATA_V3_FILES,
  SUPPORTED_KEY_ENCODINGS,
  INT_TYPES_RANGE,
  internal = TRUE,
  overwrite = TRUE
)
