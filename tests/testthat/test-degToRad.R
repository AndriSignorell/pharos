
# ===========================================================================
# degToRad / radToDeg
# ===========================================================================

test_that("degToRad converts correctly", {
  expect_equal(degToRad(0),   0)
  expect_equal(degToRad(90),  pi / 2)
  expect_equal(degToRad(180), pi)
  expect_equal(degToRad(360), 2 * pi)
  expect_equal(degToRad(c(90, 180, 270)), c(pi/2, pi, 3*pi/2))
})

test_that("radToDeg converts correctly", {
  expect_equal(radToDeg(0),    0)
  expect_equal(radToDeg(pi/2), 90)
  expect_equal(radToDeg(pi),   180)
  expect_equal(radToDeg(2*pi), 360)
  expect_equal(radToDeg(c(0.5, 1, 2) * pi), c(90, 180, 360))
})

test_that("degToRad and radToDeg are inverses", {
  vals <- c(0, 30, 45, 90, 120, 180, 270, 360)
  expect_equal(radToDeg(degToRad(vals)), vals)
})

