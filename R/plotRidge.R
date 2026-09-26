
#' Ridge Plot (Stacked Density Plot)
#'
#' Draws stacked kernel density estimates (ridge plot) for grouped data.
#' Each group is displayed as a density curve shifted along the y-axis.
#'
#' @details
#' Ridge plots are useful for comparing distributions across multiple groups.
#' Each density is normalized and vertically offset, improving readability
#' compared to overlaid density plots.
#'
#' @param x a numeric vector, or a list of numeric vectors representing
#'   groups.
#' @param ... further numeric vectors (unnamed), each forming a group, or
#'   graphical parameters passed to `par()`.
#'
#' @param formula a formula of the form `y ~ group`, or `y ~ a:b` for the
#'   cells of several grouping variables. `y ~ a + b` is not accepted, see
#'   [bedrock::resolveFormula()].
#' @param data an optional data frame containing the variables in the
#'   formula.
#' @param subset an optional expression indicating which observations to
#'   use, evaluated in `data` (`subset = len > 10`), as in [boxplot()].
#' @param na.action a function specifying how missing values are handled,
#'   defaults to [na.omit()].
#'
#' @param add logical; if `TRUE`, adds to an existing plot.
#' @param bw bandwidth for [stats::density()].
#' @param scale scaling factor for density height.
#' @param normalize how the density heights are scaled to `scale`:
#'   `"global"` (default) divides all densities by the highest peak of all
#'   groups, so that heights stay comparable across groups (as in ggridges);
#'   `"group"` divides each density by its own peak, so that every ridge
#'   reaches the full height. Use the latter when a single narrow group
#'   would otherwise flatten all others.
#' @param spacing vertical spacing between ridges.
#'
#' @param col fill color(s), recycled over the groups. `NULL` (default)
#'   uses the palette.
#' @param border border color(s), recycled over the groups. `NULL` (default)
#'   uses `col`.
#' @param lwd line width(s).
#' @param lty line type(s).
#' @param fill logical; fill area under densities.
#' @param grid logical, `NA`, or list controlling grid.
#'
#' @param main main title. `NULL` (default) derives the title from the
#'   input: the names of the data arguments, or the formula. `""`, `NA`, or
#'   `FALSE` suppress the title and compact the top margin.
#' @param xlab,ylab axis labels. For the formula method, empty labels
#'   default to the response and the grouping variable.
#' @param xlim,ylim axis limits.
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, a string, or a
#'   named list for [stamp()].
#'
#' @return Invisibly returns `NULL`.
#'
#' @examples
#' set.seed(1)
#' df <- data.frame(
#'   value = c(rnorm(100), rnorm(100, 2), rnorm(100, 4)),
#'   group = rep(c("A", "B", "C"), each = 100)
#' )
#'
#' plotRidge(value ~ group, data = df)
#'
#' # subset and the cells of two grouping variables
#' plotRidge(len ~ supp:dose, ToothGrowth, subset = len > 8)
#'
#' # the narrow group VC:0.5 flattens all others; scale each ridge to its
#' # own peak instead
#' plotRidge(len ~ supp:dose, ToothGrowth, subset = len > 8,
#'           normalize = "group")
#'
#' @seealso [plotDens()]
#' @concept base-graphics
#' @concept plotting
#'
#' @name plotRidge
NULL



#' @family plot.univariate  
#' @concept density  
#' @concept distribution-summary
#'
#'
#' @export
plotRidge <- function(x, ...) {
  UseMethod("plotRidge")
}


