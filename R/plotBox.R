
#' Grouped Boxplot
#'
#' Draws boxplots for a numeric variable, optionally grouped by a categorical
#' variable. Group means and a reference line for the overall mean can
#' optionally be overlaid.
#'
#' @param x numeric vector, or a formula of the form `x ~ g`.
#' @param groups optional grouping variable (ignored if a formula is used).
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
#'   from the input: the formula, or `x ~ g` for the default method.
#'   `""`, `NA`, or `FALSE` suppress the title and compact the top margin.
#' @param xlab label for the x-axis.
#' @param ylab label for the y-axis.
#'
#' @param ylim numeric vector of length 2 specifying the y-axis limits.
#'   If `NULL` (default), the range of `x` is used.
#'
#' @param col vector of fill colors, recycled over the groups. `NULL`
#'   (default) uses `"grey90"`.
#'
#' @param grid controls drawing of the background grid.
#'   Can be:
#'   \itemize{
#'     \item `TRUE`: draw grid with default settings
#'     \item `FALSE`, `NULL`, or `NA`: suppress grid
#'     \item a named list: arguments passed to [graphics::grid()],
#'       e.g. `list(col = "red", nx = NA, ny = NULL)` for vertical
#'       lines only
#'   }
#'
#' @param means controls drawing of group means and an overall mean reference
#'   line. Can be:
#'   \itemize{
#'     \item `TRUE`: draw with default settings
#'     \item `FALSE`, `NULL`, or `NA`: suppress
#'     \item a named list: arguments passed to the internal means function.
#'       Supported arguments: `col`, `pch`, `cex`,
#'       `lcol`, `lty`, `lwd`.
#'   }
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`,
#'   or an explicit string, as for `.withGraphicsState()` (internal).
#'   
#' @param ... graphical parameters. Parameters recognized by the
#' internal graphics framework are applied via `par()`;
#' remaining arguments are forwarded to [graphics::boxplot()].
#'
#' @details
#' Optional plot components are controlled using
#' [bedrock::callIf()] semantics:
#' \itemize{
#'   \item `TRUE`: draw with defaults
#'   \item `FALSE`, `NULL`, or `NA`: suppress component
#'   \item named list: customize component arguments
#' }
#'
#' @return Invisibly returns `NULL`.
#'
#' @seealso
#' [graphics::boxplot()],
#' [bedrock::callIf()]
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
#'
#' # data, subset and the cells of two grouping variables
#' plotBox(len ~ supp, ToothGrowth, subset = dose > 0.5)
#' plotBox(len ~ supp:dose, ToothGrowth)
#' }
#'

#' @family plot.univariate  
#' @concept boxplot  
#' @concept distribution-summary
#'
#'
#' @export
plotBox <- function(x, ...) {
  UseMethod("plotBox")
}


#' @rdname plotBox
#' @export
plotBox.default <- function(
    
  x,
  groups = NULL,
  
  main = NULL,
  xlab = "",
  ylab = "",
  
  ylim = NULL,
  
  col = NULL,
  
  grid = TRUE,
  
  means = TRUE,
  
  stamp = .useTheme,

  ...
) {
  
  # --- theme ---------------------------------------------------
  
  th <- .theme(
    grid = list(col = "grey", lwd = 1, lty = "dotted", 
                nx=NA, ny=NULL)
  )
  
  # the default method's arguments are x and groups; mc$y does not exist and
  # gave the title "NULL ~ x"
  mc   <- match.call()
  main <- .resolveTitle(main, default =
    if (is.null(mc$groups)) deparse1(mc$x)
    else paste(deparse1(mc$x), "~", deparse1(mc$groups)))
  
  .withGraphicsState({
    
    .applyParFromDots(...,
                      defaults=list(
                        mar      = c(left = 5, top = .marTop(main)) + 1,  # default
                        col.axis = "grey40", 
                        fg       = "grey30"
                        )       # border inherits from here
    )
    
    # --- Prepare data ----------------------------------------------------
    if (is.null(groups)) {
      
      split_x <- list(x)
      names(split_x) <- ""
      
    } else {
      
      groups <- factor(groups)
      split_x <- split(x, groups)
    }
    
    ng <- length(split_x)
    
    # --- Colors ----------------------------------------------------------
    if (is.null(col))
      col <- "grey90"
    
    col <- rep_len(col, ng)
    
    # ====================================================================
    # Boxplot
    # ====================================================================
    
    ylim <- ylim %||% range(x, na.rm = TRUE)
    xlim_box <- c(0.5, ng + 0.5)
    
    plot.new()
    plot.window(xlim = xlim_box, ylim = ylim)
    
    # --- grid --------------------------------------------------
    
    bedrock::callIf(graphics::grid, grid,
                    defaults = th$grid[!startsWith(names(th$grid), "group.")])
    
    # --- boxplot --------------------------------------------------
    
    if (is.null(groups)) {
      boxplot(x, add = TRUE, col = col, 
              boxlty = 0, medcol="grey50", ...)
    } else {
      boxplot(x ~ groups, add = TRUE, col = col, 
              boxlty = 0, medcol="grey50", ...)
    }
    
    if (is.null(groups)) {
      axis(1, at = 1, labels = "")
    } else {
      axis(1, at = seq(ng), labels = levels(groups))
    }
    axis(2)
    box()
    
    # --- means --------------------------------------------------
    
    bedrock::callIf(.meansBx, means,
                    defaults = list(
                      x = seq(ng),
                      y = if (is.null(groups)) mean(x, na.rm = TRUE)
                      else tapply(x, groups, mean, na.rm = TRUE),
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

    n_per_group <- if (is.null(groups)) {
      sum(!is.na(x))
    } else {
      tapply(x, groups, function(z) sum(!is.na(z)))
    }
    
    mtext(text = sprintf("n = %s", fm(n_per_group, fmt = "abs.sty")),
          side = 3, at = seq(ng), cex = 0.8, line = 1)
    
    if (nzchar(main))
      title(main = main, line = 3)
    
    if (nzchar(xlab))
      title(xlab = xlab)
    
    if (nzchar(ylab))
      title(ylab = ylab)
    
    
  # no resetLayout: plotBox() draws a single panel and sets up no layout of
  # its own, so resetting it would destroy a user's mfrow/layout()
  }, stamp = stamp)
  
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
  
  main = NULL,
  xlab = "",
  ylab = "",
  
  ...
) {
  
  # formula, data and subset are forwarded unevaluated, so that 'subset' is
  # evaluated in 'data' as in boxplot()
  r <- bedrock::resolveFormulaFromCall(
    allowed   = c("two-sample-independent", "n-sample-independent"),
    na.action = na.action
  )
  
  main <- .resolveTitle(main, default = r$dataName)

  # labels from the formula, not from the model frame: for y ~ a:b the
  # second column of the model frame holds only a
  if (!nzchar(xlab))
    xlab <- deparse1(formula[[3L]])   # grouping on the x-axis
  
  if (!nzchar(ylab))
    ylab <- deparse1(formula[[2L]])   # response on the y-axis
  
  plotBox.default(
    x    = r$x,
    groups    = r$group,
    main = main,
    xlab = xlab,
    ylab = ylab,
    ...
  )
}


.meansBx <- function(x, y, ytot, col, pch, cex, lcol, lty, lwd){
  
  abline(h = ytot, col = lcol, lty = lty, lwd = lwd)
  points(x = x, y = y, pch = pch, col = col, cex = cex)
  
}

