#' Scatterplot with Optional Smooth Lines
#'
#' Draws a scatterplot of two numeric variables with optional linear and
#' locally weighted regression lines, and an optional legend.
#'
#' @param x numeric vector of x-values, or a formula of the form `y ~ x`.
#' @param y numeric vector of y-values (ignored if a formula is used).
#'
#' @param formula a formula of the form `y ~ x`.
#' @param data an optional data frame containing variables in the formula.
#' @param subset optional expression indicating which observations to use.
#' @param na.action a function specifying how missing values are handled.
#'   Defaults to `na.omit`.
#'
#' @param main main title of the plot. `NULL` (default) derives a
#'   title from the input - `deparse(y) ~ deparse(x)` for the default
#'   method, or the formula's `dataName` for the formula method.
#'   `""`, `NA`, or `FALSE` suppress the title entirely
#'   (and compact the top margin accordingly); any other string is used
#'   as given (resolved internally via `.resolveTitle()`).
#' @param xlab label for the x-axis.
#' @param ylab label for the y-axis.
#'
#' @param xlim numeric vector of length 2; x-axis limits. If `NULL`
#'   (default), the range of `x` is used.
#' @param ylim numeric vector of length 2; y-axis limits. If `NULL`
#'   (default), the range of `y` is used.
#'
#' @param col color of the points. `.useTheme` (default) resolves to
#'   `getTheme()$points$col`.
#' @param bg background (fill) color of the points. `.useTheme`
#'   (default) resolves to `getTheme()$points$bg`.
#' @param pch plotting character. `.useTheme` (default) resolves to
#'   `getTheme()$points$pch`.
#' @param cex character expansion factor for points. `.useTheme`
#'   (default) resolves to `getTheme()$points$cex`.
#'
#' @param grid controls drawing of the background grid.
#'   Can be:
#'   \itemize{
#'     \item `.useTheme` (default): follow the active theme
#'       (`getTheme()$grid`)
#'     \item `TRUE`: draw grid with theme settings
#'     \item `FALSE`, `NULL`, or `NA`: suppress grid
#'     \item a named list: arguments passed to [graphics::grid()],
#'       overriding the theme defaults for this call only
#'   }
#'
#' @param lm controls drawing of the linear regression line.
#'   Can be:
#'   \itemize{
#'     \item `TRUE`: draw with default settings
#'     \item `FALSE`, `NULL`, or `NA`: suppress
#'     \item a named list: arguments passed to [graphics::lines()],
#'       e.g. `list(col = "blue", lwd = 2)`
#'   }
#'
#' @param loess controls drawing of the locally weighted regression line.
#'   Can be:
#'   \itemize{
#'     \item `TRUE`: draw with default settings
#'     \item `FALSE`, `NULL`, or `NA`: suppress
#'     \item a named list: arguments passed to [graphics::lines()],
#'       e.g. `list(col = "red", lty = "dashed")`
#'   }
#'
#' @param legend controls drawing of the legend.
#'   Can be:
#'   \itemize{
#'     \item `TRUE`: draw with default settings (position `"topright"`)
#'     \item `FALSE`, `NULL`, or `NA`: suppress
#'     \item a named list: arguments passed to [graphics::legend()],
#'       e.g. `list(x = "bottomleft")`
#'   }
#'   The legend is only drawn when at least one of `lm` or `loess`
#'   is active. `lm`/`loess` line colors are taken from the
#'   active theme's `twin` colors (`getTheme()$twin`).
#'
#' @param box controls drawing of the plot box.
#'   Can be:
#'   \itemize{
#'     \item `.useTheme` (default): follow the active theme
#'       (`getTheme()$box`)
#'     \item `TRUE`: draw box with theme settings
#'     \item `FALSE`, `NULL`, or `NA`: suppress box
#'     \item a named list: arguments passed to [graphics::box()],
#'       overriding the theme defaults for this call only
#'   }
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/
#'   `NULL`, a string, or a named list for [stamp()].
#' @param ... further graphical parameters passed to `par()` via the
#'   internal framework.
#'
#' @details
#' Optional plot components (`grid`, `box`, `lm`,
#' `loess`, `legend`) follow [bedrock::callIf()]
#' semantics:
#' \itemize{
#'   \item `TRUE`: draw with defaults
#'   \item `FALSE`, `NULL`, or `NA`: suppress component
#'   \item named list: customize component arguments
#' }
#'
#' `col`, `bg`, `pch`, `cex`, `grid`, and `box`
#' default to `.useTheme`, deferring to the package's active theme
#' (see [theme]) rather than a hardcoded value. This means
#' `setTheme(list(points = list(col = "black")))` changes the point
#' color for every call to `plotXY()` (and any other function using
#' the same theme section) that doesn't override `col` explicitly.
#'
#' @return Invisibly returns `NULL`.
#'
#' @seealso
#' [graphics::plot()],
#' [stats::lm()],
#' [stats::loess()],
#' [bedrock::callIf()]
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
#'
#' # No title, compact top margin
#' plotXY(temperature ~ delivery_min, bedrock::Pizza, main = "")
#' }
#'


