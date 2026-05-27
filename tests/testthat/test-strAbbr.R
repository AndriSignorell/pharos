
# tests/testthat/test-strAbbr.R
  
library(testthat)


test_that("strAbbr creates unique abbreviations", {
  x <- c("apple", "apricot", "banana")
  
  expect_equal(
    strAbbr(x, method = "left"),
    c("app", "apr", "b")
  )
})


test_that("strAbbr fixed mode uses common width", {
  x <- c("apple", "apricot", "banana")
  
  expect_equal(
    strAbbr(x, method = "fix"),
    c("app", "apr", "ban")
  )
})

