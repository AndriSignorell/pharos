
#' Hexagonal Binning Plot
#'
#' Displays a two-dimensional density estimate using hexagonal bins.
#' Observations are aggregated into hexagons and coloured according to the
#' number of observations falling into each cell.
#'
#' @param x numeric vector of x-values.
#' @param y numeric vector of y-values.
#'
#' @param nBins number of hexagons across the x-axis.
#'
#' @param col colours used for the count scale. If `NULL`, a default
#'   sequential palette is used.
#' @param border border colour of the hexagons.
#' @param grid controls the background grid. `.useTheme` (default) follows
#'   the active theme (`getTheme()$grid`), `TRUE` draws it, `FALSE`, `NULL`
#'   or `NA` suppress it, and a named list is passed to [graphics::grid()].
#'
#' @param xlim limits for the x-axis.
#' @param ylim limits for the y-axis.
#'
#' @param main main title.
#' @param xlab label for the x-axis.
#' @param ylab label for the y-axis.
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/
#'   `NULL`, a string, or a named list for [stamp()].
#'
#' @param ... additional graphical parameters passed to
#'   `.applyParFromDots()`.
#'
#' @return Invisibly returns a list containing the computed
#'   `hexbin` object and the original `x` and `y`.
#'

#' @family plot.bivariate  
#' @concept scatterplot  
#' @concept bivariate
#'
#'
#' @export
plotHexbin <- function(
    # DATA
    x,
    y,

    # LABELS
    main = NULL,
    xlab = "",
    ylab = "",

    # AXES
    xlim = NULL,
    ylim = NULL,

    # STATISTICS
    nBins = 30,

    # STYLE
    col    = NULL,
    border = NA,
    grid   = .useTheme,

    # FRAMEWORK
    stamp = .useTheme,

    ...
) {
  
  # --- checks -------------------------------------------------------------
  
  if (length(x) != length(y))
    stop("'x' and 'y' must have the same length")
  
  if (!is.numeric(x) || !is.numeric(y))
    stop("'x' and 'y' must be numeric")
  
  if (!is.numeric(nBins) || length(nBins) != 1L || nBins <= 0)
    stop("'nBins' must be a positive integer")
  
  if (!requireNamespace("hexbin", quietly = TRUE))
    stop("Package 'hexbin' needed.")
  
  if (is.null(col)) {
    col <- colorRampPalette(
      c("white", pal("helsana")[1])
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
      xbins = nBins
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
    
    .drawGrid(
      grid,
      defaults = list(
        col = "grey90",
        lwd = 1
      )
    )
    
    # --- hex geometry -----------------------------------------------------
    
    dx <- diff(range(coords$x)) / nBins
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
    
  }, stamp = stamp)
  
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


