
# ===========================================================================
# unit getter/setter
# ===========================================================================

test_that("unit setter assigns unit attribute", {
  x <- 10
  unit(x) <- "m"
  expect_equal(unit(x), "m")
})

test_that("unit getter returns NULL when no unit", {
  x <- 42
  expect_null(unit(x))
})

test_that("unit setter adds 'Unit' class", {
  x <- 5
  unit(x) <- "kg"
  expect_true(inherits(x, "Unit"))
})

test_that("unit setter NULL removes unit", {
  x <- 10
  unit(x) <- "m"
  unit(x) <- NULL
  expect_null(unit(x))
})

test_that("unit setter rejects non-scalar", {
  x <- 10
  expect_error(unit(x) <- c("m", "s"))
})

test_that("unit setter rejects non-character", {
  x <- 10
  expect_error(unit(x) <- 42)
})

