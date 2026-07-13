
#' Empirical Cumulative Distribution Function 
#' 
#' Fast plotting of the empirical cumulative distribution function (ECDF),
#' designed to stay performant even for very large vectors (n ~ 1e6-1e7).
#' 
#' The base \code{\link{plot.ecdf}}/\code{\link{ecdf}} machinery becomes
#' impractically slow well below \code{n = 1e7}, since it tracks every single
#' jump. Beyond a few thousand points, individual jumps are visually
#' indistinguishable anyway, so \code{plotECDF()} caps the rendered resolution
#' at \code{breaks} points by default.
#'
#' Resolution is achieved via quantile subsampling, not histogram binning:
#' \code{breaks} evenly-spaced probability points are mapped back to their
#' corresponding quantiles (\code{\link[stats]{quantile}}, \code{type = 7}).
#' Each rendered point therefore lies exactly on the true ECDF - unlike an
#' equal-width-histogram approximation, this adapts automatically to the
#' shape of the distribution (no resolution is wasted on near-empty bins in
#' a skewed or heavy-tailed distribution, nor lost in the tails).
#'
#' @name plotECDF
#' 
#' @param x numeric vector of the observations for the ECDF.
#'
#' @param formula a formula of the form \code{y ~ x}.
#' @param data an optional data frame containing variables in the formula.
#' @param subset optional expression indicating which observations to use.
#' @param na.action a function specifying how missing values are handled.
#'   Defaults to \code{na.omit}.
#'   
#' @param main main title of the plot. \code{NULL} (default) derives a
#'   title from \code{deparse(substitute(x))}. \code{""}, \code{NA}, or
#'   \code{FALSE} suppress the title.
#' @param xlab label for the x-axis. \code{NULL} (default) derives a label
#'   the same way as \code{main}.
#' @param ylab label for the y-axis. The y-axis itself always shows fixed
#'   probability labels (\code{.00} to \code{1.00}); \code{ylab} adds an
#'   axis title above/beside those, empty by default.
#'
#' @param xlim numeric vector of length 2; x-axis limits. \code{NULL}
#'   (default) uses \code{range(x)}.
#'
#' @param breaks controls the rendered resolution. A single integer (default
#'   \code{1000}) subsamples the ECDF at that many evenly-spaced quantiles
#'   whenever \code{length(x)} exceeds it; for \code{length(x) <= breaks},
#'   full resolution is used regardless (no data is ever thinned below its
#'   actual size). \code{NULL}, \code{FALSE}, or \code{Inf} force full
#'   resolution unconditionally, regardless of \code{length(x)}.
#' @param add logical; if \code{TRUE}, adds to an existing plot instead of
#'   starting a new one.
#'
#' @param col color of the step line and the min/max marker points.
#'   \code{.useTheme} (default) resolves to \code{getTheme()$twin[1]} - a
#'   single accent color, consistent with \code{\link{lines.loess}} and
#'   \code{plotQQ()}'s confidence band.
#' @param lwd line width.
#' @param grid controls drawing of the background grid (vertical lines at
#'   default tick positions, plus a fixed set of horizontal reference
#'   lines at the probability ticks \code{0}/\code{.25}/\code{.5}/\code{.75}/\code{1}
#'   - the latter always grey regardless of the active theme, a
#'   deliberately distinct look, not theme-driven). \code{.useTheme}
#'   (default) follows the active theme's grid on/off state
#'   (\code{getTheme()$grid}). \code{TRUE}/\code{FALSE}/\code{NA}, or a
#'   named list, as for \code{\link[graphics]{grid}}.
#' @param box controls drawing of the plot box. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$box}. \code{TRUE}/\code{FALSE}/\code{NA},
#'   or a named list, as for \code{\link[graphics]{box}}.
#'
#' @param stamp controls the corner stamp. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$stamp}. \code{TRUE}/\code{FALSE}/\code{NULL},
#'   a string, or a named list of arguments for \code{stamp()}.
#'
#' @param legend logical or list controlling the legend. If \code{TRUE}, a legend
#'   is drawn using the column names of the data. If a list is supplied, its
#'   elements are passed to the internal legend drawing routine.
#'   
#' @param \dots further graphical parameters passed to \code{\link{par}} via
#'   the internal framework.
#' 
#' @return Invisibly returns \code{NULL}.
#' 
#' @seealso \code{\link{plot.ecdf}}, \code{\link{plotFdist}},
#'   [theme]
#' 
#' @examples
#' plotECDF(faithful$eruptions)
#'
#' # large vector - automatically thinned to 1000 points, no breaks= needed
#' x <- rnorm(1e6)
#' plotECDF(x)
#'
#' # force full resolution regardless of size
#' plotECDF(x, breaks = NULL)
#'
#' # grouped ECDFs via the formula interface
#' plotECDF(Sepal.Length ~ Species, data = iris)
#'

#' @family plot.univariate  
#' @concept distribution-summary
#'
#'
#' @export
plotECDF <- function(x, ...) {
  UseMethod("plotECDF")
}


