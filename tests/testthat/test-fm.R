
# =============================================================================
# Tests for fm(), formatNum(), formatDateTime()
# =============================================================================
# Run with: testthat::test_file("test-fm.R")
# or place in tests/testthat/ and run: devtools::test()
# =============================================================================

library(testthat)

# Assumes the package is loaded, e.g. via:
# devtools::load_all()  or  library(DescTools)


# =============================================================================
# formatNum() – low-level C++ number formatter
# =============================================================================

test_that("formatNum: basic fixed-decimal formatting", {
  # Default leadDigits = 0: leading zero before decimal point is stripped
  expect_equal(formatNum(3.14159, digits = 2L),  "3.14")  # integer part > 0, no stripping
  expect_equal(formatNum(0.14159, digits = 2L),  ".14")   # leadDigits=0 strips leading "0"
  expect_equal(formatNum(3.14159, digits = 2L, leadDigits = 1L), "3.14")
  expect_equal(formatNum(0.5,     digits = 1L, leadDigits = 1L), "0.5")
  expect_equal(formatNum(100,     digits = 0L, leadDigits = 1L), "100")
})

test_that("formatNum: zero value", {
  expect_equal(formatNum(0, digits = 2L, leadDigits = 1L), "0.00")
  expect_equal(formatNum(0, digits = 0L, leadDigits = 1L), "0")
})

test_that("formatNum: negative values", {
  expect_equal(formatNum(-3.14, digits = 2L, leadDigits = 1L), "-3.14")
  expect_equal(formatNum(-0.5,  digits = 1L, leadDigits = 1L), "-0.5")
})

test_that("formatNum: NA propagation", {
  res <- formatNum(c(1.0, NA_real_, 3.0), digits = 1L, leadDigits = 1L)
  expect_true(is.na(res[2]))
  expect_equal(res[1], "1.0")
  expect_equal(res[3], "3.0")
})

test_that("formatNum: vectorised digits", {
  res <- formatNum(c(1.5, 2.567), digits = c(1L, 2L), leadDigits = 1L)
  expect_equal(res[1], "1.5")
  expect_equal(res[2], "2.57")
})

test_that("formatNum: bigMark inserts thousands separator", {
  res <- formatNum(1234567, digits = 0L, leadDigits = 1L, bigMark = ",")
  expect_equal(res, "1,234,567")
})

test_that("formatNum: decimalMark substitution", {
  res <- formatNum(3.14, digits = 2L, leadDigits = 1L, decimalMark = ",")
  expect_equal(res, "3,14")
})

test_that("formatNum: scientific notation triggered by sciBig", {
  res <- formatNum(1e10, digits = 2L, leadDigits = 1L, sciBig = 9L)
  expect_match(res, "e|E")
})

test_that("formatNum: no scientific notation when below threshold", {
  res <- formatNum(1234, digits = 0L, leadDigits = 1L, sciBig = 9999L, sciSmall = -9999L)
  expect_false(grepl("e|E", res, ignore.case = TRUE))
})

test_that("formatNum: negative digits round to power of ten", {
  # digits = -2 should round 1234 to 1200
  res <- formatNum(1234, digits = -2L, leadDigits = 1L)
  expect_equal(res, "1200")
  res2 <- formatNum(1250, digits = -2L, leadDigits = 1L)
  expect_equal(res2, "1300")  # round half up
})

test_that("formatNum: leadDigits pads with leading zeros", {
  res <- formatNum(5, digits = 0L, leadDigits = 3L)
  expect_equal(res, "005")
})

test_that("formatNum: leadDigits = 0 strips leading zero before decimal", {
  res <- formatNum(0.75, digits = 2L, leadDigits = 0L)
  expect_equal(res, ".75")
})

test_that("formatNum: vector recycling of bigMark and decimalMark", {
  res <- formatNum(c(1000, 2000), digits = 0L, leadDigits = 1L, bigMark = ".")
  expect_equal(res, c("1.000", "2.000"))
})


