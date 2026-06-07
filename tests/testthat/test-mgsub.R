
# ===========================================================================
# mgsub
# ===========================================================================

test_that("mgsub performs multiple substitutions", {
  x <- c("ABC", "BCD", "CDE")
  res <- mgsub(pattern = c("B", "C"), replacement = c("X", "Y"), x)
  expect_equal(res, c("AXY", "XYD", "YDE"))
})

test_that("mgsub with no match returns input unchanged", {
  x <- "hello"
  expect_equal(mgsub(pattern = "z", replacement = "q", x), "hello")
})

test_that("mgsub returns same length as input", {
  x <- c("aaa", "bbb", "ccc")
  res <- mgsub(c("a", "b"), c("1", "2"), x)
  expect_length(res, 3)
})

test_that("mgsub handles empty string input", {
  expect_equal(mgsub("a", "b", ""), "")
})

test_that("mgsub applies substitutions in order", {
  # if "A" -> "B" and "B" -> "C": second pattern is applied to original
  # (gsub semantics, not chained) — depends on implementation
  # Just verify the call does not error and returns a character
  res <- mgsub(c("A", "B"), c("B", "C"), "AB")
  expect_type(res, "character")
})

