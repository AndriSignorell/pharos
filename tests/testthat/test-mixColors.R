
# ===========================================================================
# mixColors
# ===========================================================================

test_that("mixColors weight=0 returns col1", {
  expect_equal(mixColors("red", "blue", 0), colToHex("red"))
})

test_that("mixColors weight=1 returns col2", {
  expect_equal(mixColors("red", "blue", 1), colToHex("blue"))
})

test_that("mixColors weight=0.5 is symmetric", {
  m1 <- mixColors("red", "blue", 0.5)
  m2 <- mixColors("blue", "red", 0.5)
  expect_equal(m1, m2)
})

test_that("mixColors black+white at 0.5 is mid-gray", {
  res <- col2rgb(mixColors("black", "white", 0.5))
  expect_equal(unname(res[1L, 1L]), 128, tolerance = 1)
  expect_equal(unname(res[2L, 1L]), 128, tolerance = 1)
  expect_equal(unname(res[3L, 1L]), 128, tolerance = 1)
})

test_that("mixColors vectorises", {
  res <- mixColors(c("red", "green"), c("blue", "yellow"), 0.5)
  expect_length(res, 2)
})

