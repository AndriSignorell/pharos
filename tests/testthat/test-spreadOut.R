
# ===========================================================================
# spreadOut
# ===========================================================================

test_that("spreadOut preserves length", {
  x <- c(1, 3, 3, 3, 3, 5)
  res <- spreadOut(x, mindist = 0.2)
  expect_length(res, length(x))
})

test_that("spreadOut enforces minimum distance", {
  x <- c(1, 3, 3, 3, 3, 5)
  res <- spreadOut(x, mindist = 0.2)
  res_sorted <- sort(res)
  diffs <- diff(res_sorted)
  expect_true(all(diffs >= 0.2 - 1e-9))
})

test_that("spreadOut preserves NA positions", {
  x <- c(5, 2.5, 2.5, NA, 3.5, 1, 3.5, NA)
  res <- spreadOut(x, mindist = 0.2)
  expect_equal(which(is.na(res)), which(is.na(x)))
})

test_that("spreadOut returns original for length < 2 non-NA", {
  expect_equal(spreadOut(c(NA, 1, NA), mindist = 0.5), c(NA, 1, NA))
  expect_equal(spreadOut(NA_real_, mindist = 0.5), NA_real_)
})

test_that("spreadOut preserves order relationship", {
  x <- c(1, 2, 3, 4, 5)
  res <- spreadOut(x, mindist = 0.1)
  expect_equal(order(res), order(x))
})

