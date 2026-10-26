#ifndef _CODEC_GZIP_H
#define _CODEC_GZIP_H

#include "Rarr.h"

void make_crc32_table(void);
SEXP gzip_trailer_c(SEXP input);

#endif
