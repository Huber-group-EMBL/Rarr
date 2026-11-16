# We test here that the tests themselves are properly configured.

test_that("all test fixture in inst/extdata/zarr_examples are used", {
  fixture_files <- list.dirs(
    system.file("extdata", "zarr_examples", package = "Rarr"),
    recursive = TRUE
  ) |>
    Filter(f = \(f) endsWith(f, ".zarr"))

  for (f in fixture_files) {
    res <- system2(
      "grep",
      c("-r", basename(f), system.file("tests", "testthat", package = "Rarr")),
      stdout = TRUE
    )
    expect_true(
      length(res) > 0,
      info = paste("Fixture", f, "is not used in any test")
    )
  }
})
