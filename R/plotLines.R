
#' Line Plot for Multiple Series
#'
#' Draws one or several line series using [graphics::matplot()].
#' The function accepts either a matrix of values or separate `x` and
#' `y` coordinates and supports optional point symbols, grid lines,
#' and an automatically positioned legend.
#'
#' @param x numeric vector, matrix or data frame. If `y` is missing,
#'   `x` is interpreted as a matrix of series where rows correspond to
#'   x positions and columns to individual lines.
#' @param y optional numeric vector or matrix giving the y-values. If supplied,
#'   `x` is interpreted as the x-coordinates.
#'
#' @param main main title of the plot. `NULL` (default) derives a title
#'   from the input. `""`, `NA`, or `FALSE` suppress the title
#'   and compact the top margin.
#' @param xlab,ylab labels for the axes.
#'
#' @param xlim,ylim limits for the axes.
#'
#' @param lty line type(s).
#' @param lwd line width(s).
#' @param xaxt,yaxt axis specification passed to [graphics::axis()].
#'
#' @param col colours for the lines. `.useTheme` (default) resolves to
#'   `pal(getTheme()$palette)`, the active theme's qualitative palette.
#' @param points controls drawing of points on the lines. `FALSE`
#'   (default) suppresses points; `TRUE` draws with theme defaults
#'   (`getTheme()$points`); a named list overrides individual elements
#'   (`pch`, `col`, `bg`, `cex`).
#' @param grid controls drawing of the background grid. `.useTheme`
#'   (default) follows the active theme (`getTheme()$grid`).
#'   `TRUE`/`FALSE`/`NA`, or a named list, as for
#'   [graphics::grid()].
#' @param legend controls the legend. `TRUE` (default) draws an
#'   inline legend via `textLegend` at the last value of each series.
#'   `FALSE`/`NA` suppresses it. A list overrides legend arguments.
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`,
#'   a string, or a named list for [stamp()].
#' @param ... additional graphical parameters passed to [graphics::par()]
#'   via `.applyParFromDots()` and to the plotting functions.
#'
#' @details
#' If `y` is missing, `x` is interpreted as a matrix and each column
#' is drawn as a separate line. Row names are used for the x-axis labels if
#' available. The legend labels default to the column names of the data.
#'
#' @return Invisibly returns a list containing:
#' \itemize{
#'   \item `x` the x-values used for plotting,
#'   \item `y` the y-values (if supplied),
#'   \item `legend` the legend specification if drawn.
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

#' @family plot.univariate  
#' @concept line-chart  
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

