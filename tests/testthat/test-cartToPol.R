
# ===========================================================================
# Coordinate conversions: cartToPol / polToCart
# ===========================================================================

test_that("cartToPol converts origin correctly", {
  res <- cartToPol(0, 0)
  expect_equal(res$r, 0)
})

test_that("cartToPol converts (1, 0) to r=1, theta=0", {
  res <- cartToPol(1, 0)
  expect_equal(res$r, 1)
  expect_equal(res$theta, 0)
})

test_that("cartToPol converts (0, 1) to r=1, theta=pi/2", {
  res <- cartToPol(0, 1)
  expect_equal(res$r, 1)
  expect_equal(res$theta, pi / 2)
})

test_that("cartToPol(-1, 0) gives r=1, theta=pi", {
  res <- cartToPol(-1, 0)
  expect_equal(res$r, 1)
  expect_equal(res$theta, pi)
})

test_that("polToCart inverts cartToPol for unit circle", {
  angles <- c(0, pi/4, pi/2, pi, 3*pi/2)
  for (a in angles) {
    xy <- polToCart(1, a)
    pol <- cartToPol(xy$x, xy$y)
    expect_equal(pol$r, 1, tolerance = 1e-10)
    expect_equal(pol$theta %% (2*pi), a %% (2*pi), tolerance = 1e-10)
  }
})

test_that("polToCart recycling works", {
  res <- polToCart(r = c(1, 2, 3), theta = pi/2)
  expect_length(res$x, 3)
  expect_equal(res$x, c(0, 0, 0), tolerance = 1e-10)
  expect_equal(res$y, c(1, 2, 3), tolerance = 1e-10)
})

test_that("cartToPol vectorises", {
  res <- cartToPol(x = c(1, 2, 3), y = c(1, 1, 1))
  expect_length(res$r, 3)
  expect_equal(res$r, sqrt(c(2, 5, 10)), tolerance = 1e-10)
})

