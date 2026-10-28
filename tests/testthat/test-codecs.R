test_that("codec: transpose", {
  x <- array(1:60, dim = c(3, 4, 5))

  expect_identical(
    x |> codec_transpose_encode(c(1, 2, 3)),
    x
  )

  ind <- c(2, 3, 1)
  expect_identical(
    x |> codec_transpose_encode(ind) |> codec_transpose_decode(ind),
    x
  )

  ind <- c(3, 1, 2)
  expect_identical(
    x |> codec_transpose_encode(ind) |> codec_transpose_decode(ind),
    x
  )

  ind <- c(1, 3, 2)
  expect_identical(
    x |> codec_transpose_encode(ind) |> codec_transpose_decode(ind),
    x
  )
})

test_that("codec: vlen-utf8", {
  # numcodecs VLenUTF8 layout: little-endian uint32 count, then each string's
  # uint32 byte length and its UTF-8 bytes
  expect_identical(
    `codec_vlen-utf8_encode`(c("ab", "\u00e9", "")),
    as.raw(c(
      c(3, 0, 0, 0),
      c(2, 0, 0, 0, 0x61, 0x62),
      c(2, 0, 0, 0, 0xc3, 0xa9),
      c(0, 0, 0, 0)
    ))
  )
  expect_identical(`codec_vlen-utf8_encode`(character(0)), as.raw(c(0, 0, 0, 0)))

  # NA is written as the string "NA"
  expect_identical(
    `codec_vlen-utf8_encode`(NA_character_),
    `codec_vlen-utf8_encode`("NA")
  )

  # latin1 strings are converted to UTF-8; "bytes" strings are written as is
  latin1 <- "caf\xe9"
  Encoding(latin1) <- "latin1"
  expect_identical(
    `codec_vlen-utf8_encode`(latin1),
    `codec_vlen-utf8_encode`("caf\u00e9")
  )
  bytes <- "caf\xe9"
  Encoding(bytes) <- "bytes"
  expect_identical(
    `codec_vlen-utf8_encode`(bytes),
    as.raw(c(1, 0, 0, 0, 4, 0, 0, 0, 0x63, 0x61, 0x66, 0xe9))
  )

  x <- matrix(c("Paris", "", "\u5317\u4eac", "\U0001f600", "NA", "x"), 2, 3)
  expect_identical(
    x |> `codec_vlen-utf8_encode`() |> `codec_vlen-utf8_decode`(dim(x)),
    x
  )

  expect_error(`codec_vlen-utf8_encode`(1:3), "character vector")
})

test_that("unsupported codec", {
  invalid_codec <- withr::local_tempfile(fileext = ".zarr")
  dir.create(invalid_codec)
  file.copy(
    system.file(
      "extdata",
      "zarr_examples",
      "column-first",
      "boolean_v3.zarr",
      package = "Rarr"
    ),
    invalid_codec,
    recursive = TRUE
  )
  meta <- jsonlite::read_json(
    file.path(invalid_codec, "boolean_v3.zarr", "zarr.json")
  )
  meta$codecs <- c(
    meta$codecs,
    list(
      list(
        "name" = "unsupported_codec",
        "configuration" = list()
      )
    )
  )
  jsonlite::write_json(
    meta,
    file.path(invalid_codec, "boolean_v3.zarr", "zarr.json"),
    auto_unbox = TRUE,
    pretty = TRUE
  )
  expect_error(
    Rarr::read_zarr_array(file.path(invalid_codec, "boolean_v3.zarr")),
    "not supported: unsupported_codec"
  )
})

test_that("codec: |O arrays are written with vlen-utf8 by default", {
  x <- array(c("a", "bb", "", "dddd", "é"), dim = 5)

  path <- withr::local_tempfile(fileext = ".zarr")
  write_zarr_array(x, path, chunk_dim = 2, data_type = "|O", zarr_version = 2L)
  expect_identical(
    jsonlite::read_json(file.path(path, ".zarray"))$filters,
    list(list(id = "vlen-utf8"))
  )
  expect_identical(read_zarr_array(path), x)

  path <- withr::local_tempfile(fileext = ".zarr")
  write_zarr_array(x, path, chunk_dim = 2, data_type = "|O", zarr_version = 3L)
  metadata <- jsonlite::read_json(file.path(path, "zarr.json"))
  expect_identical(metadata$data_type, "string")
  expect_identical(metadata$codecs[[1]], list(name = "vlen-utf8"))
  expect_identical(read_zarr_array(path), x)

  for (zarr_version in 2:3) {
    path <- withr::local_tempfile(fileext = ".zarr")
    create_empty_zarr_array(
      path,
      dim = 5,
      chunk_dim = 2,
      data_type = "|O",
      zarr_version = zarr_version
    )
    update_zarr_array(path, c("a", "bb"), index = list(2:3))
    expect_identical(
      read_zarr_array(path),
      array(c("", "a", "bb", "", ""), dim = 5)
    )
  }
})

