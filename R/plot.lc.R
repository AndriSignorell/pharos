
#' Plot Methods for Lorenz Curve Objects
#'
#' Visualize objects of class `"Lc"` and `"LcList"` returned by
#' `DescToolsX::lc()`.  The `plot()` method draws a new
#' Lorenz curve plot including the line of perfect equality; `lines()`
#' and `points()` add to an existing plot.
#'
#' For `"LcList"` objects (grouped Lorenz curves), `plot()` draws
#' the first group and overlays the remaining groups with `lines()`.
#' Colors cycle automatically when `col` is not supplied and are
#' recycled to the number of groups otherwise.
#'
#' The curve of `plot.Lc()` is drawn by `lines.Lc()` and the
#' symbols by `points.Lc()`, so all three methods share one code path
#' and one set of semantics - including the confidence band, which is
#' controlled by `cband` in `plot.Lc()` exactly as it is in
#' `lines.Lc()`.  Pass a list of arguments to
#' `DescToolsX::predict.Lc()` to control the bootstrap (e.g.
#' `cband = list(conf.level = 0.90, n = 500)`).  Set
#' `cband = NA` (default) to suppress the band.  Note that
#' `line = FALSE` suppresses the band along with the curve.
#'
#' With `general = TRUE` the generalized Lorenz curve is displayed.
#' It ends at the mean rather than at 1, so the default `ylim` and the
#' slope of the equality line follow the data; for `"LcList"` objects
#' the panel is sized to accommodate *all* groups, not just the first.
#'
#' @name plot.Lc
#'
#' @param x object of class `"Lc"` (for `plot.Lc()`,
#'   `lines.Lc()`, `points.Lc()`) or `"LcList"` (for the
#'   `*.LcList()` methods).
#' @param general logical.  If `TRUE`, the generalized Lorenz curve
#'   (scaled by the mean) is displayed instead of the standard curve.
#'   Default is `FALSE`.
#' @param main,xlab,ylab main title and axis labels, used by
#'   `plot.Lc()` only.  All default to `NULL`: no title,
#'   `"p"`, and `"L(p)"` (`"GL(p)"` if `general =
#'   TRUE`), respectively.
#' @param xlim,ylim numeric vectors of length 2 giving axis limits, used by
#'   `plot.Lc()` and `plot.LcList()`.  Default `NULL`, which
#'   resolves to `c(0, 1)` for `xlim` and, for `ylim`, to
#'   `c(0, 1)` for the standard and `c(0, max(L))` for the
#'   generalized curve.
#' @param col color of curve and symbols.  For `plot.Lc()`,
#'   `lines.Lc()` and `points.Lc()` a single color (default
#'   `NULL`, i.e. `"black"` in `plot.Lc()` and the device
#'   default in the low-level methods).  For the `"LcList"` methods a
#'   vector recycled to the number of groups (default `NULL`, i.e.
#'   `seq_len(k)`).
#' @param line logical or list, used by `plot.Lc()` to control drawing
#'   of the Lorenz curve.  `TRUE` (default) draws it with package
#'   defaults (`lty = 1`, `lwd = 2`); `FALSE` suppresses it
#'   (and the confidence band); a list overrides individual defaults and is
#'   forwarded to `lines.Lc()`.
#' @param points `NULL`, logical or list, used by `plot.Lc()` to
#'   control drawing of symbols on the curve.  `NULL` (default) is
#'   automatic: symbols are drawn only while the curve has at most
#'   `getOption("DescToolsX.plot.maxSymbols")` knots (100 by default),
#'   which keeps large samples legible.  `TRUE` always draws them with
#'   package defaults (`pch = 21`, `bg = "white"`,
#'   `cex = 1.4`); `FALSE` suppresses them; a list overrides
#'   individual defaults and is forwarded to `points.Lc()`.
#' @param eqline logical or list, used by `plot.Lc()` only.  Controls
#'   the line of perfect equality: `TRUE` (default) draws it with
#'   package defaults (`col = "grey50"`, `lty = 2`),
#'   `FALSE` suppresses it, a list is forwarded to
#'   [graphics::abline()].  Its slope is `1` for the
#'   standard and `max(L)` for the generalized curve; overriding
#'   `a`/`b` is possible but rarely sensible.
#' @param grid,box callIf-style specs for the grid and the box around the
#'   plot region, used by `plot.Lc()` only.  `.useTheme`
#'   (default) lets `getTheme()` decide, `TRUE`/`FALSE`
#'   force drawing/suppression, and a named list is forwarded to
#'   [graphics::grid()] resp. [graphics::box()].
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/
#'   `NULL`, a string, or a named list for [stamp()].
#' @param lwd line width, used by `plot.Lc()` (via `line`) and
#'   `lines.Lc()`.  Default is `2`.
#' @param lty line type, used by `plot.Lc()` (via `line`) and
#'   `lines.Lc()`.  Default is `1`.
#' @param pch plotting symbol, used by `points.Lc()` only.  Default is
#'   `16`.
#' @param cband used by `plot.Lc()` and `lines.Lc()`.
#'   `NA` to suppress the confidence band (default), or a list of
#'   arguments passed to `DescToolsX::predict.Lc()` to control
#'   bootstrap confidence intervals.
#' @param ... further arguments.  For `plot.Lc()`, graphical parameters
#'   passed to [graphics::par()] via `.applyParFromDots()`
#'   (e.g. `mar`, `cex.axis`, `las`).  For `lines.Lc()`
#'   and `points.Lc()`, further arguments passed on to
#'   [graphics::lines()] and [graphics::points()],
#'   respectively.  For `plot.LcList()`, arguments are passed to
#'   `plot.Lc()` for the first group and, restricted to those the
#'   low-level method understands, to `lines.Lc()` for the remaining
#'   ones.
#'
#' @return All methods return `NULL` invisibly.
#'
#' @seealso
#'   `DescToolsX::lc()` for computing the Lorenz curve,
#'   `DescToolsX::predict.Lc()` for bootstrap confidence
#'   intervals, `DescToolsX::gini()` for the Gini coefficient.
#'
#' @family plot.s3
#' @concept inequality
#' @concept graphics
#'
NULL


