
#' Scatterplot with Optional Smooth Lines
#'
#' Draws a scatterplot of two numeric variables with optional linear and
#' locally weighted regression lines, and an optional legend.
#'
#' @param x numeric vector of x-values, or a formula of the form \code{y ~ x}.
#' @param y numeric vector of y-values (ignored if a formula is used).
#'
#' @param formula a formula of the form \code{y ~ x}.
#' @param data an optional data frame containing variables in the formula.
#' @param subset optional expression indicating which observations to use.
#' @param na.action a function specifying how missing values are handled.
#'   Defaults to \code{na.omit}.
#'
#' @param main main title of the plot.
#' @param xlab label for the x-axis.
#' @param ylab label for the y-axis.
#'
#' @param xlim numeric vector of length 2; x-axis limits. If \code{NULL}
#'   (default), the range of \code{x} is used.
#' @param ylim numeric vector of length 2; y-axis limits. If \code{NULL}
#'   (default), the range of \code{y} is used.
#'
#' @param col color of the points. Default: \code{"grey50"}.
#' @param bg background (fill) color of the points. Default: a transparent
#'   \code{"grey80"}.
#' @param pch plotting character. Default: \code{21} (filled circle).
#' @param cex character expansion factor for points. Default: \code{1}.
#'
#' @param grid controls drawing of the background grid.
#'   Can be:
#'   \itemize{
#'     \item \code{TRUE}: draw grid with default settings
#'     \item \code{FALSE}, \code{NULL}, or \code{NA}: suppress grid
#'     \item a named list: arguments passed to \code{\link[graphics]{grid}}
#'   }
#'
#' @param lm controls drawing of the linear regression line.
#'   Can be:
#'   \itemize{
#'     \item \code{TRUE}: draw with default settings
#'     \item \code{FALSE}, \code{NULL}, or \code{NA}: suppress
#'     \item a named list: arguments passed to \code{\link[graphics]{lines}},
#'       e.g. \code{list(col = "blue", lwd = 2)}
#'   }
#'
#' @param loess controls drawing of the locally weighted regression line.
#'   Can be:
#'   \itemize{
#'     \item \code{TRUE}: draw with default settings
#'     \item \code{FALSE}, \code{NULL}, or \code{NA}: suppress
#'     \item a named list: arguments passed to \code{\link[graphics]{lines}},
#'       e.g. \code{list(col = "red", lty = "dashed")}
#'   }
#'
#' @param legend controls drawing of the legend.
#'   Can be:
#'   \itemize{
#'     \item \code{TRUE}: draw with default settings (position \code{"topright"})
#'     \item \code{FALSE}, \code{NULL}, or \code{NA}: suppress
#'     \item a named list: arguments passed to \code{\link[graphics]{legend}},
#'       e.g. \code{list(x = "bottomleft")}
#'   }
#'   The legend is only drawn when at least one of \code{lm} or \code{loess}
#'   is active.
#'
#' @param ... further graphical parameters passed to \code{par()} via the
#'   internal framework.
#'
#' @details
#' Optional plot components (\code{grid}, \code{lm}, \code{loess},
#' \code{legend}) follow \code{\link[bedrock]{callIf}} semantics:
#' \itemize{
#'   \item \code{TRUE}: draw with defaults
#'   \item \code{FALSE}, \code{NULL}, or \code{NA}: suppress component
#'   \item named list: customize component arguments
#' }
#'
#' @return Invisibly returns \code{NULL}.
#'
#' @seealso
#' \code{\link[graphics]{plot}},
#' \code{\link[stats]{lm}},
#' \code{\link[stats]{loess}},
#' \code{\link[bedrock]{callIf}}
#'
#' @examples
#' \dontrun{
#' plotXY(temperature ~ delivery_min, bedrock::Pizza,
#'        main = "Temperature vs. Delivery Time")
#'
#' # Suppress loess, customize lm line
#' plotXY(temperature ~ delivery_min, bedrock::Pizza,
#'        lm    = list(col = "darkred", lwd = 2),
#'        loess = FALSE)
#' }
#'
#' @family topic.plots
#' @concept graphics
#' @concept scatterplot
#' @concept regression
#'
#' @export
plotXY <- function(x, ...) {
  UseMethod("plotXY")
}


