
#' Convert Degrees to Radians and Vice Versa 
#' 
#' Convert degrees to radians (and back again). 
#' 
#' @name degToRad
#' @aliases degToRad radToDeg
#' @param deg a vector of angles in degrees. 
#' @param rad a vector of angles in radians. 
#' @return degToRad returns a vector of the same length as \code{deg} with the
#' angles in radians.\cr radToDeg returns a vector of the same length as
#' \code{rad} with the angles in degrees. 
#' 


#' @examples
#' 
#' degToRad(c(90,180,270))
#' radToDeg( c(0.5,1,2) * pi)
#' 



#' @rdname degToRad

#' @family graphics.utils  
#' @concept annotation
#'
#'
#' @export
degToRad <- function(deg) deg * pi /180


#' @rdname degToRad
#' @export
radToDeg <- function(rad) rad * 180 / pi