#' @family plot.bivariate  
#' @concept scatterplot  
#' @concept bivariate
#'
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
  main = NULL,
  xlab = "",
  ylab = "",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # STYLE
  col  = .useTheme,
  bg   = .useTheme,
  pch  = .useTheme,
  cex  = .useTheme,
  grid = .useTheme,
  box  = .useTheme,
  
  # FEATURES
  lm     = TRUE,
  loess  = TRUE,
  legend = TRUE,

  stamp = .useTheme,  
  ...
) {
  
  mc   <- match.call()
  main <- .resolveTitle(main, default = paste(deparse(mc$y), "~", deparse(mc$x)))
  
  col <- .useThemeValue(col, "points", "col")
  bg  <- .useThemeValue(bg,  "points", "bg")
  pch <- .useThemeValue(pch, "points", "pch")
  cex <- .useThemeValue(cex, "points", "cex")
  
  .withGraphicsState({
    
    .applyParFromDots(..., 
                      defaults=list(
                        mar=c(left=5, top=.marTop(main))
                      ))
    
    # --- prepare -------------------------------------------------
    xlim <- xlim %||% range(x, na.rm = TRUE)
    ylim <- ylim %||% range(y, na.rm = TRUE)
    
    # --- base plot -----------------------------------------------
    plot.new()
    plot.window(xlim = xlim, ylim = ylim)
    
    # --- grid ----------------------------------------------------
    .drawGrid(grid)
    
    # --- points --------------------------------------------------
    points(x, y, pch = pch, cex = cex, col = col, bg = bg)
    
    axis(1)
    axis(2)
    .drawBox(box)
    
    if (nzchar(main)) title(main = main)
    if (nzchar(xlab)) title(xlab = xlab)
    if (nzchar(ylab)) title(ylab = ylab)
    
    # --- lm line -------------------------------------------------
    twin      <- getTheme()$twin
    lm_col    <- twin[1]
    loess_col <- twin[2]
    
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
                      defaults = .legendDefaults(list(
                        x        = "topright",
                        legend   = leg_labels,
                        fill     = leg_fill,
                        text.col = "black", 
                        bg       = addOpacity("white")
                      )),
                      forbidden = c("legend", "fill"))
      
    }
    
  }, stamp = stamp)
  
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
  
  main = NULL,
  xlab = "",
  ylab = "",
  
  xlim = NULL,
  ylim = NULL,
  
  col    = .useTheme,
  bg     = .useTheme,
  pch    = .useTheme,
  cex    = .useTheme,
  
  grid   = .useTheme,
  lm     = TRUE,
  loess  = TRUE,
  legend = TRUE,
  box    = .useTheme,
  
  stamp  = .useTheme,
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
  
  x <- r$predictor
  y <- r$x
  
  main <- .resolveTitle(main, default = r$dataName)
  
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
    box    = box,
    stamp  = stamp,
    ...
  )
}
