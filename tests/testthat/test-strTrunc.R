
# tests/testthat/test-strTrunc.R
  
library(testthat)


test_that("strTrunc truncates strings", {
  expect_equal(
    strTrunc("abcdef", maxlen = 3),
    "abc..."
  )
})


test_that("strTrunc leaves short strings unchanged", {
  expect_equal(
    strTrunc("abc", maxlen = 10),
    "abc"
  )
})


test_that("strTrunc respects word boundaries", {
  expect_equal(
    strTrunc("hello world", maxlen = 8, wbound = TRUE),
    "hello..."
  )
})


test_that("strTrunc preserves NA", {
  expect_true(is.na(strTrunc(NA_character_)))
})


test_that("strTrunc rejects negative maxlen", {
  expect_error(
    strTrunc("abc", maxlen = -1),
    "maxlen"
  )
})

