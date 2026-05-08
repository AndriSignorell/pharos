
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
plotLines <- function(x, y, col=1:5, xlab = NULL,
                      ylab = NULL, xlim = NULL, ylim = NULL, 
                      lty = 1, lwd = 2, lend = par("lend"),
                      xaxt=NULL, yaxt=NULL, 
                      cex = 1, legend = TRUE, 
                      main=NULL, grid=TRUE, pch=FALSE, ...){
  
  # example:
  #
  # m <- matrix(c(3,4,5,1,5,4,2,6,2), nrow = 3,
  #             dimnames = list(dose = c("A","B","C"),
  #                             age = c("2000","2001","2002")))
  # PlotLinesA(m, col=rev(c(PalHelsana(), "grey")), main="Dosw ~ age", lwd=3, ylim=c(1,10))
  
  
  .withGraphicsState({

    if(missing(y))
      z <- as.matrix(x)
    else
      z <- as.matrix(y)

    add.legend <- !(isNA(legend) %||% isFALSE(legend))
    
    # par() aus ...
    do.call(.applyParFromDots, 
            mergeArgs(defaults=list(
                mar=c(right=10)), 
                list(...)
                ))
        
    
    last <- t(tail(apply(as.matrix(z), 2, .locf), 1))
    last <- sort(setNames(as.vector(last), nm=rownames(last)))
    

    add <- bedrock::getDotsArg(list(...), "add", FALSE)
    if(!add){
      # do not draw axes, labels and grid when only lines have to be added
      matplot(x, y, type="n", las=1, xlim=xlim, ylim=ylim, xaxt="n", 
              yaxt=yaxt, main=main, xlab=xlab, ylab=ylab, cex = cex, ...)
      if(!identical(xaxt, "n"))
        # use rownames for x-axis if available, but only if either x or y is missing
        if(!is.null(rownames(z)) && (missing(x) || missing(y)))
          axis(side = 1, at=c(1:nrow(z)), rownames(z))
      else
        axis(side=1)

      bedrock::callIf(graphics::grid, grid, 
              defaults = list(
                col   = "grey85",
                lty   = 1,
                lwd   = 1
              )  )

    }
    
    matplot(x, y, type="l", col=col, lty=lty, lwd=lwd, 
            xaxt="n", yaxt="n", add=TRUE, ...)
    
    # if(!is.na(pch))
    #   matplot(x, y, type="p", pch=pch, col=pch.col, bg=pch.bg, cex=pch.cex, 
    #           xaxt="n", yaxt="n", add=TRUE)
    
    
    # pch handling, if given
    
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
    
    if (!missing(y)) {
      pch.args$y <- y
    }
    
    bedrock::callIf(matplot, pch, defaults = pch.args)
    

    
    if (add.legend) {
      
      if(is.null(colnames(z)))
        colnames(z) <- seq(ncol(z))
      
      ord <- match(names(last), colnames(z))
      lwd <- rep(lwd, length.out=ncol(z))
      lty <- rep(lty, length.out=ncol(z))
      col <- rep(col, length.out=ncol(z))

      bedrock::callIf(.legend, 
              legend,
              defaults=list(
                  line   = c(1, 1) ,   
                  width  = 1,          
                  labels = names(last), 
                  y      = spreadOut(unlist(last), 
                                     mindist = 1.2 * strheight("M") * (
                                       if (is.list(legend) && !is.null(legend$cex)) 
                                         legend$cex else par("cex") )),
                  cex    = par("cex"),
                  col = col[ord], lwd = lwd[ord], lty = lty[ord])
              )

    }
  
  
  })
  
  invisible(list(x=x, y= if (!missing(y)) y else NULL, 
                 legend = if(add.legend) legend else NULL))
  
  
}



# == internal helper functions =======================================


.locf <- function(x) {
  
  # last observation carried forward
  # replaces NAs by the last observed value
  
  l <- !is.na(x)
  rep(c(NA, x[l]), diff(c(1L, which(l), length(x) + 1L)))

  
}





.legend <- function(line, y, width, labels, lty, lwd, col, cex, main=NULL){

  par(xpd=TRUE)
  
  line <- rep(line, length.out=2)
  
  txtline <- line[1] + naReplace(width + (!is.na(width)) * line[2], 0)
  mtext(side = 4, las=1, cex=cex, text = labels,
        line = txtline,
        at = y
  )
  
  if(!is.na(width)){
    x0 <- lineToUser(line[1], 4)
    segments(x0 = x0, x1 = lineToUser(line[1] + width, 4), y0 = y,
             lwd = lwd, lty=lty, lend = 1, col = col)
  }
  
  if(!is.null(main))
    mtext(side=4, text = main, las=1, line=line[1], at=par("usr")[4], padj=c(0))
}


