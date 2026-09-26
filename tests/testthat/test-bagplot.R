
# ── Tests for the bagplot engine (bagplot_compute_cpp) ───────────────────────

# exact halfspace depth by brute force: the minimum number of points in a
# closed halfplane whose boundary passes through p. The critical directions
# are the normals of the lines through p and each other point, taken
# slightly rotated to both sides.
.bruteDepth <- function(p, X) {
  d   <- sweep(X, 2, p)
  ang <- atan2(d[, 2], d[, 1])[rowSums(abs(d)) > 0]
  cand <- c(ang + pi / 2, ang - pi / 2)
  cand <- c(cand, cand + 1e-9, cand - 1e-9)
  min(vapply(cand, function(a)
    sum(d[, 1] * cos(a) + d[, 2] * sin(a) >= -1e-12), 0))
}

.bruteDepths <- function(X)
  vapply(seq_len(nrow(X)), function(i) .bruteDepth(X[i, ], X), 0)

.bag <- function(X, ...) bagplot_compute_cpp(X, ...)


test_that("halfspace depth matches brute force for continuous data", {
  set.seed(3)
  for (n in c(7, 20, 60)) {
    X <- cbind(rnorm(n), rnorm(n))
    expect_equal(.bag(X)$depths, .bruteDepths(X))
  }
})

test_that("halfspace depth is exact with ties and collinear points", {
  # regression guard: an off-by-one in the F array of TUKDEPTH gave wrong
  # depths for points with others collinear on both sides (discrete data)
  set.seed(9)
  grid <- cbind(sample(1:5, 40, TRUE), sample(1:5, 40, TRUE))
  expect_equal(.bag(grid)$depths, .bruteDepths(grid))

  tiesX <- cbind(sample(1:5, 40, TRUE), rnorm(40))
  expect_equal(.bag(tiesX)$depths, .bruteDepths(tiesX))

  Z    <- cbind(rnorm(20), rnorm(20))
  dups <- rbind(Z, Z[1:8, ])
  expect_equal(.bag(dups)$depths, .bruteDepths(dups))
})

test_that("halfspace depth is exact over many random configurations", {
  set.seed(11)
  for (rep in 1:40) {
    n <- sample(5:40, 1)
    k <- sample(2:6, 1)
    X <- switch(sample(3, 1),
                cbind(sample(1:k, n, TRUE), sample(1:k, n, TRUE)),
                cbind(sample(1:k, n, TRUE), rnorm(n)),
                cbind(rnorm(n), rnorm(n)))
    expect_equal(.bag(X)$depths, .bruteDepths(X))
  }
})

test_that("the result does not depend on the units of measurement", {
  # regression guard: absolute tolerances made data in small units collapse
  # to a single point (all depths n, no outliers)
  set.seed(1)
  Z   <- cbind(rnorm(50), rnorm(50))
  ref <- .bag(Z)
  area <- function(P) abs(sum(P[, 1] * c(P[-1, 2], P[1, 2]) -
                              c(P[-1, 1], P[1, 1]) * P[, 2])) / 2
  for (s in c(1e-9, 1e-3, 1e3, 1e9)) {
    r <- .bag(Z * s)
    expect_equal(r$depths, ref$depths)
    expect_equal(nrow(r$outliers), nrow(ref$outliers))
    expect_equal(area(r$bag) / s^2, area(ref$bag), tolerance = 1e-10)
    expect_equal(r$center / s, ref$center, tolerance = 1e-10)
  }
  # different units per axis
  r <- .bag(cbind(Z[, 1] * 1000 + 5, Z[, 2]))
  expect_equal(r$depths, ref$depths)
})

test_that("dither is off by default and lowers the depth of ties when on", {
  set.seed(9)
  grid <- cbind(sample(1:5, 40, TRUE), sample(1:5, 40, TRUE))
  exact <- .bruteDepths(grid)
  expect_equal(.bag(grid)$depths, exact)
  expect_true(all(.bag(grid, dither = TRUE)$depths <= exact))
})

test_that("the bag holds at least floor(n/2) points, boundary included", {
  inside <- function(P, X, tol = 1e-9) apply(X, 1, function(p) {
    n <- nrow(P); j <- n; ins <- FALSE; onEdge <- FALSE
    for (i in 1:n) {
      e <- P[j, ] - P[i, ]
      t <- max(0, min(1, sum((p - P[i, ]) * e) / sum(e^2)))
      if (sqrt(sum((P[i, ] + t * e - p)^2)) <= tol) onEdge <- TRUE
      if ((P[i, 2] > p[2]) != (P[j, 2] > p[2]) &&
          p[1] <= (P[j, 1] - P[i, 1]) * (p[2] - P[i, 2]) /
                  (P[j, 2] - P[i, 2]) + P[i, 1])
        ins <- !ins
      j <- i
    }
    ins || onEdge
  })
  set.seed(5)
  for (n in c(30, 101)) {
    Z <- cbind(rnorm(n), rnorm(n) + rnorm(n))
    expect_gte(sum(inside(.bag(Z)$bag, Z)), floor(n / 2))
  }
})

test_that("degenerate and invalid input", {
  # collinear data: no regions, no outliers
  r <- .bag(cbind(1, rnorm(10)))
  expect_equal(nrow(r$bag), 0L)
  expect_equal(nrow(r$outliers), 0L)
  expect_error(.bag(cbind(1:2, 1:2)), "at least 3")
  expect_error(.bag(cbind(c(1, NA, 3, 4), 1:4)), "missing or infinite")
})
