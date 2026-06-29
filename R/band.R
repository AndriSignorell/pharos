
#' Band Geometry
#'
#' Create a polygonal band from upper and lower boundaries.
#'
#' Typically used to represent confidence or prediction bands.
#'
#' @param x A vector or matrix of x coordinates.
#' @param y A vector or matrix of y coordinates.
#'
#' If either \code{x} or \code{y} is supplied as a two-column matrix,
#' the second column is interpreted as the lower boundary and reversed
#' automatically.
#'
#' @return
#' An object inheriting from class
#' \code{"bandGeometry"}.
#'
#' @seealso
#' \code{\link{polygon}},
#' \code{\link{ring}}
#'
#' @examples
#' set.seed(18)
#'
#' x <- rnorm(15)
#' y <- x + rnorm(15)
#'
#' new <- seq(-3, 3, 0.5)
#'
#' pred <- predict(
#'   lm(y ~ x),
#'   newdata = data.frame(x = new),
#'   interval = "confidence"
#' )
#'
#' plot(y ~ x)
#'
#' polygon(
#'   band(
#'     x = new,
#'     y = pred[,2:3]
#'   ),
#'   col = addAlpha("grey80", 0.5),
#'   border = NA
#' )
#'


#' @family geometry  
#' @concept geometry
#'
#'
#' @export
band <- function(x, y) {
  
  if(!identical(dim(y), dim(x))) {
    
    x <- as.matrix(x)
    y <- as.matrix(y)
    
    if(dim(x)[2] == 1L && dim(y)[2] == 2L)
      x <- x[, c(1L, 1L)]
    
    else if(dim(x)[2] == 2L && dim(y)[2] == 1L)
      y <- y[, c(1L, 1L)]
    
    else
      stop("incompatible dimensions for matrices x and y")
    
  }
  
  if(is.matrix(x)) {
    
    x <- c(x[,1L], rev(x[,2L]))
    y <- c(y[,1L], rev(y[,2L]))
    
  }
  
  .newGeometry(
    x = x,
    y = y,
    class = c(
      "bandGeometry",
      "polygonGeometry"
    )
  )
  
}

