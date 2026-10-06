
# tests/testthat/test-strCountWords.R
  
library(testthat)


test_that("strCountWords counts words", {
  expect_equal(
    strCountWords("this is a sentence"),
    4
  )
})


test_that("strCountWords preserves NA", {
  expect_true(is.na(strCountWords(NA_character_)))
})


