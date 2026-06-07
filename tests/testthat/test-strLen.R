
# ===========================================================================
# strLen
# ===========================================================================

test_that("strLen returns correct lengths", {
  expect_equal(strLen(c("hello", "world!")), c(5L, 6L))
  expect_equal(strLen(""), 0L)
  expect_equal(strLen(NA_character_), NA_integer_)
})

test_that("strLen is equivalent to nchar", {
  x <- c("abc", "de", "f", "")
  expect_equal(strLen(x), nchar(x))
})

