
#' Plot Methods for Lorenz Curve Objects
#'
#' Visualize objects of class \code{"lc"} and \code{"lclist"} returned by
#' \code{\link[DescToolsX]{lc}()}.  The \code{plot()} method draws a new
#' Lorenz curve plot including the line of perfect equality; \code{lines()}
#' and \code{points()} add to an existing plot.
#'
#' For \code{"lclist"} objects (grouped Lorenz curves), \code{plot()} draws
#' the first group and overlays the remaining groups with \code{lines()}.
#' Colors cycle automatically when \code{col} is not supplied.
#'
#' The confidence band in \code{lines.lc()} is drawn via \code{cbandArgs}.
#' Pass a list of arguments to \code{\link[DescToolsX]{predict.lc}()} to
#' control the bootstrap (e.g. \code{cbandArgs = list(conf.level = 0.90,
#' n = 500)}).  Set \code{cbandArgs = NA} (default) to suppress the band.
#'
#' @name plot.lc
#' 
#' @param x Object of class \code{"lc"} or \code{"lclist"}.
#' @param general Logical.  If \code{TRUE}, the generalized Lorenz curve
#'   (scaled by the mean) is displayed instead of the standard curve.
#'   Default is \code{FALSE}.
#' @param main,xlab,ylab Main title and axis labels passed to
#'   \code{\link[graphics]{plot.default}()}.
#' @param xlim,ylim Numeric vectors of length 2 giving axis limits.
#' @param col Color(s) for the curve(s).  For \code{"lclist"} methods,
#'   recycled over groups; defaults to \code{1:k}.
#' @param lwd Line width.  Default is \code{2}.
#' @param lty Line type.  Default is \code{1}.
#' @param pch Plotting symbol.  If \code{NULL} (default in
#'   \code{plot.lc()}), no points are drawn.
#' @param grid Logical or list.  If \code{TRUE} or a list, a grid is drawn
#'   before the curve.  A list is forwarded as arguments to
#'   \code{\link[graphics]{grid}()}.
#' @param box Logical.  If \code{TRUE} (default), a box is drawn around the
#'   plot area.
#' @param cbandArgs \code{NA} to suppress the confidence band (default), or
#'   a list of arguments passed to \code{\link[DescToolsX]{predict.lc}()} to
#'   control bootstrap confidence intervals.
#' @param stamp Optional character string or list.  Passed to the aurora
#'   graphics framework for plot annotation.
#' @param ... Further graphical arguments passed to the underlying
#'   \code{\link[graphics]{lines}()}, \code{\link[graphics]{points}()}, or
#'   \code{\link[graphics]{plot.default}()} call.
#'
#' @return All methods return the input object \code{x} invisibly.
#'
#' @seealso
#'   \code{\link[DescToolsX]{lc}()} for computing the Lorenz curve,
#'   \code{\link[DescToolsX]{predict.lc}()} for bootstrap confidence
#'   intervals, \code{\link[DescToolsX]{gini}()} for the Gini coefficient.
#'
#' @family inequality
#' @concept inequality
#' @concept graphics
NULL


#' @rdname plot.lc
#' @export
plot.lc <- function(
    
  # DATA
  x,
  
  # LABELS
  main = "Lorenz curve",
  xlab = "p",
  ylab = "L(p)",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # STRUCTURE
  general = FALSE,
  
  # STYLE
  col = NULL,
  lwd = 2,
  lty = 1,
  pch = NULL,
  grid = FALSE,
  box = TRUE,
  
  # FRAMEWORK
  stamp = NULL,
  
  ...
) {
  
  if (!inherits(x, "lc"))
    stop("x must be of class 'lc'")
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
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
      ylim = ylim
    )
    
    # --- grid ---
    callIf(
      graphics::grid,
      grid,
      defaults = list(col = "grey90", lty = 1)
    )
    
    # --- Lorenz curve ---
    lines(p, L, col = col, lwd = lwd, lty = lty)
    
    # --- equality line ---
    abline(0, 1, col = "grey50", lty = 2)
    
    # --- points ---
    if (!is.null(pch)) {
      points(p, L, pch = pch, col = col)
    }
    
    # --- box ---
    if (isTRUE(box)) box()
    
  }, stamp = stamp)
}


#' @rdname plot.lc
#' @export
lines.lc <- function(
    
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
  
  if (!inherits(x, "lc"))
    stop("x must be of class 'lc'")
  
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

#' @rdname plot.lc
#' @export
points.lc <- function(
    
  # DATA
  x,
  
  # STRUCTURE
  general = FALSE,
  
  # STYLE
  pch = 16,
  col = NULL,
  
  ...
) {
  
  if (!inherits(x, "lc"))
    stop("x must be of class 'lc'")
  
  # --- select curve ---
  L <- if (!general) x$L else x$L.general
  
  # --- draw points ---
  points(x$p, L, pch = pch, col = col, ...)
  
  invisible(NULL)
}




#' @rdname plot.lc
#' @export
lines.lclist <- function(x, col = NULL, ...) {
  
  k <- length(x)
  
  if (is.null(col))
    col <- seq_len(k)
  
  for (i in seq_along(x)) {
    lines(x[[i]], col = col[i], ...)
  }
  
  invisible(NULL)
}




#' @rdname plot.lc
#' @export
points.lclist <- function(x, col = NULL, ...) {
  
  k <- length(x)
  
  if (is.null(col))
    col <- seq_len(k)
  
  for (i in seq_along(x)) {
    points(x[[i]], col = col[i], ...)
  }
  
  invisible(NULL)
}



#' @rdname plot.lc
#' @export
plot.lclist <- function(x, col = NULL, ...) {
  
  k <- length(x)
  
  if (k == 0)
    stop("empty lclist")
  
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

