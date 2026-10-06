
#' Draw Polygonal Geometries
#'
#' Generic function for drawing polygon-based geometry objects.
#' This function extends graphics::polygon() with support for
#' geometry objects such as circle(), ellipse(), regPolygon() and ring() 
#' and further remains fully compatible with its original interface.
#' #'
#' For ordinary coordinate vectors the call is forwarded to
#' [graphics::polygon()]. Geometry objects such as
#' [circle()], [ellipse()], [regPolygon()]
#' and [ring()] are dispatched to specialised methods.

#' @aliases polygonX.ringGeometry polygonX.polygonGeometry polygonX.geometryCollection
#'
#' @param x an object to be drawn.
#' @param ... further arguments passed to the corresponding method.
#'
#' @return
#' Invisibly returns `x`.
#'
#' @examples
#' canvas()
#'
#' polygonX(
#'   circle(radius = 1),
#'   col = "lightblue"
#' )
#'
#' polygonX(
#'   regPolygon(
#'     radius = 0.7,
#'     nVertices = 5
#'   ),
#'   border = "red"
#' )
#'

#' @family geometry.structures
#' @concept geometry
#' @concept numerical-methods
#'
#'
#' @export
polygonX <- function(x, ...) UseMethod("polygonX")


#' @rdname polygonX
#'
#' @param y numeric vector of y-coordinates.
#' @param density density of shading lines.
#' @param angle angle of shading lines in degrees.
#' @param border border colour.
#' @param col fill colour.
#' @param lty line type.
#' @param fillOddEven logical; should the odd-even rule be used for filling?
#' 
#' @export
polygonX.default <- graphics::polygon



#' @rdname polygonX
#'
#' @param rule character string specifying the filling rule passed to
#'   [graphics::polypath()]. One of `"evenodd"` or
#'   `"winding"`.
#'

#' @export
polygonX.ringGeometry <- function(x, rule = "evenodd", ...) {
  
  graphics::polypath(
    x$x,
    x$y,
    rule = rule,
    ...
  )
  
  invisible(x)
  
}

#' @rdname polygonX
#' @export
polygonX.polygonGeometry <- function(x, ...) {
  
  graphics::polygon(
    x$x,
    x$y,
    ...
  )
  
  invisible(x)
  
}



#' @export
lines.lineGeometry <- function(x, ...) {
  
  graphics::lines(
    x$x,
    x$y,
    ...
  )
  invisible(x)
  
}

#' @export
lines.geometryCollection <- function(x, ...) {
  for (geom in x)
    lines(geom, ...)
  invisible(x)
}

#' @export
polygonX.geometryCollection <- function(x, ...) {
  
  dots <- list(...)
  
  n <- length(x)
  
  # recycle all vector arguments
  dots <- lapply(dots, function(z) {
    if(length(z) > 1L)
      rep(z, length.out = n)
    else
      z
  })
  
  for(i in seq_len(n)) {
    
    args <- lapply(dots, function(z) {
      if(length(z) == n) z[i] else z
    })
    
    do.call(
      polygonX,
      c(list(x[[i]]), args)
    )
    
  }
  
  invisible(x)
  
}


#' @export
points.geometryCollection <- function(x, ...) {
  for (geom in x)
    points(geom, ...)
  invisible(x)
}


#' @export
points.geometry <- function(x, ...) {
  graphics::points(x$x, x$y, ...)
  invisible(x)
}

