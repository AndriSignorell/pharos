
#' Plot Methods for Lorenz Curve Objects
#'
#' Visualize objects of class \code{"Lc"} and \code{"LcList"} returned by
#' \code{\link[DescToolsX]{lc}()}.  The \code{plot()} method draws a new
#' Lorenz curve plot including the line of perfect equality; \code{lines()}
#' and \code{points()} add to an existing plot.
#'
#' For \code{"LcList"} objects (grouped Lorenz curves), \code{plot()} draws
#' the first group and overlays the remaining groups with \code{lines()}.
#' Colors cycle automatically when \code{col} is not supplied.
#'
#' The confidence band in \code{lines.Lc()} is drawn via \code{cbandArgs}.
#' Pass a list of arguments to \code{\link[DescToolsX]{predict.Lc}()} to
#' control the bootstrap (e.g. \code{cbandArgs = list(conf.level = 0.90,
#' n = 500)}).  Set \code{cbandArgs = NA} (default) to suppress the band.
#'
#' @name plot.Lc
#'
#' @param x Object of class \code{"Lc"} (for \code{plot.Lc()},
#'   \code{lines.Lc()}, \code{points.Lc()}) or \code{"LcList"} (for the
#'   \code{*.LcList()} methods).
#' @param general Logical.  If \code{TRUE}, the generalized Lorenz curve
#'   (scaled by the mean) is displayed instead of the standard curve.
#'   Default is \code{FALSE}.  Used by \code{plot.Lc()}, \code{lines.Lc()},
#'   and \code{points.Lc()}; for the \code{"LcList"} methods it is passed
#'   through \code{...} to the underlying \code{Lc} method.
#' @param main,xlab,ylab Main title and axis labels, used by
#'   \code{plot.Lc()} only.  Defaults are \code{NULL}, \code{"p"}, and
#'   \code{"L(p)"}, respectively.
#' @param xlim,ylim Numeric vectors of length 2 giving axis limits, used by
#'   \code{plot.Lc()} only.  Default \code{NULL}, which resolves to
#'   \code{c(0, 1)}.
#' @param line Logical or list, used by \code{plot.Lc()} to control drawing
#'   of the Lorenz curve line.  \code{TRUE} (default) draws the line with
#'   package defaults (\code{col = "black"}, \code{lty = 1}, \code{lwd = 2});
#'   \code{FALSE} suppresses it; a list overrides individual defaults and is
#'   forwarded to \code{\link[graphics]{lines}()}.
#' @param points Logical or list, used by \code{plot.Lc()} to control drawing
#'   of points on the Lorenz curve.  \code{TRUE} (default) draws points with
#'   package defaults (\code{pch = 21}, \code{bg = "white"},
#'   \code{col = "black"}, \code{cex = 1.4}); \code{FALSE} suppresses them; a
#'   list overrides individual defaults and is forwarded to
#'   \code{\link[graphics]{points}()}.
#' @param grid Logical or list, used by \code{plot.Lc()} only.  If
#'   \code{TRUE} (default) or a list, a grid is drawn before the curve via
#'   \code{\link[graphics]{grid}()}; a list is forwarded as arguments to that
#'   function.
#' @param box Logical, used by \code{plot.Lc()} only.  If \code{TRUE}
#'   (default), a box is drawn around the plot area.
#' @param col Color for the curve or points.  For \code{lines.Lc()} and
#'   \code{points.Lc()}, a single color (default \code{NULL}, i.e. the
#'   current device default).  For the \code{"LcList"} methods, a vector
#'   recycled over groups (default \code{NULL}, i.e. \code{seq_len(k)}).
#' @param lwd Line width, used by \code{lines.Lc()} only.  Default is
#'   \code{2}.
#' @param lty Line type, used by \code{lines.Lc()} only.  Default is
#'   \code{1}.
#' @param pch Plotting symbol, used by \code{points.Lc()} only.  Default is
#'   \code{16}.
#' @param cbandArgs Used by \code{lines.Lc()} only.  \code{NA} to suppress
#'   the confidence band (default), or a list of arguments passed to
#'   \code{\link[DescToolsX]{predict.Lc}()} to control bootstrap confidence
#'   intervals.
#' @param ... Further arguments.  For \code{plot.Lc()}, graphical parameters
#'   passed to \code{\link[graphics]{par}()} via \code{.applyParFromDots()}
#'   (e.g. \code{mar}, \code{cex.axis}, \code{las}).  For \code{lines.Lc()}
#'   and \code{points.Lc()}, further arguments passed on to
#'   \code{\link[graphics]{lines}()} and \code{\link[graphics]{points}()},
#'   respectively.  For the \code{"LcList"} methods, arguments passed through
#'   to the corresponding \code{Lc} method for each group.
#'
#' @return All methods return \code{NULL} invisibly.
#'
#' @seealso
#'   \code{\link[DescToolsX]{lc}()} for computing the Lorenz curve,
#'   \code{\link[DescToolsX]{predict.Lc}()} for bootstrap confidence
#'   intervals, \code{\link[DescToolsX]{gini}()} for the Gini coefficient.
#'
#' @family inequality
#' @concept inequality
#' @concept graphics
NULL


