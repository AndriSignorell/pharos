
# tests/testthat/test-strLeftRight.R
  
library(testthat)


test_that("strLeft extracts left substring", {
  expect_equal(
    strLeft("abcdef", 3),
    "abc"
  )
})


test_that("strRight extracts right substring", {
  expect_equal(
    strRight("abcdef", 3),
    "def"
  )
})


test_that("strLeft supports negative n", {
  expect_equal(
    strLeft("abcdef", -2),
    "abcd"
  )
})


test_that("strRight supports negative n", {
  expect_equal(
    strRight("abcdef", -2),
    "cdef"
  )
})

