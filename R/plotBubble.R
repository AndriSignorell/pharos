
#' Bubble Plot
#'
#' Draws a bubble plot where the position is given by `x` and `y`,
#' and the size of each bubble increases with `area`.
#'
#' The function supports both a default interface and a formula interface
#' of the form `y ~ x | area`.
#'
#' @details
#' The bubble radii are scaled relative to the largest area: the largest
#' bubble gets a radius of `0.35 * cex` inches, the others
#' \eqn{r = 0.35 \cdot cex \cdot (area / \max(area))^{0.4}}. The exponent
#' 0.4 (instead of 0.5 for strictly area-proportional circles) dampens the
#' size differences, so that small bubbles remain visible. Radii are
#' converted to user coordinates separately for both axes, so the bubbles
#' are drawn as circles regardless of the aspect ratio.
#'
#' Bubbles are drawn in order of decreasing area, so small bubbles are not
#' hidden behind large ones.
#'
#' Graphical elements such as grids are controlled via the unified plot
#' design system using `bedrock::callIf()` and `.theme()`.
#'
#' @param x numeric vector of x positions.
#' @param y numeric vector of y positions.
#' @param area non-negative numeric vector controlling the bubble sizes.
#' @param ... additional graphical parameters passed to `par()`.
#'
#' @param col fill color(s) of the bubbles.
#' @param border border color(s) of the bubbles.
#' @param cex scaling factor applied to the bubble radii.
#'
#' @param add logical; if `TRUE`, adds to an existing plot.
#'
#' @param grid logical, `NA`, or list controlling background grid.
#'
#' @param xlim,ylim axis limits.
#'
#' @param main,xlab,ylab plot labels.
#'
#' @param na.rm logical. Observations with a missing `x`, `y` or `area`
#'   cannot be drawn and are always omitted; with `na.rm = FALSE` (default)
#'   a warning reports how many. Missing colors are not missing data, `NA`
#'   draws transparent.
#'
#' @param formula A formula of the form `y ~ x | area`.
#' @param data optional data frame.
#' @param subset optional subset expression, evaluated in `data`.
#' @param na.action function to handle missing values, defaults to
#'   [na.omit()].
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/
#'   `NULL`, a string, or a named list for [stamp()].
#'
#' @return Invisibly, a data frame with one row per drawn bubble and the
#'   columns `x`, `y`, `area`, `col`, `border`, and the radii `rx`, `ry` in
#'   user coordinates, sorted by decreasing area.
#'
#' @concept base-graphics
#' @concept plotting
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(100)
#' y <- rnorm(100)
#' a <- runif(100, 1, 10)
#'
#' plotBubble(x, y, a)
#'
#' df <- data.frame(x = x, y = y, a = a)
#' plotBubble(y ~ x | a, data = df)
#'
#' US <- data.frame(state.x77, State=state.name,
#'                    Region=state.region, Abb=state.abb)
#' plotBubble(Income ~ Population | Area ,
#'            data=US,
#'            grid=TRUE, col=addOpacity(pal("helsana")[US$Region]), cex=1.2 )
#'
#' text(Income ~ Population, US, labels=US$Abb, cex=0.8)
#'
#' @seealso [symbols()]
#'
#' @name plotBubble
NULL



#' @rdname plotBubble
#' @family plot.bivariate
#' @concept scatterplot
#' @concept bivariate
#' @export
plotBubble <- function(x, ...) {
  UseMethod("plotBubble")
}


