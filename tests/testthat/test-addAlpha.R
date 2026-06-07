
# ===========================================================================
# addAlpha
# ===========================================================================

test_that("addAlpha returns 9-character hex string", {
  res <- addAlpha("red", 0.5)
  expect_match(res, "^#[0-9A-Fa-f]{8}$")
})

test_that("addAlpha alpha=1 gives fully opaque", {
  res <- addAlpha("red", 1)
  expect_match(res, "FF$")
})

test_that("addAlpha alpha=0 gives fully transparent", {
  res <- addAlpha("red", 0)
  expect_match(res, "00$")
})

test_that("addAlpha accepts palette index", {
  res <- addAlpha(2, 0.5)
  expect_match(res, "^#[0-9A-Fa-f]{8}$")
})

