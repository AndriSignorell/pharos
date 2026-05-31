
#' Draw Polygonal Geometries
#'
#' Generic function for drawing polygon-based geometry objects.
#' This function extends graphics::polygon() with support for
#' geometry objects such as circle(), ellipse(), regPolygon() and ring() 
#' and further remains fully compatible with its original interface.
#' #'
#' For ordinary coordinate vectors the call is forwarded to
#' \code{\link[graphics]{polygon}}. Geometry objects such as
#' \code{\link{circle}}, \code{\link{ellipse}}, \code{\link{regPolygon}}
#' and \code{\link{ring}} are dispatched to specialised methods.

#' @aliases polygon.ringGeometry polygon.polygonGeometry polygon.geometryCollection
#'
#' @param x An object to be drawn.
#' @param ... Further arguments passed to the corresponding method.
#'
#' @return
#' Invisibly returns \code{x}.
#'
#' @seealso
#' \code{\link{arc}},
#' \code{\link{circle}},
#' \code{\link{ellipse}},
#' \code{\link{regPolygon}},
#' \code{\link{ring}},
#' \code{\link[graphics]{polygon}}
#'
#' @examples
#' canvas()
#'
#' polygon(
#'   circle(radius = 1),
#'   col = "lightblue"
#' )
#'
#' polygon(
#'   regPolygon(
#'     radius = 0.7,
#'     numVertices = 5
#'   ),
#'   border = "red"
#' )
#'
#' @export
polygon <- function(x, ...) UseMethod("polygon")


#' @rdname polygon
#'
#' @param y Numeric vector of y-coordinates.
#' @param density Density of shading lines.
#' @param angle Angle of shading lines in degrees.
#' @param border Border colour.
#' @param col Fill colour.
#' @param lty Line type.
#' @param fillOddEven Logical; should the odd-even rule be used for filling?

#' 
#' @export
polygon.default <- graphics::polygon



#' @rdname polygon
#'
#' @param rule Character string specifying the filling rule passed to
#'   \code{\link[graphics]{polypath}}. One of \code{"evenodd"} or
#'   \code{"winding"}.
#'

#' @export
polygon.ringGeometry <- function(x, rule = "evenodd", ...) {
  
  graphics::polypath(
    x$x,
    x$y,
    rule = rule,
    ...
  )
  
  invisible(x)
  
}

#' @rdname polygon
#' @export
polygon.polygonGeometry <- function(x, ...) {
  
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
polygon.geometryCollection <- function(x, ...) {
  
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
      polygon,
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