# =============================================================================
# formatDateTime() – low-level C++ date/time formatter
# =============================================================================

d1 <- as.Date("2024-03-05")    # Tuesday, 5 March 2024
d2 <- as.Date("2024-11-28")   # Thursday, 28 November 2024
d_jan1 <- as.Date("2024-01-01")

test_that("formatDateTime: basic date tokens dd/MM/yyyy", {
  expect_equal(formatDateTime(d1, "dd/MM/yyyy"), "05/03/2024")
})

test_that("formatDateTime: single-digit tokens d/M/yyyy", {
  expect_equal(formatDateTime(d1, "d/M/yyyy"), "5/3/2024")
})

test_that("formatDateTime: abbreviated weekday (C locale)", {
  res <- formatDateTime(d1, "ddd", locale = "C")
  expect_match(res, "^[A-Z][a-z]{2}$")  # e.g. "Tue"
})

test_that("formatDateTime: full weekday (C locale)", {
  res <- formatDateTime(d1, "dddd", locale = "C")
  expect_match(res, "^[A-Z][a-z]+$")    # e.g. "Tuesday"
  expect_true(nchar(res) > 3)
})

test_that("formatDateTime: abbreviated month name (C locale)", {
  res <- formatDateTime(d1, "MMM", locale = "C")
  expect_match(res, "^[A-Z][a-z]{2}$")   # "Mar"
  expect_equal(res, "Mar")
})

test_that("formatDateTime: full month name (C locale)", {
  res <- formatDateTime(d1, "MMMM", locale = "C")
  expect_equal(res, "March")
})

test_that("formatDateTime: yyyy returns 4-digit year", {
  expect_equal(formatDateTime(d1, "yyyy"), "2024")
})

test_that("formatDateTime: yy returns 2-digit year with leading zero", {
  d_old <- as.Date("2004-06-01")
  expect_equal(formatDateTime(d_old, "yy"), "04")
})

test_that("formatDateTime: y returns 2-digit year without leading zero", {
  d_old <- as.Date("2004-06-01")
  expect_equal(formatDateTime(d_old, "y"), "4")
  expect_equal(formatDateTime(d1, "y"), "24")
})

test_that("formatDateTime: ordinal suffix 'do'", {
  # Pass locale = "C" (English) to suppress the non-English locale warning
  expect_equal(formatDateTime(as.Date("2024-01-01"), "do", locale = "C"), "1st")
  expect_equal(formatDateTime(as.Date("2024-01-02"), "do", locale = "C"), "2nd")
  expect_equal(formatDateTime(as.Date("2024-01-03"), "do", locale = "C"), "3rd")
  expect_equal(formatDateTime(as.Date("2024-01-04"), "do", locale = "C"), "4th")
  expect_equal(formatDateTime(as.Date("2024-01-11"), "do", locale = "C"), "11th")
  expect_equal(formatDateTime(as.Date("2024-01-12"), "do", locale = "C"), "12th")
  expect_equal(formatDateTime(as.Date("2024-01-13"), "do", locale = "C"), "13th")
  expect_equal(formatDateTime(as.Date("2024-01-21"), "do", locale = "C"), "21st")
  expect_equal(formatDateTime(as.Date("2024-01-22"), "do", locale = "C"), "22nd")
})

test_that("formatDateTime: time tokens on a Date return zeros", {
  expect_equal(formatDateTime(d1, "HH:mm:ss"), "00:00:00")
  expect_equal(formatDateTime(d1, "H:m:s"),    "0:0:0")
})

test_that("formatDateTime: NA propagation", {
  res <- formatDateTime(c(d1, NA, d2), "dd.MM.yyyy")
  expect_equal(res[1], "05.03.2024")
  expect_true(is.na(res[2]))
  expect_equal(res[3], "28.11.2024")
})

test_that("formatDateTime: vector input returns correct length", {
  dates <- as.Date(c("2024-01-01", "2024-06-15", "2024-12-31"))
  res <- formatDateTime(dates, "yyyy-MM-dd")
  expect_length(res, 3)
  expect_equal(res[1], "2024-01-01")
  expect_equal(res[3], "2024-12-31")
})

