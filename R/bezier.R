
#' Bézier Geometry
#'
#' Create a Bézier curve from a set of control points.
#'
#' @param x,y Numeric vectors of control points.
#'   Alternatively, \code{x} may be a list with components
#'   \code{x} and \code{y}.
#' @param numPoints Number of points used to approximate the curve.
#'
#' @return
#' An object inheriting from class
#' \code{"bezierGeometry"}.
#'
#' @references
#' Farin, G. (1993).
#' \emph{Curves and Surfaces for Computer Aided Geometric Design}.
#' Academic Press.
#'
#' @seealso
#' \code{\link{arc}},
#' \code{\link{lines}}
#'
#' @examples
#' canvas(xlim = c(0, 1))
#'
#' lines(
#'   bezier(
#'     x = c(0, 0.5, 1),
#'     y = c(0, 1, 0)
#'   ),
#'   col = "red",
#'   lwd = 2
#' )
#'


#' @family geometry  
#' @concept geometry
#'
#'
#' @export
bezier <- function(
    x,
    y = NULL,
    numPoints = 100
) {
  
  if(is.list(x)) {
    
    if(length(x) != 2L)
      stop("'x' must be a list with components x and y.")
    
    y <- x[[2L]]
    x <- x[[1L]]
    
  }
  
  if(length(x) != length(y))
    stop("'x' and 'y' must have equal length.")
  
  if(length(x) < 3L)
    stop("At least 3 control points are required.")
  
  if(!is.numeric(numPoints) ||
     length(numPoints) != 1L ||
     is.na(numPoints) ||
     numPoints < 2L ||
     numPoints %% 1 != 0)
    stop("'numPoints' must be an integer >= 2.")
  
  n <- length(x)
  
  X <- Y <- numeric(numPoints)
  
  Z <- seq(
    0,
    1,
    length.out = numPoints
  )
  
  X[1L] <- x[1L]
  X[numPoints] <- x[n]
  
  Y[1L] <- y[1L]
  Y[numPoints] <- y[n]
  
  if(numPoints > 2L) {
    
    for(i in 2:(numPoints - 1L)) {
      
      z <- Z[i]
      
      xz <- yz <- 0
      
      const <- (1 - z)^(n - 1L)
      
      for(j in 0:(n - 1L)) {
        
        xz <- xz + const * x[j + 1L]
        yz <- yz + const * y[j + 1L]
        
        const <- const *
          (n - 1L - j) /
          (j + 1L) *
          z /
          (1 - z)
        
      }
      
      X[i] <- xz
      Y[i] <- yz
      
    }
    
  }
  
  .newGeometry(
    x = X,
    y = Y,
    class = c(
      "bezierGeometry",
      "lineGeometry"
    )
  )
  
}

