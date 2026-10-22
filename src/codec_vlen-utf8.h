#ifndef _CODECS_H
#define _CODECS_H

#include "Rarr.h"

SEXP codec_vlen_utf8_decode_c(SEXP input, SEXP chunk_dim);
SEXP codec_vlen_utf8_encode_c(SEXP input);

#endif
