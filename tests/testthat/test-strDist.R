# ===========================================================================
# strDist
# ===========================================================================

test_that("strDist levenshtein: identical strings give 0", {
  d <- strDist("abc", "abc")
  expect_equal(as.numeric(d), 0)
})

test_that("strDist levenshtein: single substitution gives 1", {
  d <- strDist("abc", "axc")
  expect_equal(as.numeric(d), 1)
})

test_that("strDist levenshtein: known DNA example", {
  # GACGGATTATG vs GATCGGAATAG -> LD = 3
  d <- strDist("GACGGATTATG", "GATCGGAATAG")
  expect_equal(as.numeric(d), 3)
})

test_that("strDist hamming: identical gives 0", {
  d <- strDist("abc", "abc", method = "hamming")
  expect_equal(as.numeric(d), 0)
})

test_that("strDist hamming: counts mismatches", {
  d <- strDist("abc", "axc", method = "hamming")
  expect_equal(as.numeric(d), 1)
  d2 <- strDist("abc", "xyz", method = "hamming")
  expect_equal(as.numeric(d2), 3)
})

test_that("strDist hamming: unequal lengths throws error", {
  expect_error(strDist("abc", "ab", method = "hamming"))
})

test_that("strDist normlevenshtein: identical gives 1", {
  d <- strDist("abc", "abc", method = "normlevenshtein")
  expect_equal(as.numeric(d), 1)
})

test_that("strDist normlevenshtein: completely different gives 0", {
  # e.g. "aaa" vs "bbb": LD=3, max=3, norm=1-3/3=0
  d <- strDist("aaa", "bbb", method = "normlevenshtein")
  expect_equal(as.numeric(d), 0)
})

test_that("strDist returns class dist", {
  d <- strDist("abc", "axc")
  expect_s3_class(d, "dist")
})

test_that("strDist has ScoringMatrix attribute for levenshtein", {
  d <- strDist("abc", "axc")
  expect_false(is.null(attr(d, "ScoringMatrix")))
})

test_that("strDist ignore.case works", {
  d_sensitive   <- strDist("ABC", "abc")
  d_insensitive <- strDist("ABC", "abc", ignore.case = TRUE)
  expect_equal(as.numeric(d_insensitive), 0)
  expect_gt(as.numeric(d_sensitive), 0)
})

test_that("strDist computes Levenshtein distance", {
  d <- strDist("kitten", "sitting")
  
  expect_equal(as.numeric(d), 3)
})


test_that("strDist computes Hamming distance", {
  d <- strDist("abc", "adc", method = "hamming")
  
  expect_equal(as.numeric(d), 1)
})


test_that("strDist rejects unequal Hamming strings", {
  expect_error(
    strDist("abc", "ab", method = "hamming")
  )
})


test_that("strDist normalized distance in [0,1]", {
  d <- strDist("abc", "abc", method = "normlevenshtein")
  
  expect_equal(as.numeric(d), 1)
})

