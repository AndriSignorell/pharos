
# ===========================================================================
# strVal
# ===========================================================================

test_that("strVal extracts numbers", {
  expect_equal(
    strVal("x = 12.5")[[1]],
    "12.5"
  )
})

test_that("strVal extracts scientific notation", {
  expect_equal(
    strVal("x=-3.2e2")[[1]],
    "-3.2e2"
  )
})


test_that("strVal converts to numeric", {
  expect_equal(
    strVal("x=2.5", as.numeric = TRUE)[[1]],
    2.5
  )
})


test_that("strVal pastes values", {
  expect_equal(
    strVal("a1b2", paste = TRUE),
    "12"
  )
})


test_that("strVal extracts integer", {
  res <- strVal("value = 42")
  expect_equal(res[[1]], "42")
})

test_that("strVal extracts decimal", {
  res <- strVal("x = 3.14")
  expect_equal(res[[1]], "3.14")
})

test_that("strVal extracts negative number", {
  res <- strVal("temp = -7.5")
  expect_equal(res[[1]], "-7.5")
})

test_that("strVal extracts scientific notation", {
  res <- strVal("val = 1.23e-4")
  expect_equal(res[[1]], "1.23e-4")
})

test_that("strVal returns empty on no-number string", {
  res <- strVal("no numbers here")
  expect_equal(res[[1]], NA_character_)
})

test_that("strVal as.numeric=TRUE returns numeric list", {
  res <- strVal("x = 2.5 and y = 3", as.numeric = TRUE)
  expect_type(res[[1]], "double")
  expect_equal(res[[1]], c(2.5, 3))
})

test_that("strVal paste=TRUE concatenates per element", {
  x <- c("a=1 b=2", "c=3")
  res <- strVal(x, paste = TRUE)
  expect_length(res, 2)
  expect_type(res, "character")
})

test_that("strVal dec=',' handles comma decimal", {
  res <- strVal("3,14", dec = ",", as.numeric = TRUE)
  expect_equal(res[[1]], 3.14)
})

test_that("strVal vectorises over input", {
  x <- c("a=1", "b=2", "c=3")
  res <- strVal(x, as.numeric = TRUE)
  expect_length(res, 3)
  expect_equal(sapply(res, `[`, 1), c(1, 2, 3))
})