#' @rdname plotECDF
#' @export
plotECDF.default <- function(
    
  # DATA
  x,
  
  # LABELS
  main = NULL,
  xlab = NULL,
  ylab = "",
  
  # AXES
  xlim = NULL,
  
  # STRUCTURE
  breaks = 1000,
  add    = FALSE,
  
  # STYLE
  col  = .useTheme,
  lwd  = 2,
  grid = .useTheme,
  box  = .useTheme,
  
  # FRAMEWORK
  stamp = .useTheme,
  
  ...
) {
  
  mc   <- match.call()
  main <- .resolveTitle(main, default = deparse(mc$x))
  
  if (is.null(xlab))
    xlab <- deparse(mc$x)
  
  col <- .useThemeValue(col, "twin")[1]
  
  n <- length(x)
  useFull <- is.null(breaks) || isFALSE(breaks) || is.infinite(breaks) || n <= breaks
  
  if (useFull) {
    xs <- sort(x)
    xp <- c(xs[1], xs)
    yp <- c(0, seq_len(n) / n)
  } else {
    p  <- seq(0, 1, length.out = breaks)
    xp <- as.numeric(stats::quantile(x, probs = p, names = FALSE, type = 7))
    yp <- p
  }
  
  mc   <- tryCatch(
    match.call(),
    error = function(e) NULL
  )
  main <- .resolveTitle(main, default = if (!is.null(mc)) deparse(mc$x) else "")
  
  
  .withGraphicsState({
    
    .applyParFromDots(...,
                      defaults = list(
                        mar = c(left = 5, top = .marTop(main))
                      ))
    
    if (!add) {
      
      plot(xp, yp,
           type = "n",
           main = main,
           xlab = xlab,
           ylab = "",
           xlim = xlim %||% range(x),
           ylim = c(0, 1),
           yaxt = "n",
           frame.plot = FALSE)
      
      # vertical grid via the generic mechanism (default x-tick spacing);
      # the horizontal reference lines below are drawn separately, with
      # their own fixed grey/dashed-dotted style, regardless of theme.
      .drawGrid(grid, defaults = list(ny = NA))
      
      if (!isFALSE(.resolveToggle(grid, getTheme()$grid)))
        abline(h = c(0, 0.25, 0.5, 0.75, 1), col = "grey",
               lty = c("dashed", "dotted", "dotted", "dotted", "dashed"))
      
      axis(2, at = seq(0, 1, 0.25),
           labels = c(".00", ".25", ".50", ".75", "1.00"), las = 1)
      
      if (nzchar(ylab)) title(ylab = ylab)
      
      .drawBox(box)
    }
    
    lines(xp, yp, type = "s", col = col, lwd = lwd)
    
    # mark min/max
    points(x = range(x), y = c(0, 1), col = col, pch = 3, cex = 2)
    
  }, stamp = stamp)
  
  invisible(NULL)
}


#' @rdname plotECDF
#' @method plotECDF formula
#' @export
plotECDF.formula <- function(
    
  # DATA
  formula,
  data,
  subset,
  na.action = na.omit,
  
  # LABELS
  main = NULL,
  xlab = NULL,
  ylab = "",
  
  # AXES
  xlim = NULL,
  
  # STRUCTURE
  breaks = 1000,
  
  # STYLE
  col  = .useTheme,
  lwd  = 2,
  grid = .useTheme,
  box  = .useTheme,
  
  # FEATURES
  legend = TRUE,
  
  # FRAMEWORK
  stamp = .useTheme,
  
  ...
) {
  
  args <- list(
    formula   = formula,
    na.action = na.action,
    allowed   = c("two-sample-independent", "n-sample-independent")
  )
  
  if (!missing(data))   args$data   <- data
  if (!missing(subset)) args$subset <- substitute(subset)
  
  r <- do.call(bedrock::resolveFormula, args)
  
  groups    <- split(r$x, r$group)
  groupLevs <- levels(r$group)
  ng        <- length(groups)
  
  main <- .resolveTitle(main, default = r$data.name)
  if (is.null(xlab)) xlab <- names(r$mf)[1]
  
  if (identical(col, .useTheme))
    col <- pal(getTheme()$palette, n = ng)
  col <- rep_len(col, ng)
  
  if (is.null(xlim))
    xlim <- range(r$x, na.rm = TRUE)
  
  for (i in seq_len(ng)) {
    
    plotECDF.default(
      groups[[i]],
      main = main, xlab = xlab, ylab = ylab,
      xlim = xlim,
      breaks = breaks,
      add = (i > 1),
      col = col[i], lwd = lwd,
      grid = grid, box = box,
      stamp = if (i == 1) stamp else FALSE,
      ...
    )
  }
  
  bedrock::callIf(
    graphics::legend,
    legend,
    defaults = .legendDefaults(list(
      x      = "bottomright",
      legend = groupLevs,
      col    = col,
      lwd    = lwd,
      bty    = "n"
    )),
    forbidden = "legend"
  )
  
  invisible(NULL)
}

