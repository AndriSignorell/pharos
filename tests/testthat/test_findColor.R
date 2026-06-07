
# ===========================================================================
# findColor
# ===========================================================================

test_that("findColor returns correct length", {
  cols <- colorRampPalette(c("blue", "red"))(100)
  res <- findColor(c(25, 50, 75), col = cols, minX = 0, maxX = 100)
  expect_length(res, 3)
})

test_that("findColor: value at minX returns first color", {
  cols <- c("blue", "white", "red")
  res <- findColor(0, col = cols, minX = 0, maxX = 100)
  expect_equal(res, "blue")
})

test_that("findColor: value at maxX returns last color", {
  cols <- c("blue", "white", "red")
  res <- findColor(100, col = cols, minX = 0, maxX = 100)
  expect_equal(res, "red")
})

test_that("findColor: out-of-range returns NA without all.inside", {
  cols <- c("blue", "white", "red")
  res <- findColor(-10, col = cols, minX = 0, maxX = 100, all.inside = FALSE)
  expect_true(is.na(res))
})

test_that("findColor: out-of-range clamps with all.inside=TRUE", {
  cols <- c("blue", "white", "red")
  res <- findColor(-10, col = cols, minX = 0, maxX = 100, all.inside = TRUE)
  expect_false(is.na(res))
  expect_equal(res, "blue")
})

test_that("findColor vectorises", {
  cols <- colorRampPalette(c("blue", "red"))(10)
  res <- findColor(c(10, 50, 90), col = cols, minX = 0, maxX = 100)
  expect_length(res, 3)
  expect_type(res, "character")
})

