
# tests/testthat/test-strCountW.R
  
library(testthat)


test_that("strCountW counts words", {
  expect_equal(
    strCountW("this is a sentence"),
    4
  )
})


test_that("strCountW preserves NA", {
  expect_true(is.na(strCountW(NA_character_)))
})


