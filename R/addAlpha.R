
#' Add an Alpha Channel to Colors
#'
#' Add transparency to colors.
#'
#' @param col Vector of valid R colors.
#' @param alpha Alpha transparency values between 0 and 1.
#'
#' @return Character vector of hexadecimal colors with alpha channel.
#'
#' @seealso \code{\link{adjustcolor}}, \code{\link{colToOpaque}}
#' 
#' @examples
#' 
#' op <- par(no.readonly = TRUE)
#' 
#' addAlpha("yellow", 0.2)
#' addAlpha(2, 0.5)   # red
#' 
#' canvas(3)
#' polygon(circle(x=c(-1,0,1), y=c(1,-1,1), radius=2), 
#'         col=addAlpha(2:4, 0.4))
#' 
#' x <- rnorm(15000)
#' par(mfrow=c(1,2))
#' plot(x, type="p", col="blue" )
#' plot(x, type="p", col=addAlpha("blue", .2), 
#'      main="Better insight with alpha channel" )
#' 
#' par(op)
#' 
 

#' @family color  
#' @concept color
#'
#'
#' @export
addAlpha <- function(col, alpha = 0.5) {
  Vectorize(grDevices::adjustcolor)(col = col, alpha.f = alpha)
}



