
# tests/testthat/test-strDist.R
  
library(testthat)


test_that("strDist computes Levenshtein distance", {
  d <- strDist("kitten", "sitting")
  
  expect_equal(as.numeric(d), 3)
})


test_that("strDist computes Hamming distance", {
  d <- strDist("abc", "adc", method = "hamming")
  
  expect_equal(as.numeric(d), 1)
})


test_that("strDist rejects unequal Hamming strings", {
  expect_error(
    strDist("abc", "ab", method = "hamming")
  )
})


test_that("strDist normalized distance in [0,1]", {
  d <- strDist("abc", "abc", method = "normlevenshtein")
  
  expect_equal(as.numeric(d), 1)
})

