
# tests/testthat/test-strAlign.R
  
library(testthat)


test_that("strAlign right aligns strings", {
  res <- strAlign(c("a", "abc"))
  
  expect_equal(nchar(res[1]), nchar(res[2]))
})


test_that("strAlign left aligns strings", {
  res <- strAlign(c("a", "abc"), "\\l")
  
  expect_true(startsWith(res[1], "a"))
})


test_that("strAlign centers strings", {
  res <- strAlign(c("a", "abc"), "\\c")
  
  expect_equal(nchar(res[1]), nchar(res[2]))
})

