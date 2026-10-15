#include "utils.h"

SEXP is_compact(SEXP x) {
  if (ALTREP(x)) {
    return ScalarLogical(TRUE);
  }
  return ScalarLogical(FALSE);
}

SEXP chop_vec(SEXP x, SEXP _size) {
  R_xlen_t n = XLENGTH(x);
  int size = INTEGER(_size)[0];
  R_xlen_t m = ceil((double)n / size);

  SEXP result = PROTECT(allocVector(VECSXP, m));
  SEXP el;
  
  R_xlen_t start = 0;

  for (R_xlen_t i = 0; i < m; i++) {
    if (start + size > n) {
      size = n - start;
    }
    el = allocVector(TYPEOF(x), size);
    // TODO: figure out how to use GET_REGION_PTR macro
    if (TYPEOF(x) == INTSXP) {
      INTEGER_GET_REGION(x, start, size, INTEGER(el));
    } else if (TYPEOF(x) == RAWSXP) {
      RAW_GET_REGION(x, start, size, RAW(el));
    }
    SET_VECTOR_ELT(result, i, el);
    start += size;
  }
  UNPROTECT(1);
  return result;
}

// Returns TRUE if every element of `x` equals the scalar `fill`. If `fill` is
// NA (or NaN), returns TRUE if every element of `x` is NA/NaN. Exits at the
// first mismatch.
SEXP is_all_fill(SEXP x, SEXP fill) {
  R_xlen_t n = XLENGTH(x);
  bool result = true;

  switch (TYPEOF(x)) {
  case LGLSXP: {
    const int *px = LOGICAL(x);
    int f = LOGICAL(fill)[0];
    for (R_xlen_t i = 0; i < n; i++) {
      if (px[i] != f) {
        result = false;
        break;
      }
    }
    break;
  }
  case INTSXP: {
    const int *px = INTEGER(x);
    int f = INTEGER(fill)[0];
    for (R_xlen_t i = 0; i < n; i++) {
      if (px[i] != f) {
        result = false;
        break;
      }
    }
    break;
  }
  case REALSXP: {
    const double *px = REAL(x);
    double f = REAL(fill)[0];
    if (ISNAN(f)) {
      for (R_xlen_t i = 0; i < n; i++) {
        if (!ISNAN(px[i])) {
          result = false;
          break;
        }
      }
    } else {
      // NaN compares false, so NA elements correctly return FALSE
      for (R_xlen_t i = 0; i < n; i++) {
        if (!(px[i] == f)) {
          result = false;
          break;
        }
      }
    }
    break;
  }
  case STRSXP: {
    SEXP f = STRING_ELT(fill, 0);
    for (R_xlen_t i = 0; i < n; i++) {
      SEXP el = STRING_ELT(x, i);
      if (el != f &&
          (el == NA_STRING || f == NA_STRING ||
           strcmp(translateCharUTF8(el), translateCharUTF8(f)) != 0)) {
        result = false;
        break;
      }
    }
    break;
  }
  default:
    error("unsupported type for `x`: %s", type2char(TYPEOF(x)));
  }

  return ScalarLogical(result);
}
