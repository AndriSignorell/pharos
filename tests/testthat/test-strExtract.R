
# tests/testthat/test-strExtract.R
  
library(testthat)


test_that("strExtract extracts first match", {
  expect_equal(
    strExtract("abc123", "\\d+"),
    "123"
  )
})


test_that("strExtract returns NA for no match", {
  expect_true(
    is.na(strExtract("abc", "\\d+"))
  )
})