test_that("formatDateTime: literal characters pass through", {
  res <- formatDateTime(d1, "dd. MM. yyyy")
  expect_equal(res, "05. 03. 2024")
})

test_that("formatDateTime: strict=TRUE rejects 'yyy'", {
  expect_error(formatDateTime(d1, "yyy"), regex = "yyy|yyyy")
})

test_that("formatDateTime: strict=TRUE rejects unknown alpha token", {
  expect_error(formatDateTime(d1, "dd/MM/yyyy Z"), regex = "Unknown|token")
})

test_that("formatDateTime: strict=TRUE requires t with 12h format", {
  expect_error(formatDateTime(
    as.POSIXct("2024-03-05 14:30:00"),
    "hh:mm"
  ), regex = "AM/PM|12-hour|tt")
})

test_that("formatDateTime: POSIXct HH:mm:ss", {
  # Use local time (no tz="UTC") so formatDateTime's localtime_r matches
  dt <- as.POSIXct("2024-03-05 14:07:09")
  expect_equal(formatDateTime(dt, "HH:mm:ss"),
               format(dt, "%H:%M:%S"))
})

test_that("formatDateTime: POSIXct single-digit H:m:s strips leading zero", {
  dt <- as.POSIXct("2024-03-05 03:05:09")
  expected <- paste(
    as.integer(format(dt, "%H")),
    as.integer(format(dt, "%M")),
    as.integer(format(dt, "%S")),
    sep = ":"
  )
  expect_equal(formatDateTime(dt, "H:m:s"), expected)
})


# =============================================================================
# fm() – high-level wrapper: numeric formatting
# =============================================================================

test_that("fm: basic numeric, fixed digits", {
  expect_equal(as.character(fm(3.14159, digits = 2)), "3.14")
  # fm default leadDigits = 1, so leading zero is kept:
  expect_equal(as.character(fm(0.1, digits = 3, leadDigits = 1)), "0.100")
  expect_equal(as.character(fm(0.1, digits = 3, leadDigits = 0)), ".100")
})

test_that("fm: digits = 0 produces integer-like output", {
  expect_equal(as.character(fm(3.7, digits = 0)), "4")
  expect_equal(as.character(fm(3.2, digits = 0)), "3")
})

test_that("fm: negative digits round to power of ten", {
  expect_equal(as.character(fm(1234, digits = -2)), "1200")
})

test_that("fm: bigMark inserts thousand separator", {
  expect_equal(as.character(fm(1234567, digits = 0, bigMark = ",")), "1,234,567")
})

test_that("fm: decMark changes decimal separator", {
  expect_equal(as.character(fm(3.14, digits = 2, decMark = ",")), "3,14")
})

test_that("fm: leadDigits = 0 strips leading zero", {
  expect_equal(as.character(fm(0.75, digits = 2, leadDigits = 0)), ".75")
})

test_that("fm: leadDigits = 3 pads with leading zeros", {
  expect_equal(as.character(fm(5, digits = 0, leadDigits = 3)), "005")
})

test_that("fm: NA replacement via naForm", {
  res <- as.character(fm(c(1.5, NA, 3.5), digits = 1, naForm = "n.a."))
  expect_equal(res[2], "n.a.")
})

test_that("fm: NA without naForm stays NA", {
  res <- as.character(fm(c(1, NA), digits = 1))
  expect_true(is.na(res[2]))
})

test_that("fm: zeroForm replaces zeros", {
  res <- as.character(fm(c(0, 1.5, 0), digits = 1, zeroForm = "-"))
  expect_equal(res[1], "-")
  expect_equal(res[3], "-")
  expect_equal(res[2], "1.5")
})

