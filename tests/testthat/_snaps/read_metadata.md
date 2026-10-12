# zarr_overview console output matches snapshot for single array

    Code
      zarr_overview(zarr_c, as_data_frame = FALSE)
    Output
      Type: Array
      Path: <path>
      Zarr Format: 2
      Shape: 30 x 20 x 10
      Chunk Shape: 10 x 10 x 5
      No. of Chunks: 12 (3 x 2 x 2)
      Data Type: int64
      Endianness: little
      Compressor: zstd
      Attributes: no

# zarr_overview works with consolidated metadata store

    Code
      metadata_df
    Output
                                                        path zarr_format
      1                           /conditions/geometry/angle           2
      2                            /conditions/geometry/band           2
      3                        /conditions/geometry/detector           2
      4                 /conditions/geometry/mean_sun_angles           2
      5   /conditions/geometry/mean_viewing_incidence_angles           2
      6                      /conditions/geometry/sun_angles           2
      7        /conditions/geometry/viewing_incidence_angles           2
      8                               /conditions/geometry/x           2
      9                               /conditions/geometry/y           2
      10        /conditions/mask/detector_footprint/r10m/b02           2
      11        /conditions/mask/detector_footprint/r10m/b03           2
      12        /conditions/mask/detector_footprint/r10m/b04           2
      13        /conditions/mask/detector_footprint/r10m/b08           2
      14          /conditions/mask/detector_footprint/r10m/x           2
      15          /conditions/mask/detector_footprint/r10m/y           2
      16        /conditions/mask/detector_footprint/r20m/b05           2
      17        /conditions/mask/detector_footprint/r20m/b06           2
      18        /conditions/mask/detector_footprint/r20m/b07           2
      19        /conditions/mask/detector_footprint/r20m/b11           2
      20        /conditions/mask/detector_footprint/r20m/b12           2
      21        /conditions/mask/detector_footprint/r20m/b8a           2
      22          /conditions/mask/detector_footprint/r20m/x           2
      23          /conditions/mask/detector_footprint/r20m/y           2
      24        /conditions/mask/detector_footprint/r60m/b01           2
      25        /conditions/mask/detector_footprint/r60m/b09           2
      26        /conditions/mask/detector_footprint/r60m/b10           2
      27          /conditions/mask/detector_footprint/r60m/x           2
      28          /conditions/mask/detector_footprint/r60m/y           2
      29        /conditions/mask/l1c_classification/r60m/b00           2
      30          /conditions/mask/l1c_classification/r60m/x           2
      31          /conditions/mask/l1c_classification/r60m/y           2
      32        /conditions/mask/l2a_classification/r20m/scl           2
      33          /conditions/mask/l2a_classification/r20m/x           2
      34          /conditions/mask/l2a_classification/r20m/y           2
      35        /conditions/mask/l2a_classification/r60m/scl           2
      36          /conditions/mask/l2a_classification/r60m/x           2
      37          /conditions/mask/l2a_classification/r60m/y           2
      38                /conditions/meteorology/cams/aod1240           2
      39                 /conditions/meteorology/cams/aod469           2
      40                 /conditions/meteorology/cams/aod550           2
      41                 /conditions/meteorology/cams/aod670           2
      42                 /conditions/meteorology/cams/aod865           2
      43               /conditions/meteorology/cams/bcaod550           2
      44               /conditions/meteorology/cams/duaod550           2
      45          /conditions/meteorology/cams/isobaricInhPa           2
      46               /conditions/meteorology/cams/latitude           2
      47              /conditions/meteorology/cams/longitude           2
      48                 /conditions/meteorology/cams/number           2
      49               /conditions/meteorology/cams/omaod550           2
      50               /conditions/meteorology/cams/ssaod550           2
      51                   /conditions/meteorology/cams/step           2
      52               /conditions/meteorology/cams/suaod550           2
      53                /conditions/meteorology/cams/surface           2
      54                   /conditions/meteorology/cams/time           2
      55             /conditions/meteorology/cams/valid_time           2
      56                      /conditions/meteorology/cams/z           2
      57         /conditions/meteorology/ecmwf/isobaricInhPa           2
      58              /conditions/meteorology/ecmwf/latitude           2
      59             /conditions/meteorology/ecmwf/longitude           2
      60                   /conditions/meteorology/ecmwf/msl           2
      61                /conditions/meteorology/ecmwf/number           2
      62                     /conditions/meteorology/ecmwf/r           2
      63                  /conditions/meteorology/ecmwf/step           2
      64               /conditions/meteorology/ecmwf/surface           2
      65                  /conditions/meteorology/ecmwf/tco3           2
      66                  /conditions/meteorology/ecmwf/tcwv           2
      67                  /conditions/meteorology/ecmwf/time           2
      68                   /conditions/meteorology/ecmwf/u10           2
      69                   /conditions/meteorology/ecmwf/v10           2
      70            /conditions/meteorology/ecmwf/valid_time           2
      71                  /measurements/reflectance/r10m/b02           2
      72                  /measurements/reflectance/r10m/b03           2
      73                  /measurements/reflectance/r10m/b04           2
      74                  /measurements/reflectance/r10m/b08           2
      75                    /measurements/reflectance/r10m/x           2
      76                    /measurements/reflectance/r10m/y           2
      77                  /measurements/reflectance/r20m/b01           2
      78                  /measurements/reflectance/r20m/b02           2
      79                  /measurements/reflectance/r20m/b03           2
      80                  /measurements/reflectance/r20m/b04           2
      81                  /measurements/reflectance/r20m/b05           2
      82                  /measurements/reflectance/r20m/b06           2
      83                  /measurements/reflectance/r20m/b07           2
      84                  /measurements/reflectance/r20m/b11           2
      85                  /measurements/reflectance/r20m/b12           2
      86                  /measurements/reflectance/r20m/b8a           2
      87                    /measurements/reflectance/r20m/x           2
      88                    /measurements/reflectance/r20m/y           2
      89                  /measurements/reflectance/r60m/b01           2
      90                  /measurements/reflectance/r60m/b02           2
      91                  /measurements/reflectance/r60m/b03           2
      92                  /measurements/reflectance/r60m/b04           2
      93                  /measurements/reflectance/r60m/b05           2
      94                  /measurements/reflectance/r60m/b06           2
      95                  /measurements/reflectance/r60m/b07           2
      96                  /measurements/reflectance/r60m/b09           2
      97                  /measurements/reflectance/r60m/b11           2
      98                  /measurements/reflectance/r60m/b12           2
      99                  /measurements/reflectance/r60m/b8a           2
      100                   /measurements/reflectance/r60m/x           2
      101                   /measurements/reflectance/r60m/y           2
      102                       /quality/atmosphere/r10m/aot           2
      103                       /quality/atmosphere/r10m/wvp           2
      104                         /quality/atmosphere/r10m/x           2
      105                         /quality/atmosphere/r10m/y           2
      106                       /quality/atmosphere/r20m/aot           2
      107                       /quality/atmosphere/r20m/wvp           2
      108                         /quality/atmosphere/r20m/x           2
      109                         /quality/atmosphere/r20m/y           2
      110                       /quality/atmosphere/r60m/aot           2
      111                       /quality/atmosphere/r60m/wvp           2
      112                         /quality/atmosphere/r60m/x           2
      113                         /quality/atmosphere/r60m/y           2
      114                   /quality/l2a_quicklook/r10m/band           2
      115                    /quality/l2a_quicklook/r10m/tci           2
      116                      /quality/l2a_quicklook/r10m/x           2
      117                      /quality/l2a_quicklook/r10m/y           2
      118                   /quality/l2a_quicklook/r20m/band           2
      119                    /quality/l2a_quicklook/r20m/tci           2
      120                      /quality/l2a_quicklook/r20m/x           2
      121                      /quality/l2a_quicklook/r20m/y           2
      122                   /quality/l2a_quicklook/r60m/band           2
      123                    /quality/l2a_quicklook/r60m/tci           2
      124                      /quality/l2a_quicklook/r60m/x           2
      125                      /quality/l2a_quicklook/r60m/y           2
      126                             /quality/mask/r10m/b02           2
      127                             /quality/mask/r10m/b03           2
      128                             /quality/mask/r10m/b04           2
      129                             /quality/mask/r10m/b08           2
      130                               /quality/mask/r10m/x           2
      131                               /quality/mask/r10m/y           2
      132                             /quality/mask/r20m/b05           2
      133                             /quality/mask/r20m/b06           2
      134                             /quality/mask/r20m/b07           2
      135                             /quality/mask/r20m/b11           2
      136                             /quality/mask/r20m/b12           2
      137                             /quality/mask/r20m/b8a           2
      138                               /quality/mask/r20m/x           2
      139                               /quality/mask/r20m/y           2
      140                             /quality/mask/r60m/b01           2
      141                             /quality/mask/r60m/b09           2
      142                             /quality/mask/r60m/b10           2
      143                               /quality/mask/r60m/x           2
      144                               /quality/mask/r60m/y           2
      145                     /quality/probability/r20m/band           2
      146                      /quality/probability/r20m/cld           2
      147                      /quality/probability/r20m/snw           2
      148                        /quality/probability/r20m/x           2
      149                        /quality/probability/r20m/y           2
                   data_type endianness compressor              dim       chunk_dim
      1   fixed_length_utf32     little      blosc                2               2
      2   fixed_length_utf32     little      blosc               13              13
      3                int64     little      blosc                6               6
      4              float64     little      blosc                2               2
      5              float64     little      blosc            13, 2           13, 2
      6              float64     little      blosc        2, 23, 23       2, 23, 23
      7              float64     little      blosc 13, 6, 2, 23, 23 7, 3, 2, 23, 23
      8                int64     little      blosc               23              23
      9                int64     little      blosc               23              23
      10               uint8       <NA>      blosc     10980, 10980      1830, 1830
      11               uint8       <NA>      blosc     10980, 10980      1830, 1830
      12               uint8       <NA>      blosc     10980, 10980      1830, 1830
      13               uint8       <NA>      blosc     10980, 10980      1830, 1830
      14               int64     little      blosc            10980           10980
      15               int64     little      blosc            10980           10980
      16               uint8       <NA>      blosc       5490, 5490        915, 915
      17               uint8       <NA>      blosc       5490, 5490        915, 915
      18               uint8       <NA>      blosc       5490, 5490        915, 915
      19               uint8       <NA>      blosc       5490, 5490        915, 915
      20               uint8       <NA>      blosc       5490, 5490        915, 915
      21               uint8       <NA>      blosc       5490, 5490        915, 915
      22               int64     little      blosc             5490            5490
      23               int64     little      blosc             5490            5490
      24               uint8       <NA>      blosc       1830, 1830        305, 305
      25               uint8       <NA>      blosc       1830, 1830        305, 305
      26               uint8       <NA>      blosc       1830, 1830        305, 305
      27               int64     little      blosc             1830            1830
      28               int64     little      blosc             1830            1830
      29               uint8       <NA>      blosc       1830, 1830        305, 305
      30               int64     little      blosc             1830            1830
      31               int64     little      blosc             1830            1830
      32               uint8       <NA>      blosc       5490, 5490        915, 915
      33               int64     little      blosc             5490            5490
      34               int64     little      blosc             5490            5490
      35               uint8       <NA>      blosc       1830, 1830        305, 305
      36               int64     little      blosc             1830            1830
      37               int64     little      blosc             1830            1830
      38             float32     little      blosc             9, 9            9, 9
      39             float32     little      blosc             9, 9            9, 9
      40             float32     little      blosc             9, 9            9, 9
      41             float32     little      blosc             9, 9            9, 9
      42             float32     little      blosc             9, 9            9, 9
      43             float32     little      blosc             9, 9            9, 9
      44             float32     little      blosc             9, 9            9, 9
      45             float64     little       <NA>                1               1
      46             float64     little      blosc                9               9
      47             float64     little      blosc                9               9
      48               int64     little       <NA>                1               1
      49             float32     little      blosc             9, 9            9, 9
      50             float32     little      blosc             9, 9            9, 9
      51               int64     little       <NA>                1               1
      52             float32     little      blosc             9, 9            9, 9
      53             float64     little       <NA>                1               1
      54               int64     little       <NA>                1               1
      55               int64     little       <NA>                1               1
      56             float32     little      blosc             9, 9            9, 9
      57             float64     little       <NA>                1               1
      58             float64     little      blosc                9               9
      59             float64     little      blosc                9               9
      60             float32     little      blosc             9, 9            9, 9
      61               int64     little       <NA>                1               1
      62             float32     little      blosc             9, 9            9, 9
      63               int64     little       <NA>                1               1
      64             float64     little       <NA>                1               1
      65             float32     little      blosc             9, 9            9, 9
      66             float32     little      blosc             9, 9            9, 9
      67               int64     little       <NA>                1               1
      68             float32     little      blosc             9, 9            9, 9
      69             float32     little      blosc             9, 9            9, 9
      70               int64     little       <NA>                1               1
      71              uint16     little      blosc     10980, 10980      1830, 1830
      72              uint16     little      blosc     10980, 10980      1830, 1830
      73              uint16     little      blosc     10980, 10980      1830, 1830
      74              uint16     little      blosc     10980, 10980      1830, 1830
      75               int64     little      blosc            10980           10980
      76               int64     little      blosc            10980           10980
      77              uint16     little      blosc       5490, 5490        915, 915
      78              uint16     little      blosc       5490, 5490        915, 915
      79              uint16     little      blosc       5490, 5490        915, 915
      80              uint16     little      blosc       5490, 5490        915, 915
      81              uint16     little      blosc       5490, 5490        915, 915
      82              uint16     little      blosc       5490, 5490        915, 915
      83              uint16     little      blosc       5490, 5490        915, 915
      84              uint16     little      blosc       5490, 5490        915, 915
      85              uint16     little      blosc       5490, 5490        915, 915
      86              uint16     little      blosc       5490, 5490        915, 915
      87               int64     little      blosc             5490            5490
      88               int64     little      blosc             5490            5490
      89              uint16     little      blosc       1830, 1830        305, 305
      90              uint16     little      blosc       1830, 1830        305, 305
      91              uint16     little      blosc       1830, 1830        305, 305
      92              uint16     little      blosc       1830, 1830        305, 305
      93              uint16     little      blosc       1830, 1830        305, 305
      94              uint16     little      blosc       1830, 1830        305, 305
      95              uint16     little      blosc       1830, 1830        305, 305
      96              uint16     little      blosc       1830, 1830        305, 305
      97              uint16     little      blosc       1830, 1830        305, 305
      98              uint16     little      blosc       1830, 1830        305, 305
      99              uint16     little      blosc       1830, 1830        305, 305
      100              int64     little      blosc             1830            1830
      101              int64     little      blosc             1830            1830
      102             uint16     little      blosc     10980, 10980      1830, 1830
      103             uint16     little      blosc     10980, 10980      1830, 1830
      104              int64     little      blosc            10980           10980
      105              int64     little      blosc            10980           10980
      106             uint16     little      blosc       5490, 5490        915, 915
      107             uint16     little      blosc       5490, 5490        915, 915
      108              int64     little      blosc             5490            5490
      109              int64     little      blosc             5490            5490
      110             uint16     little      blosc       1830, 1830        305, 305
      111             uint16     little      blosc       1830, 1830        305, 305
      112              int64     little      blosc             1830            1830
      113              int64     little      blosc             1830            1830
      114              int64     little      blosc                3               3
      115              uint8       <NA>      blosc  3, 10980, 10980   1, 1830, 1830
      116              int64     little      blosc            10980           10980
      117              int64     little      blosc            10980           10980
      118              int64     little      blosc                3               3
      119              uint8       <NA>      blosc    3, 5490, 5490     1, 915, 915
      120              int64     little      blosc             5490            5490
      121              int64     little      blosc             5490            5490
      122              int64     little      blosc                3               3
      123              uint8       <NA>      blosc    3, 1830, 1830     1, 305, 305
      124              int64     little      blosc             1830            1830
      125              int64     little      blosc             1830            1830
      126              uint8       <NA>      blosc     10980, 10980      1830, 1830
      127              uint8       <NA>      blosc     10980, 10980      1830, 1830
      128              uint8       <NA>      blosc     10980, 10980      1830, 1830
      129              uint8       <NA>      blosc     10980, 10980      1830, 1830
      130              int64     little      blosc            10980           10980
      131              int64     little      blosc            10980           10980
      132              uint8       <NA>      blosc       5490, 5490        915, 915
      133              uint8       <NA>      blosc       5490, 5490        915, 915
      134              uint8       <NA>      blosc       5490, 5490        915, 915
      135              uint8       <NA>      blosc       5490, 5490        915, 915
      136              uint8       <NA>      blosc       5490, 5490        915, 915
      137              uint8       <NA>      blosc       5490, 5490        915, 915
      138              int64     little      blosc             5490            5490
      139              int64     little      blosc             5490            5490
      140              uint8       <NA>      blosc       1830, 1830        305, 305
      141              uint8       <NA>      blosc       1830, 1830        305, 305
      142              uint8       <NA>      blosc       1830, 1830        305, 305
      143              int64     little      blosc             1830            1830
      144              int64     little      blosc             1830            1830
      145              int64     little       <NA>                1               1
      146              uint8       <NA>      blosc       5490, 5490        915, 915
      147              uint8       <NA>      blosc       5490, 5490        915, 915
      148              int64     little      blosc             5490            5490
      149              int64     little      blosc             5490            5490
                nchunks attributes
      1               1       TRUE
      2               1       TRUE
      3               1       TRUE
      4               1       TRUE
      5            1, 1       TRUE
      6         1, 1, 1       TRUE
      7   2, 2, 1, 1, 1       TRUE
      8               1       TRUE
      9               1       TRUE
      10           6, 6       TRUE
      11           6, 6       TRUE
      12           6, 6       TRUE
      13           6, 6       TRUE
      14              1       TRUE
      15              1       TRUE
      16           6, 6       TRUE
      17           6, 6       TRUE
      18           6, 6       TRUE
      19           6, 6       TRUE
      20           6, 6       TRUE
      21           6, 6       TRUE
      22              1       TRUE
      23              1       TRUE
      24           6, 6       TRUE
      25           6, 6       TRUE
      26           6, 6       TRUE
      27              1       TRUE
      28              1       TRUE
      29           6, 6       TRUE
      30              1       TRUE
      31              1       TRUE
      32           6, 6       TRUE
      33              1       TRUE
      34              1       TRUE
      35           6, 6       TRUE
      36              1       TRUE
      37              1       TRUE
      38           1, 1       TRUE
      39           1, 1       TRUE
      40           1, 1       TRUE
      41           1, 1       TRUE
      42           1, 1       TRUE
      43           1, 1       TRUE
      44           1, 1       TRUE
      45              1       TRUE
      46              1       TRUE
      47              1       TRUE
      48              1       TRUE
      49           1, 1       TRUE
      50           1, 1       TRUE
      51              1       TRUE
      52           1, 1       TRUE
      53              1       TRUE
      54              1       TRUE
      55              1       TRUE
      56           1, 1       TRUE
      57              1       TRUE
      58              1       TRUE
      59              1       TRUE
      60           1, 1       TRUE
      61              1       TRUE
      62           1, 1       TRUE
      63              1       TRUE
      64              1       TRUE
      65           1, 1       TRUE
      66           1, 1       TRUE
      67              1       TRUE
      68           1, 1       TRUE
      69           1, 1       TRUE
      70              1       TRUE
      71           6, 6       TRUE
      72           6, 6       TRUE
      73           6, 6       TRUE
      74           6, 6       TRUE
      75              1       TRUE
      76              1       TRUE
      77           6, 6       TRUE
      78           6, 6       TRUE
      79           6, 6       TRUE
      80           6, 6       TRUE
      81           6, 6       TRUE
      82           6, 6       TRUE
      83           6, 6       TRUE
      84           6, 6       TRUE
      85           6, 6       TRUE
      86           6, 6       TRUE
      87              1       TRUE
      88              1       TRUE
      89           6, 6       TRUE
      90           6, 6       TRUE
      91           6, 6       TRUE
      92           6, 6       TRUE
      93           6, 6       TRUE
      94           6, 6       TRUE
      95           6, 6       TRUE
      96           6, 6       TRUE
      97           6, 6       TRUE
      98           6, 6       TRUE
      99           6, 6       TRUE
      100             1       TRUE
      101             1       TRUE
      102          6, 6       TRUE
      103          6, 6       TRUE
      104             1       TRUE
      105             1       TRUE
      106          6, 6       TRUE
      107          6, 6       TRUE
      108             1       TRUE
      109             1       TRUE
      110          6, 6       TRUE
      111          6, 6       TRUE
      112             1       TRUE
      113             1       TRUE
      114             1       TRUE
      115       3, 6, 6       TRUE
      116             1       TRUE
      117             1       TRUE
      118             1       TRUE
      119       3, 6, 6       TRUE
      120             1       TRUE
      121             1       TRUE
      122             1       TRUE
      123       3, 6, 6       TRUE
      124             1       TRUE
      125             1       TRUE
      126          6, 6       TRUE
      127          6, 6       TRUE
      128          6, 6       TRUE
      129          6, 6       TRUE
      130             1       TRUE
      131             1       TRUE
      132          6, 6       TRUE
      133          6, 6       TRUE
      134          6, 6       TRUE
      135          6, 6       TRUE
      136          6, 6       TRUE
      137          6, 6       TRUE
      138             1       TRUE
      139             1       TRUE
      140          6, 6       TRUE
      141          6, 6       TRUE
      142          6, 6       TRUE
      143             1       TRUE
      144             1       TRUE
      145             1       TRUE
      146          6, 6       TRUE
      147          6, 6       TRUE
      148             1       TRUE
      149             1       TRUE

