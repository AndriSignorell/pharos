
# ===========================================================================
# addOpacity
# ===========================================================================

test_that("addOpacity returns 9-character hex string", {
  res <- addOpacity("red", 0.5)
  expect_match(res, "^#[0-9A-Fa-f]{8}$")
})

test_that("addOpacity alpha=1 gives fully opaque", {
  res <- addOpacity("red", 1)
  expect_match(res, "FF$")
})

test_that("addOpacity alpha=0 gives fully transparent", {
  res <- addOpacity("red", 0)
  expect_match(res, "00$")
})

test_that("addOpacity accepts palette index", {
  res <- addOpacity(2, 0.5)
  expect_match(res, "^#[0-9A-Fa-f]{8}$")
})

