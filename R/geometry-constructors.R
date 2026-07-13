

#' Arc Geometry
#'
#' Create one or more circular or elliptic arcs.
#'
#' @param x,y Coordinates of the arc centre.
#' @param radiusX,radiusY Horizontal and vertical radius.
#' @param startAngle,endAngle Start and end angle in radians.
#' @param numPoints Number of points used to approximate the arc.
#'
#' @return
#' An object inheriting from class `"arcGeometry"`.
#'
#' @family geometry.structures
#' @concept geometry
#'
#' @export
arc <- function(
    x = 0,
    y = 0,
    radiusX = 1,
    radiusY = radiusX,
    startAngle = 0,
    endAngle = 2*pi,
    numPoints = 100
) {
  
  args <- recycle(
    x          = x,
    y          = y,
    radiusX    = radiusX,
    radiusY    = radiusY,
    startAngle = startAngle,
    endAngle   = endAngle,
    numPoints  = numPoints
  )
  
  res <- vector("list", attr(args, "maxdim"))
  
  for(i in seq_along(res)) {
    
    dtheta <- args$endAngle[i] - args$startAngle[i]
    
    theta <- seq(
      from = 0,
      to = if(dtheta < 0) dtheta + 2*pi else dtheta,
      length.out = args$numPoints[i]
    ) + args$startAngle[i]
    
    res[[i]] <- .newGeometry(
      x = cos(theta) * args$radiusX[i] + args$x[i],
      y = sin(theta) * args$radiusY[i] + args$y[i],
      class = c("arcGeometry", "lineGeometry")
    )
    
  }
  
  if(length(res) == 1L)
    return(res[[1L]])
  
  class(res) <- c("geometryCollection", "list")
  
  res
}


#' Circle Geometry
#'
#' Create a circular geometry.
#'
#' @param x,y Centre coordinates.
#' @param radius Circle radius.
#' @param numPoints Number of points used to approximate the circle.
#'
#' @return
#' An object inheriting from class `"circleGeometry"`.
#'
#' @family geometry.structures
#' @concept geometry
#' 
#' @export
circle <- function(
    x = 0,
    y = 0,
    radius = 1,
    numPoints = 100
) {
  
  res <- arc(
    x = x,
    y = y,
    radiusX = radius,
    radiusY = radius,
    startAngle = 0,
    endAngle = 2*pi,
    numPoints = numPoints
  )

  res <- .setGeometryClass(
    res,
    c("circleGeometry", "polygonGeometry")
  )
  
  res
}



#' Ellipse Geometry
#'
#' Create an elliptic geometry.
#'
#' Use \code{\link{rotate}} to rotate the resulting geometry.
#'
#' @param x,y Centre coordinates.
#' @param radiusX,radiusY Horizontal and vertical radius.
#' @param numPoints Number of points used to approximate the ellipse.
#'
#' @return
#' An object inheriting from class `"ellipseGeometry"`.
#'
#' @family geometry.structures
#' @concept geometry
#' 
#' @export
ellipse <- function(
    x = 0,
    y = 0,
    radiusX = 1,
    radiusY = radiusX,
    numPoints = 100
) {
  
  res <- arc(
    x = x,
    y = y,
    radiusX = radiusX,
    radiusY = radiusY,
    startAngle = 0,
    endAngle = 2*pi,
    numPoints = numPoints
  )
  
  res <- .setGeometryClass(
    res,
    c("ellipseGeometry", "polygonGeometry")
  )
  
  res
}


#' Regular Polygon Geometry
#'
#' Create a regular polygon.
#'
#' @param x,y Centre coordinates.
#' @param radius Circumradius.
#' @param numVertices Number of vertices.
#' @param startAngle Staring angle in radians.
#'
#' @return
#' An object inheriting from class `"regPolygonGeometry"`.
#'
#' @family geometry.structures
#' @concept geometry
#' 
#' @export
regPolygon <- function(
    x = 0,
    y = 0,
    radius = 1,
    numVertices = 6,
    startAngle = 0
) {
  
  res <- arc(
    x = x,
    y = y,
    radiusX = radius,
    radiusY = radius,
    startAngle = startAngle,
    endAngle = startAngle + 2*pi,
    numPoints = numVertices + 1L
  )
  
  res$x <- res$x[-length(res$x)]
  res$y <- res$y[-length(res$y)]
  
  res <- .setGeometryClass(
    res,
    c("regPolygonGeometry", "polygonGeometry")
  )
  
  res
}


