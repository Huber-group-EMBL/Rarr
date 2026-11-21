Zarr arrays with Rarr
================

- [Introduction to Rarr](#introduction-to-rarr)
  - [Limitations with **Rarr**](#limitations-with-rarr)
- [Quick start guide](#quick-start-guide)
  - [Installation and setup](#installation-and-setup)
  - [Reading a from a local Zarr
    array](#reading-a-from-a-local-zarr-array)
  - [Reading from S3 storage](#read-s3)
  - [Writing to a Zarr array](#writing-to-a-zarr-array)
- [Required system libraries](#required-system-libraries)
  - [Funding](#funding)

<!-- badges: start -->

| GitHub Actions | Bioconductor Build Sysytem | Test Coverage |
|:--:|:--:|:--:|
| [![R-CMD-check](https://github.com/Huber-group-EMBL/Rarr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Huber-group-EMBL/Rarr/actions/workflows/R-CMD-check.yaml) | [![Bioconductor Status](https://bioconductor.org/shields/build/devel/bioc/Rarr.svg)](https://bioconductor.org/checkResults/devel/bioc-LATEST/Rarr/) | [![Codecov test coverage](https://codecov.io/gh/Huber-group-EMBL/Rarr/graph/badge.svg)](https://app.codecov.io/gh/Huber-group-EMBL/Rarr) |

<!-- badges: end -->

# Introduction to Rarr

The Zarr specification defines a format for chunked, compressed,
N-dimensional arrays. It’s design allows efficient access to subsets of
the stored array, and supports both local and cloud storage systems.
Zarr is experiencing increasing adoption in a number of scientific
fields, where multi-dimensional data are prevalent.

**Rarr** is intended to be a simple interface to reading and writing
individual Zarr arrays. It is developed in R and C with no reliance on
external libraries or APIs for interfacing with the Zarr arrays.
Additional compression libraries (e.g. blosc) are bundled with **Rarr**
to provide support for datasets compressed using these tools.

## Limitations with **Rarr**

If you know about Zarr arrays already, you’ll probably be aware they can
be stored in hierarchical groups, where additional meta data can explain
the relationship between the arrays. Currently, **Rarr** is not designed
to be aware of these hierarchical Zarr array collections. However, the
component arrays can be read individually by providing the path to them
directly.

Currently, there are also limitations on the Zarr datatypes that can be
accessed using **Rarr**. For now most numeric types can be read into R,
although in some instances e.g. 64-bit integers there is potential for
loss of information.

See the dedicated [“Supported Zarr features”
vignette](https://huber-group-embl.github.io/Rarr/articles/features.html)
for more information.

# Quick start guide

## Installation and setup

If you want to quickly get started reading an existing Zarr array with
the package, this section should have the essentials covered. First, we
need to install **Rarr**[^1] with the commands below.

``` r
## we need BiocManager to perform the installation
if (!require("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
## install Rarr
BiocManager::install("Rarr")
```

Once **Rarr** is installed, we have to load it into our R session:

``` r
library(Rarr)
```

**Rarr** can be used to read files either on local disk or on remote S3
storage systems. First lets take a look at reading from a local file.

**Rarr** uses the
[progressr](https://cran.r-project.org/package=progressr) package to
provide progress updates when reading or writing Zarr arrays. If you
want to see the progress updates, you need to set up a progress handler.
The simplest way to do this is with the `handlers()` function:

``` r
library(progressr)
old_handlers <- handlers("txtprogressbar")
# Remove the progress bar setting when exiting this session
on.exit(handlers(old_handlers))
```

## Reading a from a local Zarr array

To demonstrate reading a local file, we’ll pick the example file
containing 32-bit integers arranged in the “column first” ordering.

``` r
zarr_example <- system.file(
  "extdata",
  "zarr_examples",
  "column-first",
  "int32.zarr",
  package = "Rarr"
)
```

### Exploring the data

We can get an summary of the array properties, such as its shape and
datatype, or group properties, using the function `zarr_overview()`[^2].

``` r
zarr_overview(zarr_example)
```

    ## Type: Array
    ## Path: /tmp/RtmpN7QCt8/temp_libpath105384558e8086/Rarr/extdata/zarr_examples/column-first/int32.zarr
    ## Zarr Format: 2
    ## Shape: 30 x 20 x 10
    ## Chunk Shape: 10 x 10 x 5
    ## No. of Chunks: 12 (3 x 2 x 2)
    ## Data Type: int32
    ## Endianness: little
    ## Compressor: zstd
    ## Attributes: no

You can use this to check that the location is a valid Zarr array, and
that the shape and datatype of the array content are what you are
expecting. For example, we can see in the output above that the data
type (`int32`) corresponds to what we expect.

### Reading the Zarr array

The summary information retrieved above is required, as to read the
array with **Rarr** you need to know the shape and size of the array
(unless you want to read the entire array). From the previous output we
can see our example array has three dimensions of size 30 x 20 x 10. We
can select the subset we want to extract using a `list`. The list must
have the same length as the number of dimensions in our array, with each
element of the list corresponding to the indices you want to extract in
that dimension.

``` r
index <- list(1:4, 1:2, 1)
```

We then extract the subset using `read_zarr_array()`:

``` r
read_zarr_array(zarr_example, index = index)
```

    ## , , 1
    ## 
    ##      [,1] [,2]
    ## [1,]    1    2
    ## [2,]    1    0
    ## [3,]    1    0
    ## [4,]    1    0

## Reading from S3 storage

Read the dedicated [“Working with **remote** Zarr arrays in R”
vignette](https://huber-group-embl.github.io/Rarr/articles/S3.html) for
more information on reading Zarr arrays from S3 storage.

## Writing to a Zarr array

Up until now we’ve only covered reading existing Zarr array into R.
However, **Rarr** can also be used to write R data to disk following the
Zarr specification. To explore this, lets create an example array we
want to save as a Zarr. In this case it’s going to be a three
dimensional array and store the values 1 to 600.

``` r
x <- array(1:600, dim = c(10, 10, 6))
```

``` r
path_to_new_zarr <- file.path(tempdir(), "new.zarr")
write_zarr_array(
  x = x,
  zarr_array_path = path_to_new_zarr,
  chunk_dim = c(10, 5, 1)
)
```

We can check that the contents of the Zarr array is what we’re
expecting. Since the contents of the whole array will be too large to
display here, we use the `index` argument to extract rows 6 to 10, from
the 10th column and 1st slice. That should be the values 96, 97, 98, 99,
100, but retaining the 3-dimensional array structure of the original
array. The second line below uses `identical()` to confirm that reading
the whole Zarr returns something equivalent to our original input `x`.

``` r
read_zarr_array(zarr_array_path = path_to_new_zarr, index = list(6:10, 10, 1))
```

    ## , , 1
    ## 
    ##      [,1]
    ## [1,]   96
    ## [2,]   97
    ## [3,]   98
    ## [4,]   99
    ## [5,]  100

``` r
identical(read_zarr_array(zarr_array_path = path_to_new_zarr), x)
```

    ## [1] TRUE

# Required system libraries

To provide support for BLOSC and zstd compression tools Rarr links
against libraries providing these tools. If you have them installed on
your system Rarr will attempt to use those versions. If they are not
detected then Rarr will compile and use versions that are distributed
with the package. Either way the functionality will available, however
if you are using the system libraries and then later remove them Rarr
may fail to work correctly.

This only concerns users installing the package from source. If you are
using the pre-built binaries for Windows or Mac OSX distributed by
Bioconductor then this should not be an issue for you.

## Funding

Funding for continued development and maintenance of this package is
provided by the German Network for Bioinformatics Infrastructure.

This is an approved de.NBI service. Please help us improve by taking
[our short user
survey](https://www.surveymonkey.de/r/denbi-service?sc=hd-hub&tool=rarr).

<a href="https://www.denbi.de"><img src="https://tess.elixir-europe.org/system/content_providers/images/000/000/063/original/deNBI_Logo_rgb.jpg" width="400" align="left"></a>

[^1]: you only need to do the installation step once

[^2]: This is essentially reading and formatting the array metadata that
    accompanies any Zarr array, or the consolidated metadata if present
    in the case of a Zarr group.
