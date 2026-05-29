
#' Draw a Circle 
#' 
#' Draw one or several circle on an existing plot. 
#' 
#' All geometric arguments will be recycled. 
#' 
#' @param x,y a vector (or scalar) of xy-coordinates for the center(s) of the
#' circle(s). 
#' @param outerR a vector (or scalar) of the outer radius of the circle. 
#' @param innerR a vector (or scalar) of a potential inner radius of an annulus.
#' @param startAngle a vector (or scalar) of the starting angle(s). The sectors
#' are built counterclockwise. 
#' @param endAngle a vector (or scalar) of the ending angle(s). 
#' @param nv number of vertices to draw the circle. 
#' @param border color for circle borders. The default is par("fg"). Use border
#' = \code{NA} to omit borders. 
#' @param col color(s) to fill or shade the circle(s) with. The default
#' \code{NA} (or also NULL) means do not fill, i.e., draw transparent circles,
#' unless density is specified. 
#' @param lty line type for borders and shading; defaults to \code{"solid"}. 
#' @param lwd line width for borders and shading. 
#' @param plot logical. If \code{TRUE} the structure will be plotted. If
#' \code{FALSE} only the points are calculated and returned. Use this option if
#' you want to combine several geometric structures to a polygon. 
#' @return The function invisibly returns a list of the calculated coordinates
#' for all shapes. 
#' @seealso \code{\link{polygon}}, \code{\link{drawRegPolygon}},
#' \code{\link{drawEllipse}}, \code{\link{drawArc}} 



#' @examples
#' 
#' canvas(xlim = c(-5,5), xpd=TRUE)
#' cols <- pal("Helsana")[1:5]
#' 
#' # Draw ring
#' drawCircle (innerR = 1, outerR = 5, border="darkgrey", 
#'             col=addAlpha("yellow", 0.2), lwd=2)
#' 
#' # Draw circle
#' drawCircle (innerR = 6, border="green", lwd=3)
#' 
#' # Draw sectors
#' geom <- rbind(c(-pi, 0, .25, .5), c(0, pi, 1, 2),
#'               c(-pi/2, pi/2, 2, 2.5), c(pi/2, 3 * pi/2, 3, 4),
#'               c(pi - pi/8, pi + pi/8, 1.5, 2.5))
#' 
#' drawCircle (innerR = geom[,3], outerR = geom[,4],
#'            startAngle = geom[,1], endAngle = geom[,2],
#'            col = addAlpha(cols, 0.6),
#'            border = cols, lwd=1)
#' 
#' 
#' # clipping
#' canvas(bg="lightgrey", main="Yin ~ Yang")
#' drawCircle (outerR = 1, col="white")
#' clip(0, 2, 2, -2)
#' drawCircle(col="black")
#' clip(-2, 2, 2, -2)
#' drawCircle (y = c(-0.5,0.5), outerR = 0.5, col=c("black", "white"), border=NA)
#' drawCircle (y = c(-0.5,0.5), outerR = 0.1, col=c("white", "black"), border=NA)
#' drawCircle ()
#' 
#' 
#' # overplotting circles
#' canvas(xlim=c(-5,5))
#' drawCircle (outerR=4:1, col=c("white", "steelblue2", "white", "red"), lwd=3, nv=300)
#' 
#' 
#' # rotation
#' x <- seq(-3, 3, length.out=10)
#' y <- rep(0, length.out=length(x))
#' 
#' canvas(xlim=c(-5,5), bg="black")
#' 
#' sapply( (0:11) * pi/6, function(theta) {
#'   xy <- rotate(x, y=y, theta=theta)
#'   drawCircle (x=xy$x, y=xy$y, innerR=2.4, border=addAlpha("white", 0.2))
#' } )



#' @family plot.geometry
#' @concept graphics
#' @concept geometry
#'
#'
#' @export
drawCircle <- function (x = 0, y = x, outerR = 1, innerR = 0, startAngle = 0,
                        endAngle = 2 * pi, border = par("fg"), col = NA, 
                        lty = par("lty"),
                        lwd = par("lwd"), nv = 100, plot = TRUE) {
  
  drawSector <- function(x, y, innerR, outerR, startAngle,
                         endAngle, nv, border, col, lty, lwd, plot) {
    
    # get arc coordinates
    pts <- drawArc(x = x, y = y, rx = c(outerR, innerR), ry = c(outerR, innerR),
                   startAngle = startAngle, endAngle = endAngle, nv = nv,
                   col = border, lty = lty, lwd = lwd, plot = FALSE)
    
    is.ring <- (innerR != 0)
    is.sector <- any( ((startAngle-endAngle) %% (2*pi)) != 0)
    
    if(is.ring || is.sector) {
      # we have an inner and an outer circle
      ptx <- c(pts[[1]]$x, rev(pts[[2]]$x))
      pty <- c(pts[[1]]$y, rev(pts[[2]]$y))
      
    } else {
      # no inner circle
      ptx <- pts[[1]]$x
      pty <- pts[[1]]$y
    }
    
    if (plot) {
      if (is.ring & !is.sector) {
        # we have angles, so plot polygon for the area and lines for borders
        polygon(x = ptx, y = pty, col = col, border = NA,
                lty = lty, lwd = lwd)
        
        lines(x = pts[[1]]$x, y = pts[[1]]$y, col = border, lty = lty, lwd = lwd)
        lines(x = pts[[2]]$x, y = pts[[2]]$y, col = border, lty = lty, lwd = lwd)
        
      }
      else {
        polygon(x = ptx, y = pty, col = col, border = border,
                lty = lty, lwd = lwd)
      }
    }
    invisible(list(x = ptx, y = pty))
  }
  
  lgp <- recycle(x=x, y=y, innerR = innerR, outerR = outerR,
                 startAngle = startAngle, endAngle = endAngle, border = border,
                 col = col, lty = lty, lwd = lwd, nv = nv)
  lst <- list()
  for (i in 1L:attr(lgp, "maxdim")) {
    pts <- with(lgp, drawSector(x=x[i], y=y[i], innerR=innerR[i],
                                outerR=outerR[i], startAngle=startAngle[i],
                                endAngle=endAngle[i], nv=nv[i], border=border[i],
                                col=col[i], lty=lty[i], lwd=lwd[i],
                                plot = plot))
    lst[[i]] <- pts
  }
  invisible(lst)
}

