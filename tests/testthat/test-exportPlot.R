test_that("without create, nothing is written and the plot is drawn", {
  pdf(NULL)
  on.exit(dev.off())

  n <- 0
  f <- exportPlot({ n <- n + 1; plot(1:3) },
                  file.path(tempdir(), "xp-none"), create = FALSE)

  expect_identical(f, character(0))
  expect_equal(n, 1)
  expect_false(file.exists(file.path(tempdir(), "xp-none.png")))
})

test_that("files are written per type, extension is stripped", {
  base <- file.path(tempdir(), "xp-types")
  on.exit(unlink(paste0(base, c(".png", ".tif", ".pdf"))))

  f <- exportPlot(plot(1:3), paste0(base, ".png"),
                  type = c("png", "tif", "pdf"),
                  create = TRUE, screen = FALSE)

  expect_identical(f, paste0(base, c(".png", ".tif", ".pdf")))
  expect_true(all(file.exists(f)))
  expect_true(all(file.size(f) > 0))
})

test_that("the option switches file creation", {
  base <- file.path(tempdir(), "xp-opt")
  on.exit(unlink(paste0(base, ".png")))

  withr::local_options(pharos.exportPlot = TRUE)
  f <- exportPlot(plot(1:3), base, screen = FALSE)

  expect_true(file.exists(f))
})

test_that("works with the native pipe", {
  base <- file.path(tempdir(), "xp-pipe")
  on.exit(unlink(paste0(base, ".pdf")))

  f <- plot(1:3) |>
    exportPlot(base, type = "pdf", create = TRUE, screen = FALSE)

  expect_true(file.exists(f))
})

test_that("every device sees the same random numbers", {
  pdf(NULL)
  on.exit(dev.off())
  base <- file.path(tempdir(), "xp-rng")
  on.exit(unlink(paste0(base, c(".png", ".pdf"))), add = TRUE)

  set.seed(1)
  vals <- numeric(0)
  exportPlot({ vals <- c(vals, runif(1)); plot(1) }, base,
             type = c("png", "pdf"), create = TRUE, screen = TRUE)
  after <- runif(1)

  set.seed(1)
  ref <- runif(1)
  refAfter <- runif(1)

  expect_length(vals, 3)
  expect_true(all(vals == ref))
  # state after the call equals that of a single evaluation
  expect_identical(after, refAfter)
})

test_that("the current device is restored, also on error", {
  pdf(NULL)
  pdf(NULL)
  on.exit(graphics.off())
  dev.set(dev.prev())
  cur  <- dev.cur()
  devs <- dev.list()

  base <- file.path(tempdir(), "xp-dev")
  on.exit(unlink(paste0(base, c(".png", ".pdf"))), add = TRUE)

  exportPlot(plot(1:3), base, type = c("png", "pdf"),
             create = TRUE, screen = FALSE)
  expect_identical(dev.cur(), cur)
  expect_identical(dev.list(), devs)

  expect_error(
    exportPlot(stop("boom"), base, type = "png",
               create = TRUE, screen = FALSE),
    "boom")
  expect_identical(dev.cur(), cur)
  expect_identical(dev.list(), devs)
})

test_that("the export device is closed by number if expr opens another one", {
  pdf(NULL)
  on.exit(graphics.off())
  cur <- dev.cur()

  base <- file.path(tempdir(), "xp-newdev")
  on.exit(unlink(paste0(base, ".png")), add = TRUE)

  # expr opens a device and leaves it current
  f <- exportPlot({ plot(1:3); pdf(NULL) }, base, type = "png",
                  create = TRUE, screen = FALSE)

  expect_true(file.size(f) > 0)
  expect_identical(dev.cur(), cur)
  # the device opened by expr survives, the export device is gone
  expect_length(dev.list(), 2L)
})

test_that("a previous device closed by expr is not reactivated", {
  pdf(NULL)
  on.exit(graphics.off())
  p <- dev.cur()

  base <- file.path(tempdir(), "xp-closed")
  on.exit(unlink(paste0(base, ".png")), add = TRUE)

  expect_no_error(
    exportPlot({ plot(1:3); dev.off(p) }, base, type = "png",
               create = TRUE, screen = FALSE))
  expect_false(p %in% dev.list())
})

