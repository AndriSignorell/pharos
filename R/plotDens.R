
#' Grouped Density Plot
#'
#' Draws kernel density estimates for one or more groups. Supports both
#' classical density plots and conditional density plots.
#'
#' @details
#' The function defers entirely to \code{\link[bedrock]{resolveFormula}()}'s
#' design classification to pick a mode when \code{type = NULL}:
#' \itemize{
#'   \item \code{y ~ g} (\code{g} categorical) → density, one curve per
#'     group.
#'   \item \code{y ~ x} (\code{x} numeric) → conditional density
#'     \eqn{P(Y | X)}, a single curve - equivalent to
#'     \code{cdplot(x, factor(y))}.
#'   \item \code{y ~ x | g} → conditional density, one curve per level of
#'     \code{g}.
#' }
#' \code{type} can be set explicitly to override the default for a given
#' design (e.g. to force an error rather than silently doing the wrong
#' thing if a formula's shape is ambiguous).
#'
#' Graphical elements such as grids are controlled via the unified plot
#' design system using \code{bedrock::callIf()} and \code{.theme()}.
#'
#' @param ... Additional data vectors (unnamed, default method) or
#'   graphical parameters passed to \code{par()}.
#'
#' @param formula A formula of the form \code{y ~ group}, \code{y ~ x}
#'   (\code{x} numeric, conditional density), or \code{y ~ x | group}.
#' @param data Optional data frame.
#' @param subset Optional subset expression.
#' @param na.action Function to handle missing values.
#'
#' @param main,xlab,ylab Plot labels.
#' @param xlim,ylim Axis limits.
#'
#' @param add Logical; if \code{TRUE}, adds to an existing plot.
#' @param bw Bandwidth passed to \code{\link[stats]{density}} or \code{cdplot}.
#' @param type Character string specifying the plot type. One of
#'   \code{"density"}, \code{"conditional"}, or \code{NULL} (default,
#'   determined by \code{resolveFormula()}'s design classification).
#'
#' @param col Line color(s).
#' @param lwd Line width(s).
#' @param lty Line type(s).
#' @param fill For \code{type = "density"}: \code{FALSE} (default, no
#'   fill), \code{TRUE} (translucent fill derived from each group's
#'   \code{col} via \code{adjustcolor(col, alpha.f = 0.3)}), or one or
#'   more explicit fill colors recycled over groups. For
#'   \code{type = "conditional"} on a single, unstratified, binary curve:
#'   \code{TRUE} for cdplot-style grey shading, or a vector of 2 colors for
#'   the regions below/above the boundary curve.
#' @param grid Logical, \code{NA}, or list controlling background grid.
#'
#' @param stamp Controls the corner stamp. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$stamp}. \code{TRUE}/\code{FALSE}/\code{NULL},
#'   or an explicit string, as for \code{.withGraphicsState()} (internal).
#'   
#' @return Invisibly returns \code{NULL}.
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
#' @seealso \code{\link[stats]{density}}, \code{\link[graphics]{cdplot}},
#'   \code{\link[bedrock]{resolveFormula}}
#' 
#' @family topic.graphics
#' @concept base-graphics
#' @concept plotting
#' 
#' @name plotDens
NULL


#' @param x A numeric vector or list of numeric vectors.
#' @export
plotDens <- function(x, ...) {
  UseMethod("plotDens")
}


#' @export
plotDens.default <- function(
    
  # DATA
  x, ...,
  
  # LABELS
  main = NULL,
  xlab = "",
  ylab = "density",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # STRUCTURE
  add = FALSE,
  bw = "nrd0",
  
  # STYLE
  col = NULL,
  lwd = 2,
  lty = 1,
  fill = FALSE,
  grid = NULL,
  
  # FRAMEWORK
  stamp = TRUE
  
) {
  
  dots <- list(...)
  named <- names(dots) != ""
  
  groups <- if (is.list(x)) x else c(list(x), dots[!named])
  n <- length(groups)
  
  if (n == 0)
    stop("invalid input")
  
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
  yr <- range(unlist(lapply(dens_list, `[[`, "y")), na.rm = TRUE)
  
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
    
  }, stamp=stamp)
  
  invisible(NULL)
}


