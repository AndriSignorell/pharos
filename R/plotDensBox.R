
#' Density and Boxplot Combination (Grouped)
#'
#' Combines density plots and horizontal boxplots for a numeric variable,
#' optionally grouped by a categorical variable. The density plot shows the
#' distribution shape, while the boxplot summarizes key statistics such as
#' median, spread, and outliers.
#'
#' @param x numeric vector, or a formula of the form `x ~ g`.
#' @param g optional grouping variable (ignored if a formula is used).
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
#' @param main main title of the plot. `NULL` (default) derives the title
#'   from the input: the formula, or `x` resp. `x ~ g` for the default
#'   method. `""`, `NA`, or `FALSE` suppress the title and its outer
#'   margin.
#' @param xlab label for the x-axis, drawn below the boxplot. For the
#'   formula method, an empty label defaults to the response.
#' @param ylab label for the y-axis of the density panel.
#'
#' @param xlim numeric vector of length 2 specifying the x-axis limits.
#'   `NULL` (default) covers the data and the tails of the densities.
#'
#' @param layout_heights numeric vector of length 2 specifying the relative
#' heights of the density plot (top) and boxplot (bottom).
#'
#' @param col vector of colors, recycled over the groups. If `NULL`, a
#'   palette is generated.
#'
#' @param grid controls drawing of the background grid.
#'   Can be:
#'   \itemize{
#'     \item `TRUE`: draw grid with default settings
#'     \item `FALSE`, `NULL`, `NA`: suppress grid
#'     \item a named list: arguments passed to [graphics::grid()]
#'   }
#'
#' @param densArgs controls density estimation via
#'   [stats::density()].
#'   Can be:
#'   \itemize{
#'     \item `TRUE`: use default density settings
#'     \item `FALSE`, `NULL`, `NA`: suppress densities
#'     \item a named list: additional arguments passed to
#'       [stats::density()]
#'   }
#'
#' @param boxArgs controls drawing of boxplots via
#'   [graphics::boxplot()].
#'   Can be:
#'   \itemize{
#'     \item `TRUE`: use default boxplot settings
#'     \item `FALSE`, `NULL`, `NA`: suppress boxplots
#'     \item a named list: additional arguments passed to
#'       [graphics::boxplot()]
#'   }
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, a string, or a
#'   named list for [stamp()].
#'
#' @param ... further graphical parameters passed to
#'   [graphics::par()] via the internal framework.
#'
#' @details
#' The function arranges two plots vertically using [layout()]:
#' a density plot on top and a horizontal boxplot below. When a grouping
#' variable is provided, densities and boxplots are drawn for each group.
#'
#' Optional plot components are controlled using
#' [bedrock::callIf()] semantics:
#' \itemize{
#'   \item `TRUE`: draw with defaults
#'   \item `FALSE`: suppress component
#'   \item named list: customize component arguments
#' }
#'
#' @return Invisibly returns `NULL`.
#'
#' @seealso
#' [stats::density()],
#' [graphics::boxplot()],
#' [bedrock::callIf()]
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
#'
#' # subset and the cells of two grouping variables
#' plotDensBox(len ~ supp:dose, ToothGrowth, subset = dose > 0.5)
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
  
  main = NULL,
  xlab = "",
  ylab = "",
  
  xlim = NULL,
  
  layout_heights = c(2, 1.4),
  
  col = NULL,
  
  grid = TRUE,
  
  densArgs = TRUE,
  boxArgs  = TRUE,
  
  stamp = .useTheme,
  
  ...
) {
  
  mc   <- match.call()
  main <- .resolveTitle(main, default =
    if (is.null(mc$g)) deparse1(mc$x)
    else paste(deparse1(mc$x), "~", deparse1(mc$g)))
  
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
    
    # outer margin for the title only if there is one
    par(mar = c(0, 4.5, 1, 1),
        oma = c(0, 0, if (nzchar(main)) 3 else 0, 0))
    
    # --- Density precalculation -----------------------------------------
    # A group with fewer than 2 values gets no density (density() fails on
    # it). The list keeps one entry per group, NULL for a missing density:
    # Filter()ing the NULLs out shifted the colours of all later groups.
    dens_list <- lapply(
      
      split_x,
      
      function(v) {
        if (sum(!is.na(v)) < 2L)
          return(NULL)
        bedrock::callIf(
          stats::density,
          densArgs,
          defaults = list(
            x = v,
            na.rm = TRUE
          )
        )
      }
    )
    
    hasDens <- !vapply(dens_list, is.null, NA)
    
    ymax <- if (any(hasDens))
      max(vapply(dens_list[hasDens], function(d) max(d$y, na.rm = TRUE), 0))
    else
      1
    
    # x-axis: the data and the tails of the densities, which range(x) cut
    # off; shared by both panels
    if (is.null(xlim))
      xlim <- range(x, unlist(lapply(dens_list[hasDens], `[[`, "x")),
                    na.rm = TRUE)
    
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
    bedrock::callIf(
      graphics::grid,
      grid,
      defaults = list(col = "grey85")
    )
    
    # --- Density lines ---------------------------------------------------
    for (i in which(hasDens)) {
      
        d <- dens_list[[i]]
        
        lines(
          d$x,
          d$y,
          col = col[i],
          lwd = 2
        )
    }
    
    # ====================================================================
    # Boxplot
    # ====================================================================
    
    # room for xlab below the axis labels (title() puts it on line 3)
    par(mar = c(if (nzchar(xlab)) 4.5 else 3, 4.5, 1, 1))
    
    bedrock::callIf(
      
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
    
    # xlab was accepted but never drawn
    if (nzchar(xlab))
      title(xlab = xlab)
    
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
  
  main = NULL,
  xlab = "",
  
  ...
) {
  
  # formula, data and subset are forwarded unevaluated, so that 'subset' is
  # evaluated in 'data' as in boxplot(); y ~ a:b yields the cells as one
  # grouping factor, y ~ a + b is rejected
  r <- bedrock::resolveFormulaFromCall(
    allowed   = c("two-sample-independent", "n-sample-independent"),
    na.action = na.action
  )
  
  main <- .resolveTitle(main, default = r$dataName)
  
  if (!nzchar(xlab))
    xlab <- deparse1(formula[[2L]])   # response, below the boxplot
  
  # ylab is left to the caller: it labels the density axis, the group
  # names already label the boxplot. The remaining arguments (xlim, col,
  # densArgs, boxArgs, stamp, ...) reach the default method through ...
  plotDensBox.default(
    x    = r$x,
    g    = r$group,
    main = main,
    xlab = xlab,
    ...
  )
}
