
#' Density and Boxplot Combination (Grouped)
#'
#' Combines density plots and horizontal boxplots for a numeric variable,
#' optionally grouped by a categorical variable. The density plot shows the
#' distribution shape, while the boxplot summarizes key statistics such as
#' median, spread, and outliers.
#'
#' @param x numeric vector, or a formula of the form \code{x ~ g}.
#' @param g optional grouping variable (ignored if a formula is used).
#'
#' @param formula A formula of the form \code{y ~ group}.
#' @param data an optional data frame containing variables in the formula.
#' @param subset optional expression indicating which observations to use.
#' @param na.action a function specifying how missing values are handled.
#'
#' @param main main title of the plot.
#' @param xlab label for the x-axis.
#' @param ylab label for the y-axis.
#'
#' @param xlim numeric vector of length 2 specifying the x-axis limits.
#'
#' @param layout_heights numeric vector of length 2 specifying the relative
#'   heights of the density plot (top) and boxplot (bottom).
#'
#' @param col vector of colors. If \code{NULL}, a palette is generated.
#'
#' @param grid logical; if \code{TRUE}, a background grid is drawn in the
#'   density plot.
#'
#' @param args.dens optional list of additional arguments passed to
#'   \code{\link[stats]{density}}.
#'
#' @param args.box optional list of additional arguments passed to
#'   \code{\link[graphics]{boxplot}}.
#'
#' @param stamp optional annotation passed to the plotting framework.
#'
#' @param ... further graphical parameters passed to
#'   \code{\link[graphics]{par}} via the internal framework.
#'
#' @details
#' The function arranges two plots vertically using \code{\link{layout}}:
#' a density plot on top and a horizontal boxplot below. When a grouping
#' variable is provided, densities and boxplots are drawn for each group.
#'
#' @return Invisibly returns \code{NULL}.
#'
#' @seealso \code{\link[stats]{density}}, \code{\link[graphics]{boxplot}}
#'
#' @examples
#' \dontrun{
#' set.seed(1)
#' x <- rnorm(100)
#' g <- sample(c("A", "B"), 100, TRUE)
#'
#' plotDensBox(x)
#' plotDensBox(x, g)
#'
#' plotDensBox(x ~ g)
#' }
#'
#' @family plot.univariate
#' @concept graphics
#' @concept descriptive-statistics
#'
#'
#' @export
plotDensBox <- function(x, ...) {
  UseMethod("plotDensBox")
}


#' @rdname plotDensBox
#' @export
plotDensBox.default <- function(
    
  x,
  g = NULL,
  
  main = "",
  xlab = "",
  ylab = "",
  
  xlim = NULL,
  
  layout_heights = c(2, 1.4),
  
  col = NULL,
  grid = TRUE,
  
  args.dens = NULL,
  args.box = NULL,
  
  stamp = NULL,
  
  ...
) {
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # --- Prepare data ------------------------------------------------------
    if (is.null(g)) {
      split_x <- list(x)
      names(split_x) <- ""
    } else {
      g <- factor(g)
      split_x <- split(x, g)
    }
    
    if (is.null(xlim))
      xlim <- range(x, na.rm = TRUE)
    
    ng <- length(split_x)
    
    # --- Colors ------------------------------------------------------------
    if (is.null(col))
      col <- grDevices::hcl.colors(ng, "Dark 3")
    
    # --- Layout ------------------------------------------------------------
    layout(matrix(c(1, 2), nrow = 2), heights = layout_heights)
    
    # --- Density -----------------------------------------------------------
    par(mar = c(0, 4.5, 1, 1), oma = c(0,0,4,0))
    
    
    
    # --- Density vorberechnen ---------------------------------------------
    dens_list <- lapply(split_x, function(v)
      density(v, na.rm = TRUE)
    )
    
    ymax <- max(sapply(dens_list, function(d) max(d$y, na.rm = TRUE)))
    
    # --- Plot ---------------------------------------------------------------
    plot(NA,
         xlim = xlim,
         ylim = c(0, ymax),
         xaxt = "n",
         xlab = "",
         ylab = ylab,
         main = "")
    
    if (grid)
      graphics::grid(col = "grey85")
    
    for (i in seq_along(dens_list)) {
      d <- dens_list[[i]]
      lines(d$x, d$y, col = col[i], lwd = 2)
    }

    # --- Boxplot -----------------------------------------------------------
    par(mar = c(3.5, 4.5, 1, 1))

    # boxplot(
    #     x = split_x,
    #     horizontal = TRUE,
    #     frame.plot = FALSE,
    #     col = adjustcolor(col, alpha.f = 0.6),
    #     # xlim = xlim,        # OK
    #     xlim = c(0.5, length(split_x) + 0.5),  # WICHTIG
    #     xaxt = "n",
    #     yaxt = "n"
    # )
    
    box_args <- list(
      x = split_x,
      horizontal = TRUE,
      frame.plot = FALSE,
      col = adjustcolor(col, alpha.f = 0.6),
      ylim = xlim,      
      xlim = c(0.5, length(split_x) + 0.5),  
      xaxt = "n",
      yaxt = "n"
    )

    if (!is.null(args.box))
      box_args[names(args.box)] <- args.box

    do.call(graphics::boxplot, box_args)
    
    axis(1)
    
    if (!is.null(names(split_x))) {
      axis(2,
           at = seq_along(split_x),
           labels = names(split_x),
           las = 1,
           lwd = 0)
    }
    
    if (nzchar(main))
      title(main = main, outer = TRUE)
    
  }, stamp = stamp, resetLayout = TRUE)
  
  invisible(NULL)
}





#' @rdname plotDensBox
#' @method plotDensBox formula
#' @export
plotDensBox.formula <- function(
    
  formula,
  data,
  subset,
  na.action = na.omit,
  
  main = "",
  xlab = "",
  ylab = "",
  
  xlim = NULL,
  
  layout_heights = c(2, 1.4),
  
  col = NULL,
  grid = TRUE,
  
  args.dens = NULL,
  args.box = NULL,
  
  stamp = NULL,
  
  ...
) {
  
  r <- resolveFormula(
    formula = formula,
    data = data,
    subset = subset,
    na.action = na.action,
    allowed = c("two.sample.independent", "n.sample.independent")
  )
  
  x <- r$x
  g <- r$group
  
  if (!nzchar(main))
    main <- r$data.name
  
  if (!nzchar(xlab))
    xlab <- names(r$mf)[1]
  
  if (!nzchar(ylab))
    ylab <- names(r$mf)[2]
  
  plotDensBox.default(
    x = x,
    g = g,
    main = main,
    xlab = xlab,
    ylab = ylab,
    xlim = xlim,
    layout_heights = layout_heights,
    col = col,
    grid = grid,
    args.dens = args.dens,
    args.box = args.box,
    stamp = stamp,
    ...
  )
  
}

