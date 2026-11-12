# Truncate overflow values and warn about bool NA values before writing

Applies the two pre-write data checks that are needed identically in
both
[`write_zarr_array()`](https://huber-group-embl.github.io/Rarr/reference/write_zarr_array.md)
and
[`update_zarr_array()`](https://huber-group-embl.github.io/Rarr/reference/update_zarr_array.md):

## Usage

``` r
.prepare_write_data(x, metadata)
```

## Arguments

- x:

  The R array to be written.

- metadata:

  Array metadata list as returned by
  [`.read_array_metadata()`](https://huber-group-embl.github.io/Rarr/reference/dot-read_array_metadata.md).

## Value

`x`, possibly with overflow values clamped.

## Details

1.  If the target type is an integer type narrower than R's native
    representation (`int8`, `int16`), clamp out-of-range values via
    `.truncate_overflow()`. Floats are not clamped, since
    [`writeBin()`](https://rdrr.io/r/base/readBin.html) follows IEEE 754
    when narrowing to `float32`, values beyond its range become `Inf` or
    `-Inf`.

2.  If the target type is `bool`, warn when `x` contains `NA` values
    (which the Zarr bool type cannot represent).
