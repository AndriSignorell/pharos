
# tests/testthat/test-strRev.R
  
library(testthat)


test_that("strRev reverses strings", {
  expect_equal(
    strRev("abc"),
    "cba"
  )
})


test_that("strRev is unicode safe", {
  expect_equal(
    strRev("äöü"),
    "üöä"
  )
})

