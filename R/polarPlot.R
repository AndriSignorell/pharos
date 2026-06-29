

#' Polar Plot for Radial Data
#'
#' Creates a polar coordinate plot for one or multiple radial series.
#'
#' @param r Numeric vector or matrix of radial values. Each row represents one series.
#' @param theta Optional numeric vector or matrix of angles (in radians).
#'   Must match the dimensions of \code{r}. If \code{NULL}, equally spaced angles are used.
#' @param main Optional plot title.
#' @param type Character vector specifying plot type for each series:
#'   \describe{
#'     \item{"p"}{points}
#'     \item{"l"}{polygon (connected and optionally filled)}
#'     \item{"h"}{radial segments ("histogram"-style)}
#'   }
#' @param rlim Numeric limit for radial axis. If \code{NULL}, determined automatically.
#' @param col Color for points/lines.
#' @param border Color for border in case of type \code{polygon}.
#' @param add Logical; if \code{TRUE}, adds to an existing plot.
#' @param ... Additional graphical parameters passed to base plotting functions.
#'
#' @details
#' The function supports plotting multiple radial series simultaneously.
#' Each row of \code{r} is treated as a separate series.
#'
#' Angles are interpreted in radians. If \code{theta} is not provided,
#' points are distributed evenly over \eqn{[0, 2\pi)}.
#'
#' Graphical parameters such as \code{lwd}, \code{lty}, \code{pch},
#' \code{cex}, \code{fill}, and \code{mar} can be passed via \code{...}.
#'
#' @return
#' Invisibly returns \code{NULL}.
#'
#' @examples
#' r <- matrix(runif(20), nrow = 2)
#' plotPolar(r, type = c("l", "p"), col = c("blue", "red"))
#'
#' # with custom angles
#' theta <- seq(0, 2*pi, length.out = 10)
#' plotPolar(r[1,], theta = theta, type = "h")
#'


#' @family plot.special  
#' @concept bivariate
#'
#'
#' @export
plotPolar <- function(r, theta = NULL
                      
                      , main = NULL 
                      , type = "p"
                      , rlim = NULL
                      , col = NULL
                      , border = NULL
                      , add = FALSE, ...) {
  
# these are all params, to be set in ...
# , lwd = par("lwd"), lty = par("lty")
# , pch = par("pch")
# , fill = NA, cex = par("cex")
# , mar = c(2, 2, 5, 2)
                      
  .withGraphicsState({

    # par() from ...
    .applyParFromDots(...)
    
    if( ncol(r <- as.matrix(r)) == 1) r <- t(r)
    k <- nrow(r)
    
    if(is.null(theta)) {
      theta <- seq(0, 2*pi, length=ncol(r)+1)[-(ncol(r)+1)]
      if( nrow(r) > 1 ){
        theta <- matrix( rep(theta, times=nrow(r)), ncol=ncol(r), byrow = TRUE )
      }  else {
        theta <- t(as.matrix(theta))
      }
    } else {
      if( ncol(theta <- as.matrix(theta)) == 1) theta <- t(theta)
    }
    
    
    if (length(type) < k) type <- rep(type, length.out = k)
    if (length(col) < k)  col <- rep(col, length.out = k)
    if (length(border) < k) border <- rep(border, length.out = k)

    # definition follows plot.default()
    if (is.null(rlim))
      rlim <- max(abs(r[is.finite(r)]))*1.12
    
    if(!add){
      par(pty = "s", xpd=TRUE)
      plot(x=c(-rlim, rlim), y=c(-rlim, rlim),
           type = "n", axes = FALSE, main = main, xlab = "", ylab = "", ...)
    }
    
    for (i in seq_len(k)) {
      xy <- xy.coords( x=cos(theta[i,]) * r[i,], 
                       y=sin(theta[i,])*r[i,])
      if(type[i] == "p"){
        points( xy, col = col[i] )
      } else if( type[i]=="l") {
        polygon(xy, border = border[i], col = col[i])
      } else if( type[i]=="h") {
        segments(x0=0, y0=0, x1=xy$x, y1=xy$y, col = col[i])
      }
    }
  
  })  
  
}


