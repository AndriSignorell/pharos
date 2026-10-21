
#' Grouped Boxplot
#'
#' Draws boxplots for a numeric variable, optionally grouped by a categorical
#' variable. Group means and a reference line for the overall mean can
#' optionally be overlaid.
#'
#' @param x numeric vector, or a formula of the form `x ~ g`.
#' @param groups optional grouping variable (ignored if a formula is used).
#' @param order optional order of the groups along the group axis: a
#'   character vector of group levels, e.g.
#'   `order = c("versicolor", "virginica", "setosa")`, or their positions
#'   (`order = c(2, 3, 1)`). Levels not mentioned follow in their original
#'   order. `NULL` (default) keeps the order of the factor levels. Colors
#'   given in `col` apply to the groups in the order drawn.
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
#' @param horiz logical. If `TRUE`, the boxes are drawn horizontally, as
#'   with `boxplot(horizontal = TRUE)`: groups on the y-axis, values on the
#'   x-axis. Default `FALSE`. The left margin is then widened to the
#'   longest group label, unless `mar` in `...` sets the left side.
#'
#' @param main main title. `NULL` (default) draws none, unless the
#'   theme sets `autoTitle = TRUE` (see [theme]); the title is then
#'   derived from the input: the formula, or `x ~ g` for the default
#'   method. `""`, `NA` or `FALSE` always suppress it and compact the top
#'   margin; any other string is used as given.
#' @param xlab label for the x-axis, i.e. the horizontal axis as drawn
#'   (the value axis if `horiz = TRUE`).
#' @param ylab label for the y-axis, i.e. the vertical axis as drawn
#'   (the group axis if `horiz = TRUE`).
#'
#' @param ylim numeric vector of length 2 specifying the limits of the value
#'   axis (the x-axis if `horiz = TRUE`, as in [graphics::boxplot()]).
#'   If `NULL` (default), the range of `x` is used.
#'
#' @param col vector of fill colors, recycled over the groups. `NULL`
#'   (default) uses `"grey90"`.
#'
#' @param grid controls drawing of the background grid.
#'   Can be:
#'   \itemize{
#'     \item `TRUE`: draw grid with default settings (lines along the
#'       value axis only)
#'     \item `FALSE`, `NULL`, or `NA`: suppress grid
#'     \item a named list: arguments passed to [graphics::grid()],
#'       e.g. `list(col = "red", nx = NA, ny = NULL)` for horizontal
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
#' By default the boxes are drawn without an outline (`boxlty = 0`) and
#' with a grey median (`medcol = "grey50"`). Supplying `border` draws the
#' outline in that color, and the median follows it; `boxlty` and
#' `medcol` given explicitly take precedence.
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
#'
#' # horizontal boxes
#' plotBox(len ~ supp:dose, ToothGrowth, horiz = TRUE)
#'
#' # groups in a chosen order, e.g. by median
#' plotBox(Sepal.Length ~ Species, data = iris,
#'         order = c("versicolor", "virginica", "setosa"))
#' med <- tapply(iris$Sepal.Length, iris$Species, median)
#' plotBox(Sepal.Length ~ Species, data = iris, order = order(med))
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
  order  = NULL,
  
  horiz = FALSE,
  
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
  
  horiz <- isTRUE(horiz)
  
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
  
  # value axis is side 2 (vertical) or side 1 (horizontal); the n labels
  # move from the top (side 3) to the right (side 4)
  side_val <- if (horiz) 1L else 2L
  side_grp <- if (horiz) 2L else 1L
  
  if (!is.null(groups))
    groups <- .orderLevels(factor(groups), order)
  else if (!is.null(order))
    stop("'order' needs a grouping variable", call. = FALSE)
  
  .withGraphicsState({
    
    .applyParFromDots(...,
                      defaults=list(
                        mar      = if (horiz)
                          c(left = 5, top = .marTop(main), right = 4) + 1
                        else
                          c(left = 5, top = .marTop(main)) + 1,
                        col.axis = "grey40", 
                        fg       = "grey30"
                        )       # border inherits from here
    )
    
    # horizontal: the group labels stand on side 2 with las = 1, so the
    # left margin follows the longest label (measured as .adjustMargin()
    # does: cex.axis, labels at line 1), and ylab moves out past them to
    # ylabLine. A 'mar' in ... that names the left side (or a full mar)
    # blocks the widening; ylab is still placed past the labels.
    ylabLine <- NA
    if (horiz && !is.null(groups)) {
      labEnd   <- .marginLines(levels(groups), side = 2, las = 1,
                               cex = par("cex.axis"), axisLine = 1)
      ylabLine <- max(par("mgp")[1L], labEnd + 0.8)
      if (!"left" %in% .userMarSides(list(...))) {
        need <- if (nzchar(ylab)) ylabLine + 1.2 else labEnd + 0.5
        mar  <- par("mar")
        if (need > mar[2L]) {
          mar[2L] <- need
          par(mar = mar)
        }
        .checkMargins()
      }
    }
    
    # --- Prepare data ----------------------------------------------------
    if (is.null(groups)) {
      
      split_x <- list(x)
      names(split_x) <- ""
      
    } else {
      
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
    
    vlim <- ylim %||% range(x, na.rm = TRUE)    # value axis
    glim <- c(0.5, ng + 0.5)                    # group axis
    
    plot.new()
    if (horiz)
      plot.window(xlim = vlim, ylim = glim)
    else
      plot.window(xlim = glim, ylim = vlim)
    
    # --- grid --------------------------------------------------
    
    # the theme's grid runs along the value axis; turn it with the plot
    grid_def <- th$grid[!startsWith(names(th$grid), "group.")]
    if (horiz && all(c("nx", "ny") %in% names(grid_def)))
      grid_def[c("nx", "ny")] <- grid_def[c("ny", "nx")]
    
    bedrock::callIf(graphics::grid, grid, defaults = grid_def)
    
    # --- boxplot --------------------------------------------------
    
    # Own look: no box outline, grey median. A 'border' asks for the
    # outline, so the box then gets one in that color, with the median in
    # it as in boxplot(). The defaults are merged with ..., so that an
    # explicit boxlty or medcol replaces them instead of being passed twice
    # (boxplot() would silently keep the first of two).
    dots      <- list(...)
    hasBorder <- "border" %in% names(dots)

    bxArgs <- modifyList(
      list(boxlty = if (hasBorder) 1 else 0,
           medcol = if (hasBorder) dots$border else "grey50"),
      dots)

    do.call(boxplot,
            c(list(if (is.null(groups)) x else x ~ groups,
                   add = TRUE, col = col, horizontal = horiz, axes = FALSE),
              bxArgs))
    
    axis(side_grp, at = seq(ng),
         labels = if (is.null(groups)) "" else levels(groups),
         las = if (horiz) 1 else 0)
    axis(side_val)
    box()
    
    # --- means --------------------------------------------------
    
    bedrock::callIf(.meansBx, means,
                    defaults = list(
                      x = seq(ng),
                      y = if (is.null(groups)) mean(x, na.rm = TRUE)
                      else tapply(x, groups, mean, na.rm = TRUE),
                      ytot = mean(x, na.rm = TRUE),
                      horiz = horiz,
                      col = "darkblue",
                      pch = 4,
                      cex = 1.5,
                      lcol = "darkblue",
                      lty = "dashed",
                      lwd = 2),
                    forbidden = c("x", "y", "ytot", "horiz")
    )
    
    # --- group n --------------------------------------------------

    n_per_group <- if (is.null(groups)) {
      sum(!is.na(x))
    } else {
      tapply(x, groups, function(z) sum(!is.na(z)))
    }
    
    mtext(text = sprintf("n = %s", fm(n_per_group, fmt = "abs.sty")),
          side = if (horiz) 4 else 3, at = seq(ng), cex = 0.8, line = 1,
          las = if (horiz) 1 else 0, adj = if (horiz) 0 else NA)
    
    if (nzchar(main))
      title(main = main, line = if (horiz) 1.5 else 3)
    
    if (nzchar(xlab))
      title(xlab = xlab)
    
    if (nzchar(ylab))
      title(ylab = ylab, line = ylabLine)
    
    
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
  
  horiz = FALSE,
  
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
  glab <- deparse1(formula[[3L]])   # grouping
  vlab <- deparse1(formula[[2L]])   # response
  
  # xlab/ylab refer to the axes as drawn
  if (!nzchar(xlab))
    xlab <- if (isTRUE(horiz)) vlab else glab
  
  if (!nzchar(ylab))
    ylab <- if (isTRUE(horiz)) glab else vlab
  
  plotBox.default(
    x      = r$x,
    groups = r$group,
    horiz  = horiz,
    main   = main,
    xlab   = xlab,
    ylab   = ylab,
    ...
  )
}


# Reorders the levels of a factor: 'order' names levels or gives their
# positions; levels not mentioned keep their relative order and follow
# at the end. Everything built from the factor afterwards (split(),
# tapply(), the axis labels, boxplot()) then follows the new order.
.orderLevels <- function(f, order = NULL) {

  if (is.null(order))
    return(f)

  lev <- levels(f)

  if (is.numeric(order)) {
    if (anyNA(order) || any(order != round(order)) ||
        any(order < 1 | order > length(lev)))
      stop(gettextf("numeric 'order' must hold positions between 1 and %d",
                    length(lev)), call. = FALSE)
    order <- lev[order]
  }

  if (!is.character(order))
    stop("'order' must be a character vector of group levels or their ",
         "positions", call. = FALSE)

  bad <- setdiff(order, lev)
  if (length(bad))
    stop(gettextf("unknown group(s) in 'order': %s. Groups are: %s",
                  toString(dQuote(bad, FALSE)), toString(lev)),
         call. = FALSE)

  if (anyDuplicated(order))
    stop("'order' names a group more than once", call. = FALSE)

  factor(f, levels = c(order, setdiff(lev, order)))
}


.meansBx <- function(x, y, ytot, horiz = FALSE, col, pch, cex, lcol, lty, lwd){
  
  if (horiz) {
    abline(v = ytot, col = lcol, lty = lty, lwd = lwd)
    points(x = y, y = x, pch = pch, col = col, cex = cex)
  } else {
    abline(h = ytot, col = lcol, lty = lty, lwd = lwd)
    points(x = x, y = y, pch = pch, col = col, cex = cex)
  }
  
}
