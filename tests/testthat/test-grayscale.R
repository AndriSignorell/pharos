
# ===========================================================================
# grayscale
# ===========================================================================

test_that("grayscale returns gray for gray input", {
  g <- grayscale("grey50")
  rgb_vals <- col2rgb(g)
  expect_equal(unname(rgb_vals[1L, 1L]), unname(rgb_vals[2L, 1L]))
  expect_equal(unname(rgb_vals[2L, 1L]), unname(rgb_vals[3L, 1L]))
})

test_that("grayscale of white is white", {
  expect_equal(grayscale("white"), "#FFFFFF")
})

test_that("grayscale of black is black", {
  expect_equal(grayscale("black"), "#000000")
})

test_that("grayscale returns equal R/G/B channels", {
  cols <- c("red", "green", "blue", "#804020")
  result <- col2rgb(grayscale(cols))
  expect_equal(unname(result[1L, ]), unname(result[2L, ]))
  expect_equal(unname(result[2L, ]), unname(result[3L, ]))
})

test_that("grayscale vectorises", {
  res <- grayscale(c("red", "green", "blue"))
  expect_length(res, 3)
})

