
#' Line Plot for Multiple Series
#'
#' Draws one or several line series using \code{\link[graphics]{matplot}}.
#' The function accepts either a matrix of values or separate \code{x} and
#' \code{y} coordinates and supports optional point symbols, grid lines,
#' and an automatically positioned legend.
#'
#' @param x Numeric vector, matrix or data frame. If \code{y} is missing,
#'   \code{x} is interpreted as a matrix of series where rows correspond to
#'   x positions and columns to individual lines.
#' @param y Optional numeric vector or matrix giving the y-values. If supplied,
#'   \code{x} is interpreted as the x-coordinates.
#'
#' @param main Main title of the plot. \code{NULL} (default) derives a title
#'   from the input. \code{""}, \code{NA}, or \code{FALSE} suppress the title
#'   and compact the top margin.
#' @param xlab,ylab Labels for the axes.
#'
#' @param xlim,ylim Limits for the axes.
#'
#' @param lty Line type(s).
#' @param lwd Line width(s).
#' @param xaxt,yaxt Axis specification passed to \code{\link[graphics]{axis}}.
#'
#' @param col Colours for the lines. \code{.useTheme} (default) resolves to
#'   \code{pal(getTheme()$palette)}, the active theme's qualitative palette.
#' @param points Controls drawing of points on the lines. \code{FALSE}
#'   (default) suppresses points; \code{TRUE} draws with theme defaults
#'   (\code{getTheme()$points}); a named list overrides individual elements
#'   (\code{pch}, \code{col}, \code{bg}, \code{cex}).
#' @param grid Controls drawing of the background grid. \code{.useTheme}
#'   (default) follows the active theme (\code{getTheme()$grid}).
#'   \code{TRUE}/\code{FALSE}/\code{NA}, or a named list, as for
#'   \code{\link[graphics]{grid}}.
#' @param legend Controls the legend. \code{TRUE} (default) draws an
#'   inline legend via \code{textLegend} at the last value of each series.
#'   \code{FALSE}/\code{NA} suppresses it. A list overrides legend arguments.
#'
#' @param stamp Controls the corner stamp. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$stamp}. \code{TRUE}/\code{FALSE}/\code{NULL},
#'   a string, or a named list for \code{\link{stamp}()}.
#' @param ... Additional graphical parameters passed to \code{\link[graphics]{par}}
#'   via \code{.applyParFromDots()} and to the plotting functions.
#'
#' @details
#' If \code{y} is missing, \code{x} is interpreted as a matrix and each column
#' is drawn as a separate line. Row names are used for the x-axis labels if
#' available. The legend labels default to the column names of the data.
#'
#' @return Invisibly returns a list containing:
#' \itemize{
#'   \item \code{x} the x-values used for plotting,
#'   \item \code{y} the y-values (if supplied),
#'   \item \code{legend} the legend specification if drawn.
#' }
#'
#' @examples
#' m <- matrix(c(3,4,5,1,5,4,2,6,2), nrow = 3,
#'             dimnames = list(
#'               dose = c("A","B","C"),
#'               age  = c("2000","2001","2002")
#'             ))
#'
#' plotLines(m, lwd = 2, main = "Dose ~ Age")
#'
#' # with points
#' plotLines(m, points = TRUE)
#'
#' # custom legend
#' plotLines(m, legend = list(cex = 0.8))
#'
#' @family plot.timeseries
#' @concept graphics
#' @concept time-series
#'
#'
#' @export
plotLines <- function(x, y,
                      
                      # LABELS
                      main = NULL,
                      xlab = "",
                      ylab = "",
                      
                      # AXES
                      xlim = NULL,
                      ylim = NULL,
                      xaxt = NULL,
                      yaxt = NULL,
                      
                      # STRUCTURE
                      lty = 1,
                      lwd = 2,
                      
                      # STYLE
                      col    = .useTheme,
                      points = FALSE,
                      grid   = .useTheme,
                      
                      # FEATURES
                      legend = TRUE,
                      
                      # FRAMEWORK
                      stamp = .useTheme,
                      
                      ...) {
  
  if (identical(col, .useTheme))
    col <- pal(getTheme()$palette)
  
  y.missing <- missing(y)
  mc        <- match.call()
  
  defaultTitle <- if (y.missing)
    deparse(mc$x)
  else
    paste(deparse(mc$y), "~", deparse(mc$x))
  
  .withGraphicsState({
    
    if (y.missing) {
      z      <- as.matrix(x)
      x.used <- seq_len(nrow(z))
    } else {
      z      <- as.matrix(y)
      x.used <- x
    }
    
    main <- .resolveTitle(main, default = defaultTitle)
    
    if (is.null(xlim))
      xlim <- range(pretty(range(x.used, finite = TRUE)))
    
    if (is.null(ylim))
      ylim <- range(pretty(range(z, finite = TRUE)))
    
    add.legend <- !isFALSE(legend) && !bedrock::isNA(legend)
    
    labs <- colnames(z) %||% paste("Series", seq_len(ncol(z)))
    
    rmar <- if (add.legend)
      max(2.1, .marginLines(labs, side = 4, pad = 3))
    else
      2.1
    
    .applyParFromDots(
      ...,
      defaults = list(
        mar = c(left = 5, top = .marTop(main), right = rmar),
        fg  = "grey30"
      )
    )
    
    add <- bedrock::getDotsArg(list(...), "add", FALSE)
    
    if (!add) {
      
      matplot(
        x, y,
        type = "n",
        las  = 1,
        xlim = xlim,
        ylim = ylim,
        xaxt = "n",
        yaxt = yaxt,
        main = main,
        xlab = xlab,
        ylab = ylab,
        ...
      )
      
      if (!identical(xaxt, "n")) {
        if (!is.null(rownames(z)) && y.missing)
          axis(1, at = seq_len(nrow(z)), labels = rownames(z))
        else
          axis(1)
      }
      
      .drawGrid(grid)
    }
    
    matplot(
      x, y,
      type = "l",
      col  = col,
      lty  = lty,
      lwd  = lwd,
      xaxt = "n",
      yaxt = "n",
      add  = TRUE,
      ...
    )
    
    if (!isFALSE(points) && !is.null(points) && !bedrock::isNA(points)) {
      
      pt <- if (identical(points, .useTheme) || isTRUE(points)) {
        getTheme()$points
      } else {
        .modifyListSafe(getTheme()$points, points)
      }
      
      pch.args <- list(
        x    = x,
        type = "p",
        pch  = pt$pch,
        col  = pt$col,
        bg   = pt$bg,
        cex  = pt$cex,
        xaxt = "n",
        yaxt = "n",
        add  = TRUE
      )
      
      if (!y.missing)
        pch.args$y <- y
      
      do.call(matplot, pch.args)
    }
    
    if (add.legend) {
      
      par(xpd = NA)
      
      last <- t(tail(apply(as.matrix(z), 2, locf), 1))
      last <- setNames(as.vector(last), rownames(last))
      
      bedrock::callIf(
        textLegend,
        legend,
        defaults = list(
          y   = last,
          col = col,
          lty = lty,
          lwd = lwd
        )
      )
    }
    
  }, stamp = stamp)
  
  invisible(list(
    x      = x,
    y      = if (!y.missing) y else NULL,
    legend = if (add.legend) legend else NULL
  ))
}

