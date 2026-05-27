
# tests/testthat/test-strSpell.R
  
library(testthat)


test_that("strSpell converts to NATO alphabet", {
  expect_equal(
    strSpell("AB"),
    c("CAP Alfa", "CAP Bravo")
  )
})


test_that("strSpell converts to Morse code", {
  expect_equal(
    strSpell("SOS", type = "Morse"),
    c("...", "---", "...")
  )
})

