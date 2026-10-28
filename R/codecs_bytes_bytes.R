codec_blosc_decode <- function(bytes, ...) {
  .Call(
    "decompress_chunk_BLOSC",
    bytes,
    PACKAGE = "Rarr"
  )
}

codec_blosc_encode <- function(bytes, ...) {
  compressor_config <- list(...)
  .Call(
    "compress_chunk_BLOSC",
    bytes,
    compressor_config$typesize,
    compressor_config$cname,
    compressor_config$clevel,
    which(
      compressor_config$shuffle == c("noshuffle", "shuffle", "bitshuffle")
    ) -
      1L,
    compressor_config$blocksize,
    PACKAGE = "Rarr"
  )
}

codec_zlib_decode <- codec_gzip_decode <- function(bytes, ...) {
  memDecompress(
    from = bytes,
    type = "gzip",
    asChar = FALSE
  )
}

codec_zlib_encode <- function(bytes, ...) {
  memCompress(
    from = bytes,
    type = "gzip"
  )
}

codec_gzip_encode <- function(bytes, ...) {
  # memCompress(type = "gzip") writes the zlib format (RFC 1950): a 2-byte
  # header, the deflate data and a 4-byte Adler-32 checksum. The gzip format
  # (RFC 1952) wraps the same deflate data in its own header and trailer.
  zlib <- memCompress(
    from = bytes,
    type = "gzip"
  )
  deflate <- zlib[3L:(length(zlib) - 4L)]
  c(
    # ID1, ID2, CM (deflate), FLG, MTIME (4 bytes), XFL, OS (unknown)
    as.raw(c(0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff)),
    deflate,
    .Call("gzip_trailer_c", bytes, PACKAGE = "Rarr")
  )
}

codec_bz2_decode <- function(bytes, ...) {
  memDecompress(
    from = bytes,
    type = "bzip2",
    asChar = FALSE
  )
}

codec_bz2_encode <- function(bytes, ...) {
  memCompress(
    from = bytes,
    type = "bzip2"
  )
}

codec_lzma_decode <- function(bytes, ...) {
  memDecompress(
    from = bytes,
    type = "xz",
    asChar = FALSE
  )
}

codec_lzma_encode <- function(bytes, ...) {
  memCompress(
    from = bytes,
    type = "xz"
  )
}

#' @importFrom utils tail
codec_lz4_decode <- function(bytes, ...) {
  # numcodecs docs says:
  # The compressed output includes a 4-byte header storing the original size
  # of the decompressed data as a little-endian 32-bit integer.
  buffer_size <- readBin(bytes, "integer", n = 1L, size = 4L, endian = "little")
  .Call(
    "decompress_chunk_LZ4",
    tail(x = bytes, n = -4L),
    buffer_size,
    PACKAGE = "Rarr"
  )
}

codec_lz4_encode <- function(bytes, ...) {
  ## numpy stores the original size of the buffer in the first 4 bytes after
  ## compression. We should do that too for compatibility
  c(
    writeBin(length(bytes), raw(), size = 4L, endian = "little"),
    .Call("compress_chunk_LZ4", bytes, PACKAGE = "Rarr")
  )
}

codec_zstd_custom_decode <- function(bytes, ...) {
  .Call(
    "decompress_chunk_ZSTD",
    bytes,
    PACKAGE = "Rarr"
  )
}

codec_zstd_custom_encode <- function(bytes, ...) {
  compressor_config <- list(...)
  .Call(
    "compress_chunk_ZSTD",
    bytes,
    as.integer(compressor_config$level),
    PACKAGE = "Rarr"
  )
}

codec_zstd_base_decode <- function(bytes, ...) {
  memDecompress(bytes, type = "zstd", asChar = FALSE)
}

codec_zstd_base_encode <- function(bytes, ...) {
  memCompress(bytes, type = "zstd")
}
