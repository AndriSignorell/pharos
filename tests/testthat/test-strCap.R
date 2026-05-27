
# tests/testthat/test-strCap.R
  
library(testthat)


test_that("strCap capitalizes first letter", {
  expect_equal(
    strCap("hello world", "first"),
    "Hello World"
  )
})


test_that("strCap capitalizes words", {
  expect_equal(
    strCap("hello world", "word"),
    "Hello World"
  )
})


test_that("strCap title case keeps stopwords lowercase", {
  expect_equal(
    strCap("the lord of the rings", "title"),
    "the Lord of the Rings"
  )
})

