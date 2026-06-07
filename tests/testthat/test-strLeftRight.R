
# ===========================================================================
# strLeft / strRight
# ===========================================================================

test_that("strLeft extracts left substring", {
  expect_equal(
    strLeft("abcdef", 3),
    "abc"
  )
})


test_that("strRight extracts right substring", {
  expect_equal(
    strRight("abcdef", 3),
    "def"
  )
})


test_that("strLeft supports negative n", {
  expect_equal(
    strLeft("abcdef", -2),
    "abcd"
  )
})


test_that("strRight supports negative n", {
  expect_equal(
    strRight("abcdef", -2),
    "cdef"
  )
})


test_that("strLeft with positive n", {
  expect_equal(strLeft("Hello world!", 5), "Hello")
  expect_equal(strLeft("Hello world!", 0), "")
  expect_equal(strLeft("Hello world!", 12), "Hello world!")
})

test_that("strLeft with negative n cuts from right", {
  # stri_sub(x, 1, nchar(x)+n): "Hello world!" nchar=12
  # n=-5 -> stri_sub(x, 1, 7) = "Hello w"
  # n=-6 -> stri_sub(x, 1, 6) = "Hello "
  expect_equal(strLeft("Hello world!", -5), "Hello w")
  expect_equal(strLeft("Hello world!", -6), "Hello ")
})

test_that("strRight with positive n", {
  # stri_sub(x, len-n+1, len): len=12
  # n=6 -> stri_sub(x, 7, 12) = "world!"
  expect_equal(strRight("Hello world!", 6), "world!")
  expect_equal(strRight("Hello world!", 0), "")
  expect_equal(strRight("Hello world!", 12), "Hello world!")
})

test_that("strRight with negative n cuts from left", {
  # negative n: drop first |n| chars from left -> equivalent to strRight(x, nchar-|n|)
  expect_equal(strRight("Hello world!", -6), "world!")
})

test_that("strLeft/strRight handle NA", {
  expect_equal(strLeft(NA_character_, 3), NA_character_)
  expect_equal(strRight(NA_character_, 3), NA_character_)
})

test_that("strLeft vectorises", {
  x <- c("Lorem", "ipsum", "dolor", "sit", "amet")
  res <- strLeft(x, 2)
  expect_equal(res, c("Lo", "ip", "do", "si", "am"))
})

test_that("strRight recycles n", {
  x <- c("Lorem", "ipsum", "dolor", "sit", "amet")
  # n recycled: c(2,3,2,3,2)
  # "Lorem"[last 2]="em", "ipsum"[last 3]="sum", "dolor"[last 2]="or",
  # "sit"[last 3]="sit", "amet"[last 2]="et"
  res <- strRight(x, c(2, 3))
  expect_equal(res, c("em", "sum", "or", "sit", "et"))
})

test_that("strLeft and strRight partition a string", {
  x <- "Hello world!"
  n <- 5L
  expect_equal(paste0(strLeft(x, n), strRight(x, strLen(x) - n)), x)
})
