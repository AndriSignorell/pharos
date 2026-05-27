
# tests/testthat/test-strTrim.R

library(testthat)


test_that("strTrim trims both sides", {
  expect_equal(
    strTrim("  hello  "),
    "hello"
  )
})


test_that("strTrim trims left side", {
  expect_equal(
    strTrim("  hello  ", method = "left"),
    "hello  "
  )
})


test_that("strTrim trims right side", {
  expect_equal(
    strTrim("  hello  ", method = "right"),
    "  hello"
  )
})


test_that("strTrim preserves NA", {
  expect_true(is.na(strTrim(NA_character_)))
})


