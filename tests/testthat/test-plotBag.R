
# == test helpers ================================================================

# Independent exact halfspace depth: closed-halfplane count minimized over
# exhaustive boundary directions (O(n^2) per point, reference only).
.refDepth <- function(pt, xy) {
  d <- sweep(xy, 2, pt)
  zero <- rowSums(abs(d)) < 1e-12
  a <- atan2(d[!zero, 2], d[!zero, 1])
  m <- length(a)
  if (m == 0) return(sum(zero))
  phis <- sort(unique(c(a + 1e-9, a - 1e-9, a + pi + 1e-9, a + pi - 1e-9)))
  best <- m
  for (phi in phis) {
    rel <- (a - phi) %% (2 * pi)
    best <- min(best, sum(rel > 0 & rel < pi), sum(rel > pi & rel < 2 * pi))
  }
  best + sum(zero)
}

# Boundary-tolerant point-in-polygon count (angle sum + edge distance)
.pipTol <- function(pts, poly, tol) {
  inside <- apply(pts, 1, function(p) {
    d <- sweep(rbind(poly, poly[1, ]), 2, p)
    a <- diff(atan2(d[, 2], d[, 1]))
    a <- atan2(sin(a), cos(a))
    abs(sum(a)) > pi
  })
  onEdge <- apply(pts, 1, function(p) {
    m <- rbind(poly, poly[1, ])
    dmin <- Inf
    for (i in seq_len(nrow(poly))) {
      e <- m[i + 1, ] - m[i, ]
      w <- p - m[i, ]
      t <- max(0, min(1, sum(w * e) / sum(e * e)))
      dmin <- min(dmin, sqrt(sum((w - t * e)^2)))
    }
    dmin < tol
  })
  sum(inside | onEdge)
}

# Car data from Rousseeuw, Ruts & Tukey (1999)
.cardata <- cbind(
  c(2560, 2345, 1845, 2260, 2440, 2285, 2275, 2350, 2295, 1900, 2390, 2075,
    2330, 3320, 2885, 3310, 2695, 2170, 2710, 2775, 2840, 2485, 2670, 2640,
    2655, 3065, 2750, 2920, 2780, 2745, 3110, 2920, 2645, 2575, 2935, 2920,
    2985, 3265, 2880, 2975, 3450, 3145, 3190, 3610, 2885, 3480, 3200, 2765,
    3220, 3480, 3325, 3855, 3850, 3195, 3735, 3665, 3735, 3415, 3185, 3690),
  c(97, 114, 81, 91, 113, 97, 97, 98, 109, 73, 97, 89, 109, 305, 153, 302,
    133, 97, 125, 146, 107, 109, 121, 151, 133, 181, 141, 132, 133, 122,
    181, 146, 151, 116, 135, 122, 141, 163, 151, 153, 202, 180, 182, 232,
    143, 180, 180, 151, 189, 180, 231, 305, 302, 151, 202, 182, 181, 143,
    146, 146))


# == bagplot_compute_cpp =========================================================

test_that("halfspace depths match an independent reference implementation", {
  set.seed(11)
  for (n in c(25, 60, 110)) {
    xy  <- cbind(rnorm(n), rnorm(n) * runif(1, 0.5, 3) + rnorm(n))
    res <- bagplot_compute_cpp(xy, dither = FALSE)
    ref <- apply(xy, 1, .refDepth, xy = xy)
    expect_identical(as.integer(res$depths), as.integer(ref),
                     info = paste("n =", n))
  }
})

test_that("bag contains floor(n/2) points up to boundary ties", {
  gen <- list(
    function() cbind(rnorm(200), rnorm(200)),
    function() cbind(rexp(150), rexp(150)^2),
    function() cbind(rt(75, 2), rt(75, 2))
  )
  set.seed(1)
  for (g in gen) {
    xy   <- g()
    half <- floor(nrow(xy) / 2)
    res  <- bagplot_compute_cpp(xy)
    tol  <- 1e-6 * max(apply(xy, 2, sd))
    cnt  <- .pipTol(xy, res$bag, tol)
    expect_gte(cnt, half)
    # continuous data: only isolated boundary ties expected
    expect_lte(cnt, half + 6)
  }
})

