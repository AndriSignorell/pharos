
# ===========================================================================
# mixCol
# ===========================================================================

test_that("mixCol weights=0 returns col1", {
  expect_equal(mixCol("red", "blue", 0), colToHex("red"))
})

test_that("mixCol weights=1 returns col2", {
  expect_equal(mixCol("red", "blue", 1), colToHex("blue"))
})

test_that("mixCol weights=0.5 is symmetric", {
  m1 <- mixCol("red", "blue", 0.5)
  m2 <- mixCol("blue", "red", 0.5)
  expect_equal(m1, m2)
})

test_that("mixCol black+white at 0.5 is mid-gray", {
  res <- col2rgb(mixCol("black", "white", 0.5))
  expect_equal(unname(res[1L, 1L]), 128, tolerance = 1)
  expect_equal(unname(res[2L, 1L]), 128, tolerance = 1)
  expect_equal(unname(res[3L, 1L]), 128, tolerance = 1)
})

test_that("mixCol vectorises", {
  res <- mixCol(c("red", "green"), c("blue", "yellow"), 0.5)
  expect_length(res, 2)
})

