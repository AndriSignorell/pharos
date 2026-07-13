
#' Stacked Area Plot
#'
#' Draws one or several stacked area series using cumulative polygons.
#' The function accepts either a matrix of values or separate \code{x} and
#' \code{y} coordinates. Multiple series are displayed as stacked areas.
#'
#' @param x numeric vector, matrix or data frame. If \code{y} is missing,
#'   \code{x} is interpreted as a matrix of series where rows correspond to
#'   x positions and columns to individual areas.
#' @param y optional numeric vector or matrix giving the y-values. If supplied,
#'   \code{x} is interpreted as the x-coordinates.
#' @param prop logical indicating whether rows should be converted to
#'   proportions so that stacked areas sum to one.
#' @param col fill colours used for the areas.
#' @param xlab label for the x-axis.
#' @param ylab label for the y-axis.
#' @param xlim limits for the x-axis.
#' @param ylim limits for the y-axis.
#' @param legend logical or list controlling the legend. If \code{TRUE}, a legend
#'   is drawn using the column names of the data. If a list is supplied, its
#'   elements are passed to the internal legend drawing routine.
#' @param main main title of the plot.
#' @param grid logical or list controlling the background grid. If \code{TRUE},
#'   a default grid is drawn.
#' @param ... additional graphical parameters passed to \code{\link[graphics]{par}}
#'   via \code{.applyParFromDots()} and to the plotting functions.
#'
#' @details
#' If \code{y} is missing, \code{x} is interpreted as a matrix and each column
#' is drawn as a separate stacked area.
#'
#' The cumulative sums are calculated row-wise and displayed as polygons stacked
#' on top of each other.
#'
#' If \code{prop = TRUE}, each row is converted to proportions before plotting,
#' so the stacked areas sum to one.
#'
#' Row names are used as x-axis labels when available and \code{y} is omitted.
#'
#' @return Invisibly returns a list containing:
#' \itemize{
#' \item \code{x} the x-values used for plotting,
#' \item \code{y} the original y-values,
#' \item \code{cumulative} the cumulative values used to construct the areas,
#' \item \code{legend} the legend specification if drawn.
#' }
#'
#' @examples
#' plotArea(VADeaths)
#'
#' plotArea(
#'   WorldPhones,
#'   col = pal("helsana")
#' )
#'
#' plotArea(
#'   WorldPhones,
#'   prop = TRUE,
#'   col = rainbow(ncol(WorldPhones))
#' )
#'
#' x <- 1:20
#' y <- cbind(
#'   A = runif(20, 1, 5),
#'   B = runif(20, 1, 3),
#'   C = runif(20, 1, 4)
#' )
#'
#' plotArea(x, y)
#'



#' @family plot.univariate  
#' @concept line-chart
#'
#'
#' @export
plotArea <- function(
    x, y,
    prop = FALSE,
    col = NULL,
    xlab = "",
    ylab = "",
    xlim = NULL,
    ylim = NULL,
    legend = TRUE,
    main = NULL,
    grid = TRUE,
    ...
) {
  
  y.missing <- missing(y)
  
  if (is.null(col))
    col <- pal("helsana")
  
  .withGraphicsState({
    
    if (y.missing) {
      
      z <- as.matrix(x)
      
      x <- seq_len(nrow(z))
      y <- z
      
    } else {
      
      z <- as.matrix(y)
      
    }
    
    y <- as.matrix(y)
    
    if (prop)
      y <- prop.table(y, 1)
    
    col <- rep_len(col, ncol(y))
    
    cumulative <- t(
      rbind(
        0,
        apply(y, 1, cumsum)
      )
    )
    
    if (is.null(xlim))
      xlim <- range(pretty(x), finite = TRUE)
    
    if (is.null(ylim))
      ylim <- if (prop)
        c(0, 1)
    else
      range(pretty(cumulative), finite = TRUE)
    
    add.legend <- !isFALSE(legend) && !isNA(legend)

    labs <- colnames(z)
    
    if (is.null(labs))
      labs <- paste("Series", seq_len(ncol(z)))
    
    rmar <- if(add.legend)
      max(
        2.1,
        .marginLines(
          labs,
          side = 4,
          pad = 3
        )
      )
    else
      2.1
    
    .applyParFromDots(
      ...,
      defaults = list(
        mar = c(
          left  = 5,
          top   = .marTop(main),
          right = rmar
        ),
        fg = "grey30"
      )
    )
    
    add <- bedrock::getDotsArg(list(...), "add", FALSE)
    
    if (!add) {
      
      plot(
        NA,
        xlim = xlim,
        ylim = ylim,
        xaxt = "n",
        yaxt = "n",
        xlab = xlab,
        ylab = ylab,
        main = main,
        ...
      )
      
      if (!is.null(rownames(z)) && y.missing) {
        
        axis(
          side = 1,
          at = seq_len(nrow(z)),
          labels = rownames(z)
        )
        
      } else {
        
        axis(side = 1)
        
      }
      
      axis(side = 2, las = 1)
      
    }
    
    xx <- c(x, rev(x))
    
    for (i in seq_len(ncol(cumulative) - 1)) {
      
      polygon(
        x = xx,
        y = c(
          cumulative[, i + 1],
          rev(cumulative[, i])
        ),
        col = col[i],
        border = NA
      )
      
    }
    
    # grid on top of polygons
    
    bedrock::callIf(
      graphics::grid,
      grid,
      defaults = list(
        nx  = NA,
        ny  = NULL,
        col = "grey85",
        lty = 1,
        lwd = 1
      )
    )
    
    if (add.legend) {
      
      par(xpd = NA)
      
      bedrock::callIf(
        textLegend,
        legend,
        defaults = list(
          y      = cumsum(midx(y[nrow(y), ], inclZero = TRUE)),
          labels = labs,
          col    = col,
          lwd    = 3
        ),
        forbidden = "y"
      )
      
    }
    
  })
  
  invisible(
    list(
      x = x,
      y = y,
      cumulative = cumulative,
      legend = if (add.legend) legend else NULL
    )
  )
  
}

