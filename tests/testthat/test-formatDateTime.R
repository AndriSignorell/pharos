
# fm() returns a 'noquote' object, so every comparison against a plain
# character vector has to strip the class first. Comparing fm() against
# format() also has to pin the locale on both sides - format() follows
# LC_TIME, fm() follows its own lang argument.
chr <- function(x) as.character(x)


test_that("Dates are broken down in UTC, not in local time", {

  # A Date carries no time zone. Converting it to seconds and applying
  # localtime() lands on the PREVIOUS day for every negative UTC offset -
  # the entire western hemisphere. Europe never sees it, which is why it
  # survived this long.
  d <- as.Date("2019-01-01")

  for (tz in c("America/New_York", "Pacific/Auckland", "Europe/Zurich", "UTC"))
    withr::with_envvar(c(TZ = tz), {
      expect_equal(chr(fm(d, fmt = "yyyy-MM-dd")), "2019-01-01", label = tz)
    })
})


test_that("fm agrees with format() across a year of dates", {

  d <- seq(as.Date("2019-01-01"), as.Date("2019-12-31"), by = "days")

  # a purely numeric format, so the comparison does not depend on LC_TIME
  for (tz in c("UTC", "America/Los_Angeles", "Europe/Zurich", "Asia/Tokyo"))
    withr::with_envvar(c(TZ = tz), {
      expect_equal(chr(fm(d, fmt = "yyyy-MM-dd")),
                   format(d, "%Y-%m-%d"), label = tz)
    })
})


test_that("weekday and month names match format() in the same locale", {

  d <- seq(as.Date("2019-01-01"), as.Date("2019-12-31"), by = "days")

  withr::with_envvar(c(TZ = "America/Los_Angeles"), {
    withr::with_locale(c(LC_TIME = "C"), {
      expect_equal(chr(fm(d, fmt = "ddd", lang = "en")), format(d, "%a"))
      expect_equal(chr(fm(d, fmt = "MMMM", lang = "en")), format(d, "%B"))
    })
  })
})


test_that("Dates with integer storage are accepted", {

  # built explicitly: seq.Date() returns integer storage only from R 4.5.0
  x <- .Date(as.integer(as.Date("2019-01-01")) + 0:23)
  y <- as.Date("2019-01-01") + seq(0, 23)

  expect_identical(typeof(x), "integer")
  expect_identical(typeof(y), "double")

  expect_equal(chr(fm(x, fmt = "ddd")), chr(fm(y, fmt = "ddd")))
  expect_equal(chr(fm(x, fmt = "yyyy-MM-dd")), format(y, "%Y-%m-%d"))
})


test_that("midnight on a 12-hour clock is 12, not 0", {

  d <- as.Date("2019-01-01")

  # h/hh used to fall into the zero branch meant for the 24-hour tokens
  expect_equal(chr(fm(d, fmt = "hh:mm tt", lang = "en")), "12:00 AM")
  expect_equal(chr(fm(d, fmt = "h:mm tt", lang = "en")), "12:00 AM")

  # the 24-hour tokens stay at zero
  expect_equal(chr(fm(d, fmt = "HH:mm")), "00:00")
  expect_equal(chr(fm(d, fmt = "H:mm")), "0:00")

  # and a POSIXct is unaffected by the Date branch
  tt <- as.POSIXct("2019-01-01 00:30:00", tz = "UTC")
  expect_equal(chr(fm(tt, fmt = "hh:mm tt", lang = "en")), "12:30 AM")
  expect_equal(chr(fm(tt, fmt = "HH:mm")), "00:30")
})


test_that("a POSIXct is formatted in its own tzone, like format()", {

  # The invariant is agreement with base R, which is platform- and
  # session-independent - unlike an expectation written as a literal
  # clock reading, which depends on what the C runtime makes of TZ.
  inst <- as.POSIXct("2019-01-01 00:30:00", tz = "UTC")

  for (tz in c("UTC", "Europe/Zurich", "Asia/Tokyo", "America/New_York")) {

    tt <- as.POSIXct(format(inst, tz = "UTC"), tz = tz)

    expect_equal(chr(fm(tt, fmt = "yyyy-MM-dd HH:mm")),
                 format(tt, "%Y-%m-%d %H:%M"), label = tz)
  }

  # and the same instant printed in four zones gives four readings
  readings <- vapply(c("UTC", "Europe/Zurich", "Asia/Tokyo"),
                     function(tz) {
                       y <- inst
                       attr(y, "tzone") <- tz
                       chr(fm(y, fmt = "HH:mm"))
                     }, character(1L))

  expect_equal(unname(readings), c("00:30", "01:30", "09:30"))
})


