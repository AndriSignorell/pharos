

test_that("pharos does not load without DescToolsX", {
  expect_error(
    library(pharos),
    NA
  )
})

test_that("the default styles are registered on load", {
  sty <- c("abs.sty", "num.sty", "per.sty", "pval.sty")

  expect_true(all(sty %in% names(styles())))
  expect_true(all(vapply(options()[sty], inherits, logical(1L), what = "Style")))

  # they can be used by name
  expect_equal(as.character(fm(0.1234, fmt = "per.sty")), "12.3%")
  expect_equal(as.character(fm(1234.4, fmt = "abs.sty")), "1234")
})

test_that("loading does not overwrite styles the user has defined", {
  old <- options(abs.sty = style(digits = 2))
  on.exit(options(old), add = TRUE)

  pharos:::.onLoad(NULL, "pharos")

  expect_equal(as.character(fm(1, fmt = "abs.sty")), "1.00")
})
