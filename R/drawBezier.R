#' Draw a Bézier Curve
#'
#' Draw a Bézier curve defined by a set of control points.
#'
#' Bézier curves are widely used in computer-aided geometric design
#' (CAD) due to their favorable geometric and numerical properties.
#'
#' @param x,y Numeric vectors of control points.
#'   Alternatively, \code{x} may be a list with components
#'   \code{x} and \code{y}.
#' @param nv Number of vertices used to approximate the curve.
#' @param col Color for the curve. Defaults to \code{par(\"col\")}.
#' @param lty Line type.
#' @param lwd Line width.
#' @param draw Logical; if \code{TRUE} (default), the curve is drawn.
#'   Otherwise only the coordinates are computed and returned.
#'
#' @return
#' Invisibly returns a list with components:
#' \describe{
#'   \item{x}{x-coordinates of the curve}
#'   \item{y}{y-coordinates of the curve}
#' }
#'
#' @references
#' Farin, G. (1993).
#' \emph{Curves and Surfaces for Computer Aided Geometric Design}.
#' Academic Press.
#'
#' @seealso
#' \code{\link{polygon}}
#'
#' @examples
#' canvas(xlim = c(0, 1))
#' grid()
#'
#' drawBezier(
#'   x = c(0, 0.5, 1),
#'   y = c(0, 0.5, 0),
#'   col = "blue",
#'   lwd = 2
#' )
#'
#' drawBezier(
#'   x = c(0, 0.5, 1),
#'   y = c(0, 1, 0),
#'   col = "red",
#'   lwd = 2
#' )
#'
#' drawBezier(
#'   x = c(0, 0.25, 0.5, 0.75, 1),
#'   y = c(0, 1, 1, 1, 0),
#'   col = "darkgreen",
#'   lwd = 2
#' )
#'
#' @family plot.geometry
#' @concept graphics
#' @concept plot-geometry
#'


#' @export
drawBezier <- function(
    x,
    y = NULL,
    nv = 100,
    col = par("col"),
    lty = par("lty"),
    lwd = par("lwd"),
    draw = TRUE
) {
  
  # --- alternative input form ---------------------------------------
  
  if (is.list(x)) {
    
    if (length(x) != 2L)
      stop("'x' must be a list with components x and y.")
    
    y <- x[[2L]]
    x <- x[[1L]]
  }
  
  # --- input checks --------------------------------------------------
  
  if (length(x) != length(y))
    stop("'x' and 'y' must have equal length.")
  
  if (length(x) < 3L)
    stop("At least 3 control points are required.")
  
  if (!is.numeric(nv) || length(nv) != 1L ||
      is.na(nv) || nv < 2L || nv %% 1 != 0)
    stop("'nv' must be an integer >= 2.")
  
  n <- length(x)
  
  # --- initialize ----------------------------------------------------
  
  X <- Y <- numeric(nv)
  Z <- seq(0, 1, length.out = nv)
  
  X[1L]  <- x[1L]
  X[nv]  <- x[n]
  
  Y[1L]  <- y[1L]
  Y[nv]  <- y[n]
  
  # --- evaluate Bézier curve ----------------------------------------
  
  if (nv > 2L) {
    
    for (i in 2:(nv - 1L)) {
      
      z <- Z[i]
      xz <- yz <- 0
      
      const <- (1 - z)^(n - 1L)
      for (j in 0:(n - 1L)) {
        xz <- xz + const * x[j + 1L]
        yz <- yz + const * y[j + 1L]
        const <- const * (n - 1L - j) / (j + 1L) * z / (1 - z)
      }
      
      X[i] <- xz
      Y[i] <- yz
    }
  }
  
  # --- draw ----------------------------------------------------------
  
  if (draw) {
    lines( x = X, y = Y, col = col, lty = lty, lwd = lwd )
  }
  
  invisible(list(x = X, y = Y))
  
}

