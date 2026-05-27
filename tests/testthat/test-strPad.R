
# tests/testthat/test-strPad.R
  
library(testthat)


test_that("strPad pads left adjusted strings", {
  expect_equal(
    strPad("abc", width = 5),
    "abc  "
  )
})


test_that("strPad pads right adjusted strings", {
  expect_equal(
    strPad("abc", width = 5, adj = "right"),
    "  abc"
  )
})


test_that("strPad pads centered strings", {
  expect_equal(
    strPad("abc", width = 5, adj = "center"),
    " abc "
  )
})

