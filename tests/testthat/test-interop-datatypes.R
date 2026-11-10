skip_if_no_zarr_py()

# values beyond the int32 range read back as NA before grumpy 0.1.1.9005
int64_read_issue <- if (packageVersion("grumpy") < "0.1.1.9005") "#289"

cases <- list(
  interop_case(
    name = "bool",
    dtype = "bool",
    x = c(TRUE, FALSE, TRUE, TRUE, FALSE)
  ),
  interop_case(
    name = "int8",
    dtype = "int8",
    x = c(-128L, -1L, 0L, 1L, 127L)
  ),
  interop_case(
    name = "int16",
    dtype = "int16",
    x = c(-32768L, -1L, 0L, 1L, 32767L)
  ),
  interop_case(
    name = "int32",
    dtype = "int32",
    x = c(-.Machine$integer.max, -1L, 0L, 1L, .Machine$integer.max)
  ),
  interop_case(
    name = "int64",
    dtype = "int64",
    x = c(-.Machine$integer.max, -1L, 0L, 1L, .Machine$integer.max)
  ),
  interop_case(
    name = "int64 beyond the int32 range",
    dtype = "int64",
    x = c(-2^40, -2^31 - 5, 0, 2^31 + 5, 2^40),
    known_issue = list(read = int64_read_issue, write = "#289")
  ),
  interop_case(
    name = "uint8",
    dtype = "uint8",
    x = c(0L, 1L, 127L, 128L, 255L)
  ),
  interop_case(
    name = "uint16",
    dtype = "uint16",
    x = c(0L, 1L, 32767L, 32768L, 65535L)
  ),
  interop_case(
    name = "uint32",
    dtype = "uint32",
    x = c(0L, 1L, 255L, 65535L, .Machine$integer.max)
  ),
  interop_case(
    name = "uint32 beyond the int32 range",
    dtype = "uint32",
    x = c(0, 1, 2^31, 2^32 - 2, 2^32 - 1),
    known_issue = list(read = int64_read_issue, write = "#289")
  ),
  interop_case(
    name = "uint64",
    dtype = "uint64",
    x = c(0L, 1L, 255L, 65535L, .Machine$integer.max)
  ),
  interop_case(
    name = "uint64 beyond the int32 range",
    dtype = "uint64",
    x = c(0, 1, 2^31, 2^40, 2^53),
    known_issue = list(read = int64_read_issue, write = "#289")
  ),
  interop_case(
    name = "float16",
    dtype = "float16",
    x = c(-65504, -1.5, 0, 0.25, 65504),
    supported = "read"
  ),
  interop_case(
    name = "float32",
    dtype = "float32",
    x = c(NaN, -1.5, -0, 2^-149, 2^24)
  ),
  interop_case(
    name = "float32 beyond the int32 range",
    dtype = "float32",
    x = c(-Inf, -3.4028234663852886e38, -2^40, 2^40, Inf),
    known_issue = list(write = "#304")
  ),
  interop_case(
    name = "float64",
    dtype = "float64",
    x = c(-.Machine$double.xmax, -1.5, 0, 0.25, .Machine$double.xmax)
  ),
  interop_case(
    name = "float64 with special values",
    dtype = "float64",
    x = c(NaN, -Inf, -0, 5e-324, Inf)
  ),
  interop_case(
    name = "string",
    dtype = "string",
    x = c("a", "", "with space", "héllo", "多字节")
  )
)

test_interop_cases(cases)
