
#' Hexagonal Binning Plot
#'
#' Displays a two-dimensional density estimate using hexagonal bins.
#' Observations are aggregated into hexagons and coloured according to the
#' number of observations falling into each cell.
#'
#' @param x Numeric vector of x-values.
#' @param y Numeric vector of y-values.
#'
#' @param bins Number of hexagons across the x-axis.
#'
#' @param col Colours used for the count scale. If \code{NULL}, a default
#'   sequential palette is used.
#' @param border Border colour of the hexagons.
#' @param grid Logical or list controlling the background grid.
#'
#' @param xlim Limits for the x-axis.
#' @param ylim Limits for the y-axis.
#'
#' @param main Main title.
#' @param xlab Label for the x-axis.
#' @param ylab Label for the y-axis.
#'
#' @param ... Additional graphical parameters passed to
#'   \code{.applyParFromDots()}.
#'
#' @return Invisibly returns a list containing the computed
#'   \code{hexbin} object and the original \code{x} and \code{y}.
#'
#' @family plot.bivariate
#' @concept graphics
#' @concept density-estimation
#'
#' @export
plotHexbin <- function(
    
  # DATA
  x,
  y,
  
  # STRUCTURE
  bins = 30,
  
  # STYLE
  col = NULL,
  border = NA,
  grid = FALSE,
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # LABELS
  main = NULL,
  xlab = "",
  ylab = "",
  
  ...
  
) {
  
  # --- checks -------------------------------------------------------------
  
  if (length(x) != length(y))
    stop("'x' and 'y' must have the same length")
  
  if (!is.numeric(x) || !is.numeric(y))
    stop("'x' and 'y' must be numeric")
  
  if (!is.numeric(bins) || length(bins) != 1L || bins <= 0)
    stop("'bins' must be a positive integer")
  
  if (!requireNamespace("hexbin", quietly = TRUE))
    stop("Package 'hexbin' needed.")
  
  if (is.null(col)) {
    col <- colorRampPalette(
      c("white", pal("Helsana")[1])
    )(100)
  }
  
  .withGraphicsState({
    
    .applyParFromDots(
      ...,
      defaults = list(
        mar = c(
          left  = 5,
          top   = .marTop(main),
          right = 2.1
        ), 
        asp = 1
      )
    )
    
    # --- hexbin -----------------------------------------------------------
    
    hb <- hexbin::hexbin(
      x,
      y,
      xbins = bins
    )
    
    coords <- hexbin::hcell2xy(hb)
    
    # --- plot region ------------------------------------------------------
    
    if (is.null(xlim))
      xlim <- range(pretty(range(x, finite = TRUE)))
    
    if (is.null(ylim))
      ylim <- range(pretty(range(y, finite = TRUE)))
    
    plot(
      NA,
      xlim = xlim,
      ylim = ylim,
      xlab = xlab,
      ylab = ylab,
      main = main,
      type = "n"
    )
    
    # --- grid -------------------------------------------------------------
    
    bedrock::callIf(
      graphics::grid,
      grid,
      defaults = list(
        col = "grey90",
        lwd = 1
      )
    )
    
    # --- hex geometry -----------------------------------------------------
    
    dx <- diff(range(coords$x)) / bins
    dy <- dx * 2 / sqrt(3)
    
    # --- colours ----------------------------------------------------------
    
    idx <- ceiling(
      hb@count / max(hb@count) * length(col)
    )
    
    idx[idx < 1] <- 1
    idx[idx > length(col)] <- length(col)
    
    cols <- col[idx]
    
    # --- draw -------------------------------------------------------------
    
    for (i in seq_along(coords$x)) {
      
      hxy <- .hexVertices(
        cx = coords$x[i],
        cy = coords$y[i],
        dx = dx,
        dy = dy
      )
      
      polygon(
        hxy$x,
        hxy$y,
        col = cols[i],
        border = border
      )
      
    }
    
  })
  
  invisible(
    list(
      hexbin = hb,
      x = x,
      y = y
    )
  )
  
}


# == internal helper functions ==============================================

# Hilfsfunktion: Eckpunkte eines Hexagons
.hexVertices <- function(cx, cy, dx, dy) {
  angles <- seq(30, 360, by = 60) * pi / 180
  list(x = cx + dx/2 * cos(angles),
       y = cy + dy/2 * sin(angles))
}