test_that("fm: fmt = '%' multiplies by 100 and appends %", {
  res <- as.character(fm(0.1234, digits = 1, fmt = "%"))
  expect_equal(res, "12.3%")
  res2 <- as.character(fm(1, digits = 0, fmt = "%"))
  expect_equal(res2, "100%")
})

test_that("fm: fmt = 'e' forces scientific notation", {
  res <- as.character(fm(0.000314159, fmt = "e", digits = 2))
  expect_match(res, "[eE]")
})

test_that("fm: fmt = '*' returns significance stars", {
  expect_equal(as.character(fm(0.0005, fmt = "*")), "***")
  expect_equal(as.character(fm(0.005,  fmt = "*")), "** ")
  expect_equal(as.character(fm(0.03,   fmt = "*")), "*  ")
  expect_equal(as.character(fm(0.08,   fmt = "*")), ".  ")
  expect_equal(as.character(fm(0.5,    fmt = "*")), "   ")
})

test_that("fm: fmt = 'p' formats p-values", {
  res <- as.character(fm(0.0001, fmt = "p"))
  expect_match(res, "^< ")           # "< 0.001"
  res2 <- as.character(fm(0.032, fmt = "p"))
  expect_match(res2, "^0\\.0[0-9]+") # "0.032"
})

test_that("fm: fmt = 'p*' returns p-value and stars together", {
  res <- as.character(fm(0.03, fmt = "p*"))
  expect_match(res, "\\*")   # contains at least one star
  expect_match(res, "0\\.")  # contains a decimal number
})

test_that("fm: fmt = 'frac' converts to fraction", {
  res <- as.character(fm(0.1, fmt = "frac"))
  expect_equal(res, "1/10")
  res2 <- as.character(fm(0.5, fmt = "frac"))
  expect_equal(res2, "1/2")
})

test_that("fm: fmt = 'eng' produces engineering notation", {
  res <- as.character(fm(12345, fmt = "eng", digits = 2))
  expect_match(res, "e[+-][0-9]+")
  expect_match(res, "^1[0-9\\.]+")   # mantissa 10 <= x < 1000
})

test_that("fm: fmt = 'engabb' uses SI prefix", {
  res <- as.character(fm(1e6, fmt = "engabb", digits = 1))
  expect_match(res, "M")   # mega
  res2 <- as.character(fm(1e3, fmt = "engabb", digits = 1))
  expect_match(res2, "k")  # kilo
})

test_that("fm: sci threshold triggers scientific notation", {
  res_big <- as.character(fm(10000, sci = 3, digits = 2))
  expect_match(res_big, "[eE]")
  res_small <- as.character(fm(500, sci = 4, digits = 0))
  expect_false(grepl("[eE]", res_small))
})

test_that("fm: vector input returns same-length character vector", {
  x <- c(1, 10, 100, 1000)
  res <- as.character(fm(x, digits = 1))
  expect_length(res, 4)
  expect_type(res, "character")
})

test_that("fm: preserves names", {
  x <- c(a = 1.1, b = 2.2)
  res <- fm(x, digits = 1)
  expect_equal(names(res), c("a", "b"))
})

test_that("fm: list input raises error", {
  expect_error(fm(list(1, 2, 3)), "atomic vector")
})

test_that("fm: factor input is coerced to character without error", {
  f <- factor(c("a", "b", "a"))
  expect_no_error(fm(f))
})


# =============================================================================
# fm() – high-level wrapper: date formatting
# =============================================================================

test_that("fm: Date with fmt string, English locale", {
  d <- as.Date("2026-01-21")
  res <- as.character(fm(d, fmt = "MMMM do yyyy", lang = "en"))
  expect_equal(res, "January 21st 2026")
})

test_that("fm: Date with dd/MM/yyyy", {
  d <- as.Date("2024-03-05")
  res <- as.character(fm(d, fmt = "dd/MM/yyyy"))
  expect_equal(res, "05/03/2024")
})

test_that("fm: Date vector", {
  dates <- as.Date(c("2024-01-01", "2024-12-31"))
  res <- as.character(fm(dates, fmt = "dd.MM.yyyy"))
  expect_equal(res[1], "01.01.2024")
  expect_equal(res[2], "31.12.2024")
})