test_that("loop lies within the data range (fence is not drawn as loop)", {
  set.seed(1)
  xy  <- cbind(rnorm(200), rnorm(200))
  res <- bagplot_compute_cpp(xy)
  tol <- 1e-6
  expect_gte(min(res$loop[, 1]), min(xy[, 1]) - tol)
  expect_lte(max(res$loop[, 1]), max(xy[, 1]) + tol)
  expect_gte(min(res$loop[, 2]), min(xy[, 2]) - tol)
  expect_lte(max(res$loop[, 2]), max(xy[, 2]) + tol)
})

test_that("fence is the bag inflated by `factor` around the center", {
  set.seed(4)
  xy  <- cbind(rnorm(80), rnorm(80))
  res <- bagplot_compute_cpp(xy, factor = 2.5)
  expect_equal(res$fence,
               sweep(sweep(res$bag, 2, res$center) * 2.5, 2, res$center, "+"),
               ignore_attr = TRUE)
})

test_that("larger fence factor never yields more outliers", {
  set.seed(9)
  xy <- cbind(rt(120, 2), rt(120, 2))
  no <- vapply(c(2, 3, 4, 6),
               function(f) nrow(bagplot_compute_cpp(xy, factor = f)$outliers),
               0L)
  expect_true(all(diff(no) <= 0))
})

test_that("cardata reproduces the known high-displacement outliers", {
  res <- bagplot_compute_cpp(.cardata)
  known <- cbind(c(3320, 3310, 3855, 3850), c(305, 302, 305, 302))
  for (i in seq_len(nrow(known)))
    expect_true(any(res$outliers[, 1] == known[i, 1] &
                    res$outliers[, 2] == known[i, 2]),
                info = paste("missing outlier", known[i, 1], known[i, 2]))
  # borderline classifications may vary slightly, but not wildly
  expect_lte(nrow(res$outliers), 7)
})

test_that("results are deterministic (fixed dither stream)", {
  set.seed(2)
  xy <- cbind(rnorm(60), rnorm(60))
  expect_identical(bagplot_compute_cpp(xy), bagplot_compute_cpp(xy))
})

test_that("result structure is complete and consistently typed", {
  set.seed(3)
  xy  <- cbind(rnorm(40), rnorm(40))
  res <- bagplot_compute_cpp(xy)
  expect_named(res, c("center", "depth", "bag", "fence", "loop",
                      "outliers", "depths"))
  expect_length(res$center, 2L)
  expect_length(res$depths, nrow(xy))
  for (el in c("bag", "fence", "loop", "outliers")) {
    expect_true(is.matrix(res[[el]]), info = el)
    expect_identical(colnames(res[[el]]), c("x", "y"), info = el)
  }
  expect_true(all(res$depths >= 1))
})

test_that("degenerate inputs are handled gracefully", {
  expect_error(bagplot_compute_cpp(cbind(1, 1)), "at least 3")
  # collinear and heavily tied data must not crash (dither breaks ties)
  expect_silent(r1 <- bagplot_compute_cpp(cbind(1:10, 2 * (1:10))))
  expect_silent(r2 <- bagplot_compute_cpp(cbind(rep(1:2, 5), rep(1:2, 5))))
  expect_silent(r3 <- bagplot_compute_cpp(cbind(c(0, 1, 0.5), c(0, 0, 1)),
                                          dither = FALSE))
  # without dither, collinear data yields empty polygons instead of nonsense
  r4 <- bagplot_compute_cpp(cbind(1:10, 2 * (1:10)), dither = FALSE)
  expect_identical(nrow(r4$bag), 0L)
  expect_identical(nrow(r4$loop), 0L)
})

