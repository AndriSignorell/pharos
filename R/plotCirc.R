
#' Circular Chord Diagram
#'
#' Draws a chord diagram of a two-way table: the categories of the rows
#' lie as sectors on the right half of a circle, those of the columns on
#' the left half, and every cell of the table is a ribbon between its row
#' and its column sector whose width is proportional to its value.
#'
#' @param x a numeric matrix or two-way table with non-negative entries.
#'   Rows and columns are the two sets of categories; the dimnames give
#'   the labels.
#'
#' @param main main title. `NULL` (default) draws none, unless the theme
#'   sets `autoTitle = TRUE` (see [theme]); the title is then the name of
#'   `x`. `""`, `NA` or `FALSE` always suppress it and compact the top
#'   margin; any other string is used as given.
#'
#' @param gap gap between two sectors, in degrees.
#'
#' @param sector sector styling. Can be:
#' \itemize{
#'   \item `TRUE` (default): the qualitative palette of the active theme
#'     (see [theme]), without border,
#'   \item `FALSE` or `NULL`: no sectors,
#'   \item a vector of colors,
#'   \item a list with the elements `col` and/or `border`.
#' }
#' Colors are given for the rows followed by the columns of `x` and are
#' recycled to their number.
#'
#' @param ribbon ribbon styling. Can be:
#' \itemize{
#'   \item `TRUE` (default): the color of the row sector a ribbon starts
#'     from, with the opacity `opacity`, without border,
#'   \item `FALSE` or `NULL`: no ribbons,
#'   \item a vector of colors, one per row of `x` (recycled),
#'   \item a list with the elements `col` and/or `border`.
#' }
#'
#' @param opacity opacity of the default ribbon colors, between 0 and 1.
#'
#' @param labels label styling. Can be:
#' \itemize{
#'   \item `TRUE` (default): the row and column names of `x`, written
#'     horizontally,
#'   \item `FALSE` or `NULL`: no labels,
#'   \item a character vector of labels, for the rows followed by the
#'     columns of `x`,
#'   \item a list with the elements `labels`, `cex`, `col` and `las`;
#'     `las = 2` writes the labels radially, perpendicular to the circle.
#' }
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/
#'   `NULL`, a string, or a named list for [stamp()].
#' @param ... further graphical parameters passed to [par()] via the
#'   internal framework.
#'
#' @details
#' The size of a sector is the margin total of its category. Within a row
#' sector the ribbons are ordered like the column sectors they lead to,
#' within a column sector like the row sectors, both from top to bottom;
#' this keeps crossings few. Empty cells draw no ribbon.
#'
#' The plot region is enlarged as far as needed for the labels, so that
#' long category names are not cut off.
#'
#' @return Invisibly, a list with the data frame `sectors` (category,
#'   margin (`"row"` or `"col"`), total, start and end angle in radians,
#'   color) and the label positions `x` and `y`.
#'
#' @examples
#' set.seed(1)
#' x <- matrix(sample(1:10, 36, replace = TRUE), nrow = 6,
#'             dimnames = list(LETTERS[1:6], letters[1:6]))
#'
#' plotCirc(x)
#'
#' # a contingency table, radial labels
#' plotCirc(HairEyeColor[, , "Female"], labels = list(las = 2))
#'
#' # own colors and white borders
#' plotCirc(x,
#'          sector = list(col = hcol(), border = "white"),
#'          ribbon = list(border = "white"))
#'
#' @family plot.special
#' @concept frequency-table
#' @concept flow-diagram
#'
#' @export
plotCirc <- function(
    # DATA
    x,

    # LABELS
    main = NULL,

    # STRUCTURE
    gap = 3,

    # STYLE
    opacity = 0.5,

    # FEATURES
    sector = TRUE,
    ribbon = TRUE,
    labels = TRUE,

    # FRAMEWORK
    stamp = .useTheme,

    ...
) {

  mc   <- match.call()
  main <- .resolveTitle(main, default = deparse1(mc$x))

  if (!is.matrix(x) && !(is.table(x) && length(dim(x)) == 2L))
    stop("'x' must be a matrix or a two-way table", call. = FALSE)

  x <- unclass(as.matrix(x))
  if (!is.numeric(x) || anyNA(x) || any(x < 0) || sum(x) == 0)
    stop("'x' must hold non-negative numbers, not all zero", call. = FALSE)

  nr <- nrow(x)
  nc <- ncol(x)
  d  <- degToRad(gap)

  innerR <- 0.94      # ring of the sectors
  outerR <- 1
  labR   <- 1.06      # labels just outside the ring

  # --- sector angles -----------------------------------------------------
  # Rows on the right half, from the top clockwise; columns on the left
  # half, from the top counterclockwise. Each half holds its gaps, half a
  # gap at the top and at the bottom. Angles are in radians, counted
  # counterclockwise from 3 o'clock.

  rowW <- rowSums(x) / sum(x) * (pi - nr * d)
  colW <- colSums(x) / sum(x) * (pi - nc * d)

  rowStart <- pi / 2 - d / 2 - c(0, cumsum(rowW + d)[-nr])   # upper edge
  rowEnd   <- rowStart - rowW
  colStart <- pi / 2 + d / 2 + c(0, cumsum(colW + d)[-nc])   # upper edge
  colEnd   <- colStart + colW

  # --- styling -------------------------------------------------------------

  secCol <- as.character(pal(getTheme()$palette, n = nr + nc))
  sector <- .circStyle(sector, col = secCol, n = nr + nc, arg = "sector")

  rowCol <- (if (is.null(sector)) secCol else sector$col)[seq_len(nr)]
  ribbon <- .circStyle(ribbon, col = grDevices::adjustcolor(rowCol, alpha.f = opacity),
                       n = nr, arg = "ribbon")

  if (is.character(labels))
    labels <- list(labels = labels)

  defLabels <- c(rownames(x) %||% LETTERS[seq_len(nr)],
                 colnames(x) %||% letters[seq_len(nc)])

  drawLabels <- !(is.null(labels) || isFALSE(labels) ||
                    (length(labels) == 1L && !is.list(labels) && is.na(labels)))
  lab <- list(labels = defLabels, cex = 1, col = "grey20", las = 1)
  if (is.list(labels))
    lab[names(labels)] <- labels
  lab$labels <- rep_len(as.character(lab$labels), nr + nc)

  # label angle: the middle of each sector, rows first
  theta <- c((rowStart + rowEnd) / 2, (colStart + colEnd) / 2)
  pos   <- polToCart(labR, theta)

  .withGraphicsState({

    .applyParFromDots(...,
                      defaults = list(
                        mar = c(bottom = 1, left = 1, top = .marTop(main),
                                right = 1),
                        xpd = NA))

    # Half width of the plot region in user units, so that no label is
    # cut off. A label at angle theta reaches labR * |cos| + its share of
    # the text width along x (labR * |sin| + height along y); the text
    # size is fixed in inches, the user units scale with the limit, hence
    # lim >= reach / (1 - 2 * share / side) for the square region.
    lim <- 1.08
    if (drawLabels) {
      side <- min(par("pin"))
      w  <- strwidth(lab$labels, units = "inches", cex = lab$cex)
      h  <- strheight(lab$labels, units = "inches", cex = lab$cex)
      ac <- abs(cos(theta))
      as <- abs(sin(theta))
      if (isTRUE(lab$las == 2)) {
        wx <- w * ac
        hy <- w * as
      } else {
        wx <- w * ifelse(ac > 0.15, 1, 0.5)
        hy <- h * ifelse(as > 0.15, 1, 0.5)
      }
      need <- c((labR * ac + 0.02) / pmax(0.3, 1 - 2 * wx / side),
                (labR * as + 0.02) / pmax(0.3, 1 - 2 * hy / side))
      lim <- max(lim, need)
    }

    canvas(xlim = c(-lim, lim), main = if (nzchar(main)) main else NULL)

    # --- ribbons ---------------------------------------------------------
    # One ribbon per non-empty cell, stacked within the row sector in
    # column order and within the column sector in row order.

    if (!is.null(ribbon)) {

      rowCut <- rowStart - t(apply(x, 1, function(v)
        c(0, cumsum(v)))) / sum(x) * (pi - nr * d)          # nr x (nc + 1)
      colCut <- sweep(apply(x, 2, function(v) c(0, cumsum(v))) /
                        sum(x) * (pi - nc * d),
                      2L, colStart, "+")                    # (nr + 1) x nc

      for (i in seq_len(nr)) for (j in seq_len(nc)) {
        if (x[i, j] == 0)
          next
        .circRibbon(rowCut[i, j], rowCut[i, j + 1L],
                    colCut[i, j], colCut[i + 1L, j],
                    r = innerR, col = ribbon$col[i], border = ribbon$border[i])
      }
    }

    # --- sectors ---------------------------------------------------------

    if (!is.null(sector)) {
      from <- c(rowEnd, colStart)
      to   <- c(rowStart, colEnd)
      for (k in seq_len(nr + nc)) {
        a <- .circArc(outerR, from[k], to[k])
        b <- .circArc(innerR, to[k], from[k])
        polygon(c(a$x, b$x), c(a$y, b$y),
                col = sector$col[k], border = sector$border[k])
      }
    }

    # --- labels ----------------------------------------------------------

    if (drawLabels) {

      cs <- cos(theta)

      if (isTRUE(lab$las == 2)) {
        # radial, read from the circle outwards; on the left half turned
        # by 180 degrees so that no label stands upside down
        left <- cs < 0
        srt  <- radToDeg(theta) + ifelse(left, 180, 0)
        for (k in seq_along(theta))
          text(pos$x[k], pos$y[k], lab$labels[k], srt = srt[k],
               adj = c(if (left[k]) 1 else 0, 0.5),
               cex = lab$cex, col = lab$col)
      } else {
        # horizontal, anchored on the side facing the circle
        sn <- sin(theta)
        for (k in seq_along(theta))
          text(pos$x[k], pos$y[k], lab$labels[k],
               adj = c(if (cs[k] > 0.15) 0 else if (cs[k] < -0.15) 1 else 0.5,
                       if (sn[k] > 0.15) 0 else if (sn[k] < -0.15) 1 else 0.5),
               cex = lab$cex, col = lab$col)
      }
    }

  }, stamp = stamp)

  invisible(list(
    sectors = data.frame(
      category = c(rownames(x) %||% LETTERS[seq_len(nr)],
                   colnames(x) %||% letters[seq_len(nc)]),
      margin = rep(c("row", "col"), c(nr, nc)),
      total  = c(rowSums(x), colSums(x)),
      start  = c(rowStart, colStart),
      end    = c(rowEnd, colEnd),
      col    = if (is.null(sector)) NA_character_ else sector$col,
      row.names = NULL),
    x = pos$x, y = pos$y))
}




