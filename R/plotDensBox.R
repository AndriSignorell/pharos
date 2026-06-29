
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
#' heights of the density plot (top) and boxplot (bottom).
#'
#' @param col vector of colors. If \code{NULL}, a palette is generated.
#'
#' @param grid controls drawing of the background grid.
#'   Can be:
#'   \itemize{
#'     \item \code{TRUE}: draw grid with default settings
#'     \item \code{FALSE}, \code{NULL}, \code{NA}: suppress grid
#'     \item a named list: arguments passed to \code{\link[graphics]{grid}}
#'   }
#'
#' @param densArgs controls density estimation via
#'   \code{\link[stats]{density}}.
#'   Can be:
#'   \itemize{
#'     \item \code{TRUE}: use default density settings
#'     \item \code{FALSE}, \code{NULL}, \code{NA}: suppress densities
#'     \item a named list: additional arguments passed to
#'       \code{\link[stats]{density}}
#'   }
#'
#' @param boxArgs controls drawing of boxplots via
#'   \code{\link[graphics]{boxplot}}.
#'   Can be:
#'   \itemize{
#'     \item \code{TRUE}: use default boxplot settings
#'     \item \code{FALSE}, \code{NULL}, \code{NA}: suppress boxplots
#'     \item a named list: additional arguments passed to
#'       \code{\link[graphics]{boxplot}}
#'   }
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
#' Optional plot components are controlled using
#' \code{\link[bedrock]{callIf}} semantics:
#' \itemize{
#'   \item \code{TRUE}: draw with defaults
#'   \item \code{FALSE}: suppress component
#'   \item named list: customize component arguments
#' }
#'
#' @return Invisibly returns \code{NULL}.
#'
#' @seealso
#' \code{\link[stats]{density}},
#' \code{\link[graphics]{boxplot}},
#' \code{\link[bedrock]{callIf}}
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
#' plotDensBox(
#'   x,
#'   densArgs = list(adjust = 2),
#'   boxArgs  = list(notch = TRUE)
#' )
#'
#' plotDensBox(
#'   x,
#'   boxArgs = FALSE
#' )
#'
#' plotDensBox(x ~ g)
#' }
#'

#' @family plot.univariate  
#' @concept density  
#' @concept boxplot
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
  
  densArgs = TRUE,
  boxArgs  = TRUE,
  
  stamp = NULL,
  
  ...
) {
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # --- Prepare data ----------------------------------------------------
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
    
    # --- Colors ----------------------------------------------------------
    if (is.null(col))
      col <- grDevices::hcl.colors(ng, "Dark 3")
    
    col <- rep_len(col, ng)
    
    # --- Layout ----------------------------------------------------------
    layout(
      matrix(c(1, 2), nrow = 2),
      heights = layout_heights
    )
    
    # ====================================================================
    # Density plot
    # ====================================================================
    
    par(mar = c(0, 4.5, 1, 1),
        oma = c(0, 0, 4, 0))
    
    # --- Density precalculation -----------------------------------------
    dens_list <- lapply(
      
      split_x,
      
      function(v)
        callIf(
          stats::density,
          densArgs,
          defaults = list(
            x = v,
            na.rm = TRUE
          )
        )
    )
    
    dens_list <- Filter(
      Negate(is.null),
      dens_list
    )
    
    ymax <- if (length(dens_list)) {
      
      max(sapply(
        dens_list,
        function(d)
          max(d$y, na.rm = TRUE)
      ))
      
    } else {
      
      1
    }
    
    # --- Empty plot ------------------------------------------------------
    plot(
      NA,
      xlim = xlim,
      ylim = c(0, ymax),
      xaxt = "n",
      xlab = "",
      ylab = ylab,
      main = ""
    )
    
    # --- Grid ------------------------------------------------------------
    callIf(
      graphics::grid,
      grid,
      defaults = list(col = "grey85")
    )
    
    # --- Density lines ---------------------------------------------------
    if (length(dens_list)) {
      
      for (i in seq_along(dens_list)) {
        
        d <- dens_list[[i]]
        
        lines(
          d$x,
          d$y,
          col = col[i],
          lwd = 2
        )
      }
    }
    
    # ====================================================================
    # Boxplot
    # ====================================================================
    
    par(mar = c(3.5, 4.5, 1, 1))
    
    callIf(
      
      graphics::boxplot,
      
      boxArgs,
      
      defaults = list(
        x = split_x,
        horizontal = TRUE,
        frame.plot = FALSE,
        col = adjustcolor(col, alpha.f = 0.6),
        ylim = xlim,
        xlim = c(0.5, length(split_x) + 0.5),
        xaxt = "n",
        yaxt = "n"
      )
    )
    
    axis(1)
    
    if (!is.null(names(split_x))) {
      
      axis(
        2,
        at = seq_along(split_x),
        labels = names(split_x),
        las = 1,
        lwd = 0
      )
    }
    
    if (nzchar(main))
      title(main = main, outer = TRUE)
    
  },
  stamp = stamp,
  resetLayout = TRUE)
  
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
  
  densArgs = TRUE,
  boxArgs  = TRUE,
  
  stamp = NULL,
  
  ...
) {
  
  args <- list(
    formula   = formula,
    na.action = na.action,
    allowed   = c(
      "two-sample-independent",
      "n-sample-independent"
    )
  )
  
  if (!missing(data))
    args$data <- data
  
  if (!missing(subset))
    args$subset <- substitute(subset)
  
  r <- do.call( bedrock::resolveFormula, args )
  
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
    densArgs = densArgs,
    boxArgs = boxArgs,
    stamp = stamp,
    ...
  )
}

