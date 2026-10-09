# ===========================================================================
# Color representation conversions: rgbToHex, rgbToCol, colToHsv, rgbToCmy
# ===========================================================================

test_that("rgbToHex returns one code per color", {
  # a vector is a single color
  expect_equal(rgbToHex(c(162, 42, 42)), "#A22A2A")
  expect_equal(rgbToHex(matrix(c(162, 42, 42), nrow = 3)), "#A22A2A")

  # one color per column - used to be pasted into one single string
  expect_equal(rgbToHex(colToRgb(c("tomato", "royalblue"))),
               c("#FF6347", "#4169E1"))
  expect_equal(rgbToHex(colToRgb(c(a = "tomato", b = "royalblue"))),
               colToHex(c("tomato", "royalblue")))
})

test_that("rgbToHex and longToRgb/rgbToLong round-trip", {
  cols <- c("tomato", "royalblue", "black", "white")
  expect_equal(rgbToHex(longToRgb(rgbToLong(colToRgb(cols)))), colToHex(cols))
})

test_that("rgbToCol finds named colors in both color spaces", {
  m <- colToRgb(c("brown", "royalblue"))

  expect_equal(rgbToCol(m), c("brown", "royalblue"))
  expect_equal(rgbToCol(c("#A52A2A", "#4169E1")), c("brown", "royalblue"))

  # an RGB matrix with method = "hsv" used to be read as palette indices
  expect_equal(rgbToCol(m, method = "hsv"), c("brown", "royalblue"))
  expect_equal(rgbToCol(c("#A52A2A", "#4169E1"), method = "hsv"),
               c("brown", "royalblue"))
  expect_equal(hexToCol("#4169E1", method = "hsv", metric = "manhattan"),
               "royalblue")
})

test_that("colToHsv handles the alpha channel", {
  res <- colToHsv(c("tomato", "royalblue"))
  expect_equal(dim(res), c(3L, 2L))
  expect_equal(unname(res), unname(rgb2hsv(col2rgb(c("tomato", "royalblue")))))

  # used to fail in rgb2hsv(), which takes exactly three rows
  resA <- colToHsv(c("#FF634780", "#4169E1"), useAlphaChannel = TRUE)
  expect_equal(rownames(resA), c("h", "s", "v", "alpha"))
  expect_equal(unname(resA[1:3, ]), unname(res))
  expect_equal(unname(resA["alpha", ]), c(128, 255) / 255)
})

test_that("rgbToCmy accepts hexadecimal colors", {
  # used to fail: the colors ended up in the columns instead of the rows
  res <- rgbToCmy(c("#FF0000", "#FFFFFF", "#000000"), maxColorValue = 255)
  expect_equal(unname(res), rbind(c(0, 1, 1), c(0, 0, 0), c(1, 1, 1)))
  expect_equal(colnames(res), c("C", "M", "Y"))

  # the same as the RGB matrix with one color per row
  expect_equal(
    unname(rgbToCmy("#FF6347", maxColorValue = 255)),
    unname(rgbToCmy(t(colToRgb("tomato")), maxColorValue = 255))
  )
})
