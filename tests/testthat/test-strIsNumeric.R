
# tests/testthat/test-strIsNumeric.R
  
library(testthat)


test_that("strIsNumeric detects numeric strings", {
  expect_true(strIsNumeric("123"))
})


test_that("strIsNumeric rejects non-numeric strings", {
  expect_false(strIsNumeric("abc"))
})


test_that("strIsNumeric supports scientific notation", {
  expect_true(strIsNumeric("1e3", scientific = TRUE))
})


test_that("strIsNumeric rejects scientific notation by default", {
  expect_false(strIsNumeric("1e3"))
})