#' @rdname plotRidge
#' @method plotRidge default
#' @export
plotRidge.default <- function(
    
  # DATA
  x,
  ...,
  
  # STRUCTURE
  add = FALSE,
  bw = "nrd0",
  scale = 1,
  normalize = c("global", "group"),
  spacing = 1,
  
  # STYLE
  col = NULL,
  border = NULL,
  lwd = 1,
  lty = 1,
  fill = TRUE,
  grid = NA,
  
  # LABELS
  main = NULL,
  xlab = "",
  ylab = "",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  stamp = .useTheme
  
) {
  
  m    <- match.call(expand.dots = FALSE)
  dots <- list(...)
  
  normalize <- match.arg(normalize)
  
  # names(dots) is NULL when no argument in ... is named; the comparison
  # then gave logical(0), and every further data vector was dropped:
  # plotRidge(x, y) drew x only
  dotNames <- names(dots) %||% character(length(dots))
  unnamed  <- !nzchar(dotNames)
  
  groups <- if (is.list(x)) x else c(list(x), dots[unnamed])
  n <- length(groups)
  
  if (n == 0) stop("invalid input")
  
  # the data arguments as written, e.g. "x", "y": ridge labels for
  # separate vectors, and the default title
  argNames <- if (is.list(x)) deparse1(m$x)
              else vapply(c(list(m$x), m$...[unnamed]), deparse1, "")
  
  main <- .resolveTitle(main, default = paste(argNames, collapse = ", "))
  
  if (is.null(names(groups)))
    names(groups) <- if (is.list(x)) seq_len(n) else argNames
  
  # --- densities ----------------------------------------------
  
  dens_list <- lapply(groups, function(xi) {
    xi <- xi[!is.na(xi)]
    if (length(xi) < 2) return(NULL)
    density(xi, bw = bw)
  })
  
  valid <- !sapply(dens_list, is.null)
  dens_list <- dens_list[valid]
  groups <- groups[valid]
  n <- length(dens_list)
  
  if (n == 0) stop("no valid groups")
  
  # normalize heights: to the highest peak of all groups (comparable
  # heights), or each to its own peak (every ridge at full height)
  maxy <- max(unlist(lapply(dens_list, `[[`, "y")))
  dens_list <- lapply(dens_list, function(d) {
    d$y <- d$y / (if (normalize == "global") maxy else max(d$y)) * scale
    d
  })
  
  # --- ranges --------------------------------------------------
  
  xr <- range(unlist(lapply(dens_list, `[[`, "x")), na.rm = TRUE)
  # the top ridge starts at (n - 1) * spacing and reaches 'scale' above
  # it; n * spacing left an empty band of one spacing at the top
  yr <- c(0, ((n - 1) * spacing + scale) * 1.04)
  
  xlim <- xlim %||% xr
  ylim <- ylim %||% yr
  
  # --- colors --------------------------------------------------
  
  # recycled: a single colour (col = "red") coloured the first ridge only,
  # the others got NA and were invisible
  col    <- rep_len(col %||% .getOption("palette", grDevices::palette()), n)
  border <- rep_len(border %||% col, n)
  
  # --- theme ---------------------------------------------------
  
  th <- .theme(
    grid = list(col = "grey90", lwd = 1, lty = "dotted")
  )
  
  # --- plotting ------------------------------------------------
  
  .withGraphicsState({
    
    .applyParFromDots(..., defaults = list(mar = c(top = .marTop(main))))
    
    if (!add) {
      plot(NA,
           xlim = xlim,
           ylim = ylim,
           main = main,
           xlab = xlab,
           ylab = ylab,
           type = "n",
           yaxt = "n")
    }
    
    # grid
    bedrock::callIf(graphics::grid, grid,
            defaults = th$grid[!startsWith(names(th$grid), "group.")])  
    
    # ridges
    for (i in seq_len(n)) {
      
      d <- dens_list[[i]]
      y_offset <- (i - 1) * spacing
      
      if (isTRUE(fill)) {
        polygon(
          c(d$x, rev(d$x)),
          c(y_offset + d$y, rep(y_offset, length(d$y))),
          col = adjustcolor(col[i], alpha.f = 0.4),
          border = border[i],
          lwd = lwd,
          lty = lty
        )
      } else {
        lines(
          d$x, y_offset + d$y,
          col = col[i],
          lwd = lwd,
          lty = lty
        )
      }
    }
    
    # axis
    axis(2,
         at = (seq_len(n) - 1) * spacing,
         labels = names(groups),
         las = 1)
    
  }, stamp = stamp)
  
  invisible(NULL)
}




#' @rdname plotRidge
#' @method plotRidge formula
#' @export
plotRidge.formula <- function(
    formula,
    data,
    subset,
    na.action = na.omit,
    ...,
    main = NULL,
    xlab = "",
    ylab = ""
) {
  
  # formula, data and subset are forwarded unevaluated, so that 'subset' is
  # evaluated in 'data' as in boxplot(); y ~ a:b yields the cells as one
  # grouping factor, y ~ a + b is rejected
  r <- bedrock::resolveFormulaFromCall(
    allowed   = c("two-sample-independent", "n-sample-independent"),
    na.action = na.action
  )
  
  splitData <- split(r$x, r$group)
  
  main <- .resolveTitle(main, default = r$dataName)
  
  if (!nzchar(xlab)) xlab <- deparse1(formula[[2L]])   # response
  if (!nzchar(ylab)) ylab <- deparse1(formula[[3L]])   # grouping
  
  # the remaining arguments (bw, scale, col, ...) reach the default method
  # through ...
  plotRidge.default(
    splitData,
    main = main,
    xlab = xlab,
    ylab = ylab,
    ...
  )
}
