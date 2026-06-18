
#' Two-Dimensional Kernel Density Plot
#'
#' @description
#' Computes a two-dimensional kernel density estimate and visualises it
#' using contour, image, or perspective plots.
#'
#' @details
#' The function estimates a bivariate density surface using a Gaussian kernel
#' with bandwidths determined via a normal reference rule. The density is
#' evaluated on a regular grid and visualised using one of three base graphics
#' representations:
#'
#' \itemize{
#'   \item \code{"contour"}: contour lines of equal density
#'   \item \code{"image"}: raster representation of the density surface
#'   \item \code{"persp"}: three-dimensional perspective plot
#' }
#'
#' The choice of representation affects interpretability:
#' contour and image plots emphasise structure in the data distribution,
#' while perspective plots highlight global shape but may distort local density.
#'
#' Bandwidth selection follows a rule-of-thumb approach based on spread
#' (interquartile range and variance), which provides a reasonable default
#' for unimodal distributions but may oversmooth multimodal structures.
#'
#' Missing or non-finite values are not allowed and will result in an error.
#'
#' @param x Numeric vector of x-coordinates.
#' @param y Numeric vector of y-coordinates. Must have the same length as \code{x}.
#'
#' @param main Optional main title of the plot.
#' @param xlab,ylab Axis labels.
#'
#' @param xlim,ylim Numeric vectors of length two specifying axis limits.
#'
#' @param type Character string specifying the plot type.
#' One of \code{"contour"}, \code{"image"}, or \code{"persp"}.
#'
#' @param col Color specification used for \code{type = "image"}. Defaults
#'   to a reversed \code{"RedToBlack"} sequential ramp (\code{pal()}),
#'   running from black (low density) to red (high density) - hardcoded
#'   rather than theme-driven, since this is a continuous, unidirectional
#'   gradient, unlike the active theme's categorical \code{palette} or
#'   diverging \code{twin} pair, neither of which fits a density surface.
#' @param grid Controls drawing of the background grid. \code{.useTheme}
#'   (default) follows the active theme (\code{getTheme()$grid}).
#'   \code{TRUE}/\code{FALSE}/\code{NA}, or a named list, as for
#'   \code{\link[graphics]{grid}}.
#' @param box Controls drawing of the plot box. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$box}. \code{TRUE}/\code{FALSE}/\code{NA},
#'   or a named list, as for \code{\link[graphics]{box}}.
#'
#' @param ... Additional graphical parameters passed to underlying plotting functions.
#'
#' @return
#' Invisibly returns the result of the selected plotting call.
#' Typically a list containing grid coordinates and estimated density values.
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(200)
#' y <- x + rnorm(200)
#'
#' plotDens2D(x, y)
#'
#' plotDens2D(x, y, type = "image")
#'
#' @family topic.graphics
#' @concept base-graphics
#' @concept density-estimation
#' @concept kernel-methods
#' @concept bivariate


# cats <- MASS::cats
# 
# plotDens2d(cats$Bwt, cats$Hwt)
# plotDens2d(cats$Bwt, cats$Hwt, type="persp")
# plotDens2d(cats$Bwt, cats$Hwt, type="image")
# grid()
# 




#' @family plot.bivariate
#' @concept graphics
#' @concept descriptive-statistics
#'
#'
#' @export
plotDens2D <- function( x, y, 
                        
                        # LABELS
                        main = NULL,
                        xlab = NULL,
                        ylab = NULL,                    
                        
                        # AXES
                        xlim = NULL, 
                        ylim = NULL, 
                        
                        # STRUCTURE
                        type=c("contour", "image", "persp"),
                        
                        # STYLE
                        col  = rev(pal("RedToBlack", n = 100)),
                        grid = .useTheme,
                        box  = .useTheme,
                        
                        ... ) {
  
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    bw <- c(.bandwidth.nrd(x), .bandwidth.nrd(y))
    
    kde <- .kde2d(x = x, y=y, h=bw, n=500, 
                  lims = c(range(x), range(y)))
    
    
    if(is.null(xlim)) xlim <- range(x, finite = TRUE)
    if(is.null(ylim)) ylim <- range(y, finite = TRUE)
    # if(is.null(zlim)) zlim <- range(z, finite = TRUE)
    
    res <- switch(match.arg(type),  
                  contour= { contour(kde, xlab=xlab, ylab=ylab, xlim=xlim, ylim=ylim,
                                     main = main,
                                     nlevels=8, labcex=0.8)},
                  
                  persp = { 
                    persp(kde, ticktype="simple", theta=50, phi=20, r=4, scale=TRUE,
                          main = main,
                          xlab=xlab %||% "", ylab=ylab  %||% "", zlab="Relative Frequency")},
                  
                  image = {
                    image(kde, 
                          xlab=xlab %||% "", ylab=ylab  %||% "", 
                          col=col,
                          main = main,
                          xlim=xlim %||% range(x), ylim=ylim  %||% range(y)) }
    )        
    
    
    .drawGrid(grid)
    .drawBox(box)
    
    
  })
  
  invisible(res)
  
}



# == internal helper functions 

.bandwidth.nrd <- function (x) {
  r <- quantile(x, c(0.25, 0.75))
  h <- (r[2L] - r[1L])/1.34
  4 * 1.06 * min(sqrt(var(x)), h) * length(x)^(-1/5)
}


.kde2d <- function (x, y, h, n = 25, lims = c(range(x), range(y))) {
  
  nx <- length(x)
  if (length(y) != nx)
    stop("data vectors must be the same length")
  
  if (any(!is.finite(x)) || any(!is.finite(y)))
    stop("missing or infinite values in the data are not allowed")
  
  if (any(!is.finite(lims)))
    stop("only finite values are allowed in 'lims'")
  
  n <- rep(n, length.out = 2L)
  gx <- seq.int(lims[1L], lims[2L], length.out = n[1L])
  gy <- seq.int(lims[3L], lims[4L], length.out = n[2L])
  
  h <- if (missing(h))
    c(.bandwidth.nrd(x), .bandwidth.nrd(y))
  else rep(h, length.out = 2L)
  
  if (any(h <= 0))
    stop("bandwidths must be strictly positive")
  
  h <- h/4
  ax <- outer(gx, x, "-")/h[1L]
  ay <- outer(gy, y, "-")/h[2L]
  z <- tcrossprod(matrix(dnorm(ax), , nx), 
                  matrix(dnorm(ay), , nx))/(nx * h[1L] * h[2L])
  
  list(x = gx, y = gy, z = z)
  
}

