test_that("fm() on a matrix prints without quotes", {

  # REGRESSION: fm.default() returns noquote(), but fm.matrix() rebuilt the
  # result with matrix(), which drops the class - so fm(m) printed with
  # quotation marks while fm(as.vector(m)) did not
  m <- cor(swiss)
  res <- fm(m, digits = 3)

  expect_s3_class(res, "noquote")
  expect_true(is.matrix(unclass(res)))
  expect_equal(dim(unclass(res)), dim(m))
  expect_equal(dimnames(unclass(res)), dimnames(m))

  # the printed form carries no quotation marks
  out <- capture.output(print(res))
  expect_false(any(grepl('"', out, fixed = TRUE)))
})


test_that("the entries of a matrix are padded to one common width", {

  # a character matrix prints LEFT justified, so without padding every
  # negative entry shifts one place against the positive ones
  res <- unclass(fm(cor(swiss), digits = 3))

  w <- nchar(res)
  expect_equal(length(unique(as.vector(w))), 1L)

  # the padding is on the left, so the decimal points line up.
  # unique() strips the attributes regexpr() carries (match.length,
  # index.type, useBytes), so compare plain integers
  expect_true(all(grepl("^ *-?[0-9]", as.vector(res))))
  expect_equal(unique(as.integer(regexpr(".", as.vector(res), fixed = TRUE))),
               as.integer(regexpr(".", res[1, 1], fixed = TRUE)))
})


test_that("an explicit width still wins", {

  res <- unclass(fm(cor(swiss), digits = 3, width = 12))
  expect_true(all(nchar(res) == 12))

  # and align is honoured rather than overridden by the padding
  left <- unclass(fm(cor(swiss), digits = 3, align = "\\l"))
  expect_length(unique(as.vector(nchar(left))), 1L)
  expect_false(any(grepl("^ ", left)))
  
})


test_that("a table keeps its class and prints unquoted", {

  tab <- table(swiss$Fertility > 70, swiss$Education > 10)
  res <- fm(tab)

  expect_s3_class(res, "table")
  expect_equal(dim(res), dim(tab))

  out <- capture.output(print(res))
  expect_false(any(grepl('"', out, fixed = TRUE)))
})


test_that("NA entries survive the padding", {

  m <- matrix(c(1.5, NA, -2.25, 3), nrow = 2)
  res <- unclass(fm(m, digits = 2))

  # m is filled column-wise, so the NA sits in [2, 1] - [1, 2] is -2.25
  expect_true(is.na(res[2, 1]) || res[2, 1] == "NA")
  expect_equal(dim(res), c(2L, 2L))

  # with an explicit naForm the placeholder is padded like the rest
  res2 <- unclass(fm(m, digits = 2, naForm = "-"))
  # nchar() of a matrix is a matrix, and unique() then works row-wise:
  # as.vector() first, as in the padding test above
  expect_equal(length(unique(as.vector(nchar(res2)))), 1L)
})


test_that("the vector and matrix paths format identically", {

  m <- cor(swiss)

  v <- unclass(fm(as.vector(m), digits = 3))
  s <- unclass(fm(m, digits = 3))

  # same content, up to the padding the matrix path adds
  expect_equal(trimws(as.vector(s)), trimws(v))
})


test_that("a named Style reaches the matrix and table methods", {

  # REGRESSION: the methods for matrix, table and ftable pass every formal
  # on by name, NULL included. match.call() reported all of them as
  # supplied, and assigning NULL deletes a list element - so the Style was
  # wiped clean on its way through. fm(pi, fmt = "num.sty") honoured
  # digits = 3, fm(cor(swiss), fmt = "num.sty") silently did not.
  sty <- style(digits = 3, bigMark = "'")

  m <- cor(swiss)

  expect_equal(trimws(as.vector(unclass(fm(m, fmt = sty)))),
               trimws(as.vector(unclass(fm(m, digits = 3)))))

  # the whole Style arrives, not only digits
  big <- matrix(c(1234567.891, 22.5, -333.25, 4), nrow = 2)
  expect_true(any(grepl("'", unclass(fm(big, fmt = sty)), fixed = TRUE)))

  # and the same for a table
  tab <- table(swiss$Fertility > 70, swiss$Education > 10)
  expect_equal(trimws(as.vector(unclass(fm(tab, fmt = sty)))),
               trimws(as.vector(unclass(fm(tab, digits = 3)))))

  # the vector path was never broken - it stays the reference
  expect_equal(unclass(fm(pi, fmt = sty)), unclass(fm(pi, digits = 3)))
})


test_that("an explicit argument still overrides the Style", {

  sty <- style(digits = 3, bigMark = "'")
  m   <- cor(swiss)

  expect_equal(trimws(as.vector(unclass(fm(m, fmt = sty, digits = 5)))),
               trimws(as.vector(unclass(fm(m, digits = 5)))))

  # ... on the vector path too
  expect_equal(unclass(fm(pi, fmt = sty, digits = 5)),
               unclass(fm(pi, digits = 5)))
})