test_that("a grob is drawn, not printed", {
  drawn <- 0
  registerS3method("drawDetails", "xpRecGrob",
                   function(x, recording) drawn <<- drawn + 1,
                   envir = asNamespace("grid"))
  g <- grid::grob(cl = "xpRecGrob")

  base <- file.path(tempdir(), "xp-grob")
  on.exit(unlink(paste0(base, ".png")))

  f <- exportPlot(g, base, type = "png", create = TRUE, screen = FALSE)

  expect_equal(drawn, 1)
  expect_true(file.size(f) > 0)

  # drawn by the call and returned invisibly: not drawn a second time
  drawn <- 0
  drawAndReturn <- function(g) {
    grid::grid.newpage()
    grid::grid.draw(g)
    invisible(g)
  }
  exportPlot(drawAndReturn(g), base, type = "png",
             create = TRUE, screen = FALSE)
  expect_equal(drawn, 1)
})

test_that("an object drawn by the call yields one PDF page", {
  base <- file.path(tempdir(), "xp-pages")
  on.exit(unlink(paste0(base, ".pdf")))

  g <- grid::rectGrob()
  drawAndReturn <- function(g) {
    grid::grid.newpage()
    grid::grid.draw(g)
    invisible(g)
  }
  f <- exportPlot(drawAndReturn(g), base, type = "pdf",
                  create = TRUE, screen = FALSE)

  # count page objects in the uncompressed PDF structure
  txt <- readLines(f, warn = FALSE, encoding = "latin1")
  expect_equal(sum(grepl("/Type /Page\\b", txt, useBytes = TRUE)), 1L)
})

test_that("a device that fails to open is an error, the caller's is kept", {
  pdf(NULL)
  on.exit(graphics.off())
  cur  <- dev.cur()
  devs <- dev.list()

  # the svg() failure on macOS: a warning, but no device
  failing <- function() warning("unable to load the cairo module")
  expect_error(.openDevice(failing, "svg device for 'x.svg'"),
               "could not open a svg device.*cairo module")
  expect_identical(dev.cur(), cur)
  expect_identical(dev.list(), devs)

  # a device that opens is returned by number, its warnings passed on
  noisy <- function() { warning("just a note"); pdf(NULL) }
  expect_warning(d <- .openDevice(noisy, "pdf device"), "just a note")
  expect_identical(unname(d), unname(dev.cur()))
  dev.off(d)
})

# capabilities("cairo") is TRUE on macOS without XQuartz, but svg() cannot
# open a device there; probe the device itself
svgUsable <- function() {
  before <- dev.list()
  suppressWarnings(try(svg(tempfile(fileext = ".svg")), silent = TRUE))
  opened <- setdiff(dev.list(), before)
  if (length(opened))
    dev.off(opened)
  length(opened) == 1L
}

test_that("svg is written where a cairo device can be opened", {
  skip_if_not(svgUsable(), "no usable cairo svg device")
  base <- file.path(tempdir(), "xp-svg")
  on.exit(unlink(paste0(base, ".svg")))

  f <- exportPlot(plot(1:3), base, type = "svg",
                  create = TRUE, screen = FALSE)
  expect_true(file.exists(f))
})

test_that("invalid arguments are refused", {
  expect_error(exportPlot(plot(1), create = TRUE, screen = FALSE), "file")
  expect_error(exportPlot(plot(1), "x", type = "jpg", create = TRUE), "type")
  expect_error(exportPlot(plot(1), "x", width = -1, create = TRUE), "width")
  expect_error(exportPlot(plot(1), "x", height = NA, create = TRUE), "height")
  expect_error(exportPlot(plot(1), "x", res = 0, create = TRUE), "res")
  expect_error(exportPlot(plot(1), "x", width = Inf, create = TRUE), "width")
  expect_error(exportPlot(plot(1), "x", res = Inf, create = TRUE), "res")
  expect_error(exportPlot(plot(1), "x", width = 1:2, create = TRUE), "width")
  expect_error(exportPlot(plot(1), "x", create = NA), "create")
  expect_error(exportPlot(plot(1), "x", screen = "yes"), "screen")
})

test_that("arguments are checked before anything is drawn", {
  n <- 0
  expect_error(exportPlot({ n <- n + 1; plot(1) }, "x", width = -1))
  expect_equal(n, 0)
})
