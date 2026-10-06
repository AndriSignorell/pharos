
# ===========================================================================
# findCol
# ===========================================================================

test_that("findCol returns correct length", {
  cols <- colorRampPalette(c("blue", "red"))(100)
  res <- findCol(c(25, 50, 75), col = cols, minX = 0, maxX = 100)
  expect_length(res, 3)
})

test_that("findCol: value at minX returns first color", {
  cols <- c("blue", "white", "red")
  res <- findCol(0, col = cols, minX = 0, maxX = 100)
  expect_equal(res, "blue")
})

test_that("findCol: value at maxX returns last color", {
  cols <- c("blue", "white", "red")
  res <- findCol(100, col = cols, minX = 0, maxX = 100)
  expect_equal(res, "red")
})

test_that("findCol: out-of-range returns NA without allInside", {
  cols <- c("blue", "white", "red")
  res <- findCol(-10, col = cols, minX = 0, maxX = 100, all.inside = FALSE)
  expect_true(is.na(res))
})

test_that("findCol: out-of-range clamps with allInside=TRUE", {
  cols <- c("blue", "white", "red")
  res <- findCol(-10, col = cols, minX = 0, maxX = 100, all.inside = TRUE)
  expect_false(is.na(res))
  expect_equal(res, "blue")
})

test_that("findCol vectorises", {
  cols <- colorRampPalette(c("blue", "red"))(10)
  res <- findCol(c(10, 50, 90), col = cols, minX = 0, maxX = 100)
  expect_length(res, 3)
  expect_type(res, "character")
})

