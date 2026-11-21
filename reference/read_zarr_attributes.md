# Read the attributes associated with a Zarr array or group

Read the attributes associated with a Zarr array or group

## Usage

``` r
read_zarr_attributes(
  zarr_path,
  s3_client = NULL,
  missing = c("ignore", "warning", "error")
)
```

## Arguments

- zarr_path:

  A character vector of length 1. This provides the path to a Zarr array
  or group of arrays. This can either be on a local file system or on S3
  storage.

- s3_client:

  A list representing an S3 client. This should be produced by
  [`paws.storage::s3()`](https://rdrr.io/pkg/paws.storage/man/s3.html).

- missing:

  A character vector of length 1. This determines the behaviour when no
  file containing attributes is found. This can be one of:

  - "ignore" (the default): `NULL` is returned silently

  - "warning": a warning is issued and `NULL` is returned.

  - "error": an error is raised.

## Value

A list containing the attributes. If the file containing attributes
(`.zattrs` for Zarr v2 or `zarr.json` for Zarr v3) exists but no
attributes are provided, `NULL` is returned.

## Examples

``` r
read_zarr_attributes(
  "https://livingobjects.ebi.ac.uk/bioimaging-integrator-data/S-BIAD800/f49ada41-43bf-47ff-99b9-bdf8cc311ce3/f49ada41-43bf-47ff-99b9-bdf8cc311ce3.zarr/0/"
)
#> $multiscales
#> $multiscales[[1]]
#> $multiscales[[1]]$metadata
#> $multiscales[[1]]$metadata$method
#> [1] "loci.common.image.SimpleImageScaler"
#> 
#> $multiscales[[1]]$metadata$version
#> [1] "Bio-Formats 0.6.8"
#> 
#> 
#> $multiscales[[1]]$axes
#> $multiscales[[1]]$axes[[1]]
#> $multiscales[[1]]$axes[[1]]$name
#> [1] "t"
#> 
#> $multiscales[[1]]$axes[[1]]$type
#> [1] "time"
#> 
#> 
#> $multiscales[[1]]$axes[[2]]
#> $multiscales[[1]]$axes[[2]]$name
#> [1] "c"
#> 
#> $multiscales[[1]]$axes[[2]]$type
#> [1] "channel"
#> 
#> 
#> $multiscales[[1]]$axes[[3]]
#> $multiscales[[1]]$axes[[3]]$name
#> [1] "z"
#> 
#> $multiscales[[1]]$axes[[3]]$type
#> [1] "space"
#> 
#> 
#> $multiscales[[1]]$axes[[4]]
#> $multiscales[[1]]$axes[[4]]$name
#> [1] "y"
#> 
#> $multiscales[[1]]$axes[[4]]$type
#> [1] "space"
#> 
#> 
#> $multiscales[[1]]$axes[[5]]
#> $multiscales[[1]]$axes[[5]]$name
#> [1] "x"
#> 
#> $multiscales[[1]]$axes[[5]]$type
#> [1] "space"
#> 
#> 
#> 
#> $multiscales[[1]]$name
#> [1] "Tonsil 3_C00.png"
#> 
#> $multiscales[[1]]$datasets
#> $multiscales[[1]]$datasets[[1]]
#> $multiscales[[1]]$datasets[[1]]$path
#> [1] "0"
#> 
#> $multiscales[[1]]$datasets[[1]]$coordinateTransformations
#> $multiscales[[1]]$datasets[[1]]$coordinateTransformations[[1]]
#> $multiscales[[1]]$datasets[[1]]$coordinateTransformations[[1]]$scale
#> $multiscales[[1]]$datasets[[1]]$coordinateTransformations[[1]]$scale[[1]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[1]]$coordinateTransformations[[1]]$scale[[2]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[1]]$coordinateTransformations[[1]]$scale[[3]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[1]]$coordinateTransformations[[1]]$scale[[4]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[1]]$coordinateTransformations[[1]]$scale[[5]]
#> [1] 1
#> 
#> 
#> $multiscales[[1]]$datasets[[1]]$coordinateTransformations[[1]]$type
#> [1] "scale"
#> 
#> 
#> 
#> 
#> $multiscales[[1]]$datasets[[2]]
#> $multiscales[[1]]$datasets[[2]]$path
#> [1] "1"
#> 
#> $multiscales[[1]]$datasets[[2]]$coordinateTransformations
#> $multiscales[[1]]$datasets[[2]]$coordinateTransformations[[1]]
#> $multiscales[[1]]$datasets[[2]]$coordinateTransformations[[1]]$scale
#> $multiscales[[1]]$datasets[[2]]$coordinateTransformations[[1]]$scale[[1]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[2]]$coordinateTransformations[[1]]$scale[[2]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[2]]$coordinateTransformations[[1]]$scale[[3]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[2]]$coordinateTransformations[[1]]$scale[[4]]
#> [1] 2
#> 
#> $multiscales[[1]]$datasets[[2]]$coordinateTransformations[[1]]$scale[[5]]
#> [1] 2
#> 
#> 
#> $multiscales[[1]]$datasets[[2]]$coordinateTransformations[[1]]$type
#> [1] "scale"
#> 
#> 
#> 
#> 
#> $multiscales[[1]]$datasets[[3]]
#> $multiscales[[1]]$datasets[[3]]$path
#> [1] "2"
#> 
#> $multiscales[[1]]$datasets[[3]]$coordinateTransformations
#> $multiscales[[1]]$datasets[[3]]$coordinateTransformations[[1]]
#> $multiscales[[1]]$datasets[[3]]$coordinateTransformations[[1]]$scale
#> $multiscales[[1]]$datasets[[3]]$coordinateTransformations[[1]]$scale[[1]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[3]]$coordinateTransformations[[1]]$scale[[2]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[3]]$coordinateTransformations[[1]]$scale[[3]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[3]]$coordinateTransformations[[1]]$scale[[4]]
#> [1] 4
#> 
#> $multiscales[[1]]$datasets[[3]]$coordinateTransformations[[1]]$scale[[5]]
#> [1] 4
#> 
#> 
#> $multiscales[[1]]$datasets[[3]]$coordinateTransformations[[1]]$type
#> [1] "scale"
#> 
#> 
#> 
#> 
#> $multiscales[[1]]$datasets[[4]]
#> $multiscales[[1]]$datasets[[4]]$path
#> [1] "3"
#> 
#> $multiscales[[1]]$datasets[[4]]$coordinateTransformations
#> $multiscales[[1]]$datasets[[4]]$coordinateTransformations[[1]]
#> $multiscales[[1]]$datasets[[4]]$coordinateTransformations[[1]]$scale
#> $multiscales[[1]]$datasets[[4]]$coordinateTransformations[[1]]$scale[[1]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[4]]$coordinateTransformations[[1]]$scale[[2]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[4]]$coordinateTransformations[[1]]$scale[[3]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[4]]$coordinateTransformations[[1]]$scale[[4]]
#> [1] 8
#> 
#> $multiscales[[1]]$datasets[[4]]$coordinateTransformations[[1]]$scale[[5]]
#> [1] 8
#> 
#> 
#> $multiscales[[1]]$datasets[[4]]$coordinateTransformations[[1]]$type
#> [1] "scale"
#> 
#> 
#> 
#> 
#> $multiscales[[1]]$datasets[[5]]
#> $multiscales[[1]]$datasets[[5]]$path
#> [1] "4"
#> 
#> $multiscales[[1]]$datasets[[5]]$coordinateTransformations
#> $multiscales[[1]]$datasets[[5]]$coordinateTransformations[[1]]
#> $multiscales[[1]]$datasets[[5]]$coordinateTransformations[[1]]$scale
#> $multiscales[[1]]$datasets[[5]]$coordinateTransformations[[1]]$scale[[1]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[5]]$coordinateTransformations[[1]]$scale[[2]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[5]]$coordinateTransformations[[1]]$scale[[3]]
#> [1] 1
#> 
#> $multiscales[[1]]$datasets[[5]]$coordinateTransformations[[1]]$scale[[4]]
#> [1] 16
#> 
#> $multiscales[[1]]$datasets[[5]]$coordinateTransformations[[1]]$scale[[5]]
#> [1] 16
#> 
#> 
#> $multiscales[[1]]$datasets[[5]]$coordinateTransformations[[1]]$type
#> [1] "scale"
#> 
#> 
#> 
#> 
#> 
#> $multiscales[[1]]$version
#> [1] "0.4"
#> 
#> 
#> 
#> $omero
#> $omero$channels
#> $omero$channels[[1]]
#> $omero$channels[[1]]$color
#> [1] "FF0000"
#> 
#> $omero$channels[[1]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[1]]$active
#> [1] TRUE
#> 
#> $omero$channels[[1]]$label
#> [1] "Channel 0"
#> 
#> $omero$channels[[1]]$window
#> $omero$channels[[1]]$window$min
#> [1] 0
#> 
#> $omero$channels[[1]]$window$max
#> [1] 255
#> 
#> $omero$channels[[1]]$window$start
#> [1] 0
#> 
#> $omero$channels[[1]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[1]]$family
#> [1] "linear"
#> 
#> $omero$channels[[1]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[2]]
#> $omero$channels[[2]]$color
#> [1] "00FF00"
#> 
#> $omero$channels[[2]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[2]]$active
#> [1] TRUE
#> 
#> $omero$channels[[2]]$label
#> [1] "Channel 1"
#> 
#> $omero$channels[[2]]$window
#> $omero$channels[[2]]$window$min
#> [1] 0
#> 
#> $omero$channels[[2]]$window$max
#> [1] 255
#> 
#> $omero$channels[[2]]$window$start
#> [1] 0
#> 
#> $omero$channels[[2]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[2]]$family
#> [1] "linear"
#> 
#> $omero$channels[[2]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[3]]
#> $omero$channels[[3]]$color
#> [1] "0000FF"
#> 
#> $omero$channels[[3]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[3]]$active
#> [1] TRUE
#> 
#> $omero$channels[[3]]$label
#> [1] "Channel 2"
#> 
#> $omero$channels[[3]]$window
#> $omero$channels[[3]]$window$min
#> [1] 0
#> 
#> $omero$channels[[3]]$window$max
#> [1] 255
#> 
#> $omero$channels[[3]]$window$start
#> [1] 0
#> 
#> $omero$channels[[3]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[3]]$family
#> [1] "linear"
#> 
#> $omero$channels[[3]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[4]]
#> $omero$channels[[4]]$color
#> [1] "FF0000"
#> 
#> $omero$channels[[4]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[4]]$active
#> [1] FALSE
#> 
#> $omero$channels[[4]]$label
#> [1] "Channel 3"
#> 
#> $omero$channels[[4]]$window
#> $omero$channels[[4]]$window$min
#> [1] 0
#> 
#> $omero$channels[[4]]$window$max
#> [1] 255
#> 
#> $omero$channels[[4]]$window$start
#> [1] 0
#> 
#> $omero$channels[[4]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[4]]$family
#> [1] "linear"
#> 
#> $omero$channels[[4]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[5]]
#> $omero$channels[[5]]$color
#> [1] "00FF00"
#> 
#> $omero$channels[[5]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[5]]$active
#> [1] FALSE
#> 
#> $omero$channels[[5]]$label
#> [1] "Channel 4"
#> 
#> $omero$channels[[5]]$window
#> $omero$channels[[5]]$window$min
#> [1] 0
#> 
#> $omero$channels[[5]]$window$max
#> [1] 255
#> 
#> $omero$channels[[5]]$window$start
#> [1] 0
#> 
#> $omero$channels[[5]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[5]]$family
#> [1] "linear"
#> 
#> $omero$channels[[5]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[6]]
#> $omero$channels[[6]]$color
#> [1] "0000FF"
#> 
#> $omero$channels[[6]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[6]]$active
#> [1] FALSE
#> 
#> $omero$channels[[6]]$label
#> [1] "Channel 5"
#> 
#> $omero$channels[[6]]$window
#> $omero$channels[[6]]$window$min
#> [1] 0
#> 
#> $omero$channels[[6]]$window$max
#> [1] 255
#> 
#> $omero$channels[[6]]$window$start
#> [1] 0
#> 
#> $omero$channels[[6]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[6]]$family
#> [1] "linear"
#> 
#> $omero$channels[[6]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[7]]
#> $omero$channels[[7]]$color
#> [1] "FF0000"
#> 
#> $omero$channels[[7]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[7]]$active
#> [1] FALSE
#> 
#> $omero$channels[[7]]$label
#> [1] "Channel 6"
#> 
#> $omero$channels[[7]]$window
#> $omero$channels[[7]]$window$min
#> [1] 0
#> 
#> $omero$channels[[7]]$window$max
#> [1] 255
#> 
#> $omero$channels[[7]]$window$start
#> [1] 0
#> 
#> $omero$channels[[7]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[7]]$family
#> [1] "linear"
#> 
#> $omero$channels[[7]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[8]]
#> $omero$channels[[8]]$color
#> [1] "00FF00"
#> 
#> $omero$channels[[8]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[8]]$active
#> [1] FALSE
#> 
#> $omero$channels[[8]]$label
#> [1] "Channel 7"
#> 
#> $omero$channels[[8]]$window
#> $omero$channels[[8]]$window$min
#> [1] 0
#> 
#> $omero$channels[[8]]$window$max
#> [1] 255
#> 
#> $omero$channels[[8]]$window$start
#> [1] 0
#> 
#> $omero$channels[[8]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[8]]$family
#> [1] "linear"
#> 
#> $omero$channels[[8]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[9]]
#> $omero$channels[[9]]$color
#> [1] "0000FF"
#> 
#> $omero$channels[[9]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[9]]$active
#> [1] FALSE
#> 
#> $omero$channels[[9]]$label
#> [1] "Channel 8"
#> 
#> $omero$channels[[9]]$window
#> $omero$channels[[9]]$window$min
#> [1] 0
#> 
#> $omero$channels[[9]]$window$max
#> [1] 255
#> 
#> $omero$channels[[9]]$window$start
#> [1] 0
#> 
#> $omero$channels[[9]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[9]]$family
#> [1] "linear"
#> 
#> $omero$channels[[9]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[10]]
#> $omero$channels[[10]]$color
#> [1] "FF0000"
#> 
#> $omero$channels[[10]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[10]]$active
#> [1] FALSE
#> 
#> $omero$channels[[10]]$label
#> [1] "Channel 9"
#> 
#> $omero$channels[[10]]$window
#> $omero$channels[[10]]$window$min
#> [1] 0
#> 
#> $omero$channels[[10]]$window$max
#> [1] 255
#> 
#> $omero$channels[[10]]$window$start
#> [1] 0
#> 
#> $omero$channels[[10]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[10]]$family
#> [1] "linear"
#> 
#> $omero$channels[[10]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[11]]
#> $omero$channels[[11]]$color
#> [1] "00FF00"
#> 
#> $omero$channels[[11]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[11]]$active
#> [1] FALSE
#> 
#> $omero$channels[[11]]$label
#> [1] "Channel 10"
#> 
#> $omero$channels[[11]]$window
#> $omero$channels[[11]]$window$min
#> [1] 0
#> 
#> $omero$channels[[11]]$window$max
#> [1] 255
#> 
#> $omero$channels[[11]]$window$start
#> [1] 0
#> 
#> $omero$channels[[11]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[11]]$family
#> [1] "linear"
#> 
#> $omero$channels[[11]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[12]]
#> $omero$channels[[12]]$color
#> [1] "0000FF"
#> 
#> $omero$channels[[12]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[12]]$active
#> [1] FALSE
#> 
#> $omero$channels[[12]]$label
#> [1] "Channel 11"
#> 
#> $omero$channels[[12]]$window
#> $omero$channels[[12]]$window$min
#> [1] 0
#> 
#> $omero$channels[[12]]$window$max
#> [1] 255
#> 
#> $omero$channels[[12]]$window$start
#> [1] 0
#> 
#> $omero$channels[[12]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[12]]$family
#> [1] "linear"
#> 
#> $omero$channels[[12]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[13]]
#> $omero$channels[[13]]$color
#> [1] "FF0000"
#> 
#> $omero$channels[[13]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[13]]$active
#> [1] FALSE
#> 
#> $omero$channels[[13]]$label
#> [1] "Channel 12"
#> 
#> $omero$channels[[13]]$window
#> $omero$channels[[13]]$window$min
#> [1] 0
#> 
#> $omero$channels[[13]]$window$max
#> [1] 255
#> 
#> $omero$channels[[13]]$window$start
#> [1] 0
#> 
#> $omero$channels[[13]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[13]]$family
#> [1] "linear"
#> 
#> $omero$channels[[13]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[14]]
#> $omero$channels[[14]]$color
#> [1] "00FF00"
#> 
#> $omero$channels[[14]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[14]]$active
#> [1] FALSE
#> 
#> $omero$channels[[14]]$label
#> [1] "Channel 13"
#> 
#> $omero$channels[[14]]$window
#> $omero$channels[[14]]$window$min
#> [1] 0
#> 
#> $omero$channels[[14]]$window$max
#> [1] 255
#> 
#> $omero$channels[[14]]$window$start
#> [1] 0
#> 
#> $omero$channels[[14]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[14]]$family
#> [1] "linear"
#> 
#> $omero$channels[[14]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[15]]
#> $omero$channels[[15]]$color
#> [1] "0000FF"
#> 
#> $omero$channels[[15]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[15]]$active
#> [1] FALSE
#> 
#> $omero$channels[[15]]$label
#> [1] "Channel 14"
#> 
#> $omero$channels[[15]]$window
#> $omero$channels[[15]]$window$min
#> [1] 0
#> 
#> $omero$channels[[15]]$window$max
#> [1] 255
#> 
#> $omero$channels[[15]]$window$start
#> [1] 0
#> 
#> $omero$channels[[15]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[15]]$family
#> [1] "linear"
#> 
#> $omero$channels[[15]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[16]]
#> $omero$channels[[16]]$color
#> [1] "FF0000"
#> 
#> $omero$channels[[16]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[16]]$active
#> [1] FALSE
#> 
#> $omero$channels[[16]]$label
#> [1] "Channel 15"
#> 
#> $omero$channels[[16]]$window
#> $omero$channels[[16]]$window$min
#> [1] 0
#> 
#> $omero$channels[[16]]$window$max
#> [1] 255
#> 
#> $omero$channels[[16]]$window$start
#> [1] 0
#> 
#> $omero$channels[[16]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[16]]$family
#> [1] "linear"
#> 
#> $omero$channels[[16]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[17]]
#> $omero$channels[[17]]$color
#> [1] "00FF00"
#> 
#> $omero$channels[[17]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[17]]$active
#> [1] FALSE
#> 
#> $omero$channels[[17]]$label
#> [1] "Channel 16"
#> 
#> $omero$channels[[17]]$window
#> $omero$channels[[17]]$window$min
#> [1] 0
#> 
#> $omero$channels[[17]]$window$max
#> [1] 255
#> 
#> $omero$channels[[17]]$window$start
#> [1] 0
#> 
#> $omero$channels[[17]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[17]]$family
#> [1] "linear"
#> 
#> $omero$channels[[17]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[18]]
#> $omero$channels[[18]]$color
#> [1] "0000FF"
#> 
#> $omero$channels[[18]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[18]]$active
#> [1] FALSE
#> 
#> $omero$channels[[18]]$label
#> [1] "Channel 17"
#> 
#> $omero$channels[[18]]$window
#> $omero$channels[[18]]$window$min
#> [1] 0
#> 
#> $omero$channels[[18]]$window$max
#> [1] 255
#> 
#> $omero$channels[[18]]$window$start
#> [1] 0
#> 
#> $omero$channels[[18]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[18]]$family
#> [1] "linear"
#> 
#> $omero$channels[[18]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[19]]
#> $omero$channels[[19]]$color
#> [1] "FF0000"
#> 
#> $omero$channels[[19]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[19]]$active
#> [1] FALSE
#> 
#> $omero$channels[[19]]$label
#> [1] "Channel 18"
#> 
#> $omero$channels[[19]]$window
#> $omero$channels[[19]]$window$min
#> [1] 0
#> 
#> $omero$channels[[19]]$window$max
#> [1] 255
#> 
#> $omero$channels[[19]]$window$start
#> [1] 0
#> 
#> $omero$channels[[19]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[19]]$family
#> [1] "linear"
#> 
#> $omero$channels[[19]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[20]]
#> $omero$channels[[20]]$color
#> [1] "00FF00"
#> 
#> $omero$channels[[20]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[20]]$active
#> [1] FALSE
#> 
#> $omero$channels[[20]]$label
#> [1] "Channel 19"
#> 
#> $omero$channels[[20]]$window
#> $omero$channels[[20]]$window$min
#> [1] 0
#> 
#> $omero$channels[[20]]$window$max
#> [1] 255
#> 
#> $omero$channels[[20]]$window$start
#> [1] 0
#> 
#> $omero$channels[[20]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[20]]$family
#> [1] "linear"
#> 
#> $omero$channels[[20]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[21]]
#> $omero$channels[[21]]$color
#> [1] "0000FF"
#> 
#> $omero$channels[[21]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[21]]$active
#> [1] FALSE
#> 
#> $omero$channels[[21]]$label
#> [1] "Channel 20"
#> 
#> $omero$channels[[21]]$window
#> $omero$channels[[21]]$window$min
#> [1] 0
#> 
#> $omero$channels[[21]]$window$max
#> [1] 255
#> 
#> $omero$channels[[21]]$window$start
#> [1] 0
#> 
#> $omero$channels[[21]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[21]]$family
#> [1] "linear"
#> 
#> $omero$channels[[21]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[22]]
#> $omero$channels[[22]]$color
#> [1] "FF0000"
#> 
#> $omero$channels[[22]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[22]]$active
#> [1] FALSE
#> 
#> $omero$channels[[22]]$label
#> [1] "Channel 21"
#> 
#> $omero$channels[[22]]$window
#> $omero$channels[[22]]$window$min
#> [1] 0
#> 
#> $omero$channels[[22]]$window$max
#> [1] 255
#> 
#> $omero$channels[[22]]$window$start
#> [1] 0
#> 
#> $omero$channels[[22]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[22]]$family
#> [1] "linear"
#> 
#> $omero$channels[[22]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[23]]
#> $omero$channels[[23]]$color
#> [1] "00FF00"
#> 
#> $omero$channels[[23]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[23]]$active
#> [1] FALSE
#> 
#> $omero$channels[[23]]$label
#> [1] "Channel 22"
#> 
#> $omero$channels[[23]]$window
#> $omero$channels[[23]]$window$min
#> [1] 0
#> 
#> $omero$channels[[23]]$window$max
#> [1] 255
#> 
#> $omero$channels[[23]]$window$start
#> [1] 0
#> 
#> $omero$channels[[23]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[23]]$family
#> [1] "linear"
#> 
#> $omero$channels[[23]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[24]]
#> $omero$channels[[24]]$color
#> [1] "0000FF"
#> 
#> $omero$channels[[24]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[24]]$active
#> [1] FALSE
#> 
#> $omero$channels[[24]]$label
#> [1] "Channel 23"
#> 
#> $omero$channels[[24]]$window
#> $omero$channels[[24]]$window$min
#> [1] 0
#> 
#> $omero$channels[[24]]$window$max
#> [1] 255
#> 
#> $omero$channels[[24]]$window$start
#> [1] 0
#> 
#> $omero$channels[[24]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[24]]$family
#> [1] "linear"
#> 
#> $omero$channels[[24]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[25]]
#> $omero$channels[[25]]$color
#> [1] "FF0000"
#> 
#> $omero$channels[[25]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[25]]$active
#> [1] FALSE
#> 
#> $omero$channels[[25]]$label
#> [1] "Channel 24"
#> 
#> $omero$channels[[25]]$window
#> $omero$channels[[25]]$window$min
#> [1] 0
#> 
#> $omero$channels[[25]]$window$max
#> [1] 255
#> 
#> $omero$channels[[25]]$window$start
#> [1] 0
#> 
#> $omero$channels[[25]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[25]]$family
#> [1] "linear"
#> 
#> $omero$channels[[25]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[26]]
#> $omero$channels[[26]]$color
#> [1] "00FF00"
#> 
#> $omero$channels[[26]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[26]]$active
#> [1] FALSE
#> 
#> $omero$channels[[26]]$label
#> [1] "Channel 25"
#> 
#> $omero$channels[[26]]$window
#> $omero$channels[[26]]$window$min
#> [1] 0
#> 
#> $omero$channels[[26]]$window$max
#> [1] 255
#> 
#> $omero$channels[[26]]$window$start
#> [1] 0
#> 
#> $omero$channels[[26]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[26]]$family
#> [1] "linear"
#> 
#> $omero$channels[[26]]$inverted
#> [1] FALSE
#> 
#> 
#> $omero$channels[[27]]
#> $omero$channels[[27]]$color
#> [1] "0000FF"
#> 
#> $omero$channels[[27]]$coefficient
#> [1] 1
#> 
#> $omero$channels[[27]]$active
#> [1] FALSE
#> 
#> $omero$channels[[27]]$label
#> [1] "Channel 26"
#> 
#> $omero$channels[[27]]$window
#> $omero$channels[[27]]$window$min
#> [1] 0
#> 
#> $omero$channels[[27]]$window$max
#> [1] 255
#> 
#> $omero$channels[[27]]$window$start
#> [1] 0
#> 
#> $omero$channels[[27]]$window$end
#> [1] 255
#> 
#> 
#> $omero$channels[[27]]$family
#> [1] "linear"
#> 
#> $omero$channels[[27]]$inverted
#> [1] FALSE
#> 
#> 
#> 
#> $omero$rdefs
#> $omero$rdefs$defaultT
#> [1] 0
#> 
#> $omero$rdefs$model
#> [1] "greyscale"
#> 
#> $omero$rdefs$defaultZ
#> [1] 0
#> 
#> 
#> 
```
