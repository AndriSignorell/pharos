
# tests/testthat/test-strExtractBetween.R
  
library(testthat)


test_that("strExtractBetween extracts content", {
  expect_equal(
    strExtractBetween("a[123]b", "\\[", "\\]"),
    "123"
  )
})


test_that("strExtractBetween supports greedy matching", {
  expect_equal(
    strExtractBetween("a[1]b[2]c", "\\[", "\\]", greedy = TRUE),
    "1]b[2"
  )
})

