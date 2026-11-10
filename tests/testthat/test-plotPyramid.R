# == test helpers ================================================================

# every test draws on a fresh null device of a fixed size
.withDevice <- function(expr) {
  grDevices::pdf(NULL, width = 7, height = 5)
  on.exit(grDevices::dev.off())
  force(expr)
}

lx <- c(a = 8, b = 11, c = 24, d = 43)
rx <- c(127, 125, 48, 0)


# == input =======================================================================

test_that("two vectors and a two-column matrix describe the same plot", {
  m <- cbind(Left = lx, Right = rx)

  r1 <- .withDevice(plotPyramid(lx, rx))
  r2 <- .withDevice(plotPyramid(m, lxlab = FALSE, rxlab = FALSE))
  r3 <- .withDevice(plotPyramid(as.data.frame(m), lxlab = FALSE,
                                rxlab = FALSE))

  expect_equal(r1, r2)
  expect_equal(r1, r3)
})

test_that("invalid input is rejected", {
  expect_error(.withDevice(plotPyramid(lx)), "two columns")
  expect_error(.withDevice(plotPyramid(cbind(lx, rx, rx))), "two columns")
  expect_error(.withDevice(plotPyramid(lx, rx[-1])), "same length")
  expect_error(.withDevice(plotPyramid(lx, -rx)), "negative")
  expect_error(.withDevice(plotPyramid(letters[1:4], rx)), "numeric")
  expect_error(.withDevice(plotPyramid(lx, rx, labels = c("x", "y"))),
               "labels")
  expect_error(.withDevice(plotPyramid(lx, rx, gap = -1)), "gap")
  expect_error(.withDevice(plotPyramid(lx, rx, xlim = c(1, 2, 3))), "xlim")
  expect_error(.withDevice(plotPyramid(lx, rx, xlim = 0)), "xlim")
})


# == geometry ====================================================================

test_that("the midpoints are those of barplot()", {
  r <- .withDevice(plotPyramid(lx, rx))
  b <- .withDevice(barplot(rx, horiz = TRUE, plot = FALSE))

  expect_equal(as.vector(r), as.vector(b))

  r <- .withDevice(plotPyramid(lx, rx, space = 0, width = 2))
  b <- .withDevice(barplot(rx, horiz = TRUE, plot = FALSE,
                           space = 0, width = 2))

  expect_equal(as.vector(r), as.vector(b))
})

test_that("the gap is as given, and zero without labels", {
  expect_equal(attr(.withDevice(plotPyramid(lx, rx, gap = 10)), "gap"), 10)
  expect_equal(attr(.withDevice(plotPyramid(lx, rx, gap = 0)), "gap"), 0)
  expect_equal(
    attr(.withDevice(plotPyramid(lx, rx, labels = FALSE)), "gap"), 0)
  expect_equal(
    attr(.withDevice(plotPyramid(unname(lx), rx)), "gap"), 0)
})

test_that("the automatic gap holds the widest label", {
  .withDevice({
    r   <- plotPyramid(lx, rx, labels = c("a", "bb", "a long label", "c"))
    gap <- attr(r, "gap")
    w   <- strwidth("a long label", units = "user", cex = par("cex.axis"))
    usr <- par("usr")
  })

  expect_gt(gap, w)
  # both halves keep the same extent around the gap
  expect_equal(usr[1], -usr[2])
})

test_that("longer labels widen the gap", {
  g1 <- attr(.withDevice(plotPyramid(lx, rx)), "gap")
  g2 <- attr(.withDevice(plotPyramid(lx, rx, labels = strrep(names(lx), 9))),
             "gap")

  expect_gt(g2, g1)
})

test_that("xlim sets the extent of the halves on a common scale", {
  usr <- .withDevice({
    r <- plotPyramid(lx, rx, xlim = c(50, 150), gap = 20)
    par("usr")
  })

  pad <- 0.02 * 200
  expect_equal(usr[1:2], c(-50 - 10 - pad, 150 + 10 + pad))
})


# == axis ========================================================================

test_that("tick labels are thinned from zero on both halves", {
  .withDevice({
    plot.new()
    plot.window(xlim = c(0, 1), ylim = c(0, 1))
    # room for all labels
    all <- .pyramidTickLabels(NULL, c(0, 0.5, 1))
    # ticks far too dense for their labels
    thin <- .pyramidTickLabels(NULL, seq(0, 1, by = 0.01))
  })

  expect_equal(all, c("0", "0.5", "1"))
  expect_equal(thin[1], "0")
  expect_true(any(thin == ""))
  shown <- which(thin != "")
  expect_length(unique(diff(shown)), 1L)
})

test_that("the axis format is applied to the unsigned values", {
  labs <- .withDevice({
    plot.new()
    .axisLabels(list(digits = 1), c(0, 1, 2))
  })

  expect_equal(trimws(as.character(labs)), c("0.0", "1.0", "2.0"))
})


# == features ====================================================================

test_that("the optional layers run", {
  expect_no_error(.withDevice(
    plotPyramid(lx, rx, main = "Title", lxlab = "left", rxlab = "right",
                text = TRUE, grid = TRUE, box = TRUE)))
  expect_no_error(.withDevice(
    plotPyramid(lx, rx, xax = FALSE, grid = FALSE, labels = NA,
                text = list(labels = list(letters[1:4], LETTERS[1:4]),
                            cex = 0.7))))
  expect_no_error(.withDevice(
    plotPyramid(lx, rx, gap = 0, xax = list(digits = 1, col = "red"),
                grid = list(col = "red", lty = "solid"),
                col = list(1:4, 5:8), border = "white",
                mar = c(left = 6))))
})

test_that("add = TRUE draws into the existing plot", {
  .withDevice({
    r1  <- plotPyramid(lx, rx, space = 0)
    usr <- par("usr")
    mar <- par("mar")
    r2  <- plotPyramid(rx, lx, add = TRUE, gap = attr(r1, "gap"), space = 0,
                       main = "ignored", text = TRUE)

    # same geometry, coordinate system untouched
    expect_equal(r2, r1)
    expect_equal(par("usr"), usr)
    expect_equal(par("mar"), mar)
  })

  expect_error(.withDevice({
    plotPyramid(lx, rx)
    plotPyramid(lx, rx, add = TRUE)
  }), "gap")
})

test_that("the graphics state is restored", {
  grDevices::pdf(NULL)
  on.exit(grDevices::dev.off())

  old <- par(c("mar", "xaxs", "cex", "las"))
  plotPyramid(lx, rx, main = "Title", mar = c(left = 8))

  expect_equal(par(c("mar", "xaxs", "cex", "las")), old)
})
