test_that("codec: transpose", {
  x <- array(1:60, dim = c(3, 4, 5))

  for (perm in list(
    c(1L, 2L, 3L),
    c(3L, 2L, 1L),
    c(2L, 3L, 1L),
    c(3L, 1L, 2L),
    c(1L, 3L, 2L),
    c(2L, 1L, 3L)
  )) {
    decoded <- codec_transpose_encode(x, perm) |>
      codec_transpose_decode(perm)
    expect_identical(decoded, x)
  }

  c <- matrix(1:10, 2, 5, byrow = TRUE)
  f <- matrix(1:10, 2, 5, byrow = FALSE)
  # When writing a standard (F-order) matrix in R, and applying what looks like
  # a no-op transpose, we actually get a C-order interpretation of the data, as
  # expected by python.
  # rev() to emulate what is done in .configure_codecs()
  expect_identical(
    codec_transpose_decode(f, rev(c(1L, 2L))),
    c
  )
  expect_identical(
    codec_transpose_encode(c, rev(c(1L, 2L))),
    f
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
  expect_identical(
    `codec_vlen-utf8_encode`(character(0)),
    as.raw(c(0, 0, 0, 0))
  )

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

test_that("codec: gzip", {
  x <- charToRaw("Hello, world!")
  gziped <- codec_gzip_encode(x, level = 6L)
  # GZIP magic bytes
  expect_identical(gziped[1:2], as.raw(c(0x1f, 0x8b)))
  expect_identical(
    codec_gzip_decode(gziped),
    x
  )
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
