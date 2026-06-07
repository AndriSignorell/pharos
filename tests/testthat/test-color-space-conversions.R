
# ===========================================================================
# Color space conversions: CMYKToRGB, CMYKToCMY, CMYToCMYK, RGBToCMY
# ===========================================================================

test_that("CMYKToRGB converts black (0,0,0,1) to #000000", {
  expect_equal(CMYKToRGB(0, 0, 0, 1), "#000000")
})

test_that("CMYKToRGB converts white (0,0,0,0) to #FFFFFF", {
  expect_equal(CMYKToRGB(0, 0, 0, 0), "#FFFFFF")
})

test_that("CMYKToRGB converts pure cyan (1,0,0,0) to #00FFFF", {
  expect_equal(CMYKToRGB(1, 0, 0, 0), "#00FFFF")
})

test_that("CMYKToCMY converts black ink (0,0,0,1) correctly", {
  # CMY of full-black CMYK: C=1, M=1, Y=1
  res <- CMYKToCMY(matrix(c(0, 0, 0, 1), nrow = 1))
  expect_equal(as.numeric(res), c(1, 1, 1))
})

test_that("CMYKToCMY round-trips through CMYToCMYK when K = min(C,M,Y)", {
  # CMYToCMYK normalises to maximum K (canonical form).
  # Roundtrip is exact only when the input is already in canonical form,
  # i.e. K = min(C, M, Y) AND at least one of C/M/Y equals 0 after
  # subtracting K. Use pure cyan (C=1, M=0, Y=0, K=0) as a safe case.
  cmyk_in <- matrix(c(1, 0, 0, 0), nrow = 1)
  colnames(cmyk_in) <- c("C", "M", "Y", "K")
  cmy     <- CMYKToCMY(cmyk_in)
  cmyk_out <- CMYToCMYK(cmy)
  expect_equal(as.numeric(cmyk_out), as.numeric(cmyk_in), tolerance = 1e-10)
})

test_that("CMYKToCMY -> CMYToCMYK produces equivalent colors (same CMY)", {
  # For arbitrary CMYK, the CMY intermediate is unique even though
  # the back-converted CMYK may differ (different K allocation).
  # Verify that CMYKToCMY(CMYToCMYK(cmy)) recovers the same CMY.
  cmy_in <- matrix(c(0.38, 0.62, 0.42), nrow = 1)
  colnames(cmy_in) <- c("C", "M", "Y")
  cmyk   <- CMYToCMYK(cmy_in)
  cmy_out <- CMYKToCMY(cmyk)
  expect_equal(as.numeric(cmy_out), as.numeric(cmy_in), tolerance = 1e-10)
})

test_that("RGBToCMY converts white to (0,0,0)", {
  res <- RGBToCMY(matrix(c(1, 1, 1), nrow = 1), maxColorValue = 1)
  expect_equal(as.numeric(res), c(0, 0, 0))
})

test_that("RGBToCMY converts black to (1,1,1)", {
  res <- RGBToCMY(matrix(c(0, 0, 0), nrow = 1), maxColorValue = 1)
  expect_equal(as.numeric(res), c(1, 1, 1))
})

