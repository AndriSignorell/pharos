
#' Association Plot for Contingency Tables
#'
#' Plots an association plot (Cohen-Friendly plot) for a two-dimensional
#' contingency table. Cells are drawn with widths proportional to the square
#' root of expected frequencies and heights proportional to Pearson residuals.
#' Color encodes both the direction and strength of the association using a
#' diverging palette.
#'
#' @param x a two-dimensional contingency table (\code{table} or \code{matrix}).
#' @param col character vector of colors for the diverging palette. Default
#'   uses \code{pal("RedWhiteBlue3", n = 100)} from the DescToolsX theme.
#'   Negative residuals map to the first color, zero to the middle, positive
#'   to the last.
#' @param border the color of the border
#' @param space numeric, fraction of average cell width/height used as gap
#'   between cells. Default \code{0.3}.
#' @param reorder logical. If \code{TRUE} (default), rows and columns are
#'   reordered by the strength of the strongest association
#'   (\code{max(|residual|)}) in descending order.
#' @param labels logical or character. If \code{TRUE}, Pearson residuals are
#'   printed inside each cell. If \code{FALSE} (default), no labels are shown.
#'   A character format string (e.g. \code{"\%.1f"}) can also be passed for
#'   custom formatting.
#' @param cex.labels numeric, character expansion for cell labels.
#'   Default \code{0.7}.
#' @param main character, plot title.
#' @param xlab character, x-axis label. Defaults to the first dimension name.
#' @param ylab character, y-axis label. Defaults to the second dimension name.
#' @param \dots further arguments passed to \code{\link[graphics]{rect}}.
#'
#' @details
#' The plot is based on the association plot described in Cohen (1980) and
#' Friendly (1992). Each cell \eqn{(i,j)} is represented by a rectangle:
#' \itemize{
#'   \item \strong{width} proportional to \eqn{\sqrt{e_{ij}}}
#'     (square root of expected frequency)
#'   \item \strong{height} proportional to the Pearson residual
#'     \eqn{d_{ij} = (f_{ij} - e_{ij}) / \sqrt{e_{ij}}}
#' }
#' A horizontal baseline at zero represents independence. Cells above the
#' baseline indicate positive association, cells below negative association.
#'
#' Color encodes both direction and magnitude: the diverging palette runs from
#' the negative color (strong negative residual) through white (no association)
#' to the positive color (strong positive residual).
#'
#' @references
#'   Cohen, A. (1980). On the graphical display of the significant components
#'   of a two-way contingency table. \emph{Communications in Statistics —
#'   Theory and Methods}, 9, 1025--1041.
#'
#'   Friendly, M. (1992). Graphical methods for categorical data.
#'   \emph{SAS User Group International Conference Proceedings}, 17, 190--200.
#'
#' @seealso \code{\link[graphics]{mosaicplot}}, \code{\link{plotMosaic}},
#'   \code{\link[DescToolsX]{conf}}
#'
#' @examples
#' tab <- table(bedrock::Pizza$driver, bedrock::Pizza$area)
#'
#' # default
#' plotAssoc(tab)
#'
#' # custom palette
#' plotAssoc(tab, col = pal("RedWhiteGreen", n = 100))
#'
#' # with residual labels
#' plotAssoc(tab, labels = TRUE)
#'
#' # no reordering
#' plotAssoc(tab, reorder = FALSE)
#' 
#'  
#' plotAssoc(tab,
#'           main = "Association Hair ~ Eye",
#'           cutoff = 1,
#'           xlab="Hair Color", ylab="Eye Color")
#' 
#' cols <- pal()[c(12, 8)]
#' plotAssoc(tab,
#'           main = "Association Hair ~ Eye",
#'           cutoff = 1, 
#'           col = fade(cols, 0.7), border = cols,
#'           reorder = TRUE, cex.axis = 0.9, 
#'           xlab = list(labels = "Hair Color ", 
#'                     col = "#5B2A45", cex = 1.1), 
#'           ylab = NA, labels = TRUE)
#' 


