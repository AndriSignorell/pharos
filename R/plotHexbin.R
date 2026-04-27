
#' Hexagonal Binning Scatter Plot
#'
#' Draws a hexagonal binning plot for two numeric variables using the
#' \pkg{hexbin} package. Observations are aggregated into hexagonal cells,
#' and cell counts are visualized by color intensity.
#'
#' @param x Numeric vector for the x-axis.
#' @param y Numeric vector for the y-axis. Must have the same length as \code{x}.
#' @param bins Integer specifying the number of bins along the x-axis.
#'   Passed to \code{\link[hexbin]{hexbin}} as \code{xbins}. Default is \code{30}.
#' @param ... Additional graphical parameters passed to
#'   \code{\link[graphics]{plot}}.
#'
#' @details
#' The function uses \code{\link[hexbin]{hexbin}} to compute hexagonal binning
#' and then draws the hexagons manually using \code{\link[graphics]{polygon}}.
#' Colors are assigned based on the relative frequency of observations per
#' hexagon, scaled to a fixed palette of 100 colors.
#'
#' The hexagon size is determined in user coordinates based on the range
#' of the data and the number of bins.
#'
#' @return Invisibly returns \code{NULL}.
#'
#' @seealso \code{\link[hexbin]{hexbin}}, \code{\link[graphics]{polygon}}
#'
#' @examples
#' \dontrun{
#' set.seed(1)
#' x <- rnorm(1000)
#' y <- x + rnorm(1000)
#'
#' plotHexbin(x, y, bins = 40,
#'            xlab = "x", ylab = "y",
#'            main = "Hexbin plot")
#' }
#'


#' @export
plotHexbin <- function(x, y, bins = 30, ...) {
  
  # --- Input checks ---------------------------------------------------------
  if (length(x) != length(y))
    stop("'x' and 'y' must have the same length")
  
  if (!is.numeric(x) || !is.numeric(y))
    stop("'x' and 'y' must be numeric")
  
  if (!is.numeric(bins) || length(bins) != 1L || bins <= 0)
    stop("'bins' must be a positive integer")
  
  if (!requireNamespace("hexbin", quietly = TRUE))
    stop("Package 'hexbin' needed.")
  
  # --- Compute hexbin -------------------------------------------------------
  hb     <- hexbin::hexbin(x, y, xbins = bins)
  coords <- hexbin::hcell2xy(hb)
  
  # --- Hexagon size (user coordinates) -------------------------------------
  dx <- diff(range(coords$x)) / bins
  dy <- dx * 2 / sqrt(3)
  
  # --- Color mapping --------------------------------------------------------
  pal     <- colorRampPalette(c("#C6DBEF", "#08306B"))
  nColors <- 100L
  cols    <- pal(nColors)[ceiling(hb@count / max(hb@count) * nColors)]
  
  # --- Empty plot -----------------------------------------------------------
  plot(coords$x, coords$y, type = "n", ...)
  
  # --- Draw hexagons --------------------------------------------------------
  for (i in seq_along(coords$x)) {
    hexcoords <- .hexVertices(coords$x[i], coords$y[i], dx, dy)
    polygon(hexcoords$x, hexcoords$y,
            col    = cols[i],
            border = NA)
  }
  
  # --- Return hexbin object -------------------------------------------------
  invisible(hb)
}


# == internal helper functions ==============================================

# Hilfsfunktion: Eckpunkte eines Hexagons
.hexVertices <- function(cx, cy, dx, dy) {
  angles <- seq(30, 360, by = 60) * pi / 180
  list(x = cx + dx/2 * cos(angles),
       y = cy + dy/2 * sin(angles))
}


