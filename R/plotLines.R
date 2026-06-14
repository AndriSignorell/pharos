
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
#' @param col Colours used for the lines.
#' @param xlab Label for the x-axis.
#' @param ylab Label for the y-axis.
#' @param xlim Limits for the x-axis.
#' @param ylim Limits for the y-axis.
#' @param lty Line type(s).
#' @param lwd Line width(s).
#' @param lend Line end style passed to \code{\link[graphics]{par}}.
#' @param xaxt Specification of the x-axis (passed to \code{\link[graphics]{axis}}).
#' @param yaxt Specification of the y-axis.
#' @param cex Character expansion for labels and annotations.
#' @param legend Logical or list controlling the legend. If \code{TRUE}, a legend
#'   is drawn using the column names of the data. If a list is supplied, its
#'   elements are passed to the internal legend drawing routine.
#' @param main Main title of the plot.
#' @param grid Logical or list controlling the background grid. If \code{TRUE},
#'   a default grid is drawn.
#' @param pch Logical, numeric or list controlling the drawing of points on the
#'   lines. If \code{TRUE}, points are drawn with default settings. A list is
#'   passed to \code{\link[graphics]{matplot}}.
#' @param ... Additional graphical parameters passed to \code{\link[graphics]{par}}
#'   via \code{.applyParFromDots()} and to the plotting functions.
#'
#' @details
#' If \code{y} is missing, \code{x} is interpreted as a matrix and each column
#' is drawn as a separate line. Row names are used for the x-axis labels if
#' available. The legend labels default to the column names of the data.
#'
#' The function internally uses \code{\link[graphics]{matplot}} and supports
#' adding lines to an existing plot via \code{add = TRUE}.
#'
#' @return Invisibly returns a list containing:
#' \itemize{
#' \item \code{x} the x-values used for plotting,
#' \item \code{y} the y-values (if supplied),
#' \item \code{legend} the legend specification if drawn.
#' }
#'
#' 
#' @examples
#' m <- matrix(c(3,4,5,1,5,4,2,6,2), nrow = 3,
#'             dimnames = list(
#'               dose = c("A","B","C"),
#'               age  = c("2000","2001","2002")
#'             ))
#'
#' plotLines(m, col = 1:3, lwd = 2,
#'           main = "Dose ~ Age")
#'
#' # with points
#' plotLines(m, col = 1:3, pch = TRUE)
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
                      col=NULL,
                      xlab = "", ylab = "",
                      xlim = NULL, ylim = NULL,
                      lty = 1, lwd = 2, lend = par("lend"),
                      xaxt=NULL, yaxt=NULL,
                      cex = 1, legend = TRUE,
                      main=NULL, grid=TRUE,
                      pch=FALSE, ...) {
  
  if(is.null(col))
    col <- pal("Helsana")
  
  .withGraphicsState({
    
    y.missing <- missing(y)
    
    if(y.missing) {
      z <- as.matrix(x)
      x.used <- seq_len(nrow(z))
    } else {
      z <- as.matrix(y)
      x.used <- x
    }
    
    if(is.null(xlim))
      xlim <- range(pretty(range(x.used, finite = TRUE)))
    
    if(is.null(ylim))
      ylim <- range(pretty(range(z, finite = TRUE)))
    
    add.legend <- !isFALSE(legend) && !isNA(legend)
    
    labs <- colnames(z)
    
    if(is.null(labs))
      labs <- paste("Series", seq_len(ncol(z)))
    
    rmar <- if(add.legend)
      max(
        2.1,
        .marginLines(
          labs,
          side = 4,
          pad = 3
        )
      )
    else
      2.1
    
    
    .applyParFromDots(
      ...,
      defaults = list(
        mar = c(
          left  = 5,
          top   = .marTop(main),
          right = rmar
        ),
        fg = "grey30"
      )
    )
    
    add <- bedrock::getDotsArg(list(...), "add", FALSE)
    
    if(!add) {
      
      matplot(
        x, y,
        type = "n",
        las = 1,
        xlim = xlim,
        ylim = ylim,
        xaxt = "n",
        yaxt = yaxt,
        main = main,
        xlab = xlab,
        ylab = ylab,
        cex = cex,
        ...
      )
      
      if(!identical(xaxt, "n")) {
        
        if(!is.null(rownames(z)) && y.missing) {
          
          axis(
            side = 1,
            at = seq_len(nrow(z)),
            labels = rownames(z)
          )
          
        } else {
          
          axis(side = 1)
          
        }
        
      }
      
      bedrock::callIf(
        graphics::grid,
        grid,
        defaults = list(
          col = "grey85",
          lty = 1,
          lwd = 1
        )
      )
      
    }
    
    matplot(
      x, y,
      type = "l",
      col = col,
      lty = lty,
      lwd = lwd,
      xaxt = "n",
      yaxt = "n",
      add = TRUE,
      ...
    )
    
    pch.args <- list(
      x    = x,
      type = "p",
      pch  = 1,
      col  = par("fg"),
      bg   = par("bg"),
      cex  = 1,
      xaxt = "n",
      yaxt = "n",
      add  = TRUE
    )
    
    if(!y.missing)
      pch.args$y <- y
    
    bedrock::callIf(
      matplot,
      pch,
      defaults = pch.args
    )
    
    if(add.legend) {
      
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
    
  })
  
  invisible(
    list(
      x = x,
      y = if(!y.missing) y else NULL,
      legend = if(add.legend) legend else NULL
    )
  )
  
}
