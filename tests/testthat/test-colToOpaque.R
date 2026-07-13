

# ===========================================================================
# colToOpaque / fade
# ===========================================================================

test_that("colToOpaque against white: fully opaque input unchanged", {
  hex <- colToHex("red")
  res <- colToOpaque(hex, opacity = 1, bg = colToRGB("white"))
  expect_equal(tolower(unname(res)), tolower(hex))
})

test_that("colToOpaque against white: opacity=0 returns white", {
  hex <- colToHex("red")
  res <- colToOpaque(hex, opacity = 0, bg = colToRGB("white"))
  expect_equal(tolower(unname(res)), "#ffffff")
})

test_that("fade returns opaque hex color", {
  res <- fade("red", 0.5)
  expect_match(unname(res), "^#[0-9A-Fa-f]{6}$")
})

test_that("fade opacity=1 returns original color", {
  res <- fade("red", 1)
  expect_equal(tolower(unname(res)), tolower(colToHex("red")))
})

test_that("fade opacity=0 returns white (against white bg)", {
  res <- fade("red", 0)
  expect_equal(tolower(unname(res)), "#ffffff")
})