#' @rdname plotBubble
#' @method plotBubble default
#' @export
plotBubble.default <- function(
    # DATA
    x,
    y,
    area,

    # LABELS
    main = "",
    xlab = "",
    ylab = "",

    # AXES
    xlim = NULL,
    ylim = NULL,

    # STRUCTURE
    add = FALSE,

    # STYLE
    col    = NA,
    border = NULL,
    cex    = 1,
    grid   = NA,

    # DATA HANDLING
    na.rm = FALSE,

    # FRAMEWORK
    stamp = .useTheme,

    ...
) {

  # --- data prep ------------------------------------------------

  d.frm <- as.data.frame(
    recycle(
      x      = x,
      y      = y,
      area   = area,
      col    = col,
      border = border %||% par("fg")
    ),
    stringsAsFactors = FALSE
  )

  # --- missing values -------------------------------------------

  # Only position and area count: col = NA is the default (transparent),
  # and complete.cases() over all columns dropped every row with it.
  ok <- stats::complete.cases(d.frm[c("x", "y", "area")])
  if (!all(ok)) {
    if (!isTRUE(na.rm))
      warning(gettextf(
        "%d observation(s) with missing 'x', 'y' or 'area' not drawn",
        sum(!ok)), domain = NA)
    d.frm <- d.frm[ok, , drop = FALSE]
  }

  if (nrow(d.frm) == 0)
    stop("no valid observations")

  if (any(d.frm$area < 0))
    stop("'area' must not be negative")

  # large bubbles first, small ones on top
  d.frm <- bedrock::sortX(d.frm, by = 3, decreasing = TRUE)

  # --- ranges ---------------------------------------------------

  if (is.null(xlim))
    xlim <- range(pretty(range(d.frm$x)))

  if (is.null(ylim))
    ylim <- range(pretty(range(d.frm$y)))

  # --- theme ----------------------------------------------------

  th <- .theme(
    grid = list(
      col = "grey90",
      lwd = 1,
      lty = "dotted"
    )
  )

  # --- plotting -------------------------------------------------

  .withGraphicsState({

    .applyParFromDots(...,
                      defaults=list(
                        mar=c(left=5, top=.marTop(naIf(main, ""))),
                        col.axis = "grey40",
                        fg       = "grey50"
                      ))

    if (!add) {

      plot(
        NA,
        xlim = xlim,
        ylim = ylim,
        main = main,
        xlab = xlab,
        ylab = ylab,
        type = "n"
      )

    }

    # --- grid ---------------------------------------------------

    bedrock::callIf(
      graphics::grid,
      grid,
      defaults = th$grid[
        !startsWith(names(th$grid), "group.")
      ]
    )

    # --- bubble scaling (screen based) --------------------------

    # radius in inches, relative to the largest area (see Details);
    # all areas zero: no visible bubbles instead of 0/0
    amax <- max(d.frm$area)
    r.in <- if (amax > 0) 0.35 * cex * (d.frm$area / amax)^0.4 else 0

    d.frm$rx <- r.in * diff(par("usr")[1:2]) / par("pin")[1]
    d.frm$ry <- r.in * diff(par("usr")[3:4]) / par("pin")[2]

    # --- draw bubbles -------------------------------------------

    polygonX(
      ellipse(
        x       = d.frm$x,
        y       = d.frm$y,
        radiusX = d.frm$rx,
        radiusY = d.frm$ry
      ),
      col    = d.frm$col,
      border = d.frm$border
    )

  }, stamp = stamp)

  invisible(d.frm)

}



#' @rdname plotBubble
#' @method plotBubble formula
#' @export
plotBubble.formula <- function(
    # DATA
    formula,
    data      = NULL,
    subset,
    na.action = na.omit,

    # LABELS
    main = "",
    xlab = "",
    ylab = "",

    # AXES
    xlim = NULL,
    ylim = NULL,

    # STRUCTURE
    add = FALSE,

    # STYLE
    col    = NA,
    border = NULL,
    cex    = 1,
    grid   = NA,

    ...
) {

  # --- formula parsing -----------------------------------------

  rhs <- formula[[3]]

  if (length(formula) != 3L || length(rhs) != 3L ||
      !identical(rhs[[1]], as.name("|")))
    stop("formula must be of the form y ~ x | area")

  y_var <- formula[[2]]
  x_var <- rhs[[2]]
  a_var <- rhs[[3]]

  # --- rewrite formula for model.frame -------------------------

  # y ~ x | area  ->  y ~ x + area, keeping the formula's environment
  f <- formula
  f[[3]] <- call("+", x_var, a_var)

  # --- model.frame ---------------------------------------------

  # positive list: only the model.frame arguments are passed on, so that
  # plot arguments and ... (las = 1, stamp = FALSE) never reach
  # model.frame(), where they would be evaluated as additional variables
  m <- match.call(expand.dots = FALSE)
  m <- m[c(1L, match(c("formula", "data", "subset"), names(m), 0L))]

  m[[1L]]     <- quote(stats::model.frame)
  m$formula   <- f
  m$na.action <- na.action

  mf <- eval(m, parent.frame())

  # --- default labels ------------------------------------------

  if (!nzchar(xlab))
    xlab <- deparse1(x_var)

  if (!nzchar(ylab))
    ylab <- deparse1(y_var)

  # --- call default method -------------------------------------

  plotBubble.default(
    x    = mf[[2]],
    y    = mf[[1]],
    area = mf[[3]],

    add = add,

    col    = col,
    border = border,
    cex    = cex,
    grid   = grid,

    xlim = xlim,
    ylim = ylim,

    main = main,
    xlab = xlab,
    ylab = ylab,

    ...
  )

}
