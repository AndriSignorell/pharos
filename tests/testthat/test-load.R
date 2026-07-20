

test_that("pharos does not load without DescToolsX", {
  expect_error(
    library(pharos),
    NA
  )
})