# zarr_overview console output matches snapshot for consolidated store

    Code
      zarr_overview(zarr_store_consolidated, as_data_frame = FALSE)
    Output
      Type: Group of Arrays
      Path: <path>
      Arrays:
      ---
      Path: <path>
        Zarr Format: 2
        Shape: 1
        Chunk Shape: 1
        No. of Chunks: 1 (1)
        Data Type: float64
        Endianness: little
        Compressor: blosc
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 2
        Shape: 2 x 2
        Chunk Shape: 2 x 2
        No. of Chunks: 1 (1 x 1)
        Data Type: float64
        Endianness: little
        Compressor: blosc
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 2
        Shape: 3 x 3 x 3
        Chunk Shape: 3 x 3 x 3
        No. of Chunks: 1 (1 x 1 x 1)
        Data Type: float64
        Endianness: little
        Compressor: blosc
        Attributes: no

# zarr_overview works with consolidated v3 metadata

    Code
      zarr_overview(zarr_store_consolidated_v3, as_data_frame = FALSE)
    Output
      Type: Group of Arrays
      Path: <path>
      Arrays:
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 3 x 45087 x 11580
        Chunk Shape: 1 x 4096 x 4096
        No. of Chunks: 108 (3 x 12 x 3)
        Data Type: uint8
        Endianness: NA
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 3 x 22543 x 5790
        Chunk Shape: 1 x 4096 x 4096
        No. of Chunks: 36 (3 x 6 x 2)
        Data Type: uint8
        Endianness: NA
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 3 x 11271 x 2895
        Chunk Shape: 1 x 4096 x 2895
        No. of Chunks: 9 (3 x 3 x 1)
        Data Type: uint8
        Endianness: NA
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 3 x 5635 x 1447
        Chunk Shape: 1 x 4096 x 1447
        No. of Chunks: 6 (3 x 2 x 1)
        Data Type: uint8
        Endianness: NA
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 3 x 2817 x 723
        Chunk Shape: 1 x 2817 x 723
        No. of Chunks: 3 (3 x 1 x 1)
        Data Type: uint8
        Endianness: NA
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 4 x 17098 x 51187
        Chunk Shape: 1 x 4096 x 4096
        No. of Chunks: 260 (4 x 5 x 13)
        Data Type: uint16
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 4 x 8549 x 25593
        Chunk Shape: 1 x 4096 x 4096
        No. of Chunks: 84 (4 x 3 x 7)
        Data Type: uint16
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 4 x 4274 x 12796
        Chunk Shape: 1 x 4096 x 4096
        No. of Chunks: 32 (4 x 2 x 4)
        Data Type: uint16
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 4 x 2137 x 6398
        Chunk Shape: 1 x 2137 x 4096
        No. of Chunks: 8 (4 x 1 x 2)
        Data Type: uint16
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 4 x 1068 x 3199
        Chunk Shape: 1 x 1068 x 3199
        No. of Chunks: 4 (4 x 1 x 1)
        Data Type: uint16
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 17098 x 51187
        Chunk Shape: 4096 x 4096
        No. of Chunks: 65 (5 x 13)
        Data Type: uint32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 8549 x 25593
        Chunk Shape: 4096 x 4096
        No. of Chunks: 21 (3 x 7)
        Data Type: uint32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 4274 x 12796
        Chunk Shape: 4096 x 4096
        No. of Chunks: 8 (2 x 4)
        Data Type: uint32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 2137 x 6398
        Chunk Shape: 2137 x 4096
        No. of Chunks: 2 (1 x 2)
        Data Type: uint32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 1068 x 3199
        Chunk Shape: 1068 x 3199
        No. of Chunks: 1 (1 x 1)
        Data Type: uint32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 17098 x 51187
        Chunk Shape: 4096 x 4096
        No. of Chunks: 65 (5 x 13)
        Data Type: uint32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 8549 x 25593
        Chunk Shape: 4096 x 4096
        No. of Chunks: 21 (3 x 7)
        Data Type: uint32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 4274 x 12796
        Chunk Shape: 4096 x 4096
        No. of Chunks: 8 (2 x 4)
        Data Type: uint32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 2137 x 6398
        Chunk Shape: 2137 x 4096
        No. of Chunks: 2 (1 x 2)
        Data Type: uint32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 1068 x 3199
        Chunk Shape: 1068 x 3199
        No. of Chunks: 1 (1 x 1)
        Data Type: uint32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 
        Chunk Shape: 
        No. of Chunks: 1 ()
        Data Type: bool
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 162254
        No. of Chunks: 1 (1)
        Data Type: string
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: float64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 162254
        No. of Chunks: 1 (1)
        Data Type: string
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: int64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: int64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: int64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: int64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: float64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: float64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: int64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: int64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: int64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 40564
        No. of Chunks: 4 (4)
        Data Type: float64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254 x 2
        Chunk Shape: 40564 x 1
        No. of Chunks: 8 (4 x 2)
        Data Type: float64
        Endianness: little
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 377
        Chunk Shape: 377
        No. of Chunks: 1 (1)
        Data Type: string
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 377
        Chunk Shape: 377
        No. of Chunks: 1 (1)
        Data Type: string
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 377
        Chunk Shape: 377
        No. of Chunks: 1 (1)
        Data Type: string
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 377
        Chunk Shape: 377
        No. of Chunks: 1 (1)
        Data Type: string
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 4900367
        Chunk Shape: 153137
        No. of Chunks: 32 (32)
        Data Type: float32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 4900367
        Chunk Shape: 153137
        No. of Chunks: 32 (32)
        Data Type: int32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162255
        Chunk Shape: 81128
        No. of Chunks: 2 (2)
        Data Type: int32
        Endianness: little
        Compressor: zstd
        Attributes: no
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 1
        Chunk Shape: 1
        No. of Chunks: 1 (1)
        Data Type: string
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 162254
        Chunk Shape: 162254
        No. of Chunks: 1 (1)
        Data Type: int8
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 
        Chunk Shape: 
        No. of Chunks: 1 ()
        Data Type: string
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 
        Chunk Shape: 
        No. of Chunks: 1 ()
        Data Type: string
        Endianness: NA
        Compressor: zstd
        Attributes: yes
      ---
      Path: <path>
        Zarr Format: 3
        Shape: 
        Chunk Shape: 
        No. of Chunks: 1 ()
        Data Type: string
        Endianness: NA
        Compressor: zstd
        Attributes: yes

# zarr_overview console output matches snapshot for v3 metadata

    Code
      zarr_overview(zarr_v3, as_data_frame = FALSE)
    Output
      Type: Array
      Path: <path>
      Zarr Format: 3
      Shape: 3 x 4 x 5
      Chunk Shape: 3 x 4 x 5
      No. of Chunks: 1 (1 x 1 x 1)
      Data Type: int64
      Endianness: little
      Compressor: zstd
      Attributes: no

# zarr_overview throws error for mixed v2/v3 zarr

    The path contains both `.zarray` (Zarr V2 specification) and `zarr.json` (Zarr V3 specification) metadata files.
    An array or group must conform to either the Zarr V2 or V3 specification.

---

    The path contains both `.zmetadata` (Zarr V2 specification) and `zarr.json` (Zarr V3 specification) consolidated metadata files.
    An array or group must conform to either the Zarr V2 or V3 specification.

