
# tests/testthat/test-strTrunc.R
  
library(testthat)


test_that("strTrunc truncates strings", {
  expect_equal(
    strTrunc("abcdef", maxLen = 3),
    "abc..."
  )
})


test_that("strTrunc leaves short strings unchanged", {
  expect_equal(
    strTrunc("abc", maxLen = 10),
    "abc"
  )
})


test_that("strTrunc respects word boundaries", {
  expect_equal(
    strTrunc("hello world", maxLen = 8, wordBound = TRUE),
    "hello..."
  )
})


test_that("strTrunc preserves NA", {
  expect_true(is.na(strTrunc(NA_character_)))
})


test_that("strTrunc rejects negative maxlen", {
  expect_error(
    strTrunc("abc", maxLen = -1),
    "maxLen"
  )
})