test_that("codec: chains of compressors are written and read in order", {
  x <- array(c("a", "bb", "", "dddd", "é"), dim = 5)
  path <- withr::local_tempfile(fileext = ".zarr")
  write_zarr_array(
    x,
    path,
    chunk_dim = 2,
    data_type = "|O",
    codecs = list(use_vlen_utf8(), use_blosc(), use_zstd())
  )
  codecs <- jsonlite::read_json(file.path(path, "zarr.json"))$codecs
  expect_identical(
    vapply(codecs, `[[`, character(1L), "name"),
    c("vlen-utf8", "blosc", "zstd")
  )
  expect_identical(read_zarr_array(path), x)

  # Names of the list are dropped, as the metadata needs a JSON array
  m <- matrix(runif(20), nrow = 4)
  path <- withr::local_tempfile(fileext = ".zarr")
  write_zarr_array(
    m,
    path,
    chunk_dim = c(2, 3),
    codecs = list(a = use_zstd(), b = use_blosc())
  )
  codecs <- jsonlite::read_json(file.path(path, "zarr.json"))$codecs
  expect_null(names(codecs))
  expect_identical(read_zarr_array(path), m)

  path <- withr::local_tempfile(fileext = ".zarr")
  write_zarr_array(m, path, chunk_dim = c(2, 3), codecs = list())
  expect_identical(read_zarr_array(path), m)
})

test_that("codec: positional arguments are unchanged by `codecs`", {
  path <- withr::local_tempfile(fileext = ".zarr")
  write_zarr_array(array(1:4 + 0.5), path, 2, "double", "F", use_zstd(), -1)
  expect_equal(jsonlite::read_json(file.path(path, "zarr.json"))$fill_value, -1)

  path <- withr::local_tempfile(fileext = ".zarr")
  create_empty_zarr_array(path, 4, 2, "double", "F", use_zstd(), -1)
  expect_equal(jsonlite::read_json(file.path(path, "zarr.json"))$fill_value, -1)
})

test_that("codec: invalid codec lists are rejected before writing", {
  m <- matrix(runif(20), nrow = 4)
  x <- array(c("a", "bb"), dim = 2)
  path <- withr::local_tempfile(fileext = ".zarr")
  expect_error(
    write_zarr_array(m, path, chunk_dim = c(2, 3), codecs = use_zstd()),
    "must be a list of codecs"
  )
  expect_error(
    write_zarr_array(
      m,
      path,
      chunk_dim = c(2, 3),
      compressor = use_blosc(),
      codecs = list(use_zstd())
    ),
    "Only one of `compressor` and `codecs`"
  )
  expect_error(
    write_zarr_array(
      m,
      path,
      chunk_dim = c(2, 3),
      codecs = list(use_vlen_utf8())
    ),
    "requires `data_type = \"|O\"`",
    fixed = TRUE
  )
  expect_error(
    write_zarr_array(
      x,
      path,
      chunk_dim = 2,
      data_type = "|O",
      codecs = list(list(id = "bytes"))
    ),
    "need a variable-length codec"
  )
  expect_error(
    write_zarr_array(
      x,
      path,
      chunk_dim = 2,
      data_type = "|O",
      codecs = list(use_zstd(), use_vlen_utf8())
    ),
    "must come before the compressors"
  )
  expect_error(
    write_zarr_array(
      m,
      path,
      chunk_dim = c(2, 3),
      codecs = list(use_zstd(), use_zstd())
    ),
    "only be given once"
  )
  expect_error(
    write_zarr_array(
      m,
      path,
      chunk_dim = c(2, 3),
      codecs = list(use_zstd(), use_blosc()),
      zarr_version = 2L
    ),
    "at most one compressor"
  )
  expect_error(
    write_zarr_array(
      m,
      path,
      chunk_dim = c(2, 3),
      codecs = list(list(id = "bytes", endian = "big"))
    ),
    "takes no options"
  )
  expect_error(
    write_zarr_array(
      m,
      path,
      chunk_dim = c(2, 3),
      codecs = list(list(id = "crc32c"))
    ),
    "not supported for writing: crc32c"
  )
  expect_error(
    write_zarr_array(
      m,
      path,
      chunk_dim = c(2, 3),
      codecs = list(list(id = "transpose", order = 1:0))
    ),
    "set with `order`"
  )
  expect_error(
    write_zarr_array(
      m,
      path,
      chunk_dim = c(2, 3),
      codecs = list(use_lz4(), list(id = "numcodecs.lz4"))
    ),
    "only be given once"
  )
  expect_error(
    write_zarr_array(m, path, chunk_dim = c(2, 3), compressor = "zstd"),
    "`compressor` must be a compressor"
  )
  expect_error(
    write_zarr_array(array(1:2), path, chunk_dim = 2, data_type = "|O"),
    "is for character arrays"
  )
  expect_false(file.exists(path))
})
