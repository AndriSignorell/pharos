

# tests/testthat/test-strVal.R
  
library(testthat)


test_that("strVal extracts numbers", {
  expect_equal(
    strVal("x = 12.5")[[1]],
    "12.5"
  )
})


test_that("strVal extracts scientific notation", {
  expect_equal(
    strVal("x=-3.2e2")[[1]],
    "-3.2e2"
  )
})


test_that("strVal converts to numeric", {
  expect_equal(
    strVal("x=2.5", as.numeric = TRUE)[[1]],
    2.5
  )
})


test_that("strVal pastes values", {
  expect_equal(
    strVal("a1b2", paste = TRUE),
    "12"
  )
})

