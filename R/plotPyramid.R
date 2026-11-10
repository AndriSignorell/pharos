
#' Pyramid Plot (Back-to-Back Barplot)
#'
#' Draws two series of horizontal bars back to back on a common scale,
#' with the category labels in a gap between them. The classic use is the
#' population pyramid; the display is also known as a butterfly chart or
#' back-to-back barplot and serves any comparison of two series over the
#' same categories.
#'
#' Both halves share one coordinate system, so that bar lengths can be
#' compared across the gap: a unit on the left is as long as a unit on the
#' right. The left series is drawn towards the left from `-gap/2`, the
#' right series towards the right from `gap/2`. The value axis shows the
#' unsigned values on both sides.
#'
#' As in [graphics::barplot()], the first category is drawn at the bottom.
#'
#' @param lx,rx numeric vectors of non-negative values for the left and the
#'   right half. Alternatively `lx` can be a matrix, table or data frame
#'   with two columns, which are then taken as left and right series; the
#'   row names serve as `labels` and the column names as `lxlab` and
#'   `rxlab`.
#' @param labels the category labels. `NULL` (default) uses the names of
#'   `lx` (or the row names of a two-column `lx`). `FALSE` or `NA`
#'   suppress them.
#' @param main main title. `NULL` (default) draws none. `""`, `NA` or
#'   `FALSE` also suppress it; the top margin is compacted whenever no
#'   title is drawn.
#' @param lxlab,rxlab labels for the left and the right half, centered
#'   below the respective part of the value axis. `NULL` (default) uses
#'   the column names of a two-column `lx` and draws none otherwise;
#'   `""`, `NA` or `FALSE` suppress a label.
#' @param xax controls drawing of the value axis.
#'   \describe{
#'     \item{`NULL`, `TRUE`}{draw the axis using package defaults}
#'     \item{`FALSE`}{suppress the axis}
#'     \item{`list(...)`}{format arguments for [fm()] and axis parameters
#'       for [graphics::axis()], as for `yax` in [plotBar()]}
#'   }
#' @param xlim the extent of the value axis: one number for both halves or
#'   two numbers, `c(left, right)`. The scale stays the same on both
#'   sides, a larger extent merely gets more room. `NULL` (default) uses
#'   the same pretty limit for both halves.
#' @param gap the width of the gap between the halves, in units of the
#'   value axis. `NULL` (default) reserves just the room the `labels`
#'   need. With `gap = 0` the halves touch and the labels move to the left
#'   margin.
#' @param add logical. If `TRUE`, only the bars (and their `text`) are
#'   added to an existing pyramid plot, e.g. to overlay a second
#'   population. The `gap` of that plot must then be given, see the
#'   return value; `space` and `width` must be the same as well.
#' @param col the fill colors of the left and the right half, recycled to
#'   length 2. `.useTheme` (default) resolves to `getTheme()$twin`. A list
#'   of two vectors sets the colors per bar.
#' @param border bar border colour. `.useTheme` (default) resolves to
#'   `getTheme()$bar$border`.
#' @param grid controls the vertical grid lines at the axis ticks.
#'   `.useTheme` (default) follows the active theme (`getTheme()$grid`),
#'   `TRUE` draws them with theme settings, `FALSE`, `NULL` or `NA`
#'   suppress them. A named list sets `col`, `lwd` and `lty` for this call.
#' @param box controls drawing of the plot box. `TRUE`/`FALSE`/`NA`, the
#'   theme via `.useTheme`, or a named list for [graphics::box()].
#' @param text optional list of arguments passed to [barText()] to draw
#'   value labels on the bars, `TRUE` for the defaults (the values,
#'   outside the bar ends). `labels` can be a list of two vectors, for the
#'   left and the right half.
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`,
#'   or an explicit string, as for `.withGraphicsState()` (internal).
#' @param ... further arguments: `space` and `width` are passed to
#'   [graphics::barplot()], graphical parameters such as `mar`, `las` or
#'   `cex.axis` are set via [graphics::par()].
#'
#' @return Invisibly returns the midpoints of the bars as returned by
#'   [graphics::barplot()], with the realized gap width as attribute
#'   `"gap"`. A bar of the right half with value `v` ends at
#'   `gap/2 + v`, one of the left half at `-gap/2 - v`.
#'
#' @seealso [plotBar], [barText], [theme]
#'
#' @examples
#' # two vectors
#' d.sda <- data.frame(
#'   kt_x  = c("NW","TG","UR","AI","OW","GR","BE","SH","AG","BS","FR"),
#'   apo_n = c(  8,  11,   9,   7,   9,  24,  19,  19,  20,  43,  27),
#'   sda_n = c(127, 125, 121, 121, 110,  48,  34,  33,   0,   0,   0)
#' )
#'
#' plotPyramid(lx = d.sda$apo_n, rx = d.sda$sda_n, labels = d.sda$kt_x,
#'             lxlab = "Drugstores", rxlab = "General practitioners",
#'             main = "Density of general practitioners and drugstores")
#'
#' # more room for the longer half, own colors
#' plotPyramid(lx = d.sda$apo_n, rx = d.sda$sda_n, labels = d.sda$kt_x,
#'             xlim = c(50, 150), col = c("lightslategray", "orange2"))
#'
#' # values on the bars
#' plotPyramid(lx = d.sda$apo_n, rx = d.sda$sda_n, labels = d.sda$kt_x,
#'             xax = FALSE, grid = FALSE,
#'             text = list(cex = 0.7, border = NA))
#'
#' # a two-column table: labels and titles are taken from the dimnames
#' tab <- cbind(Male   = c(2.1, 2.3, 2.9, 3.4, 3.2, 2.6, 1.7, 0.8),
#'              Female = c(2.0, 2.2, 2.8, 3.4, 3.3, 2.9, 2.2, 1.4))
#' rownames(tab) <- c("0-9", "10-19", "20-29", "30-39", "40-49",
#'                    "50-59", "60-69", "70+")
#'
#' plotPyramid(tab, main = "Population (in 1000)",
#'             xax = list(digits = 1))
#'
#' # no gap: the labels move to the left margin
#' plotPyramid(tab, gap = 0, space = 0, border = "white")
#'
#' # two populations overlaid with semi-transparent bars (made-up numbers)
#' now  <- tab
#' then <- tab * c(1.5, 1.4, 1.2, 1, 0.9, 0.7, 0.5, 0.4)
#'
#' cols <- c(addOpacity(getTheme()$twin, 0.5), addOpacity("grey30", 0.4))
#'
#' r <- plotPyramid(now, xlim = 3.5, space = 0,
#'                  col = cols[1:2], border = "white",
#'                  main = "Population then and now")
#' plotPyramid(then, add = TRUE, gap = attr(r, "gap"), space = 0,
#'             col = cols[3], border = "white")
#' legend("topright", legend = c("now", "then"), fill = cols[c(2, 3)],
#'        border = NA, bty = "n")
#'
#' @family plot.bivariate
#' @concept bar-chart
#' @concept pyramid
#'
#'
#' @export
plotPyramid <- function(lx, rx = NULL,

                        # LABELS
                        labels = NULL,
                        main   = NULL,
                        lxlab  = NULL,
                        rxlab  = NULL,

                        # AXES
                        xax  = NULL,
                        xlim = NULL,

                        # STRUCTURE
                        gap = NULL,
                        add = FALSE,

                        # STYLE
                        col    = .useTheme,
                        border = .useTheme,
                        grid   = .useTheme,
                        box    = FALSE,

                        # FEATURES
                        text = NULL,

                        # FRAMEWORK
                        stamp = .useTheme,
                        ...) {

  dots <- list(...)

  d <- .pyramidData(lx, rx, labels, lxlab, rxlab)
  lx <- d$lx
  rx <- d$rx
  labels <- d$labels

  main <- .resolveTitle(main)

  # one fill per half; a list of two vectors sets them bar by bar
  col <- .useThemeValue(col, "twin")
  col <- if (is.list(col)) rep_len(col, 2L) else as.list(rep_len(col, 2L))
  border <- .useThemeValue(border, "bar", "border")

  # --- value scale: same ticks and same unit length on both halves ---
  if (is.null(xlim)) {
    ticks <- pretty(c(0, lx, rx))
    xlim  <- rep(max(ticks), 2L)
  } else {
    if (!is.numeric(xlim) || !length(xlim) %in% 1:2 ||
        anyNA(xlim) || any(xlim <= 0))
      stop("'xlim' must be one or two positive numbers, c(left, right)",
           call. = FALSE)
    xlim  <- rep_len(xlim, 2L)
    ticks <- pretty(c(0, max(xlim)))
  }
  ticksL <- ticks[ticks <= xlim[1L]]
  ticksR <- ticks[ticks <= xlim[2L]]

  # the bars may end right at the limit: a little air for the bar ends
  # and the outermost tick labels
  pad <- 0.02 * sum(xlim)

  if (!is.null(gap) &&
      (!is.numeric(gap) || length(gap) != 1L || is.na(gap) || gap < 0))
    stop("'gap' must be NULL or a single non-negative number", call. = FALSE)

  if (add && is.null(gap))
    stop("'gap' must be given with add = TRUE: ",
         "use attr(, \"gap\") of the plot the bars are added to",
         call. = FALSE)

  hasLabels  <- length(labels) > 0L
  hasHalfLab <- nzchar(d$lxlab) || nzchar(d$rxlab)

  b <- NULL

  .withGraphicsState({

    bpArgs <- dots[intersect(names(dots), c("space", "width"))]

    drawBars <- function(height, offset, ...) {
      do.call(barplot, c(
        list(height = height, horiz = TRUE, offset = offset,
             axes = FALSE, axisnames = FALSE, ...),
        bpArgs))
    }

    if (add) {

      # the coordinate system exists: only the midpoints are needed
      b <- do.call(barplot, c(list(height = rx, horiz = TRUE, plot = FALSE),
                              bpArgs))

    } else {

      .applyParFromDots(...,
            defaults = list(
              mar = c(bottom = if (hasHalfLab) 4.1 else 3.1,
                      left   = 2.1,
                      top    = .marTop(main),
                      right  = 2.1)
        )
      )

      # without a gap the labels need the left margin
      if (hasLabels && identical(gap, 0) &&
          !"left" %in% .userMarSides(dots) && par("yaxt") != "n")
        .adjustMargin(labels, side = 2)

      if (is.null(gap))
        gap <- if (hasLabels) .pyramidGap(labels, sum(xlim) + 2 * pad) else 0

      atL <- -gap / 2 - ticksL
      atR <-  gap / 2 + ticksR

      # --- Setup (invisible) ---
      b <- drawBars(rx, offset = gap / 2, col = NA, border = NA,
                    xlim = c(-xlim[1L] - gap / 2 - pad,
                              xlim[2L] + gap / 2 + pad),
                    xaxs = "i", main = main)

      # --- GRID Layer ---
      .drawPyramidGrid(grid, at = c(atL, atR))

    }

    # --- bars ---
    drawBars(-lx, offset = -gap / 2, col = col[[1L]], border = border,
             add = TRUE)
    drawBars( rx, offset =  gap / 2, col = col[[2L]], border = border,
             add = TRUE)

    # --- Text Layer ---
    textLabels <- list(lx, rx)
    if (is.list(text) && is.list(text$labels)) {
      textLabels <- rep_len(text$labels, 2L)
      text$labels <- NULL
    }

    # barText() takes the side a label goes to from the sign of the
    # height: an empty bar gets a height that keeps its sign, so that its
    # label lands on the outside of the baseline like all the others
    eps <- 1e-9 * max(xlim)

    for (i in 1:2)
      bedrock::callIf(barText,
                      text,
                      defaults = list(
                        height = c(-1, 1)[i] * pmax(list(lx, rx)[[i]], eps),
                        mids   = b,
                        horiz  = TRUE,
                        beside = TRUE,
                        labels = textLabels[[i]],
                        pos    = "top-out",
                        offset = c(-1, 1)[i] * gap / 2
                      ),
                      forbidden = c("height", "mids", "horiz", "beside",
                                    "offset"),
                      warn = TRUE
      )

    # --- value axis ---
    # two pieces, each with its own zero; without a gap the zeros coincide.
    # axis() drops overlapping labels in drawing order, which would leave
    # different values on the two halves: they are thinned here instead,
    # counted from zero on both sides.
    if (!add && !isFALSE(xax)) {

      tickLabels <- .pyramidTickLabels(xax, ticks)
      labsL <- tickLabels[seq_along(ticksL)]
      labsR <- tickLabels[seq_along(ticksR)]

      if (gap > 0) {
        .drawAxis(1, xax, at = rev(atL), labels = rev(labsL))
        .drawAxis(1, xax, at = atR, labels = labsR)
      } else {
        .drawAxis(1, xax, at     = c(rev(atL), atR[-1L]),
                          labels = c(rev(labsL), labsR[-1L]))
      }
    }

    # --- category labels ---
    if (!add && hasLabels && par("yaxt") != "n") {
      if (gap > 0)
        text(x = 0, y = b, labels = labels, adj = c(0.5, 0.5),
             cex = par("cex.axis"), col = par("col.axis"),
             font = par("font.axis"))
      else
        axis(side = 2, at = b, labels = labels, tick = FALSE, las = 1)
    }

    # --- titles of the halves ---
    labLine <- par("mgp")[1L] - 0.5
    labCex  <- par("cex") * par("cex.lab")
    if (!add && nzchar(d$lxlab))
      mtext(d$lxlab, side = 1, line = labLine, cex = labCex,
            col = par("col.lab"), font = par("font.lab"),
            at = -gap / 2 - xlim[1L] / 2)
    if (!add && nzchar(d$rxlab))
      mtext(d$rxlab, side = 1, line = labLine, cex = labCex,
            col = par("col.lab"), font = par("font.lab"),
            at = gap / 2 + xlim[2L] / 2)

    # --- box ---
    if (!add)
      .drawBox(box, defaults = list(which = "plot"))

  }, stamp = if (add) FALSE else stamp)

  attr(b, "gap") <- gap
  invisible(b)

}



# == internal helper functions =======================================

# Normalizes the input of plotPyramid() to two numeric vectors of the same
# length, the category labels (character(0) for none) and the titles of
# the halves ("" for none).
.pyramidData <- function(lx, rx, labels, lxlab, rxlab) {

  defLab <- c("", "")

  if (is.null(rx)) {
    if (is.data.frame(lx))
      lx <- as.matrix(lx)
    if (length(dim(lx)) != 2L || ncol(lx) != 2L)
      stop("'lx' must have two columns (left, right) if 'rx' is not given",
           call. = FALSE)
    defLab <- colnames(lx) %||% defLab
    nms <- rownames(lx)
    rx  <- lx[, 2L]
    lx  <- lx[, 1L]
  } else {
    nms <- names(lx) %||% names(rx)
    lx  <- as.vector(lx)
    rx  <- as.vector(rx)
  }

  if (!is.numeric(lx) || !is.numeric(rx))
    stop("'lx' and 'rx' must be numeric", call. = FALSE)
  if (length(lx) != length(rx))
    stop("'lx' and 'rx' must have the same length", call. = FALSE)
  if (any(c(lx, rx) < 0, na.rm = TRUE))
    stop("'lx' and 'rx' must not be negative", call. = FALSE)

  lx <- unname(lx)
  rx <- unname(rx)

  noLabels <- isFALSE(labels) || (length(labels) == 1L && is.na(labels))
  labels <- if (noLabels) {
    character(0)
  } else {
    as.character(labels %||% nms %||% character(0))
  }
  if (length(labels) && length(labels) != length(lx))
    stop("'labels' must have the same length as 'lx'", call. = FALSE)

  halfLab <- function(lab, default) {
    if (is.null(lab))
      return(default)
    if (isFALSE(lab) || (length(lab) == 1L && is.na(lab)))
      return("")
    lab
  }

  list(lx = lx, rx = rx, labels = labels,
       lxlab = halfLab(lxlab, defLab[1L]),
       rxlab = halfLab(rxlab, defLab[2L]))
}



# Gap width in units of the value axis that holds the widest label plus
# one character width of air on either side. 'range' is the extent of the
# x axis without the gap. The gap is part of the axis it is measured on:
# with w the label width and W the width of the plot region in inches,
# gap / (range + gap) = w / W.
.pyramidGap <- function(labels, range) {

  cex <- par("cex.axis")
  w <- max(strwidth(labels, units = "inches", cex = cex)) +
    2 * strwidth("M", units = "inches", cex = cex)

  # the labels never take more than half of the plot region
  share <- min(w / par("pin")[1L], 0.5)

  range * share / (1 - share)
}



# Formatted labels for the ticks of the value axis, with "" for those
# that are skipped: every k-th label is kept, counted from zero, with the
# smallest k that leaves a character width between neighbours. 'ticks'
# are equidistant and start at zero.
.pyramidTickLabels <- function(ax, ticks) {

  labels <- as.character(.axisLabels(ax, ticks))

  if (length(ticks) < 2L)
    return(labels)

  cex <- .splitAxisArgs(ax)$axis$cex.axis %||% par("cex.axis")

  need <- max(strwidth(labels, units = "inches", cex = cex)) +
    strwidth("M", units = "inches", cex = cex)
  step <- diff(ticks[1:2]) / diff(par("usr")[1:2]) * par("pin")[1L]

  k <- max(1L, ceiling(need / step))
  labels[(seq_along(ticks) - 1L) %% k != 0L] <- ""

  labels
}



# Vertical grid lines at the given positions. graphics::grid() places its
# lines at the ticks of the user coordinates, which on the shifted and
# mirrored halves of a pyramid are not the ticks of the value axis; hence
# abline(). Toggle and theme handling as in .drawGrid().
.drawPyramidGrid <- function(grid, at) {

  th <- getTheme()$grid

  lineArgs <- c("col", "lwd", "lty")
  defaults <- list(col = "grey80", lwd = 1, lty = "dotted")
  if (is.list(th))
    defaults <- .modifyListSafe(defaults, th[intersect(names(th), lineArgs)])

  args <- .resolveSpec(.resolveToggle(grid, th), defaults)

  if (is.null(args))
    return(invisible())

  do.call(graphics::abline,
          c(list(v = at), args[intersect(names(args), lineArgs)]))

  invisible()
}
