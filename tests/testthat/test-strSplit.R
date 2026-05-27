
# tests/testthat/test-strSplit.R
  
library(testthat)


test_that("strSplit splits fixed strings", {
  expect_equal(
    strSplit("a,b,c", ",", fixed = TRUE),
    c("a", "b", "c")
  )
})


test_that("strSplit splits regex patterns", {
  expect_equal(
    strSplit("a1b2c", "\\d"),
    c("a", "b", "c")
  )
})


test_that("strSplit returns list for vector input", {
  res <- strSplit(c("a b", "c d"), " ")
  
  expect_type(res, "list")
  expect_length(res, 2)
})
