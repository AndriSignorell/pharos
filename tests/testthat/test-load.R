

test_that("lyra does not load without DescToolsX", {
  expect_error(
    library(lyra),
    NA
  )
})
