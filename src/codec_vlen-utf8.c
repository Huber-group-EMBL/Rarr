#include "codec_vlen-utf8.h"
#include <string.h>

/* Decode a vlen-utf8 encoded raw vector (numcodecs VLenUTF8 format).
 *
 * Format (all integers little-endian):
 *   [4 bytes] nvalues
 *   repeated nvalues times:
 *     [4 bytes] nbytes_i
 *     [nbytes_i bytes] utf-8 string data (no NUL terminator)
 *
 * Only the first `n_needed` strings are decoded (NULL means all). The rest are
 * left as "" since they are discarded later in the reading pipeline.
 */
SEXP codec_vlen_utf8_decode_c(SEXP input, SEXP chunk_dim, SEXP n_needed) {

  const unsigned char *buf = RAW_RO(input);
  const R_xlen_t buf_len = xlength(input);

  if (buf_len < 4)
    error("vlen-utf8 buffer too short to contain nvalues header");

  /* Read nvalues (little-endian uint32) */
  uint32_t nvalues;
  memcpy(&nvalues, buf, 4);

  SEXP data = PROTECT(allocVector(STRSXP, (R_xlen_t)nvalues));

  const unsigned char *pos = buf + 4;
  const unsigned char *end = buf + buf_len;

  uint32_t n_decode = nvalues;
  if (!isNull(n_needed)) {
    double n = asReal(n_needed);
    if (!ISNAN(n) && n >= 0 && n < (double)nvalues)
      n_decode = (uint32_t)n;
  }

  for (uint32_t i = 0; i < n_decode; i++) {

    if (pos + 4 > end)
      error("vlen-utf8 buffer too short reading length of element %u", i);

    uint32_t nbytes;
    memcpy(&nbytes, pos, 4);
    pos += 4;

    if (pos + nbytes > end)
      error("vlen-utf8 buffer too short reading data of element %u", i);

    SET_STRING_ELT(data, i, mkCharLenCE((const char *)pos, (int)nbytes, CE_UTF8));
    pos += nbytes;
  }

  /* Set dim attribute if chunk_dim is not NULL / NA */
  if (!isNull(chunk_dim) && xlength(chunk_dim) > 0) {
    Rf_dimgets(data, chunk_dim);
  }

  UNPROTECT(1);
  return data;
}

/* Encode a character vector as vlen-utf8 (numcodecs VLenUTF8 format), in the
 * layout read by codec_vlen_utf8_decode_c() above. As in the previous R
 * encoder (charToRaw(enc2utf8(x))), strings are converted to UTF-8, strings
 * marked as "bytes" are written unchanged, and NA is written as "NA".
 */
static void write_uint32_le(unsigned char *p, uint32_t v) {
  p[0] = (unsigned char)(v & 0xFF);
  p[1] = (unsigned char)((v >> 8) & 0xFF);
  p[2] = (unsigned char)((v >> 16) & 0xFF);
  p[3] = (unsigned char)((v >> 24) & 0xFF);
}

SEXP codec_vlen_utf8_encode_c(SEXP input) {

  if (!isString(input))
    error("vlen-utf8 encoding needs a character vector");

  const R_xlen_t n = xlength(input);
  if ((double)n > (double)UINT32_MAX)
    error("vlen-utf8 encoding of more than %u strings in one chunk (got %lld). "
          "Try using a smaller chunk shape.",
          UINT32_MAX, (long long)n);

  /* First pass: the UTF-8 bytes of each string and the total size */
  const char **strings = (const char **)R_alloc((size_t)n, sizeof(char *));
  uint32_t *nbytes = (uint32_t *)R_alloc((size_t)n, sizeof(uint32_t));
  double total = 4;
  for (R_xlen_t i = 0; i < n; i++) {
    const SEXP el = STRING_ELT(input, i);
    const char *s = getCharCE(el) == CE_BYTES ? CHAR(el) : translateCharUTF8(el);
    size_t len = strlen(s);
    if ((double)len > (double)UINT32_MAX)
      error("vlen-utf8 encoding of a string longer than %u bytes (got %zu)",
            UINT32_MAX, len);
    strings[i] = s;
    nbytes[i] = (uint32_t)len;
    total += 4 + (double)len;
  }
  if (total > (double)R_XLEN_T_MAX)
    error("vlen-utf8 encoding larger than a raw vector can hold (%.0f > %.0f "
          "bytes). Try using a smaller chunk shape.",
          total, (double)R_XLEN_T_MAX);

  /* Second pass: nvalues, then each length and its bytes */
  SEXP out = PROTECT(allocVector(RAWSXP, (R_xlen_t)total));
  unsigned char *pos = RAW(out);
  write_uint32_le(pos, (uint32_t)n);
  pos += 4;
  for (R_xlen_t i = 0; i < n; i++) {
    write_uint32_le(pos, nbytes[i]);
    pos += 4;
    memcpy(pos, strings[i], nbytes[i]);
    pos += nbytes[i];
  }

  UNPROTECT(1);
  return out;
}
