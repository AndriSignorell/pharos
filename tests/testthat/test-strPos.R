
# tests/testthat/test-strPos.R
  
library(testthat)


test_that("strPos finds first position", {
  expect_equal(
    unname(strPos("abcdef", "cd")),
    3L
  )
})


test_that("strPos returns NA when pattern missing", {
  expect_true(
    is.na(strPos("abcdef", "xx"))
  )
})


