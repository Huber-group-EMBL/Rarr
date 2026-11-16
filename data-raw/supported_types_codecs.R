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

INT_TYPES_RANGE <- list(
  "int8" = c(min = -2^(8 - 1), max = 2^(8 - 1) - 1),
  "int16" = c(min = -2^(16 - 1), max = 2^(16 - 1) - 1),
  "int32" = c(min = -2^(32 - 1), max = 2^(32 - 1) - 1),
  "int64" = c(min = -2^(64 - 1), max = 2^(64 - 1) - 1),
  "uint8" = c(min = 0, max = 2^8 - 1),
  "uint16" = c(min = 0, max = 2^16 - 1),
  "uint32" = c(min = 0, max = 2^32 - 1),
  "uint64" = c(min = 0, max = 2^64 - 1)
) |>
  list2env(hash = TRUE, parent = emptyenv())

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
