#include "Rarr.h"
#include <R_ext/Altrep.h>

SEXP is_compact(SEXP x);
SEXP chop_vec(SEXP x, SEXP _sizes);
SEXP is_all_fill(SEXP x, SEXP fill);