test_that("changing TZ does not disturb a POSIXct that carries a tzone", {

  tt <- as.POSIXct("2019-01-01 00:30:00", tz = "UTC")

  # _tzset() on Windows cannot parse IANA names and falls back to UTC, so
  # anything that leans on the C runtime's zone is not portable. The zone
  # is resolved in R now, which makes this invariant hold everywhere.
  for (tz in c("UTC", "Europe/Zurich", "Asia/Tokyo"))
    withr::with_envvar(c(TZ = tz), {
      expect_equal(chr(fm(tt, fmt = "HH:mm")), "00:30", label = tz)
      expect_equal(chr(fm(tt, fmt = "HH:mm")), format(tt, "%H:%M"), label = tz)
    })
})


test_that(".formatDateTime() applies the time zone, its kernel does not", {

  # test-fm.R calls .formatDateTime() directly, so the entry point has to
  # keep behaving like format(). The UTC-only kernel sits behind it under
  # its own name and must NOT be called with an unshifted value.
  dt <- as.POSIXct("2024-01-15 14:07:09", tz = "Europe/Zurich")

  expect_equal(chr(.formatDateTime(dt, "HH:mm:ss")), format(dt, "%H:%M:%S"))
  expect_equal(chr(fm(dt, fmt = "HH:mm:ss")), format(dt, "%H:%M:%S"))

  # the kernel is one hour off by design here - it reads the raw instant
  expect_equal(chr(pharos:::formatDateTimeUtc_cpp(dt, "HH:mm:ss")),
               format(dt, "%H:%M:%S", tz = "UTC"))
})


test_that("a POSIXlt is accepted", {

  # .formatDateTime() reads a numeric vector; a POSIXlt is a list and
  # would have hit "cannot coerce type 'list'"
  lt <- as.POSIXlt("2019-07-01 14:45:00", tz = "Europe/Zurich")

  expect_equal(chr(fm(lt, fmt = "yyyy-MM-dd HH:mm")), "2019-07-01 14:45")
  expect_equal(chr(fm(lt, fmt = "HH:mm")), format(lt, "%H:%M"))
})


test_that("the 12-hour check still requires an AM/PM designator", {

  tt <- as.POSIXct("2019-01-01 14:30:00", tz = "UTC")

  expect_error(fm(tt, fmt = "hh:mm"), "AM/PM")
  expect_no_error(fm(tt, fmt = "hh:mm tt"))
  expect_no_error(fm(tt, fmt = "HH:mm"))
})


test_that("strict checks fire in the compiled routine regardless of length", {

  # fm() itself short-circuits on a zero-length x and never reaches the
  # C++ routine, so the check is asserted where it lives
  expect_error(pharos:::.formatDateTime(as.Date(character(0)), "yyy"), "yyyy")
  expect_error(pharos:::.formatDateTime(as.Date(character(0)), "qq"),
               "Unknown format token")
  expect_error(pharos:::.formatDateTime(as.Date(character(0)), "hh:mm"), "AM/PM")

  # and identically for a non-empty vector
  expect_error(fm(Sys.Date(), fmt = "yyy"), "yyyy")
  expect_error(fm(Sys.Date(), fmt = "qq"), "Unknown format token")
})


test_that("non-finite values become NA, not garbage", {

  d <- as.Date(c("2019-01-01", NA))
  expect_equal(chr(fm(d, fmt = "yyyy")), c("2019", NA))

  # Inf reached static_cast<time_t>() before, which is undefined behaviour
  x <- structure(c(17897, Inf, -Inf, NaN), class = "Date")
  expect_equal(chr(fm(x, fmt = "yyyy")), c("2019", NA, NA, NA))
})


test_that("the format is parsed once, not per element", {

  # not a correctness test but a floor: 1e5 elements with a 10-token
  # format used to run the 22-entry token table 1e6 times
  d <- rep(as.Date("2019-01-01"), 1e5)
  expect_lt(system.time(fm(d, fmt = "dddd, dd. MMMM yyyy"))[["elapsed"]], 5)
})
