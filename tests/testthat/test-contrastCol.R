# ===========================================================================
# contrastCol
# ===========================================================================

test_that("contrastCol returns black on white background", {
  expect_equal(unname(contrastCol("white")), "black")
})

test_that("contrastCol returns white on black background", {
  expect_equal(unname(contrastCol("black")), "white")
})

test_that("contrastCol returns white on dark red", {
  expect_equal(unname(contrastCol("#8B0000")), "white")
})

test_that("contrastCol returns black on yellow", {
  expect_equal(unname(contrastCol("yellow")), "black")
})

test_that("contrastCol vectorises", {
  res <- unname(contrastCol(c("white", "black", "yellow", "navy")))
  expect_length(res, 4)
  expect_equal(res[1], "black")
  expect_equal(res[2], "white")
})

test_that("contrastCol respects custom light/dark", {
  res <- unname(contrastCol("white", light = "ivory", dark = "grey10"))
  expect_equal(res, "grey10")
})

