
#' Grouped Density Plot
#'
#' Draws kernel density estimates for one or more groups. Supports both
#' classical density plots and conditional density plots.
#'
#' @details
#' The function defers entirely to [bedrock::resolveFormula()]'s
#' design classification to pick a mode when `type = NULL`:
#' \itemize{
#'   \item `y ~ g` (`g` categorical) → density, one curve per
#'     group.
#'   \item `y ~ x` (`x` numeric) → conditional density
#'     \eqn{P(Y | X)}, a single curve - equivalent to
#'     `cdplot(x, factor(y))`.
#'   \item `y ~ x | g` → conditional density, one curve per level of
#'     `g`.
#' }
#' `type` can be set explicitly to override the default for a given
#' design (e.g. to force an error rather than silently doing the wrong
#' thing if a formula's shape is ambiguous).
#'
#' Graphical elements such as grids are controlled via the unified plot
#' design system using `bedrock::callIf()` and `.theme()`.
#'
#' @param ... additional data vectors (unnamed, default method) or
#'   graphical parameters passed to `par()`.
#'
#' @param formula a formula of the form `y ~ group` (or `y ~ a:b` for the
#'   cells of several grouping variables), `y ~ x` (`x` numeric,
#'   conditional density), or `y ~ x | group`. `y ~ a + b` is not accepted,
#'   see [bedrock::resolveFormula()].
#' @param data an optional data frame containing the variables in the
#'   formula.
#' @param subset an optional expression indicating which observations to
#'   use, evaluated in `data` (`subset = len > 10`), as in [boxplot()].
#' @param na.action a function specifying how missing values are handled,
#'   defaults to [na.omit()].
#'
#' @param main main title. `NULL` (default) derives the title from the
#'   input: the names of the data arguments, or the formula. `""`, `NA`, or
#'   `FALSE` suppress the title and compact the top margin.
#' @param xlab,ylab axis labels.
#' @param xlim,ylim axis limits. `NULL` (default) uses the range of the
#'   densities, the y-axis starting at 0 (`c(0, 1)` for a conditional
#'   density).
#'
#' @param add logical; if `TRUE`, adds to an existing plot.
#' @param bw bandwidth passed to [stats::density()] or `cdplot`.
#' @param type character string specifying the plot type. One of
#'   `"density"`, `"conditional"`, or `NULL` (default,
#'   determined by `resolveFormula()`'s design classification).
#'
#' @param col line color(s).
#' @param lwd line width(s).
#' @param lty line type(s).
#' @param fill for `type = "density"`: `FALSE` (default, no
#'   fill), `TRUE` (translucent fill derived from each group's
#'   `col` via `adjustcolor(col, alpha.f = 0.3)`), or one or
#'   more explicit fill colors recycled over groups. For
#'   `type = "conditional"` on a single, unstratified, binary curve:
#'   `TRUE` for cdplot-style grey shading, or a vector of 2 colors for
#'   the regions below/above the boundary curve.
#' @param grid logical, `NA`, or list controlling background grid.
#' @param legend controls the legend, drawn only for more than one curve,
#'   with the group names (the level names for the formula method, the
#'   names of the data arguments otherwise). `TRUE` (default) draws it with
#'   default settings, `FALSE`/`NULL`/`NA` suppress it, a named list is
#'   passed on to [graphics::legend()] (e.g. `list(x = "topleft")`).
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`,
#'   or an explicit string, as for `.withGraphicsState()` (internal).
#'   
#' @return Invisibly returns `NULL`.
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(100)
#' g <- rep(c("A", "B"), each = 50)
#'
#' # standard density (k = 2 groups)
#' plotDens(x ~ g)
#'
#' # conditional density, single curve - auto-detected, no type= needed
#' y <- rbinom(100, 1, plogis(x))
#' plotDens(y ~ x)
#'
#' # same, with cdplot-style fill
#' plotDens(y ~ x, fill = c("red", "blue"))
#'
#' # conditional density, stratified by group
#' plotDens(y ~ x | g)
#'
#' # subset and the cells of two grouping variables
#' plotDens(len ~ supp:dose, ToothGrowth, subset = dose > 0.5)
#'
#' @seealso [stats::density()], [graphics::cdplot()],
#'   [bedrock::resolveFormula()]
#' 
#' @concept base-graphics
#' @concept plotting
#' 
#' @name plotDens
NULL


#' @param x A numeric vector or list of numeric vectors.

#' @family plot.univariate  
#' @concept density  
#' @concept distribution-summary
#'
#'
#' @export
plotDens <- function(x, ...) {
  UseMethod("plotDens")
}


#' @rdname plotDens
#' @method plotDens default
#' @export
plotDens.default <- function(
    # DATA
    x,
    ...,

    # LABELS
    main = NULL,
    xlab = "",
    ylab = "density",

    # AXES
    xlim = NULL,
    ylim = NULL,

    # STATISTICS
    bw = "nrd0",

    # STRUCTURE
    add = FALSE,

    # STYLE
    col  = NULL,
    lwd  = 2,
    lty  = 1,
    fill = FALSE,
    grid = NULL,

    # FEATURES
    legend = TRUE,

    # FRAMEWORK
    stamp = .useTheme
) {
  
  m    <- match.call(expand.dots = FALSE)
  dots <- list(...)
  
  # names(dots) is NULL when no argument in ... is named; the comparison
  # then gave logical(0), and every further data vector was dropped:
  # plotDens(x, y) drew x only
  dotNames <- names(dots) %||% character(length(dots))
  unnamed  <- !nzchar(dotNames)
  
  groups <- if (is.list(x)) x else c(list(x), dots[unnamed])
  n <- length(groups)
  
  if (n == 0)
    stop("invalid input")
  
  # the data arguments as written: legend labels for separate vectors, and
  # the default title
  argNames <- if (is.list(x)) deparse1(m$x)
              else vapply(c(list(m$x), m$...[unnamed]), deparse1, "")
  
  if (is.null(names(groups)))
    names(groups) <- if (is.list(x)) seq_len(n) else argNames
  
  main <- .resolveTitle(main, default = paste(argNames, collapse = ", "))
  
  dens_list <- lapply(groups, function(xi) {
    xi <- xi[!is.na(xi)]
    if (length(xi) < 2) return(NULL)
    density(xi, bw = bw)
  })
  
  valid <- !sapply(dens_list, is.null)
  dens_list <- dens_list[valid]
  groups <- groups[valid]
  n <- length(dens_list)
  
  if (n == 0)
    stop("no valid groups")
  
  xr <- range(unlist(lapply(dens_list, `[[`, "x")), na.rm = TRUE)
  # from 0: range() of the densities started at their smallest value, so
  # the axis floated above 0 and a fill reached below the plot region
  yr <- c(0, max(unlist(lapply(dens_list, `[[`, "y")), na.rm = TRUE))
  
  xlim <- xlim %||% xr
  ylim <- ylim %||% yr
  
  if (is.null(col))
    col <- .getOption("palette", grDevices::palette())[seq_len(n)]
  
  col <- rep_len(col, n)
  lwd <- rep_len(lwd, n)
  lty <- rep_len(lty, n)
  
  # --- fill: FALSE (none), TRUE (derive from col), or explicit color(s) ---
  fillCol <- if (is.character(fill)) {
    rep_len(fill, n)
  } else if (isTRUE(fill)) {
    adjustcolor(col, alpha.f = 0.3)
  } else {
    NULL
  }
  
  th <- .theme(
    grid = list(col = "grey80", 
                lwd = 1, lty = "dotted"),
    box  = list(col = "grey")
  )
  
  .withGraphicsState({
    
    .applyParFromDots(...,
                      defaults = list(
                        mar = c(
                          left  = 5.1,
                          top   = .marTop(main)
                        ),
                        col.axis = "grey40",
                        fg       = "grey50"     # border inherits from here
                      ))
    
    if (!add) {
      plot(NA,
           xlim = xlim,
           ylim = ylim,
           main = main,
           xlab = xlab,
           ylab = ylab,
           type = "n")
    }
    
    bedrock::callIf(graphics::grid, grid,
                    defaults = th$grid[!startsWith(names(th$grid), "group.")])
    
    for (i in seq_len(n)) {
      
      d <- dens_list[[i]]
      
      if (!is.null(fillCol)) {
        polygon(c(d$x, rev(d$x)),
                c(d$y, rep(0, length(d$y))),
                col = fillCol[i],
                border = NA)
      }
      
      lines(d$x, d$y,
            col = col[i],
            lwd = lwd[i],
            lty = lty[i])
    }
    
    .densLegend(legend, names(groups), col, lwd, lty)
    
  }, stamp=stamp)
  
  invisible(NULL)
}


#' Conditional Density Engine (cdplot-based)
#'
#' Internal engine shared by both code paths of [plotDens.formula()]
#' that need a conditional density plot: the stratified case (`y ~ x |
#' g`, several groups) and the degenerate single-group case (`y ~ x`,
#' no `| g` block).
#'
#' @param y response variable, coerced to a factor if not already one.
#' @param x continuous predictor.
#' @param g grouping/block factor. For the degenerate single-group case,
#'   pass a constant-level factor of the same length as `x` (e.g.
#'   `factor(rep.int("", length(x)))`); no legend distinction is then
#'   needed since there is only one curve.
#' @param main,xlab,ylab plot labels.
#' @param xlim,ylim axis limits.
#' @param add,bw,col,lwd,lty,grid,legend,stamp see [plotDens()].
#' @param fill `FALSE` (default, no fill), `TRUE` (cdplot-style
#'   grey shading), or a vector of 2 colors for the regions below/above the
#'   boundary curve, representing `P(y = levels(y)[1] | x)` and
#'   `P(y = levels(y)[2] | x)`. Only supported for a binary response
#'   (`nlevels(y) == 2`) and a single, unstratified curve
#'   (`nlevels(g) == 1`); both are checked explicitly with informative
#'   errors, rather than silently producing overlapping or misleading fills.
#' @param ... further graphical parameters passed to `par()`.
#'
#' @return Invisibly `NULL`.
#'
#' @noRd
.plotDensConditional <- function(
    # DATA
    y,
    x,
    g,

    # LABELS
    main = "",
    xlab = "x",
    ylab = NULL,

    # AXES
    xlim = NULL,
    ylim = NULL,

    # STATISTICS
    bw = "nrd0",

    # STRUCTURE
    add = FALSE,

    # STYLE
    col  = NULL,
    lwd  = 2,
    lty  = 1,
    fill = FALSE,
    grid = NA,

    # FEATURES
    legend = TRUE,

    # FRAMEWORK
    stamp = .useTheme,

    ...
) {
  
  if (!is.factor(y)) y <- factor(y)
  g <- factor(g)
  
  lev   <- levels(g)
  n     <- length(lev)
  nYLev <- nlevels(y)
  
  doFill <- isTRUE(fill) || is.character(fill)
  
  if (doFill && nYLev != 2)
    stop(
      "fill is currently only supported for a binary response ",
      "(2 levels); the response here has ", nYLev, " levels."
    )
  
  if (doFill && n > 1)
    stop(
      "fill is currently only supported for a single, unstratified ",
      "curve (no '| group' block); the filled regions would overlap ",
      "across groups. Use fill = FALSE for stratified plots."
    )
  
  if (isTRUE(fill))
    fill <- c("grey75", "grey90")     # cdplot-style default shading
  
  if (doFill)
    fill <- rep_len(fill, 2)
  
  ptx <- if (is.null(xlim))
    pretty(range(x, na.rm = TRUE), n = 200)
  else
    pretty(xlim, n = 200)
  
  if (is.null(col))
    col <- .getOption("palette", grDevices::palette())[seq_len(n)]
  
  col <- rep_len(col, n)
  lwd <- rep_len(lwd, n)
  lty <- rep_len(lty, n)
  
  th <- .theme(
    grid = list(col = "grey90", lwd = 1, lty = "dotted")
  )
  
  if (is.null(ylab))
    ylab <- "P(y | x)"
  
  .withGraphicsState({
    
    .applyParFromDots(...,
                      defaults = list(
                        mar = c(
                          left  = 5.1,
                          top   = .marTop(main)
                        ),
                        xaxs="i",
                        yaxs="i"
                      ))
    
    if (!add) {
      plot(
        NA,
        xlim = range(ptx),
        ylim = ylim %||% c(0, 1),
        main = main,
        xlab = xlab,
        ylab = ylab,
        type = "n"
      )
    }
    
    bedrock::callIf(
      graphics::grid,
      grid,
      defaults = th$grid[!startsWith(names(th$grid), "group.")]
    )
    
    rightEnd <- numeric(n)
    
    for (i in seq_len(n)) {
      
      idx <- g == lev[i]
      
      fit <- cdplot(y[idx] ~ x[idx], plot = FALSE, bw = bw)
      fx  <- fit[[1]]
      yy  <- fx(ptx)
      
      # level of the curve over the right third, for placing the legend
      rightEnd[i] <- mean(yy[ptx >= quantile(ptx, 2/3)], na.rm = TRUE)
      
      if (doFill) {
        polygon(c(ptx, rev(ptx)), c(rep(0, length(ptx)), rev(yy)),
                col = fill[1], border = NA)
        polygon(c(ptx, rev(ptx)), c(yy, rep(1, length(ptx))),
                col = fill[2], border = NA)
      }
      
      lines(ptx, yy, col = col[i], lwd = lwd[i], lty = lty[i])
    }
    
    # the probabilities span 0..1: put the legend where the curves are not,
    # at the right edge
    .densLegend(legend, lev, col, lwd, lty,
                x = if (mean(rightEnd) > 0.5) "bottomright" else "topright")
    
  }, stamp=stamp)
  
  invisible(NULL)
}


#' @rdname plotDens
#' @method plotDens formula
#' @export
plotDens.formula <- function(
    # DATA
    formula,
    data,
    subset,
    na.action = na.omit,

    # LABELS
    main = NULL,
    xlab = "",
    ylab = NULL,

    # STRUCTURE
    type = NULL,

    ...
) {
  
  # formula, data and subset are forwarded unevaluated, so that 'subset' is
  # evaluated in 'data' as in boxplot(); y ~ a:b yields the cells as one
  # grouping factor, y ~ a + b is rejected
  r <- bedrock::resolveFormulaFromCall(
    allowed   = c(
      "one-sample",
      "two-sample-independent",
      "n-sample-independent",
      "n-sample-dependent",
      "numeric-numeric"
    ),
    na.action = na.action
  )
  
  main <- .resolveTitle(main, default = r$dataName)
  
  # ============================================================
  # type = NULL: defer to resolveFormula()'s own classification -
  # density for a categorical group / one-sample, conditional for
  # a continuous predictor or an explicit "| group" block.
  # ============================================================
  
  if (is.null(type)) {
    type <- if (r$type %in% c("numeric-numeric", "n-sample-dependent"))
      "conditional"
    else
      "density"
  } else {
    type <- match.arg(type, c("density", "conditional"))
  }
  
  # ============================================================
  # density
  # ============================================================
  
  if (type == "density") {
    
    if (r$type == "numeric-numeric")
      stop(
        "type = \"density\" requires a categorical grouping variable; '",
        names(r$mf)[2], "' is numeric. Wrap it in factor(), e.g. ",
        names(r$mf)[1], " ~ factor(", names(r$mf)[2], "), or use ",
        "type = \"conditional\"."
      )
    
    if (r$type == "n-sample-dependent")
      stop("use type = \"conditional\" for y ~ x | group")
    
    # x/group have identical shape (full length n) for both k = 2 and
    # k > 2 - no special-casing required.
    split_data <- if (r$type == "one-sample")
      list(r$x)
    else
      split(r$x, r$group)
    
    if (!nzchar(xlab))
      xlab <- names(r$mf)[1]
    
    if (is.null(ylab))
      ylab <- "density"
    
    # the remaining arguments (xlim, bw, col, fill, legend, stamp, ...)
    # reach the default method through ...
    plotDens.default(
      split_data,
      main = main, xlab = xlab, ylab = ylab,
      ...
    )
    
    return(invisible(NULL))
  }
  
  # ============================================================
  # conditional: stratified (n-sample-dependent) or single-group
  # (numeric-numeric)
  # ============================================================
  
  if (r$type == "one-sample")
    stop(
      "type = \"conditional\" requires a predictor variable; ",
      "use a two-variable formula such as y ~ x."
    )
  
  if (r$type %in% c("two-sample-independent", "n-sample-independent"))
    stop(
      "type = \"conditional\" requires a numeric predictor; '",
      names(r$mf)[2], "' is categorical. Use a '| group' block instead, ",
      "e.g. ", names(r$mf)[1], " ~ x | ", names(r$mf)[2], "."
    )
  
  if (r$type == "numeric-numeric") {
    yVal <- r$x
    xVal <- r$predictor
    gVal <- factor(rep.int("", length(xVal)))
  } else {
    # n-sample-dependent
    yVal <- r$response
    xVal <- r$treatment
    gVal <- r$block
  }
  
  if (!nzchar(xlab))
    xlab <- names(r$mf)[2]
  
  if (is.null(ylab))
    ylab <- paste0("P(", names(r$mf)[1], " | ", names(r$mf)[2], ")")
  
  .plotDensConditional(
    y = yVal, x = xVal, g = gVal,
    main = main, xlab = xlab, ylab = ylab,
    ...
  )
  
  invisible(NULL)
}



# legend for more than one curve, shared by the density and the
# conditional engine
.densLegend <- function(legend, labels, col, lwd, lty, x = "topright") {
  if (length(labels) < 2L)
    return(invisible())
  bedrock::callIf(
    graphics::legend,
    legend,
    defaults = .legendDefaults(list(
      x      = x,
      inset  = 0.02,
      legend = labels,
      col    = col,
      lwd    = lwd,
      lty    = lty,
      bty    = "n"
    )),
    forbidden = "legend"
  )
}
