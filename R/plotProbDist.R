
#' Plot Probability Distribution
#'
#' Produces a plot of a probability distribution function with shaded areas.
#' Useful for illustrating critical regions, p-values, or probability masses
#' in statistics teaching materials.
#'
#' @param breaks numeric vector of break points defining the boundaries between
#'   shaded areas. The first and last value define the plot range passed to
#'   \code{\link{shade}()}; interior values are the actual boundaries.
#' @param FUN the distribution density function to plot, typically of the form
#'   \code{function(x) dnorm(x, mean=0, sd=1)}.
#' @param main main title for the plot. \code{NULL} or \code{""} suppresses
#'   the title and reduces the top margin automatically.
#' @param xlim numeric vector of length 2. x-axis limits passed to
#'   \code{\link{curve}()}.
#' @param col color(s) for the shaded areas. Recycled if shorter than the
#'   number of areas. Defaults to the "helsana" palette.
#' @param density density of shading lines passed to \code{\link{shade}()}.
#'   Default is \code{7}.
#' @param ylab label for the y-axis. Default is \code{"density"}.
#' @param areaLabels controls labels placed in the centre of each shaded area.
#'   \code{NULL} (default) suppresses labels. \code{TRUE} uses
#'   \code{LETTERS} as default labels. A character vector sets explicit labels.
#'   A named list overrides individual arguments passed to
#'   \code{\link{boxedText}()} (e.g. \code{list(cex = 3)} or
#'   \code{list(x = c(-2, 3), y = 0.1)} for manual positioning).
#' @param breakLabels controls labels placed on the x-axis at interior break
#'   points via \code{\link{mtext}()}. \code{NULL} (default) suppresses labels.
#'   \code{TRUE} uses \code{LETTERS} as default labels. A character vector
#'   sets explicit labels. A named list overrides individual arguments
#'   (e.g. \code{list(cex = 1.8, font = 1)}).
#' @param grid controls background grid. \code{FALSE} (default) suppresses the
#'   grid. \code{TRUE} or \code{.useTheme} draws a grid according to the
#'   current theme. A named list overrides individual arguments passed to
#'   \code{\link{grid}()}.
#' @param box controls the plot box. \code{.useTheme} (default) uses the
#'   current theme setting. \code{TRUE}/\code{FALSE} forces the box on or off.
#'   A named list overrides individual arguments passed to
#'   \code{\link{box}()}.
#' @param \dots further graphical parameters passed to \code{\link{curve}()}
#'   and \code{.applyParFromDots()}, e.g. \code{las}, \code{col.axis}.
#'
#' @return \code{NULL}, invisibly.
#'
#' @examples
#' # Normal distribution with two areas
#' plotProbDist(breaks = c(-10, -1, 12),
#'              FUN    = function(x) dnorm(x, mean = 2, sd = 2),
#'              main   = "Normal-Distribution N(2,2)",
#'              xlim   = c(-7, 10),
#'              col    = c("deeppink4", "skyblue3"),
#'              density = c(20, 7),
#'              breakLabels = TRUE)
#'
#' # t-distribution with three areas
#' plotProbDist(breaks = c(-6, -2.3, 1.5, 6),
#'              FUN    = function(x) dt(x, df = 8),
#'              main   = "t-Distribution (df=8)",
#'              xlim   = c(-4, 4),
#'              col    = c("deeppink4", "skyblue3", "darkorange2"),
#'              density = c(20, 7),
#'              areaLabels = FALSE,
#'              breakLabels = list(text=c("A", "B")))
#'
#' # Chi-square distribution
#' plotProbDist(breaks  = c(0, 15, 35),
#'              FUN     = function(x) dchisq(x, df = 8),
#'              main    = expression(chi^2~"-Distribution (df=8)"),
#'              xlim    = c(0, 30),
#'              col     = c("deeppink4", "skyblue3"),
#'              density = c(0, 20),
#'              breakLabels = list(text="B"))
#'
#'
#' @seealso \code{\link{curve}}
#' 
#' @family plot.distribution  
#' @concept distribution-summary
#'
#'
#' @export
plotProbDist <- function(breaks, FUN, main = "",
                         xlim = NULL,
                         col = NULL, density = 7, ylab = "density",
                         areaLabels = NULL,
                         breakLabels = NULL,
                         grid = FALSE,
                         box  = .useTheme,
                         ...) {
  
  .withGraphicsState({
    
    .applyParFromDots(...,
                      defaults = list(
                        mar = c(
                          bottom = 5,
                          top    = .marTop(main)
                        )
                      ))
    
    fct <- FUN
    FUN <- eval(parse(text = "fct"))
    
    if (is.null(col))
      col <- pal("helsana")[1:length(breaks)]
    
    curve(FUN, xlim = xlim, main = main,
          type = "n", las = 1, ylab = ylab, ...)
    
    shade(FUN, breaks = breaks, col = col, density = density)
    
    .drawGrid(grid)
    .drawBox(box)
    
    # --- areaLabels ---
    callIf(
      boxedText,
      areaLabels,
      defaults = list(
        labels = LETTERS[1:(length(breaks) - 1)],
        x      = moveAvg(c(xlim[1], head(breaks, -1)[-1], xlim[2]), order = 2, align = "left"),
        y      = abcCoords("left")$xy$y,
        cex    = 2,
        border = NA
      )
    )
    
    # --- breakLabels ---
    callIf(
      mtext,
      breakLabels,
      defaults = list(
        text = LETTERS[1:length(head(breaks, -1)[-1])],
        side = 1,
        line = 2.5,
        at   = head(breaks, -1)[-1],
        font = 2,
        cex  = 1.4
      )
    )
    
  })
}

