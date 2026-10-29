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


test_that("the entries of a matrix are not padded unless asked for", {

  # REGRESSION: fm.matrix()/fm.table() padded every entry to the widest one
  # of the whole object. That width ended up in the values: tOne() wrote
  # "( 3.3%)" because a row it never showed held 96.7%. Lining up is a
  # matter of display (print(..., right = TRUE)) or of an explicit request.
  res <- unclass(fm(cor(swiss), digits = 3))

  expect_false(any(grepl("^ ", res)))
  expect_gt(length(unique(as.vector(nchar(res)))), 1L)

  # decimal points line up on request. unique() strips the attributes
  # regexpr() carries (match.length, index.type, useBytes), so compare
  # plain integers
  dec <- unclass(fm(cor(swiss), digits = 3, align = "."))
  expect_length(unique(as.integer(regexpr(".", as.vector(dec), fixed = TRUE))),
                1L)
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


test_that("NA entries survive, with and without padding", {

  m <- matrix(c(1.5, NA, -2.25, 3), nrow = 2)
  res <- unclass(fm(m, digits = 2))

  # m is filled column-wise, so the NA sits in [2, 1] - [1, 2] is -2.25
  expect_true(is.na(res[2, 1]) || res[2, 1] == "NA")
  expect_equal(dim(res), c(2L, 2L))

  # an explicit naForm replaces it, without padding
  res2 <- unclass(fm(m, digits = 2, naForm = "-"))
  expect_identical(res2[2, 1], "-")

  # with an explicit width the placeholder is padded like the rest.
  # nchar() of a matrix is a matrix, and unique() then works row-wise:
  # as.vector() first
  res3 <- unclass(fm(m, digits = 2, naForm = "-", width = 6))
  expect_equal(unique(as.vector(nchar(res3))), 6L)
})


test_that("the vector and matrix paths format identically", {

  m <- cor(swiss)

  v <- unclass(fm(as.vector(m), digits = 3))
  s <- unclass(fm(m, digits = 3))

  # identical: the matrix path no longer adds any padding
  expect_equal(as.vector(s), as.vector(v))
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
