# Close only devices opened by the current test and restore the initial one.
.localExportDevices <- function(envir = parent.frame()) {
  before <- dev.list()
  current <- dev.cur()
  withr::defer({
    for (id in setdiff(dev.list(), before)) {
      if (id %in% dev.list())
        dev.off(id)
    }
    if (current > 1L && current %in% dev.list())
      dev.set(current)
  }, envir = envir)
  invisible(before)
}

test_that("without create, nothing is written and the plot is drawn", {
  .localExportDevices()
  pdf(NULL)

  base <- tempfile("xp-none-")
  n <- 0
  f <- exportPlot({ n <- n + 1; plot(1:3) },
                  base, create = FALSE)

  expect_identical(f, character(0))
  expect_equal(n, 1)
  expect_false(file.exists(paste0(base, ".png")))
})

test_that("files are written per type, extension is stripped", {
  base <- tempfile("xp-types-")
  withr::defer(unlink(paste0(base, c(".png", ".tif", ".pdf"))))

  f <- exportPlot(plot(1:3), paste0(base, ".png"),
                  type = c("png", "tif", "pdf"),
                  create = TRUE, screen = FALSE)

  expect_identical(f, paste0(base, c(".png", ".tif", ".pdf")))
  expect_true(all(file.exists(f)))
  expect_true(all(file.size(f) > 0))
})

test_that("the option switches file creation", {
  base <- tempfile("xp-opt-")
  withr::defer(unlink(paste0(base, ".png")))

  withr::local_options(pharos.exportPlot = TRUE)
  f <- exportPlot(plot(1:3), base, screen = FALSE)

  expect_true(file.exists(f))
})

test_that("works with the native pipe", {
  base <- tempfile("xp-pipe-")
  withr::defer(unlink(paste0(base, ".pdf")))

  f <- plot(1:3) |>
    exportPlot(base, type = "pdf", create = TRUE, screen = FALSE)

  expect_true(file.exists(f))
})

test_that("every device sees the same random numbers", {
  .localExportDevices()
  pdf(NULL)
  base <- tempfile("xp-rng-")
  withr::defer(unlink(paste0(base, c(".png", ".pdf"))))

  withr::local_seed(1)
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
  .localExportDevices()
  pdf(NULL)
  pdf(NULL)
  dev.set(dev.prev())
  cur  <- dev.cur()
  devs <- dev.list()

  base <- tempfile("xp-dev-")
  withr::defer(unlink(paste0(base, c(".png", ".pdf"))))

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
  before <- .localExportDevices()
  pdf(NULL)
  cur <- dev.cur()

  base <- tempfile("xp-newdev-")
  withr::defer(unlink(paste0(base, ".png")))

  # expr opens a device and leaves it current
  f <- exportPlot({ plot(1:3); pdf(NULL) }, base, type = "png",
                  create = TRUE, screen = FALSE)

  expect_true(file.size(f) > 0)
  expect_identical(dev.cur(), cur)
  # the device opened by expr survives, the export device is gone
  expect_length(setdiff(dev.list(), before), 2L)
})

test_that("a previous device closed by expr is not reactivated", {
  .localExportDevices()
  pdf(NULL)
  p <- dev.cur()

  base <- tempfile("xp-closed-")
  withr::defer(unlink(paste0(base, ".png")))

  expect_no_error(
    exportPlot({ plot(1:3); dev.off(p) }, base, type = "png",
               create = TRUE, screen = FALSE))
  expect_false(p %in% dev.list())
})

test_that("a grob is drawn, not printed", {
  drawn <- 0
  # Restore the method table, including any pre-existing registration.
  methods <- get(".__S3MethodsTable__.", envir = asNamespace("grid"))
  key <- "drawDetails.xpRecGrob"
  hadMethod <- exists(key, envir = methods, inherits = FALSE)
  oldMethod <- if (hadMethod) get(key, envir = methods, inherits = FALSE)
  withr::defer({
    if (hadMethod) {
      assign(key, oldMethod, envir = methods)
    } else if (exists(key, envir = methods, inherits = FALSE)) {
      rm(list = key, envir = methods)
    }
  })
  registerS3method("drawDetails", "xpRecGrob",
                   function(x, recording) drawn <<- drawn + 1,
                   envir = asNamespace("grid"))
  g <- grid::grob(cl = "xpRecGrob")

  base <- tempfile("xp-grob-")
  withr::defer(unlink(paste0(base, ".png")))

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
  skip_if_not_installed("pdftools")
  base <- tempfile("xp-pages-")
  withr::defer(unlink(paste0(base, ".pdf")))

  g <- grid::rectGrob()
  drawAndReturn <- function(g) {
    grid::grid.newpage()
    grid::grid.draw(g)
    invisible(g)
  }
  f <- exportPlot(drawAndReturn(g), base, type = "pdf",
                  create = TRUE, screen = FALSE)

  expect_equal(pdftools::pdf_info(f)$pages, 1L)
})

test_that("svg is written where cairo is available", {
  skip_if_not(capabilities("cairo"))
  base <- tempfile("xp-svg-")
  withr::defer(unlink(paste0(base, ".svg")))

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
