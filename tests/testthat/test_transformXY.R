
# ===========================================================================
# transformXY
# ===========================================================================

test_that("transformXY identity: no change", {
  x <- c(1, 2, 3); y <- c(1, 2, 3)
  res <- transformXY(x, y)
  expect_equal(res$x, x)
  expect_equal(res$y, y)
})

test_that("transformXY scale only", {
  x <- c(1, 2); y <- c(3, 4)
  res <- transformXY(x, y, scale = 2)
  expect_equal(res$x, c(2, 4))
  expect_equal(res$y, c(6, 8))
})

test_that("transformXY scale x and y independently", {
  res <- transformXY(c(1, 1), c(1, 1), scale = c(2, 3))
  expect_equal(res$x, c(2, 2))
  expect_equal(res$y, c(3, 3))
})

test_that("transformXY translation only", {
  x <- c(0, 1); y <- c(0, 1)
  res <- transformXY(x, y, translate = c(5, 10))
  expect_equal(res$x, c(5, 6))
  expect_equal(res$y, c(10, 11))
})

test_that("transformXY rotation preserves distance from origin", {
  # distance invariant regardless of rotation convention
  res <- transformXY(1, 0, theta = pi / 2)
  expect_equal(sqrt(res$x^2 + res$y^2), 1, tolerance = 1e-10)
})

test_that("transformXY rotation by pi maps point to opposite side of origin", {
  # rotate() uses centroid as center; with two symmetric points centroid=(0,0)
  # (1,0) and (-1,0): centroid=0 -> standard rotation applies
  res <- transformXY(c(1, -1), c(0, 0), theta = pi)
  expect_equal(res$x, c(-1, 1), tolerance = 1e-10)
  expect_equal(res$y, c(0, 0),  tolerance = 1e-10)
})

test_that("transformXY rotation CCW: (1,0) and (-1,0) by pi/2 -> (0,1) and (0,-1)", {
  # centroid of c(1,-1), c(0,0) is (0,0), so standard CCW rotation:
  # (1,0) -> (0,1) and (-1,0) -> (0,-1)
  res <- transformXY(c(1, -1), c(0, 0), theta = pi / 2)
  expect_equal(res$x, c(0, 0),  tolerance = 1e-10)
  expect_equal(res$y, c(1, -1), tolerance = 1e-10)
})

test_that("transformXY rotation by 2*pi is identity", {
  res <- transformXY(c(3, 1), c(4, 2), theta = 2 * pi)
  expect_equal(res$x, c(3, 1), tolerance = 1e-10)
  expect_equal(res$y, c(4, 2), tolerance = 1e-10)
})

test_that("transformXY accepts matrix input", {
  m <- cbind(c(1, 2), c(3, 4))
  res <- transformXY(m, scale = 1)
  expect_equal(res$x, c(1, 2))
  expect_equal(res$y, c(3, 4))
})

test_that("transformXY theta must be scalar", {
  expect_error(transformXY(1, 1, theta = c(0, 1)))
})