#' @rdname plotXY
#' @export
plotXY.default <- function(
    
  x,
  y,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = "",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # STYLE
  col  = "grey50",
  bg   = addAlpha("grey80"),
  pch  = 21,
  cex  = 1.1,
  grid = TRUE,
  
  # FEATURES
  lm     = TRUE,
  loess  = TRUE,
  legend = TRUE,
  
  ...
) {
  
  .withGraphicsState({
    
    .applyParFromDots(..., 
                      defaults=list(
                        mar=c(left=5, top=.marTop(naIf(main, ""))),
                        col.axis = "grey40", 
                        fg       = "grey50"             
      ))
    
    # --- theme ---------------------------------------------------
    th <- .theme(
      grid = list(col = "grey", lwd = 1, lty = "dotted")
    )
    
    # --- prepare -------------------------------------------------
    xlim <- xlim %||% range(x, na.rm = TRUE)
    ylim <- ylim %||% range(y, na.rm = TRUE)
    
    # --- base plot -----------------------------------------------
    plot.new()
    plot.window(xlim = xlim, ylim = ylim)
    
    # --- grid ----------------------------------------------------
    bedrock::callIf(graphics::grid, grid,
                    defaults = th$grid[!startsWith(names(th$grid), "group.")])
    
    # --- points --------------------------------------------------
    points(x, y, pch = pch, cex = cex, col = col, bg = bg)
    
    axis(1)
    axis(2)
    box()
    
    if (nzchar(main)) title(main = main)
    if (nzchar(xlab)) title(xlab = xlab)
    if (nzchar(ylab)) title(ylab = ylab)
    
    # --- lm line -------------------------------------------------
    lm_col    <- pal("Helsana", n=NA)[1]
    loess_col <- pal("Helsana", n=NA)[2]
    
    bedrock::callIf(lines, lm,
                    defaults = list(
                      x   = lm(y ~ x),
                      col = lm_col,
                      lwd = 1.5
                    ))
    
    # --- loess line ----------------------------------------------
    bedrock::callIf(lines, loess,
                    defaults = list(
                      x   = loess(y ~ x),
                      col = loess_col,
                      lwd = 1.5
                    ))
    
    # --- legend --------------------------------------------------
    # Only show legend if at least one smooth line is active
    show_legend <- (!isFALSE(lm)  && !is.null(lm)  && !bedrock::isNA(lm)) ||
      (!isFALSE(loess) && !is.null(loess) && !bedrock::isNA(loess))
    
    if (show_legend) {
      leg_labels <- character(0)
      leg_fill   <- character(0)
      
      if (!isFALSE(lm) && !is.null(lm) && !bedrock::isNA(lm)) {
        leg_labels <- c(leg_labels, "linear")
        leg_fill   <- c(leg_fill,   lm_col)
      }
      if (!isFALSE(loess) && !is.null(loess) && !bedrock::isNA(loess)) {
        leg_labels <- c(leg_labels, "loess")
        leg_fill   <- c(leg_fill,   loess_col)
      }
      
      bedrock::callIf(graphics::legend, legend,
                      defaults = list(
                        x        = "topright",
                        legend   = leg_labels,
                        fill     = leg_fill,
                        box.col  = "white", 
                        bg       = addAlpha("white"), 
                        inset    = 0.01,
                        text.col = "black"
                      ),
                      forbidden = c("legend", "fill"))
    }
    
  })
  
  invisible(NULL)
}


#' @rdname plotXY
#' @method plotXY formula
#' @export
plotXY.formula <- function(
    
  formula,
  data,
  subset,
  na.action = na.omit,
  
  main = "",
  xlab = "",
  ylab = "",
  
  xlim = NULL,
  ylim = NULL,
  
  col    = "grey50",
  bg     = addAlpha("grey80"),
  pch    = 21,
  cex    = 1.1,
  
  grid   = TRUE,
  lm     = TRUE,
  loess  = TRUE,
  legend = TRUE,
  
  ...
) {
  
  args <- list(
    formula   = formula,
    na.action = na.action,
    allowed   = "numeric-numeric"
  )
  
  if (!missing(data))
    args$data <- data
  
  if (!missing(subset))
    args$subset <- substitute(subset)
  
  r <- do.call(bedrock::resolveFormula, args)
  
  x <- r$group
  y <- r$x
  
  if (!nzchar(main)) main <- r$data.name
  if (!nzchar(xlab)) xlab <- names(r$mf)[2]
  if (!nzchar(ylab)) ylab <- names(r$mf)[1]
  
  plotXY.default(
    x      = x,
    y      = y,
    main   = main,
    xlab   = xlab,
    ylab   = ylab,
    xlim   = xlim,
    ylim   = ylim,
    col    = col,
    bg     = bg,
    pch    = pch,
    cex    = cex,
    grid   = grid,
    lm     = lm,
    loess  = loess,
    legend = legend,
    ...
  )
}