test_that("outlier classification agrees with aplpack (superset on cardata)", {
  # suppressWarnings: aplpack warns about a missing Tk display on headless
  # systems (CI) already while its namespace is loaded
  skip_if_not(suppressWarnings(requireNamespace("aplpack", quietly = TRUE)),
              "aplpack not installed")
  a   <- suppressWarnings(
           aplpack::compute.bagplot(.cardata[, 1], .cardata[, 2],
                                    approx.limit = 5000))
  res <- bagplot_compute_cpp(.cardata)
  ao  <- rbind(a$pxy.outlier)[, 1:2, drop = FALSE]
  skip_if(is.null(ao) || nrow(ao) == 0)
  for (i in seq_len(nrow(ao)))
    expect_true(any(res$outliers[, 1] == ao[i, 1] &
                    res$outliers[, 2] == ao[i, 2]),
                info = paste("aplpack outlier not flagged:",
                             ao[i, 1], ao[i, 2]))
})


# == plotBag wrapper =============================================================

test_that("plotBag draws and returns the computation invisibly", {
  set.seed(1)
  x <- cbind(rnorm(100), rnorm(100))
  pdf(f <- tempfile(fileext = ".pdf"))
  on.exit({dev.off(); unlink(f)})
  expect_invisible(res <- plotBag(x))
  expect_named(res, c("center", "depth", "bag", "fence", "loop",
                      "outliers", "depths"))
  # element control: all off / customized must not error
  expect_silent(plotBag(x, points = FALSE, median = FALSE, bag = FALSE,
                        loop = FALSE, out = FALSE, box = FALSE))
  expect_silent(plotBag(x, fence = TRUE, grid = TRUE,
                        bag = list(col = "red"), loop = list(lty = 3)))
  # data frames work
  expect_silent(plotBag(data.frame(a = rnorm(50), b = rnorm(50))))
})

test_that("plotBag.formula matches the default method", {
  cd <- data.frame(Weight = .cardata[, 1], Disp = .cardata[, 2])
  pdf(f <- tempfile(fileext = ".pdf"))
  on.exit({dev.off(); unlink(f)})
  rf <- plotBag(Disp ~ Weight, data = cd)
  rd <- plotBag(cbind(cd$Weight, cd$Disp))
  # y ~ x puts the predictor on the horizontal axis, so both routes agree
  # on every computed component (the formula method adds 'data.name')
  for (el in names(rd))
    expect_equal(rf[[el]], rd[[el]], ignore_attr = TRUE, info = el)
  expect_s3_class(rf, "bagplot")
  expect_identical(rf$data.name, "Disp ~ Weight")
})

test_that("plotBag.formula honours subset, na.action and the calling env", {
  cd <- data.frame(Weight = .cardata[, 1], Disp = .cardata[, 2])
  pdf(f <- tempfile(fileext = ".pdf"))
  on.exit({dev.off(); unlink(f)})

  rs <- plotBag(Disp ~ Weight, data = cd, subset = Weight < 3000)
  expect_identical(length(rs$depths), sum(cd$Weight < 3000))

  cd2 <- cd
  cd2$Disp[c(1, 5)] <- NA
  rn <- plotBag(Disp ~ Weight, data = cd2)
  expect_identical(length(rn$depths), nrow(cd) - 2L)

  # variables found in the calling environment when 'data' is missing
  Weight <- cd$Weight
  Disp   <- cd$Disp
  expect_silent(re <- plotBag(Disp ~ Weight))
  expect_identical(length(re$depths), nrow(cd))
})

test_that("plotBag.formula rejects non numeric-numeric designs", {
  cd <- data.frame(Weight = .cardata[, 1], Disp = .cardata[, 2])
  pdf(f <- tempfile(fileext = ".pdf"))
  on.exit({dev.off(); unlink(f)})
  expect_error(plotBag(Disp ~ factor(Weight > 2500), data = cd), "not allowed")
  expect_error(plotBag(Disp ~ 1, data = cd), "not allowed")
})

test_that("plotBag validates its input", {
  expect_error(plotBag(cbind(1:5, 1:5, 1:5)), "2-column")
  expect_error(plotBag(data.frame(a = letters[1:5], b = 1:5)), "numeric")
})
