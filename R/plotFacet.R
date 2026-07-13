
#' Facet Panel Matrix in Base Graphics
#'
#' Draws a lattice-like matrix of panels in base graphics with identical
#' plot region sizes, panel strips, axes on the outer panels only and a
#' user-supplied panel function for the content. Panel gaps are defined in
#' margin lines and remain exact, independent of device size and strip
#' height, as the strip space is reserved separately in the layout.
#'
#' The available device area inside the outer margins is partitioned with
#' \code{\link{layout}} such that all plot regions have exactly the same
#' size in inches. The horizontal gap between two adjacent columns is
#' \code{horiz} margin lines, the vertical gap between two adjacent rows is
#' \code{vert} lines. Since margin lines have the same physical size in
#' both directions, \code{horiz == vert} yields visually equal gaps.
#'
#' The strip is drawn with \code{\link{titleRect}} above each panel. Its
#' height (\code{line} argument of \code{titleRect}) is reserved in the top
#' margin of every panel, so the strip never eats into the gap between the
#' rows.
#'
#' Note that \code{\link{plot.new}} silently reduces \code{cex} (and with
#' it \code{csi}, the physical size of a margin line) in layouts with more
#' than two regions, which would make the realized panel margins deviate
#' from the computed layout. The function therefore controls the character
#' size deterministically via its \code{cex} argument and sets the panel
#' margins in inches (\code{mai}/\code{omi}), so that all plot regions are
#' exactly equal in size.
#'
#' @param samples a list of samples, each a list (or data.frame) with
#'   components \code{x} and \code{y}.
#' @param dim integer vector of length 2, the number of rows and columns
#'   of the panel matrix, \code{c(nrow, ncol)}.
#' @param panelFun the panel function, called per panel as
#'   \code{panelFun(x, y, col, pch, ...)} with a fully set up coordinate
#'   system.
#' @param cols the colors for the panels, recycled to the number of
#'   samples. Default is \code{hcl.colors(n, "Dark 3")}.
#' @param stripLabels the labels for the panel strips. Default is the
#'   sequence along \code{samples}.
#' @param main the main title, placed in the outer margin.
#' @param xlab,ylab the axis labels, placed in the outer margins.
#' @param xlim,ylim the common axis limits for all panels. Default is the
#'   range over all samples.
#' @param mar the margins around the whole panel matrix in lines,
#'   \code{c(bottom, left, top, right)}. The bottom and left margins hold
#'   the axis annotation of the outer panels.
#' @param oma the outer margins in lines, holding \code{xlab}, \code{ylab}
#'   and \code{main}.
#' @param horiz the horizontal gap between adjacent columns in margin
#'   lines.
#' @param vert the vertical gap between adjacent rows in margin lines.
#'   Default is \code{horiz}, yielding physically equal gaps.
#' @param strip controls the panel strips, evaluated by
#'   [bedrock::callIf]: \code{TRUE} (default) draws strips with default
#'   settings, \code{FALSE}/\code{NULL}/\code{NA} suppresses them (no
#'   space is reserved), a named list is passed as arguments to
#'   \code{\link{titleRect}}, e.g.
#'   \code{list(bg = "steelblue", col = "white", line = 1.5)}. The
#'   \code{label} argument is set per panel from \code{stripLabels} and
#'   cannot be overridden.
#' @param bg the background color of the plot regions.
#' @param grid controls the grid lines, evaluated by [bedrock::callIf]:
#'   \code{TRUE} (default) draws grid lines at the positions of
#'   \code{\link{axTicks}} with default settings
#'   (\code{col = "grey85", lwd = 0.8}), \code{FALSE}/\code{NULL}/\code{NA}
#'   suppresses them, a named list is passed as arguments to
#'   \code{\link{abline}}, e.g. \code{list(col = "white", lty = "dotted")}.
#'   The default positions \code{v} and \code{h} can be overridden, e.g.
#'   \code{list(v = seq(0, 20, 5))}.
#' @param cex the character expansion used inside the panels (axis
#'   annotation, strip labels, panel content) and as unit for the panel
#'   margin lines. Default is 0.66, matching R's own reduction in
#'   multi-figure layouts. Set deterministically after each
#'   \code{plot.new()}, see Details.
#' @param pch the plotting character, passed to \code{panelFun}.
#' @param \dots the dots are passed to \code{panelFun}.
#'
#' @return Invisibly returns a list with the realized geometry:
#'   \code{horiz}, \code{vert}, \code{strip_line} (reserved strip height
#'   in lines) and the common plot region size \code{plot_width_in},
#'   \code{plot_height_in} in inches.
#'
#' @examples
#' samples <- lapply(split(ChickWeight, ChickWeight$Chick)[1:25],
#'                   function(z) list(x = z$Time, y = z$weight))
#'
#' my_panel <- function(x, y, col, pch = 16, ...) {
#'   points(x, y, pch = pch, col = col)
#'   abline(lm(y ~ x), lwd = 1)
#' }
#'
#' plotFacet(samples, dim = c(5, 5), panelFun = my_panel,
#'            xlab = "Time", ylab = "Weight", main = "ChickWeight",
#'            strip = list(bg = "grey80", cex = 0.8))
#'
#' @seealso [graphics::layout], [titleRect], [bedrock::callIf]
#'
#' @family graphics.layout
#' @concept facet
#' @concept panel
#'
#' @export
plotFacet <- function(
    samples,
    dim,
    panelFun,
    cols = NULL,
    stripLabels = NULL,
    main = "",
    xlab = "",
    ylab = "",
    xlim = NULL,
    ylim = NULL,
    mar = c(2.5, 2.5, 0.5, 0.5),
    oma = c(3, 3, 4, 1.2),
    horiz = 1,
    vert = NULL,
    strip = TRUE,
    bg = "grey95",
    grid = TRUE,
    cex = 0.66,
    pch = 16,
    ...
) {

  stopifnot(length(dim) == 2, is.list(samples))

  nr <- dim[1]
  nc <- dim[2]
  n_panels <- nr * nc
  n <- length(samples)

  if (n > n_panels)
    stop("More samples than panels available.")

  if (is.null(cols))
    cols <- grDevices::hcl.colors(n, "Dark 3")
  cols <- rep(cols, length.out = n)

  if (is.null(stripLabels))
    stripLabels <- seq_len(n)

  # margin lines have the same physical size horizontally and vertically
  # (mai = mar * csi * mex on all four sides), so no aspect correction needed
  if (is.null(vert))
    vert <- horiz

  # strip geometry: the titleRect() 'line' argument defines the strip
  # height in margin lines and must be reserved in the panel layout
  strip_defaults <- list(bg = "grey85", border = 1, line = 1.2)
  strip_on <- !isFALSE(strip) && !is.null(strip) && !isNA(strip)
  strip_line <- if (!strip_on) 0
                else if (is.list(strip)) strip$line %||% strip_defaults$line
                else strip_defaults$line

  # grid defaults; positions v/h are added per panel from axTicks()
  grid_defaults <- list(col = "grey85", lwd = 0.8)

  if (is.null(xlim))
    xlim <- range(unlist(lapply(samples, `[[`, "x")), na.rm = TRUE)
  if (is.null(ylim))
    ylim <- range(unlist(lapply(samples, `[[`, "y")), na.rm = TRUE)

  oldpar <- par(no.readonly = TRUE)
  on.exit(par(oldpar), add = TRUE)

  # deterministic line sizes in inches: full-size lines for the outer
  # margins, cex-scaled lines for the panel margins (matches what
  # lineToUser()/titleRect() will use at par("cex") == cex)
  line_full <- par("cin")[2] * par("lheight")
  line_in <- line_full * cex
  din <- par("din")

  # available area inside the outer margins
  inner_w <- din[1] - (oma[2] + oma[4]) * line_full
  inner_h <- din[2] - (oma[1] + oma[3]) * line_full

  # margins per column (left to right) and per row (top to bottom), in
  # lines; the strip belongs to EVERY panel and is reserved in the top
  # margin, so the visible gap between rows remains exactly 'vert'
  left_mars   <- c(mar[2], rep(horiz / 2, max(0, nc - 1)))
  right_mars  <- c(rep(horiz / 2, max(0, nc - 1)), mar[4])
  top_mars    <- strip_line + c(mar[3], rep(vert / 2, max(0, nr - 1)))
  bottom_mars <- c(rep(vert / 2, max(0, nr - 1)), mar[1])

  # common plot region size (identical for all panels)
  plot_w <- (inner_w - sum(left_mars + right_mars) * line_in) / nc
  plot_h <- (inner_h - sum(top_mars + bottom_mars) * line_in) / nr

  if (plot_w <= 0 || plot_h <= 0)
    stop("Not enough space for this layout / these margin settings.")

  fig_w <- plot_w + (left_mars + right_mars) * line_in
  fig_h <- plot_h + (top_mars + bottom_mars) * line_in

  lay <- matrix(seq_len(n_panels), nrow = nr, ncol = nc, byrow = TRUE)
  layout(lay, widths = fig_w, heights = fig_h)
  # outer margins in inches: independent of any later csi changes
  par(omi = oma * line_full)

  for (i in seq_len(n_panels)) {

    row_i <- (i - 1) %/% nc + 1
    col_i <- (i - 1) %%  nc + 1

    # panel margins in inches: par(mar) would be converted with the csi
    # that plot.new() shrinks in multi-figure layouts, distorting the
    # plot region sizes
    par(mai = c(bottom_mars[row_i], left_mars[col_i],
                top_mars[row_i],    right_mars[col_i]) * line_in)

    if (i > n) {
      plot.new()
      next
    }

    s <- samples[[i]]

    plot.new()
    # override the automatic multi-figure cex reduction deterministically
    par(cex = cex)
    plot.window(xlim = xlim, ylim = ylim)
    usr <- par("usr")

    # background and grid; default grid positions at the axis ticks,
    # overridable via grid = list(v = ..., h = ...)
    rect(usr[1], usr[3], usr[2], usr[4], col = bg, border = NA)
    callIf(abline, grid,
           defaults = c(list(v = axTicks(1), h = axTicks(2)),
                        grid_defaults))

    # axes on the outer panels only
    if (row_i == nr) axis(1)
    if (col_i == 1)  axis(2, las = 1)

    # panel content
    panelFun(x = s$x, y = s$y, col = cols[i], pch = pch, ...)
    box()

    # strip above the plot region, in the reserved top margin;
    # 'label' is set per panel and must not be overridden (warn once only)
    callIf(titleRect, strip,
           defaults = c(list(label = stripLabels[i]), strip_defaults),
           forbidden = "label", warn = i == 1)
  }

  # outer annotation with explicit full-size cex (par("cex") is 'cex' here)
  if (nzchar(xlab)) mtext(xlab, side = 1, outer = TRUE, line = 1, cex = 1)
  if (nzchar(ylab)) mtext(ylab, side = 2, outer = TRUE, line = 1, cex = 1)
  if (nzchar(main)) mtext(main, side = 3, outer = TRUE, line = 1.5, cex = 1.2)

  invisible(list(
    horiz = horiz,
    vert = vert,
    strip_line = strip_line,
    cex = cex,
    plot_width_in = plot_w,
    plot_height_in = plot_h
  ))
}