test_that("fm: Date NA propagation", {
  dates <- as.Date(c("2024-01-01", NA))
  res <- as.character(fm(dates, fmt = "dd.MM.yyyy"))
  expect_true(is.na(res[2]))
})

test_that("fm: POSIXct time formatting", {
  # Use local time to match formatDateTime's localtime_r behaviour
  dt <- as.POSIXct("2024-06-15 09:05:03")
  res <- as.character(fm(dt, fmt = "yyyy-MM-dd HH:mm:ss"))
  expected <- paste0(
    format(dt, "%Y-%m-%d"),
    " ",
    format(dt, "%H:%M:%S")
  )
  expect_equal(res, expected)
})


# =============================================================================
# fm() – matrix method
# =============================================================================

test_that("fm.matrix: returns matrix with correct dimensions", {
  m <- matrix(c(1.1, 2.22, 3.333, 4.4444), nrow = 2)
  res <- fm(m, digits = 2)
  expect_true(is.matrix(res))
  expect_equal(dim(res), c(2, 2))
})

test_that("fm.matrix: values are formatted", {
  m <- matrix(c(1.5, 2.5), nrow = 1)
  res <- fm(m, digits = 1)
  expect_equal(res[1, 1], "1.5")
  expect_equal(res[1, 2], "2.5")
})

test_that("fm.matrix: dimnames are preserved", {
  m <- matrix(1:4, nrow = 2,
              dimnames = list(c("r1","r2"), c("c1","c2")))
  res <- fm(m * 1.0, digits = 0)
  expect_equal(rownames(res), c("r1","r2"))
  expect_equal(colnames(res), c("c1","c2"))
})


# =============================================================================
# fm() – data.frame method
# =============================================================================

test_that("fm.data.frame: returns data.frame", {
  df <- data.frame(a = c(1.1, 2.2), b = c(100.5, 200.7))
  res <- fm(df, digits = 1)
  expect_s3_class(res, "data.frame")
})

test_that("fm.data.frame: formats each column", {
  df <- data.frame(a = c(1.123, 2.456), b = c(10.001, 20.009))
  res <- fm(df, digits = 2)
  expect_equal(as.character(res$a[1]), "1.12")
  expect_equal(as.character(res$b[1]), "10.00")
})

test_that("fm.data.frame: per-column digits via recycling", {
  df <- data.frame(a = c(1.111), b = c(2.222))
  res <- fm(df, digits = c(1L, 2L))
  expect_equal(as.character(res$a), "1.1")
  expect_equal(as.character(res$b), "2.22")
})


# =============================================================================
# fm() – table method
# =============================================================================

test_that("fm.table: formats table values", {
  tbl <- table(c("a","b","a","a","b"))
  res <- fm(tbl, digits = 0)
  expect_s3_class(res, "table")
})


# =============================================================================
# Edge cases and robustness
# =============================================================================

test_that("fm: Inf and -Inf handled without crash", {
  expect_no_error(fm(Inf,  digits = 2))
  expect_no_error(fm(-Inf, digits = 2))
})

test_that("fm: very small number near zero", {
  res <- as.character(fm(1e-15, fmt = "e", digits = 2))
  expect_match(res, "[eE]")
})

test_that("fm: very large number", {
  res <- as.character(fm(1e15, digits = 0, sci = 20))
  expect_false(grepl("[eE]", res))
  expect_match(res, "^1")
})

test_that("fm: single element vector still returns character", {
  expect_type(as.character(fm(42, digits = 1)), "character")
})

test_that("fm: empty numeric vector returns zero-length character", {
  res <- fm(numeric(0), digits = 2)
  expect_length(res, 0)
  expect_true(inherits(res, "character"))
})

test_that("fm: non-interpretable fmt raises warning, not error", {
  expect_warning(fm(1.5, fmt = "INVALID_XYZ"), "fmt")
})

