# ===========================================================================
# contrastColor
# ===========================================================================

test_that("contrastColor returns black on white background", {
  expect_equal(unname(contrastColor("white")), "black")
})

test_that("contrastColor returns white on black background", {
  expect_equal(unname(contrastColor("black")), "white")
})

test_that("contrastColor returns white on dark red", {
  expect_equal(unname(contrastColor("#8B0000")), "white")
})

test_that("contrastColor returns black on yellow", {
  expect_equal(unname(contrastColor("yellow")), "black")
})

test_that("contrastColor vectorises", {
  res <- unname(contrastColor(c("white", "black", "yellow", "navy")))
  expect_length(res, 4)
  expect_equal(res[1], "black")
  expect_equal(res[2], "white")
})

test_that("contrastColor respects custom light/dark", {
  res <- unname(contrastColor("white", light = "ivory", dark = "grey10"))
  expect_equal(res, "grey10")
})

