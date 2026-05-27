
# tests/testthat/test-strChop.R
  
library(testthat)


test_that("strChop splits by lengths", {
  expect_equal(
    strChop("abcdef", len = c(2, 2, 2)),
    c("ab", "cd", "ef")
  )
})


test_that("strChop splits by positions", {
  expect_equal(
    strChop("abcdef", pos = c(2, 4)),
    c("ab", "cd", "ef")
  )
})


test_that("strChop rejects simultaneous len and pos", {
  expect_error(
    strChop("abc", len = 1, pos = 1)
  )
})