#' Ring Geometry
#'
#' Create one or more rings or ring segments.
#'
#' @param x,y Centre coordinates.
#' @param innerRadius Radius of the inner boundary.
#' @param outerRadius Radius of the outer boundary.
#' @param startAngle,endAngle Start and end angle in radians.
#' @param numPoints Number of points used for each boundary.
#'
#' @return
#' An object inheriting from class \code{"ringGeometry"} or a
#' \code{"geometryCollection"}.
#'
#' @family geometry.structures
#' @concept geometry
#' 
#' @export
ring <- function(
    x = 0,
    y = 0,
    innerRadius = 0.5,
    outerRadius = 1,
    startAngle = 0,
    endAngle = 2*pi,
    numPoints = 100
) {
  
  args <- recycle(
    x           = x,
    y           = y,
    innerRadius = innerRadius,
    outerRadius = outerRadius,
    startAngle  = startAngle,
    endAngle    = endAngle,
    numPoints   = numPoints
  )
  
  if(any(args$innerRadius >= args$outerRadius))
    stop("'innerRadius' must be smaller than 'outerRadius'")
  
  res <- vector("list", attr(args, "maxdim"))
  
  for(i in seq_along(res)) {
    
    dtheta <- (args$endAngle[i] - args$startAngle[i]) %% (2*pi)
    
    isFullRing <- isTRUE(all.equal(dtheta, 0))
    
    if(isFullRing) {
      
      outer <- circle(
        x = args$x[i],
        y = args$y[i],
        radius = args$outerRadius[i],
        numPoints = args$numPoints[i]
      )
      
      inner <- circle(
        x = args$x[i],
        y = args$y[i],
        radius = args$innerRadius[i],
        numPoints = args$numPoints[i]
      )
      
      res[[i]] <- .newGeometry(
        x = c(outer$x, NA, rev(inner$x)),
        y = c(outer$y, NA, rev(inner$y)),
        class = c("ringGeometry", "polygonGeometry")
      )
      
    } else {
      
      outer <- arc(
        x = args$x[i],
        y = args$y[i],
        radiusX = args$outerRadius[i],
        radiusY = args$outerRadius[i],
        startAngle = args$startAngle[i],
        endAngle = args$endAngle[i],
        numPoints = args$numPoints[i]
      )
      
      inner <- arc(
        x = args$x[i],
        y = args$y[i],
        radiusX = args$innerRadius[i],
        radiusY = args$innerRadius[i],
        startAngle = args$startAngle[i],
        endAngle = args$endAngle[i],
        numPoints = args$numPoints[i]
      )
      
      res[[i]] <- .newGeometry(
        x = c(outer$x, rev(inner$x)),
        y = c(outer$y, rev(inner$y)),
        class = c("ringGeometry", "polygonGeometry")
      )
      
    }
    
  }
  
  if(length(res) == 1L)
    return(res[[1L]])
  
  class(res) <- c("geometryCollection", "list")
  
  res
  
}



# == internal helper functions ==============================================

.newGeometry <- function(x, y, class) {
  
  res <- xy.coords(x = x, y = y)
  
  class(res) <- c(class, "geometry")
  
  res
  
}


.setGeometryClass <- function(x, class) {
  
  stopifnot(is.character(class))
  
  if(inherits(x, "geometryCollection")) {
    
    for(i in seq_along(x))
      class(x[[i]]) <- c(class, "geometry")
    
    return(x)
    
  }
  
  class(x) <- c(class, "geometry")
  
  x
  
}

