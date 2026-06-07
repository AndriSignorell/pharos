
# ===========================================================================
# fmCI
# ===========================================================================

test_that("fmCI formats with default template", {
  x <- c(est = 2.1, lci = 1.5, uci = 3.8)
  res <- fmCI(x)
  expect_true(grepl("2.1", res))
  expect_true(grepl("1.5", res))
  expect_true(grepl("3.8", res))
  expect_true(grepl("[", res, fixed = TRUE))
  expect_true(grepl("]", res, fixed = TRUE))
})

test_that("fmCI respects custom template", {
  x <- c(2.1, 1.5, 3.8)
  res <- fmCI(x, template = "%s (%s to %s)")
  expect_true(grepl("to", res))
  expect_false(grepl("[", res, fixed = TRUE))
})

test_that("fmCI respects digits argument", {
  x <- c(2.1234, 1.5678, 3.8901)
  res <- fmCI(x, digits = 1)
  expect_true(grepl("2.1", res))
  expect_false(grepl("2.12", res))
})