# == internal helper functions =============================================


# Resolves the 'sector' and 'ribbon' arguments of plotCirc() to a list with
# the recycled elements 'col' and 'border', or to NULL if the element is
# not to be drawn.
.circStyle <- function(x, col, n, arg, border = NA) {

  if (is.null(x) || isFALSE(x))
    return(NULL)

  sty <- list(col = col, border = border)

  if (is.list(x)) {

    if (is.null(names(x)) || !all(names(x) %in% names(sty)))
      stop(gettextf(
        "'%s' must be TRUE, FALSE, a vector of colors or a list with the elements 'col' and/or 'border'",
        arg), call. = FALSE)

    sty[names(x)] <- x

  } else if (!isTRUE(x)) {
    sty$col <- x
  }

  lapply(sty, rep, length.out = n)
}


# Points on a circle of radius r from angle 'from' to angle 'to'
.circArc <- function(r, from, to, n = max(2L, ceiling(abs(to - from) / 0.02)))
  polToCart(r, seq(from, to, length.out = n))


# Quadratic Bezier curve from p0 to p2 with the control point in the
# centre of the circle
.circBezier <- function(p0, p2, n = 60) {
  t <- seq(0, 1, length.out = n)
  list(x = (1 - t)^2 * p0$x + t^2 * p2$x,
       y = (1 - t)^2 * p0$y + t^2 * p2$y)
}


# One ribbon between the row arc [r1, r2] and the column arc [c1, c2]
# (r1, c1 the upper edges). The upper edges are joined with each other and
# the lower ones, so the ribbon does not twist.
.circRibbon <- function(r1, r2, c1, c2, r, col, border) {

  rowArc <- .circArc(r, r1, r2)
  colArc <- .circArc(r, c2, c1)
  down   <- .circBezier(polToCart(r, r2), polToCart(r, c2))
  up     <- .circBezier(polToCart(r, c1), polToCart(r, r1))

  polygon(c(rowArc$x, down$x, colArc$x, up$x),
          c(rowArc$y, down$y, colArc$y, up$y),
          col = col, border = border)
}