#' Restrict Dots to Arguments the lines.Lc() Path Understands
#'
#' `plot.LcList()` receives the dots of a `plot()` call, which legitimately
#' contain plot-only arguments (`main`, `xlim`, `mar`, ...).  Forwarding
#' them verbatim to `lines()` makes `plot.xy()` emit one
#' `"... is not a graphical parameter"` warning per group, so the dots are
#' filtered against a whitelist of `lines.Lc()` formals plus the line-level
#' graphical parameters accepted by `plot.xy()`.
#'
#' @param dots list of the caller's dots (`list(...)`).
#'
#' @return The filtered list.
#'
#' @noRd
.dotsForLines <- function(dots) {

  keep <- c(
    # lines.Lc() formals
    "general", "cband",
    # graphical parameters honoured by plot.xy()
    "lwd", "lty", "type", "pch", "cex", "bg",
    "lend", "ljoin", "lmitre", "xpd"
  )

  dots[names(dots) %in% keep]
}


#' @rdname plot.Lc
#' @export
plot.Lc <- function(

  # DATA
  x,

  # LABELS
  main = NULL,
  xlab = NULL,
  ylab = NULL,

  # AXES
  xlim = NULL,
  ylim = NULL,

  # STRUCTURE
  general = FALSE,

  # STYLE
  col = NULL,
  line = TRUE,
  points = NULL,
  eqline = TRUE,

  grid = .useTheme,
  box = .useTheme,

  # FEATURES
  cband = NA,

  stamp = .useTheme,
  ...
) {

  if (!inherits(x, "Lc"))
    stop("x must be of class 'Lc'")

  # NULL means "no title" here, hence .resolveTitle() with the empty
  # default - .marTop() must see the resolved value, as it treats NULL as
  # "default title present" and would reserve the generous top margin.
  main <- .resolveTitle(main)
  xlab <- xlab %||% "p"
  ylab <- ylab %||% if (general) "GL(p)" else "L(p)"

  .withGraphicsState({

    .applyParFromDots(...,
                      defaults = list(
                        pty  = "s",
                        xaxs = "i",
                        yaxs = "i",
                        mar  = c(
                          left  = 5,
                          top   = .marTop(main)
                        )
                      ))

    # --- data selection ---
    L <- if (!general) x$L else x$L.general
    p <- x$p

    # --- axis limits ---
    # The generalized curve ends at the mean, not at 1.
    if (is.null(xlim)) xlim <- c(0, 1)
    if (is.null(ylim)) ylim <- if (general) c(0, max(L, na.rm = TRUE)) else c(0, 1)

    # --- symbols: automatic unless explicitly specified ---
    if (is.null(points))
      points <- length(p) <= .resolvePar("maxSymbols", default = 100)

    # --- base plot ---
    plot(
      p, L,
      type = "n",
      main = main,
      xlab = xlab,
      ylab = ylab,
      xlim = xlim,
      ylim = ylim
    )

    # --- grid ---
    .drawGrid(
      grid,
      defaults = list(
        col = "grey90",
        lty = 1)
    )

    # --- equality line (below the curve) ---
    # 'eqline' shadows nothing, but note that the local formals 'points',
    # 'line', 'grid' and 'box' do shadow the same-named functions. R's
    # lookup skips non-functions in call position, so graphics::points()
    # etc. still resolve correctly; the qualified names below make that
    # explicit rather than relying on it.
    callIf(
      graphics::abline,
      eqline,
      defaults = list(
        a = 0,
        b = if (general) max(L, na.rm = TRUE) else 1,
        col = "grey50",
        lty = 2)
    )

    # --- Lorenz curve, incl. confidence band ---
    # Delegated to lines.Lc() so that plot(), lines() and the LcList
    # methods share one implementation - notably for cband.
    callIf(
      graphics::lines,
      line,
      defaults = list(
        x = x,
        general = general,
        col = col %||% "black",
        lty = 1,
        lwd = 2,
        cband = cband)
    )

    # --- box ---
    .drawBox(box)

    # --- points ---
    # xpd = NA: with xaxs/yaxs = "i" the knots at p = 0 and p = 1 sit
    # exactly on the box and would otherwise be clipped in half.
    callIf(
      graphics::points,
      points,
      defaults = list(
        x = x,
        general = general,
        col = col %||% "black",
        pch = 21,
        bg = "white",
        cex = 1.4,
        xpd = NA)
    )

  }, stamp = stamp)
}


