
#' Apply Geometric Transformations to Coordinates
#'
#' Applies scaling, rotation, and translation to a set of 2D coordinates.
#' The transformations are applied in the following order:
#' \enumerate{
#'   \item Scaling
#'   \item Rotation (see \code{\link{rotate}})
#'   \item Translation
#' }
#'
#' @param x Numeric vector of x coordinates, or an object coercible by
#'   \code{\link{xy.coords}}.
#' @param y Numeric vector of y coordinates. Ignored if \code{x} already
#'   contains both coordinates.
#' @param translate Numeric vector of length 1 or 2 specifying translation
#'   in x and y direction. Recycled if necessary. Default is \code{c(0, 0)}.
#' @param scale Numeric vector of length 1 or 2 specifying scaling factors
#'   for x and y. Recycled if necessary. Default is \code{c(1, 1)}.
#' @param theta Rotation angle in radians. Default is \code{0}.
#' @param asp Aspect ratio adjustment passed to \code{\link{rotate}}.
#'   Default is \code{1}.
#'
#' @details
#' This function is a convenience wrapper combining basic affine transformations.
#' Internally, it uses \code{\link{rotate}} for rotation.
#'
#' @return A list with components \code{x} and \code{y}, as returned by
#'   \code{\link{xy.coords}}.
#'
#' @examples
#' x <- c(0, 1, 1, 0)
#' y <- c(0, 0, 1, 1)
#'
#' # scale, rotate and translate a square
#' transformXY(x, y,
#'             scale = 2,
#'             theta = pi / 4,
#'             translate = c(1, 1))
#'
#' # matrix input
#' m <- cbind(x, y)
#' transformXY(m, scale = 0.5, theta = pi/6)
#'
#' @seealso \code{\link{rotate}}
#'



#' @family coordinate.transform
#' @concept geometry
#' @concept mathematics
#' @concept data-manipulation
#'
#'
#' @export
transformXY <- function(x, y = NULL,
                        translate = c(0, 0),
                        scale = c(1, 1),
                        theta = 0,
                        asp = 1) {
  
  # --- Validation ---
  if (!is.numeric(theta) || length(theta) != 1)
    stop("'theta' must be a single numeric value.")
  
  if (!is.numeric(asp) || length(asp) != 1)
    stop("'asp' must be a single numeric value.")
  
  xy <- xy.coords(x, y)
  
  translate <- rep_len(translate, 2)
  scale <- rep_len(scale, 2)
  
  # --- Scaling ---
  xy$x <- xy$x * scale[1]
  xy$y <- xy$y * scale[2]
  
  # --- Rotation (floating point safe) ---
  if (!isTRUE(all.equal(theta, 0))) {
    xy <- rotate(xy$x, xy$y, theta = theta, asp = asp)
  }
  
  # --- Translation ---
  xy$x <- xy$x + translate[1]
  xy$y <- xy$y + translate[2]
  
  return(xy)
}
