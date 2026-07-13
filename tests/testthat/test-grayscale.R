
# ===========================================================================
# grayscale
# ===========================================================================

test_that("grayscale returns gray for gray input", {
  g <- grayScale("grey50")
  rgb_vals <- col2rgb(g)
  expect_equal(unname(rgb_vals[1L, 1L]), unname(rgb_vals[2L, 1L]))
  expect_equal(unname(rgb_vals[2L, 1L]), unname(rgb_vals[3L, 1L]))
})

test_that("grayScale of white is white", {
  expect_equal(grayScale("white"), "#FFFFFF")
})

test_that("grayScale of black is black", {
  expect_equal(grayScale("black"), "#000000")
})

test_that("grayScale returns equal R/G/B channels", {
  cols <- c("red", "green", "blue", "#804020")
  result <- col2rgb(grayScale(cols))
  expect_equal(unname(result[1L, ]), unname(result[2L, ]))
  expect_equal(unname(result[2L, ]), unname(result[3L, ]))
})

test_that("grayScale vectorises", {
  res <- grayScale(c("red", "green", "blue"))
  expect_length(res, 3)
})

