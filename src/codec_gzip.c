#include "codec_gzip.h"
#include <stdint.h>

/* The 8-byte gzip trailer (RFC 1952) for the uncompressed bytes `input`: their
 * CRC-32, then their length modulo 2^32, both little-endian. R's memCompress()
 * only writes the zlib format (RFC 1950), so the gzip codec builds the gzip
 * format from its deflate data, a fixed header and this trailer.
 */
static uint32_t crc32_table[256];

/* Called once from R_init_Rarr() */
void make_crc32_table(void) {
  for (uint32_t n = 0; n < 256; n++) {
    uint32_t c = n;
    for (int k = 0; k < 8; k++)
      c = (c & 1) ? 0xEDB88320U ^ (c >> 1) : c >> 1;
    crc32_table[n] = c;
  }
}

static void write_uint32_le(unsigned char *p, uint32_t v) {
  p[0] = (unsigned char)(v & 0xFF);
  p[1] = (unsigned char)((v >> 8) & 0xFF);
  p[2] = (unsigned char)((v >> 16) & 0xFF);
  p[3] = (unsigned char)((v >> 24) & 0xFF);
}

SEXP gzip_trailer_c(SEXP input) {
  if (TYPEOF(input) != RAWSXP)
    error("gzip encoding needs a raw vector");

  const unsigned char *bytes = RAW(input);
  const R_xlen_t n = XLENGTH(input);
  uint32_t crc = 0xFFFFFFFFU;
  for (R_xlen_t i = 0; i < n; i++)
    crc = crc32_table[(crc ^ bytes[i]) & 0xFF] ^ (crc >> 8);
  crc ^= 0xFFFFFFFFU;

  SEXP out = PROTECT(allocVector(RAWSXP, 8));
  write_uint32_le(RAW(out), crc);
  write_uint32_le(RAW(out) + 4, (uint32_t)((uint64_t)n & 0xFFFFFFFFU));
  UNPROTECT(1);
  return out;
}
