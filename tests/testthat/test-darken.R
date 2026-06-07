
# ===========================================================================
# Color manipulation: darken / lighten
# ===========================================================================

test_that("darken amount=0 leaves color unchanged", {
  col <- "#FF8000"
  expect_equal(darken(col, 0), col)
})

test_that("darken amount=1 returns black", {
  expect_equal(darken("red", 1), "#000000")
  expect_equal(darken("white", 1), "#000000")
})

test_that("darken reduces RGB values", {
  orig <- col2rgb("red")       # 255, 0, 0
  dark <- col2rgb(darken("red", 0.5))
  expect_true(all(dark <= orig))
})

test_that("lighten amount=0 leaves color unchanged", {
  col <- "#FF8000"
  expect_equal(lighten(col, 0), col)
})

test_that("lighten amount=1 returns white", {
  expect_equal(lighten("black", 1), "#FFFFFF")
  expect_equal(lighten("red", 1), "#FFFFFF")
})

test_that("lighten increases RGB values", {
  orig <- col2rgb("blue")     # 0, 0, 255
  light <- col2rgb(lighten("blue", 0.5))
  expect_true(all(light >= orig))
})

test_that("darken and lighten are not inverses (non-symmetric by design)", {
  # darken then lighten does NOT recover original - that's expected
  col <- "#804000"
  result <- lighten(darken(col, 0.5), 0.5)
  expect_false(result == col)
})