#' Conditional Density Engine (cdplot-based)
#'
#' Internal engine shared by both code paths of \code{\link{plotDens.formula}}
#' that need a conditional density plot: the stratified case (\code{y ~ x |
#' g}, several groups) and the degenerate single-group case (\code{y ~ x},
#' no \code{| g} block).
#'
#' @param y Response variable, coerced to a factor if not already one.
#' @param x Continuous predictor.
#' @param g Grouping/block factor. For the degenerate single-group case,
#'   pass a constant-level factor of the same length as \code{x} (e.g.
#'   \code{factor(rep.int("", length(x)))}); no legend distinction is then
#'   needed since there is only one curve.
#' @param main,xlab,ylab Plot labels.
#' @param xlim,ylim Axis limits.
#' @param add,bw,col,lwd,lty,grid see \code{\link{plotDens}}.
#' @param fill \code{FALSE} (default, no fill), \code{TRUE} (cdplot-style
#'   grey shading), or a vector of 2 colors for the regions below/above the
#'   boundary curve, representing \code{P(y = levels(y)[1] | x)} and
#'   \code{P(y = levels(y)[2] | x)}. Only supported for a binary response
#'   (\code{nlevels(y) == 2}) and a single, unstratified curve
#'   (\code{nlevels(g) == 1}); both are checked explicitly with informative
#'   errors, rather than silently producing overlapping or misleading fills.
#' @param ... further graphical parameters passed to \code{par()}.
#'
#' @return Invisibly \code{NULL}.
#'
#' @noRd
.plotDensConditional <- function(
    
  # DATA
  y, x, g,
  
  # LABELS
  main = "",
  xlab = "x",
  ylab = NULL,
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # STRUCTURE
  add = FALSE,
  bw = "nrd0",
  
  # STYLE
  col = NULL,
  lwd = 2,
  lty = 1,
  fill = FALSE,
  grid = NA,
  
  stamp = TRUE,

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
        ylim = c(0, 1),
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
    
    for (i in seq_len(n)) {
      
      idx <- g == lev[i]
      
      fit <- cdplot(y[idx] ~ x[idx], plot = FALSE, bw = bw)
      fx  <- fit[[1]]
      yy  <- fx(ptx)
      
      if (doFill) {
        polygon(c(ptx, rev(ptx)), c(rep(0, length(ptx)), rev(yy)),
                col = fill[1], border = NA)
        polygon(c(ptx, rev(ptx)), c(yy, rep(1, length(ptx))),
                col = fill[2], border = NA)
      }
      
      lines(ptx, yy, col = col[i], lwd = lwd[i], lty = lty[i])
    }
    
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
  
  ...,
  
  # LABELS
  main = NULL,
  xlab = "",
  ylab = NULL,
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # STRUCTURE
  add = FALSE,
  bw = "nrd0",
  type = NULL,
  
  # STYLE
  col = NULL,
  lwd = 2,
  lty = 1,
  fill = FALSE,
  grid = NA,

  stamp = TRUE

) {
  
  args <- list(
    formula   = formula,
    na.action = na.action,
    allowed   = c(
      "one-sample",
      "two-sample-independent",
      "n-sample-independent",
      "n-sample-dependent",
      "numeric-numeric"
    )
  )
  
  if (!missing(data))
    args$data <- data
  
  if (!missing(subset))
    args$subset <- substitute(subset)
  
  r <- do.call(bedrock::resolveFormula, args)
  
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
    
    plotDens(
      split_data,
      main = main, xlab = xlab, ylab = ylab,
      xlim = xlim, ylim = ylim,
      add = add, bw = bw,
      col = col, lwd = lwd, lty = lty, fill = fill, grid = grid,
      stamp = stamp,
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
    xlim = xlim, ylim = ylim,
    add = add, bw = bw,
    col = col, lwd = lwd, lty = lty, fill = fill, grid = grid,
    stamp = stamp,
    ...
  )
  
  invisible(NULL)
}