#' @rdname plot.Lc
#' @export
lines.Lc <- function(

  # DATA
  x,

  # STRUCTURE
  general = FALSE,

  # STYLE
  col = NULL,
  lwd = 2,
  lty = 1,

  # FEATURES
  cband = NA,

  ...

) {

  if (!inherits(x, "Lc"))
    stop("x must be of class 'Lc'")

  # --- select curve ---
  L <- if (!general) x$L else x$L.general

  # --- confidence band ---
  ci <- callIf(
    predict,
    cband,
    defaults = list(
      object = x,
      conf.level = 0.95,
      general = general
    ),
    forbidden = c("col", "border")
  )

  callIf(
    .drawBandCI,
    cband,
    defaults = list(
      x = ci$p,
      ci = cbind(ci$lci, ci$uci),
      col = col %||% "black"
    ),
    forbidden = "conf.level",
    warn = FALSE
  )

  # --- draw line ---
  lines(
    x$p,
    L,
    col = col,
    lwd = lwd,
    lty = lty,
    ...
  )

  invisible(NULL)

}


#' @rdname plot.Lc
#' @export
points.Lc <- function(

  # DATA
  x,

  # STRUCTURE
  general = FALSE,

  # STYLE
  pch = 16,
  col = NULL,

  ...
) {

  if (!inherits(x, "Lc"))
    stop("x must be of class 'Lc'")

  # --- select curve ---
  L <- if (!general) x$L else x$L.general

  # --- draw points ---
  points(x$p, L, pch = pch, col = col, ...)

  invisible(NULL)
}


#' Colors for the Groups of an LcList
#'
#' Shared argument check and color resolution of the `*.LcList()` methods:
#' validates the object, rejects the empty list and recycles a supplied
#' `col` to the number of groups (the documented behaviour - indexing an
#' unrecycled vector yields `NA` for the surplus groups).
#'
#' @param x the `"LcList"` object.
#' @param col the user-supplied `col` argument, possibly `NULL`.
#'
#' @return A vector of colors of length `length(x)`.
#'
#' @noRd
.lcListCol <- function(x, col) {

  if (!inherits(x, "LcList"))
    stop("x must be of class 'LcList'")

  k <- length(x)

  if (k == 0)
    stop("empty LcList")

  if (is.null(col)) seq_len(k) else rep_len(col, k)
}


#' @rdname plot.Lc
#' @export
lines.LcList <- function(x, col = NULL, ...) {

  col <- .lcListCol(x, col)

  for (i in seq_along(x))
    lines(x[[i]], col = col[i], ...)

  invisible(NULL)
}


#' @rdname plot.Lc
#' @export
points.LcList <- function(x, col = NULL, ...) {

  col <- .lcListCol(x, col)

  for (i in seq_along(x))
    points(x[[i]], col = col[i], ...)

  invisible(NULL)
}


#' @rdname plot.Lc
#' @export
plot.LcList <- function(x, col = NULL, general = FALSE, ylim = NULL, ...) {

  col <- .lcListCol(x, col)
  k <- length(x)

  # Generalized curves end at the group mean, so the panel must
  # accommodate all groups - sizing it on the first one would clip the
  # rest.
  if (is.null(ylim) && isTRUE(general))
    ylim <- c(0, max(vapply(x,
                            function(z) max(z$L.general, na.rm = TRUE),
                            numeric(1))))

  dots <- list(...)

  do.call(plot,
          c(list(x[[1]], col = col[1], general = general, ylim = ylim),
            dots))

  # Plot-only arguments (main, xlim, mar, ...) must not reach lines(),
  # which would warn once per group.
  for (i in seq_len(k)[-1])
    do.call(lines,
            c(list(x[[i]], col = col[i], general = general),
              .dotsForLines(dots)))

  invisible(NULL)
}
