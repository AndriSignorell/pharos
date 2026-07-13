
#' Add an Alpha Channel to Colors
#'
#' Add transparency to colors.
#'
#' @param col Vector of valid R colors.
#' @param opacity Opacity value between 0 and 1.
#'
#' @return Character vector of hexadecimal colors with alpha channel.
#'
#' @examples
#' 
#' op <- par(no.readonly = TRUE)
#' 
#' addOpacity("yellow", 0.2)
#' addOpacity(2, 0.5)   # red
#' 
#' canvas(3)
#' polygon(circle(x=c(-1,0,1), y=c(1,-1,1), radius=2), 
#'         col=addOpacity(2:4, 0.4))
#' 
#' x <- rnorm(15000)
#' par(mfrow=c(1,2))
#' plot(x, type="p", col="blue" )
#' plot(x, type="p", col=addOpacity("blue", .2), 
#'      main="Better insight with alpha channel" )
#' 
#' par(op)
#' 
#' @seealso [grDevices::adjustcolor]
#' 
#' @family color.manipulation
#' @concept color
#'
#' @export
addOpacity <- function(col, opacity = 0.5) {
  Vectorize(grDevices::adjustcolor)(col = col, alpha.f = opacity)
}



