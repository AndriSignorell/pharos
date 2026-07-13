
#' Direct Labels in the Right Margin
#'
#' Draw a legend in the right margin consisting of short line segments
#' and text labels, placed next to the (typically last) values of the
#' plotted series. This labels lines directly instead of using a boxed
#' \code{\link{legend}()}, as commonly preferred for time series and
#' profile plots.
#'
#' The function owns the legend geometry: the anchor positions \code{y}
#' are sorted internally so the legend follows the vertical order of the
#' lines, the graphical parameters are recycled accordingly, and vertical
#' label collisions are resolved via \code{spreadOut()}. Callers therefore
#' simply pass the values in series order, parallel to \code{col},
#' \code{lty} and \code{lwd}.
#'
#' Drawing uses \code{\link{mtext}()} and \code{\link{segments}()} in the
#' device margin; \code{xpd} is set to \code{TRUE} and restored on exit.
#' Horizontal positions are given in margin lines of side 4 and converted
#' to user coordinates via \code{lineToUser()}.
#'
#' @param y numeric vector with the vertical anchor positions in user
#'   coordinates, typically the last observed value of each series, in
#'   series (column) order. Sorting and collision handling are done
#'   internally.
#' @param labels character vector of labels, parallel to \code{y}.
#'   Defaults to \code{names(y)}, or the series index if \code{y} is
#'   unnamed.
#' @param line numeric vector of length 1 or 2 (recycled), in margin
#'   lines of side 4. The first element is the offset of the segments
#'   from the plot region, the second the gap between segments and
#'   labels.
#' @param width length of the line segments in margin lines. Set to
#'   \code{NA} to suppress the segments; the labels are then placed
#'   directly at \code{line[1]}.
#' @param col,lty,lwd color, line type and width of the segments,
#'   parallel to \code{y} (in series order, recycled). Ignored if
#'   \code{width} is \code{NA}.
#' @param cex character expansion for the labels. Also enters the
#'   default vertical spacing, so larger text automatically gets wider
#'   spacing.
#' @param main optional title for the legend, drawn at the top of the
#'   plot region. Default is \code{NULL} (none).
#' @param mindist minimal vertical distance between labels in user
#'   coordinates, passed to \code{spreadOut()}. Default is
#'   \code{1.2 * strheight("M") * cex}.
#'
#' @return The (sorted and spread) vertical label positions, invisibly.
#'   Useful for adding further annotation next to the labels.
#'
#' @details Make sure the right margin is wide enough for segments and
#'   labels, e.g. via the \code{mar} argument of the calling plot
#'   function.
#'
#' @seealso \code{\link{plotLines}}, \code{\link{mtext}},
#'   \code{\link{segments}}, \code{\link{legend}}
#'
#' @examples
#' m <- EuStockMarkets[seq(1, 1860, 10), ]
#' op <- par(mar = c(5, 4, 4, 8))
#' matplot(m, type = "l", lty = 1, lwd = 2, col = 1:4, las = 1,
#'         main = "EU Stock Markets")
#' textLegend(y = m[nrow(m), ], labels = colnames(m),
#'            col = 1:4, lwd = 2, main = "Index")
#' par(op)
#'



#' @family graphics.annotation
#' @concept annotation
#'
#'
#' @export
#' 
textLegend <- function(y, labels = names(y),
                       line = c(1, 1), width = 1,
                       col = par("fg"), lty = par("lty"), lwd = par("lwd"),
                       cex = par("cex"), main = NULL,
                       mindist = NULL) {
  
  # y:      vertical anchor positions in user coordinates, typically the
  #         last observed value per series, in *series order* -- the
  #         parallel vectors (labels, col, lty, lwd) align by position.
  #         Sorting and collision handling happen here, not at the caller.
  
  # not needed here...
  # op <- par(xpd = TRUE)
  # on.exit(par(op))
  
  n      <- length(y)
  labels <- labels %||% as.character(seq_len(n))
  col    <- rep_len(col, n)
  lty    <- rep_len(lty, n)
  lwd    <- rep_len(lwd, n)
  
  # sort by value so the legend follows the vertical order of the lines
  ord <- order(y)
  y      <- y[ord]
  labels <- labels[ord]
  col    <- col[ord]
  lty    <- lty[ord]
  lwd    <- lwd[ord]
  
  # resolve vertical label collisions; mindist scales with the *effective*
  # cex (after callIf merging), so a user cex in the legend list
  # automatically widens the spacing -- no peeking from the caller needed
  mindist <- mindist %||% (1.2 * strheight("M") * cex)
  ypos    <- spreadOut(y, mindist = mindist)
  
  line    <- rep(line, length.out = 2)
  txtline <- line[1] + naReplace(width + (!is.na(width)) * line[2], 0)
  
  mtext(side = 4, las = 1, cex = cex, text = labels,
        line = txtline, at = ypos)
  
  if (!is.na(width))
    segments(x0 = lineToUser(line[1], 4),
             x1 = lineToUser(line[1] + width, 4),
             y0 = ypos, col = col, lty = lty, lwd = lwd, lend = 1)
  
  if (!is.null(main))
    mtext(side = 4, text = main, las = 1, line = line[1],
          at = par("usr")[4], padj = 0)
  
  invisible(ypos)
  
}

