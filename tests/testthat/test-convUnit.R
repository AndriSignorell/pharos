
library(testthat)

test_that("basic SI conversions work", {
  expect_equal(
    convUnit(1, "m", "m", d.prefix, d.units),
    1
  )
  
  expect_equal(
    convUnit(1, "km", "m", d.prefix, d.units),
    1000
  )
  
  expect_equal(
    convUnit(1, "m", "cm", d.prefix, d.units),
    100
  )
})

test_that("compound units work", {
  expect_equal(
    convUnit(100, "km/h", "m/s", d.prefix, d.units),
    27.77778,
    tolerance = 1e-5
  )
  
  expect_equal(
    convUnit(1, "m/s", "km/h", d.prefix, d.units),
    3.6,
    tolerance = 1e-6
  )
})

test_that("derived units expand correctly", {
  expect_equal(
    convUnit(1, "N", "kg*m/s^2", d.prefix, d.units),
    1
  )
  
  expect_equal(
    convUnit(1, "Pa", "N/m^2", d.prefix, d.units),
    1
  )
  
  expect_equal(
    convUnit(1, "J", "kg*m^2/s^2", d.prefix, d.units),
    1
  )
})

test_that("prefix + power works", {
  expect_equal(
    convUnit(1, "cm2", "m2", d.prefix, d.units),
    1e-4
  )
  
  expect_equal(
    convUnit(1, "km2", "m2", d.prefix, d.units),
    1e6
  )
})

test_that("temperature conversion works", {
  expect_equal(
    convUnit(0, "C", "F", d.prefix, d.units),
    32
  )
  
  expect_equal(
    convUnit(32, "F", "C", d.prefix, d.units),
    0
  )
  
  expect_equal(
    convUnit(0, "C", "K", d.prefix, d.units),
    273.15
  )
})

test_that("non-SI units via graph work", {
  expect_equal(
    convUnit(1, "mi", "m", d.prefix, d.units),
    1609.344,
    tolerance = 1e-6
  )
  
  expect_equal(
    convUnit(1, "bar", "Pa", d.prefix, d.units),
    1e5,
    tolerance = 1e-6
  )
})

test_that("dimension mismatch throws error", {
  expect_error(
    convUnit(1, "m", "s", d.prefix, d.units)
  )
})

test_that("unknown unit throws error", {
  expect_error(
    convUnit(1, "foo", "m", d.prefix, d.units)
  )
})


