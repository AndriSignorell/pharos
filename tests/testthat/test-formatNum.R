
test_that("formatNum_cpp works", {
  x <- c(1.2345, 1000.2)
  expect_type(formatNum_cpp(x), "character")
})

expect_error(
  formatNum_cpp(1, digits = integer(0)),
  "'digits' must not be empty",
  fixed = TRUE
)

expect_identical(
  formatNum_cpp(numeric(0), digits = integer(0)),
  character(0)
)