#' @family plot.bivariate
#' @concept graphics
#' @concept association-measures
#' @concept table-manipulation
#'
#'
#' @export
plotAssoc <- function(x,
                      col        = pal("RedWhiteBlue3", n = 100L),
                      border     = NA,
                      space      = 0.3,
                      reorder    = TRUE,
                      labels     = FALSE,
                      cex.labels = 0.7,
                      main       = NULL,
                      xlab       = TRUE,
                      ylab       = TRUE,
                      ...) {
  
  x <- revX(t(x), 2)
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # ── Layout / Margins ─────────────────────────────────────────
    par(mar = c(1, 5.5, 7.5, 2))
    
    
    # ── Input checks ─────────────────────────────────────────────
    if (length(dim(x)) != 2L)
      stop("'x' must be a 2-dimensional contingency table")
    
    if (any(x < 0, na.rm = TRUE) || anyNA(x))
      stop("all entries of 'x' must be nonnegative and finite")
    
    if ((n <- sum(x)) == 0L)
      stop("at least one entry of 'x' must be positive")
    
    x <- as.table(x)
    
    # ── Residuals ────────────────────────────────────────────────
    f <- x
    
    e <- outer(rowSums(f), colSums(f)) / n
    d <- (f - e) / sqrt(e)
    s <- sqrt(e)
    
    # ── Reorder ──────────────────────────────────────────────────
    if (reorder) {
      row_ord <- order(apply(abs(d), 1L, max), decreasing = TRUE)
      col_ord <- order(apply(abs(d), 2L, max), decreasing = FALSE)
      
      f <- f[row_ord, col_ord, drop = FALSE]
      e <- e[row_ord, col_ord, drop = FALSE]
      d <- d[row_ord, col_ord, drop = FALSE]
      s <- s[row_ord, col_ord, drop = FALSE]
    }
    
    # ── Layout geometry ──────────────────────────────────────────
    x.w     <- apply(s, 1L, max)
    y.h     <- apply(d, 2L, max) - apply(d, 2L, min)
    x.delta <- mean(x.w) * space
    y.delta <- mean(y.h) * space
    
    xlim <- c(0, sum(x.w) + length(x.w) * x.delta)
    ylim <- c(0, sum(y.h) + length(y.h) * y.delta)
    
    # ── Colors ───────────────────────────────────────────────────
    d_abs_max <- max(abs(d), na.rm = TRUE)
    if (d_abs_max == 0) d_abs_max <- 1
    
    npal <- length(col)
    mid  <- (npal + 1L) / 2
    
    .cellCol <- function(resid) {
      idx <- round(mid + resid / d_abs_max * (mid - 1))
      idx <- pmax(1L, pmin(npal, idx))
      col[idx]
    }

    border <-  rep(border, 2)
    .bordCol <- function(resid) {
      if(resid < 0) 
        border[1]
      else 
        border[2]
    }
        
    # ── Plot ─────────────────────────────────────────────────────
    plot.new()
    plot.window(xlim, ylim)
    
    x.r <- cumsum(x.w + x.delta)
    x.m <- (c(0, head(x.r, -1)) + x.r) / 2
    
    y.u <- cumsum(y.h + y.delta)
    y.m <- y.u - apply(pmax(d, 0), 2L, max) - y.delta / 2
    
    # ── Draw rectangles ──────────────────────────────────────────
    for (i in seq_len(nrow(f))) {
      for (j in seq_len(ncol(f))) {
        
        rect(
          x.m[i] - s[i, j] / 2,
          y.m[j],
          x.m[i] + s[i, j] / 2,
          y.m[j] + d[i, j],
          col    = .cellCol(d[i, j]),
          border = .bordCol(d[i, j])
        )
        
        if (!identical(labels, FALSE)) {
          fmt <- if (is.character(labels)) labels else "%.1f"
          
          text(
            x.m[i],
            y.m[j] + d[i, j] / 2,
            labels = sprintf(fmt, d[i, j]),
            cex    = cex.labels,
            col    = if (abs(d[i, j]) > d_abs_max * 0.6) "white" else "black"
          )
        }
      }
    }
    
    # ── Axes (table-style) ───────────────────────────────────────
    axis(3, at = x.m, labels = rownames(f), tick = FALSE, line = -0.5)
    axis(2, at = y.m, labels = colnames(f), tick = FALSE, las = 1)
    
    abline(h = c(par("usr")[4], y.m), lty = 2, col = "grey60")

    # ── Labels (table style) ─────────────────────────────────────
    ndn <- function(x, i=1) names(dimnames(x))[i]
     
    # Title
    title(main = main, line = 5)
    
    # Column label (top-left)
    if (is.character(xlab)){
      names(dimnames(x))[1] <- xlab
      xlab <- TRUE
    }
    bedrock::callIf(text, arg=xlab,
            defaults=list(
              x = par("usr")[1],
              y = max(y.m) + diff(range(y.m)) * 0.2,
              labels = gettextf("%s ", ndn(x ) %||% "rows"),
              col="brown",
              adj = 1,   # aligned to the right!
              font = 2, cex=1.2, xpd=NA
            ))

    # Row label (top-left)
    if (is.character(ylab)){
      names(dimnames(x))[2] <- ylab
      ylab <- TRUE
    }
    bedrock::callIf(text, arg=ylab,
            defaults=list(
              x = par("usr")[1],
              y = par("usr")[4] + 4*strheight("Mg", units = "user"),
              labels = ndn(x, 2) %||% "columns",
              col="brown",
              adj = 0,   # aligned to the left!
              font = 2, cex=1.2, xpd=NA
            ))

  })
  
  invisible(list(x=x.m, 
                 y=y.m))
}


