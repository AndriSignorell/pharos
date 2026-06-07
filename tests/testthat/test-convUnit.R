
library(testthat)

test_that("basic SI conversions work", {
  expect_equal(
    convUnit(1, "m", "m", Prefix, Units),
    1
  )
  
  expect_equal(
    convUnit(1, "km", "m", Prefix, Units),
    1000
  )
  
  expect_equal(
    convUnit(1, "m", "cm", Prefix, Units),
    100
  )
})

test_that("compound units work", {
  expect_equal(
    convUnit(100, "km/h", "m/s", Prefix, Units),
    27.77778,
    tolerance = 1e-5
  )
  
  expect_equal(
    convUnit(1, "m/s", "km/h", Prefix, Units),
    3.6,
    tolerance = 1e-6
  )
})

test_that("derived units expand correctly", {
  expect_equal(
    convUnit(1, "N", "kg*m/s^2", Prefix, Units),
    1
  )
  
  expect_equal(
    convUnit(1, "Pa", "N/m^2", Prefix, Units),
    1
  )
  
  expect_equal(
    convUnit(1, "J", "kg*m^2/s^2", Prefix, Units),
    1
  )
})

test_that("prefix + power works", {
  expect_equal(
    convUnit(1, "cm2", "m2", Prefix, Units),
    1e-4
  )
  
  expect_equal(
    convUnit(1, "km2", "m2", Prefix, Units),
    1e6
  )
})

test_that("temperature conversion works", {
  expect_equal(
    convUnit(0, "C", "F", Prefix, Units),
    32
  )
  
  expect_equal(
    convUnit(32, "F", "C", Prefix, Units),
    0
  )
  
  expect_equal(
    convUnit(0, "C", "K", Prefix, Units),
    273.15
  )
})

test_that("non-SI units via graph work", {
  expect_equal(
    convUnit(1, "mi", "m", Prefix, Units),
    1609.344,
    tolerance = 1e-6
  )
  
  expect_equal(
    convUnit(1, "bar", "Pa", Prefix, Units),
    1e5,
    tolerance = 1e-6
  )
})

test_that("dimension mismatch throws error", {
  expect_error(
    convUnit(1, "m", "s", Prefix, Units)
  )
})

test_that("unknown unit throws error", {
  expect_error(
    convUnit(1, "foo", "m", Prefix, Units)
  )
})


