
#' Add Error Bars to an Existing Plot 
#' 
#' Add error bars to an existing plot. 
#' 
#' A short wrapper for plotting error bars by means of \code{\link{arrows}}. 
#' 
#' @param from coordinates of points \bold{from} which to draw (the lower end
#' of the error bars). If \code{to} is left to \code{NULL} and \code{from} is a
#' \eqn{k \times 2 }{k x 2} dimensional matrix, the first column will be
#' interpreted as \code{from} and the second as \code{to}. 
#' @param to coordinates of points \bold{to} which to draw (the upper end of
#' the error bars). 
#' @param pos numeric, position of the error bars. This will either be the
#' x-coordinate in case of vertical error bars and the y-coordinate in case of
#' horizontal error bars. 
#' @param mid numeric, position of midpoints. Defaults to the mean of
#' \code{from} and \code{to}. 
#' @param horiz logical, determining whether horizontal error bars are needed
#' (default is FALSE). 
#' @param col the line color. 
#' @param lty the line type. 
#' @param lwd line width. 
#' @param code integer code, determining where end lines are to be drawn.
#' \code{code = 0} will draw no end lines, \code{code = 1} will draw an end
#' line on the left (lower) side at (\code{x0[i]}, \code{y0[i]}), \code{code =
#' 2} on the right (upper) side (\code{x1[i]}, \code{y1[i]}) and \code{code =
#' 3} (default) will draw end lines at both ends. 
#' @param length the length of the end lines. 
#' @param pch plotting character for the midpoints. The position of the points
#' is given by \code{mid}. If \code{mid} is left to \code{NULL} the points will
#' be plotted in the middle of \code{from} and \code{to}. No points will be
#' plotted if this is set to \code{NA}, which is the default.
#' @param cex.pch the character extension for the plotting characters. Default
#' is \code{par("cex")}.
#' @param col.pch the color of the plotting characters. Default is
#' \code{par("fg")}.
#' @param bg.pch the background color of the plotting characters (if pch is set
#' to 21:25). Default is \code{par("bg")}.
#' @param \dots the dots are passed to the \code{\link{arrows}} function. 
#' @seealso \code{\link{arrows}}, \code{\link{lines.loess}} 




#' @examples
#' 
#' 
#' op <- par(no.readonly = TRUE)
#' par(mfrow=c(2,2))
#' 
#' b <- barplot(1:5, ylim=c(0,6))
#' errBars(from=1:5-rep(0.5,5), to=1:5+rep(0.5,5), pos=b, length=0.2)
#' 
#' # just on one side
#' b <- barplot(1:5, ylim=c(0,6))
#' errBars(from=1:5, to=1:5+rep(0.5,5), pos=b, length=0.2, col="red", code=2, lwd=2)
#' 
#' b <- barplot(1:5, xlim=c(0,6), horiz=TRUE)
#' errBars(from=1:5, to=1:5+rep(0.2,5), pos=b, horiz=TRUE,  length=0.2, col="red", code=2, lwd=2)
#' 
#' par(xpd=FALSE)
#' dotchart(1:5, xlim=c(0,6))
#' errBars(from=1:5-rep(0.2,5), to=1:5+rep(0.2,5), horiz=TRUE, length=0.1)
#' 
#' par(op)
#' 



#' @family plot.annotation
#' @concept graphics
#' @concept descriptive-statistics
#' @concept confidence-intervals
#'
#'
#' @export
errBars <- function(from, to = NULL, pos = NULL, mid = NULL, horiz = FALSE, col = par("fg"), lty = par("lty"),
                    lwd = par("lwd"), code = 3, length=0.05,
                    pch = NA, cex.pch = par("cex"), col.pch = par("fg"), bg.pch = par("bg"), ... ) {
  
  if(is.null(to)) {
    if(!dim(from)[2] %in% c(2,3)) stop("'from' must be a kx2 or a kx3 matrix, when 'to' is not provided.")
    if(dim(from)[2] == 2) {
      to <- from[,2]
      from <- from[,1]
    } else {
      mid <- from[,1]
      to <- from[,3]
      from <- from[,2]
    }
    
  }
  if(is.null(pos)) pos <- 1:length(from)
  if(horiz){
    arrows( x0=from, x1=to, y0=pos, col=col, lty=lty, lwd=lwd, angle=90, code=code, length=length, ... )
  } else {
    arrows( x0=pos, y0=from, y1=to, col=col, lty=lty, lwd=lwd, angle=90, code=code, length=length, ... )
  }
  if(!is.na(pch) && !is.na(col.pch)){
    if(is.null(mid)) mid <- (from + to)/2
    # plot points
    if(horiz){
      points(x=mid, y=pos, pch = pch, cex = cex.pch, col = col.pch, bg=bg.pch)
    } else {
      points(x=pos, y=mid, pch = pch, cex = cex.pch, col = col.pch, bg=bg.pch)
    }
  }
}

