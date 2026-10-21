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

test_that("rgbToCol finds named colors with both difference formulas", {
  m <- colToRgb(c("brown", "royalblue"))

  expect_equal(rgbToCol(m), c("brown", "royalblue"))
  expect_equal(rgbToCol(c("#A52A2A", "#4169E1")), c("brown", "royalblue"))
  expect_equal(rgbToCol(m, method = "cie76"), c("brown", "royalblue"))

  # slightly off colors still land on their neighbour
  expect_equal(rgbToCol(c("#A22A2A", "#4169E0")), c("brown", "royalblue"))
  expect_equal(hexToCol("#4169E0", method = "cie76"), "royalblue")

  # missing colors stay missing instead of turning white
  expect_equal(rgbToCol(c("#A52A2A", NA)), c("brown", NA))
})

test_that("CIEDE2000 reproduces the test data of Sharma et al. (2005)", {
  lab1 <- rbind(c(50, 2.6772, -79.7751), c(50, 0, 0), c(50, 2.5, 0),
                c(50, -0.001, 2.49), c(60.2574, -34.0099, 36.2677),
                c(2.0776, 0.0795, -1.1350))
  lab2 <- rbind(c(50, 0, -82.7485), c(50, -1, 2), c(73, 25, -18),
                c(50, 0.0009, -2.49), c(60.4626, -34.1751, 39.4387),
                c(0.9033, -0.0636, -0.5514))
  expect_equal(.deltaE2000(lab1, lab2),
               c(2.0425, 2.3669, 27.1492, 4.8045, 1.2644, 0.9082),
               tolerance = 1e-4)
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
