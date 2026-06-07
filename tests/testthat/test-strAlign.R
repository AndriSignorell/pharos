
# ===========================================================================
# strAlign
# ===========================================================================

test_that("strAlign right-aligns by default", {
  x <- c("here", "there", "everywhere")
  res <- strAlign(x)
  widths <- nchar(res)
  expect_true(all(widths == max(nchar(x))))
  # right-aligned: "here" should have leading spaces
  expect_true(startsWith(res[1], " "))
})

test_that("strAlign left-aligns with \\l", {
  x <- c("here", "there", "everywhere")
  res <- strAlign(x, "\\l")
  widths <- nchar(res)
  expect_true(all(widths == max(nchar(x))))
  # left-aligned: first element starts with "here"
  expect_true(startsWith(res[1], "here"))
  expect_true(endsWith(res[1], " "))
})

test_that("strAlign center-aligns with \\c", {
  x <- c("hi", "there", "everywhere")
  res <- strAlign(x, "\\c")
  widths <- nchar(res)
  expect_true(all(widths == max(nchar(x))))
})

test_that("strAlign aligns at decimal separator", {
  z <- c("6.0", "45.12", "784")
  res <- strAlign(z, ".")
  # all results same width
  expect_true(length(unique(nchar(res))) == 1L)
  # dot positions should be equal or missing (784 has no dot -> at end)
  dot_pos <- regexpr(".", res, fixed = TRUE)
  # "784" has no dot so its dot_pos is -1; the others should match
  valid <- dot_pos[dot_pos > 0]
  expect_true(length(unique(valid)) == 1L)
})

test_that("strAlign preserves NA", {
  x <- c("hello", NA, "world")
  res <- strAlign(x, "\\r")
  expect_true(is.na(res[2]))
})


test_that("strAlign right aligns strings", {
  res <- strAlign(c("a", "abc"))
  
  expect_equal(nchar(res[1]), nchar(res[2]))
})


test_that("strAlign left aligns strings", {
  res <- strAlign(c("a", "abc"), "\\l")
  
  expect_true(startsWith(res[1], "a"))
})


test_that("strAlign centers strings", {
  res <- strAlign(c("a", "abc"), "\\c")
  
  expect_equal(nchar(res[1]), nchar(res[2]))
})

