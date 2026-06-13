
#' Grouped Boxplot
#'
#' Draws boxplots for a numeric variable, optionally grouped by a categorical
#' variable. Group means and a reference line for the overall mean can
#' optionally be overlaid.
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
#' @param ylim numeric vector of length 2 specifying the y-axis limits.
#'   If \code{NULL} (default), the range of \code{x} is used.
#'
#' @param col vector of colors. If \code{NULL}, a palette is generated
#'   automatically.
#'
#' @param grid controls drawing of the background grid.
#'   Can be:
#'   \itemize{
#'     \item \code{TRUE}: draw grid with default settings
#'     \item \code{FALSE}, \code{NULL}, or \code{NA}: suppress grid
#'     \item a named list: arguments passed to \code{\link[graphics]{grid}},
#'       e.g. \code{list(col = "red", nx = NA, ny = NULL)} for vertical
#'       lines only
#'   }
#'
#' @param means controls drawing of group means and an overall mean reference
#'   line. Can be:
#'   \itemize{
#'     \item \code{TRUE}: draw with default settings
#'     \item \code{FALSE}, \code{NULL}, or \code{NA}: suppress
#'     \item a named list: arguments passed to the internal means function.
#'       Supported arguments: \code{col}, \code{pch}, \code{cex},
#'       \code{lcol}, \code{lty}, \code{lwd}.
#'   }
#'
#' @param ... graphical parameters. Parameters recognized by the
#' internal graphics framework are applied via \code{par()};
#' remaining arguments are forwarded to \code{\link[graphics]{boxplot}}.
#'
#' @details
#' Optional plot components are controlled using
#' \code{\link[bedrock]{callIf}} semantics:
#' \itemize{
#'   \item \code{TRUE}: draw with defaults
#'   \item \code{FALSE}, \code{NULL}, or \code{NA}: suppress component
#'   \item named list: customize component arguments
#' }
#'
#' @return Invisibly returns \code{NULL}.
#'
#' @seealso
#' \code{\link[graphics]{boxplot}},
#' \code{\link[bedrock]{callIf}}
#'
#' @examples
#' \dontrun{
#' set.seed(1)
#' x <- rnorm(100)
#' g <- sample(c("A", "B"), 100, TRUE)
#'
#' plotBox(x)
#' plotBox(x, g)
#'
#' plotBox(x ~ g)
#' }
#'
#' @family plot.univariate
#' @concept graphics
#' @concept descriptive-statistics
#'
#' @export
plotBox <- function(x, ...) {
  UseMethod("plotBox")
}


#' @rdname plotBox
#' @export
plotBox.default <- function(
    
  x,
  g = NULL,
  
  main = "",
  xlab = "",
  ylab = "",
  
  ylim = NULL,
  
  col = NULL,
  
  grid = TRUE,
  
  means = TRUE,
  
  ...
) {
  
  # --- theme ---------------------------------------------------
  
  th <- .theme(
    grid = list(col = "grey", lwd = 1, lty = "dotted", 
                nx=NA, ny=NULL)
  )
  
  
  .withGraphicsState({
    
    .applyParFromDots(...,
                      defaults=list(
                        mar      = c(left = 5),  # default
                        col.axis = "grey40", 
                        fg       = "grey30"
                        )       # border inherits from here
    )
    
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
      col <- "grey90"
    
    col <- rep_len(col, ng)
    
    # ====================================================================
    # Boxplot
    # ====================================================================
    
    mar(top = 5.1)
    
    ylim <- ylim %||% range(x, na.rm = TRUE)
    ng_xlim <- if (is.null(g)) 1L else nlevels(factor(g))
    xlim_box <- c(0.5, ng_xlim + 0.5)
    
    plot.new()
    plot.window(xlim = xlim_box, ylim = ylim)
    
    # --- grid --------------------------------------------------
    
    bedrock::callIf(graphics::grid, grid,
                    defaults = th$grid[!startsWith(names(th$grid), "group.")])
    
    # --- boxplot --------------------------------------------------
    
    if (is.null(g)) {
      boxplot(x, add = TRUE, col = col, 
              boxlty = 0, medcol="grey50", ...)
    } else {
      boxplot(x ~ g, add = TRUE, col = col, 
              boxlty = 0, medcol="grey50", ...)
    }
    
    if (is.null(g)) {
      axis(1, at = 1, labels = "")
    } else {
      axis(1, at = seq(ng), labels = levels(g))
    }
    axis(2)
    box()
    
    # --- means --------------------------------------------------
    
    bedrock::callIf(.meansBx, means,
                    defaults = list(
                      x = seq(ng),
                      y = if (is.null(g)) mean(x, na.rm = TRUE)
                      else tapply(x, g, mean, na.rm = TRUE),
                      ytot = mean(x, na.rm = TRUE),
                      col = "darkblue",
                      pch = 4,
                      cex = 1.5,
                      lcol = "darkblue",
                      lty = "dashed",
                      lwd = 2),
                    forbidden = c("x", "y", "ytot")
    )
    
    # --- group n --------------------------------------------------

    n_per_group <- if (is.null(g)) {
      sum(!is.na(x))
    } else {
      tapply(x, g, function(z) sum(!is.na(z)))
    }
    
    mtext(text = sprintf("n = %s", fm(n_per_group, fmt = "abs.sty")),
          side = 3, at = seq(ng), cex = 0.8, line = 1)
    
    if (nzchar(main))
      title(main = main, line = 3)
    if (nzchar(xlab))
      title(xlab = xlab)
    if (nzchar(ylab))
      title(ylab = ylab)
    
    
  },
  resetLayout = TRUE)
  
  invisible(NULL)
}


#' @rdname plotBox
#' @method plotBox formula
#' @export
plotBox.formula <- function(
    
  formula,
  data,
  subset,
  na.action = na.omit,
  
  main = "",
  xlab = "",
  ylab = "",
  
  ylim = NULL,
  
  col = NULL,
  
  grid = TRUE,
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
    xlab <- names(r$mf)[2]   # grouping variable on x-axis
  
  if (!nzchar(ylab))
    ylab <- names(r$mf)[1]   # response variable on y-axis
  
  plotBox.default(
    x = x,
    g = g,
    main = main,
    xlab = xlab,
    ylab = ylab,
    ylim = ylim,
    col = col,
    grid = grid,
    ...
  )
}


.meansBx <- function(x, y, ytot, col, pch, cex, lcol, lty, lwd){
  
  abline(h = ytot, col = lcol, lty = lty, lwd = lwd)
  points(x = x, y = y, pch = pch, col = col, cex = cex)
  
}