#' @rdname plot.Lc

#' @family plot.s3  
#' @concept inequality
#'
#'
#' @export
plot.Lc <- function(
    
  # DATA
  x,
  
  # LABELS
  main = NULL,
  xlab = "p",
  ylab = "L(p)",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # STRUCTURE
  general = FALSE,
  
  # STYLE
  line = TRUE,
  points = TRUE,

  grid = TRUE,
  box = TRUE,
  ...
) {
  
  if (!inherits(x, "Lc"))
    stop("x must be of class 'Lc'")
  
  .withGraphicsState({
    
    .applyParFromDots(...,
                      defaults = list(
                        pty="s",
                        mar = c(
                          left  = 5,
                          top   = .marTop(main)
                        )
                      ))
    
    # --- data selection ---
    L <- if (!general) x$L else x$L.general
    p <- x$p
    
    # --- axis limits ---
    if (is.null(xlim)) xlim <- c(0, 1)
    if (is.null(ylim)) ylim <- c(0, 1)
    
    # --- base plot ---
    plot(
      p, L,
      type = "n",
      main = main,
      xlab = xlab,
      ylab = ylab,
      xlim = xlim,
      ylim = ylim, 
      xaxs="i", 
      yaxs="i"
    )
    
    # --- grid ---
    callIf(
      graphics::grid,
      grid,
      defaults = list(
        col = "grey90", 
        lty = 1)
    )
    
    # --- Lorenz curve ---
    callIf(
      graphics::lines,
      line,
      defaults = list(
        x = p, 
        y = L, 
        col = "black", 
        lty = 1, 
        lwd = 2)
    )

    # --- equality line ---
    abline(0, 1, col = "grey50", lty = 2)
    
    # --- box ---
    if (isTRUE(box)) box()
    
    # --- points ---
    callIf(
      graphics::points,
      points,
      defaults = list(
        x = p, 
        y = L, 
        col = "black", 
        pch = 21,
        bg = "white",
        cex = 1.4, 
        xpd = NA
        )
    )
    
    
  })
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
  cbandArgs = NA,
  
  ...
  
) {
  
  if (!inherits(x, "Lc"))
    stop("x must be of class 'Lc'")
  
  # --- select curve ---
  L <- if (!general) x$L else x$L.general
  
  # --- confidence band ---
  ci <- callIf(
    predict,
    cbandArgs,
    defaults = list(
      object = x,
      conf.level = 0.95,
      general = general
    ),
    forbidden = c("col", "border")
  )
  
  callIf(
    .drawBandCI,
    cbandArgs,
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




#' @rdname plot.Lc
#' @export
lines.LcList <- function(x, col = NULL, ...) {
  
  k <- length(x)
  
  if (is.null(col))
    col <- seq_len(k)
  
  for (i in seq_along(x)) {
    lines(x[[i]], col = col[i], ...)
  }
  
  invisible(NULL)
}




#' @rdname plot.Lc
#' @export
points.LcList <- function(x, col = NULL, ...) {
  
  k <- length(x)
  
  if (is.null(col))
    col <- seq_len(k)
  
  for (i in seq_along(x)) {
    points(x[[i]], col = col[i], ...)
  }
  
  invisible(NULL)
}



#' @rdname plot.Lc
#' @export
plot.LcList <- function(x, col = NULL, ...) {
  
  k <- length(x)
  
  if (k == 0)
    stop("empty LcList")
  
  if (is.null(col))
    col <- seq_len(k)
  
  plot(x[[1]], col = col[1], ...)
  
  if (k > 1) {
    for (i in 2:k) {
      lines(x[[i]], col = col[i], ...)
    }
  }
  
  invisible(NULL)
}

