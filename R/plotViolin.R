
#' Violin Plot
#'
#' Draws violin plots for one or more groups, combining kernel density
#' estimation with optional boxplot overlays. The function follows a
#' boxplot-like interface and supports both default and formula methods.
#'
#' @details
#' The violin shape is constructed from a kernel density estimate of each
#' group, scaled to a fixed maximum width. Optionally, boxplots and
#' quantile lines can be added.
#'
#' Graphical elements such as the boxplot overlay and grid are controlled
#' via a flexible interface using `TRUE`, `FALSE`, `NA`, or
#' `list(...)` and are evaluated using `bedrock::callIf()`.
#'
#' @section Data Handling:
#' The function accepts:
#' \itemize{
#'   \item a numeric vector
#'   \item multiple vectors via `...`
#'   \item a list of numeric vectors
#' }
#' Groups are handled similarly to `boxplot()`.
#'
#' @param x numeric vector, list of numeric vectors, or first group.
#'
#' @param ... additional data vectors (unnamed) or graphical parameters
#'   passed to `par()`.
#'
#' @param main main title. `NULL` (default) derives the title from the
#'   input: the names of the data arguments, or the formula. `""`, `NA`, or
#'   `FALSE` suppress the title and compact the top margin.
#' @param xlab,ylab axis labels. For the formula method, empty labels
#'   default to the grouping variable and the response.
#' @param xlim,ylim axis limits. `NULL` (default) uses the range of the
#'   densities, padded by 2%; given limits are used as they are.
#'
#' @param horiz logical; if `TRUE`, draws horizontal violins.
#' @param at numeric positions of the groups.
#' @param names optional group labels.
#' @param add logical; if `TRUE`, adds to an existing plot.
#' @param bw bandwidth specification passed to `density()`.
#' @param trim logical. If `TRUE` (default), the kernel density
#'   estimate of each group is restricted to the observed data range
#'   (`from = min(x)`, `to = max(x)`), so the violin never
#'   extends beyond the actual data — matching the default behavior of
#'   `ggplot2::geom_violin()`. If `FALSE`, `density()` is
#'   called with its own defaults, which extend the tails up to
#'   `cut * bw` beyond `range(x)` and may produce violins that
#'   reach into implausible values (e.g. scores above 100 or below 0).
#'
#' @param col fill color(s) of the violins.
#' @param border border color(s) of the violins.
#' @param lwd line width for violin borders.
#' @param box logical or list controlling the boxplot overlay
#'   (see Details).
#' @param grid logical, `NA`, or list controlling background grid.
#'
#' @param quantiles optional numeric vector of probabilities for drawing
#'   quantile lines inside each violin.
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, a string, or a
#'   named list for [stamp()].
#'
#' @param formula a formula of the form `y ~ group`, or `y ~ a:b` for the
#'   cells of several grouping variables. `y ~ a + b` is not accepted (unlike
#'   [boxplot()]), see [bedrock::resolveFormula()].
#' @param data an optional data frame containing the variables in the
#'   formula.
#' @param subset an optional expression indicating which observations to
#'   use, evaluated in `data` (`subset = len > 10`), as in [boxplot()].
#' @param na.action a function specifying how missing values are handled,
#'   defaults to [na.omit()].
#'
#' @name plotViolin
#'
#' @return Invisibly returns `NULL`.
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(100)
#' y <- rnorm(100, 1)
#'
#' plotViolin(x, y)
#'
#' # horizontal violins
#' plotViolin(x, y, horiz = TRUE)
#'
#' # with quantiles
#' plotViolin(x, y, quantiles = c(0.25, 0.5, 0.75))
#'
#' # untrimmed: tails extend beyond the observed data range
#' plotViolin(x, y, trim = FALSE)
#'
#' # custom styling
#' plotViolin(x, y,
#'   col = c("lightblue", "salmon"),
#'   box = list(col = "white"),
#'   grid = TRUE
#' )
#'
#' # formula interface
#' df <- data.frame(
#'   value = rnorm(200),
#'   group = rep(letters[1:4], each = 50)
#' )
#'
#' plotViolin(value ~ group, data = df)
#'
#' # subset and the cells of two grouping variables
#' plotViolin(len ~ supp:dose, ToothGrowth, subset = len > 8)
#'
#' @seealso [boxplot()], [density()]
#'

#' @family plot.univariate  
#' @concept density  
#' @concept distribution-summary
#'
#'
#' @export
plotViolin <- function(x, ...) {
  UseMethod("plotViolin")
}
#' @rdname plotViolin
#' @method plotViolin default
#' @export
plotViolin.default <- function(
    # DATA
    x,
    ...,

    # LABELS
    main = NULL,
    xlab = "",
    ylab = "",

    # AXES
    xlim = NULL,
    ylim = NULL,

    # STATISTICS
    bw   = "nrd0",
    trim = TRUE,

    # STRUCTURE
    horiz = FALSE,
    at    = NULL,
    names = NULL,
    add   = FALSE,

    # STYLE
    col    = "grey80",
    border = "black",
    lwd    = 1,
    grid   = NA,
    box    = TRUE,

    # FEATURES
    quantiles = NULL,

    # FRAMEWORK
    stamp = .useTheme
) {
  
  m <- match.call(expand.dots = FALSE)
  dots <- list(...)
  
  # --- data parsing (boxplot-style) -----------------------------
  
  # names(dots) is NULL when no argument in ... is named; the comparison
  # then gave logical(0), and every further data vector was dropped:
  # plotViolin(x, y) drew x only
  dotNames <- names(dots) %||% character(length(dots))
  unnamed  <- !nzchar(dotNames)
  groups   <- if (is.list(x)) x else c(list(x), dots[unnamed])
  
  n <- length(groups)
  if (n == 0) stop("invalid first argument")
  
  # default title: the data arguments as written, e.g. "x, y"
  main <- .resolveTitle(main, default = if (is.list(x))
    deparse1(m$x)
  else
    paste(vapply(c(list(m$x), m$...[unnamed]), deparse1, ""), collapse = ", "))
  
  if (is.null(names))
    names <- names(groups) %||% seq_len(n)
  
  if (is.null(at)) at <- seq_len(n)
  
  # --- densities precompute -------------------------------------
  
  dens_list <- vector("list", n)
  
  for (i in seq_len(n)) {
    xi <- groups[[i]]
    xi <- xi[!is.na(xi)]
    if (length(xi) < 2) next
    
    dens_list[[i]] <- if (isTRUE(trim)) {
      density(xi, bw = bw, from = min(xi), to = max(xi))
    } else {
      density(xi, bw = bw)
    }
  }
  
  if (all(vapply(dens_list, is.null, NA)))
    stop("no group has at least 2 non-missing values", call. = FALSE)
  
  # --- ranges based on densities --------------------------------
  
  dens_range <- range(
    unlist(lapply(dens_list, function(d) if (!is.null(d)) d$x)),
    na.rm = TRUE
  )
  
  # value axis: the density range with a 2% visual margin; a limit given by
  # the user is taken as it is (it was padded as well)
  valueLim <- dens_range + c(-0.02, 0.02) * diff(dens_range)
  groupLim <- range(at) + c(-0.5, 0.5)
  
  if (!horiz) {
    xlim <- xlim %||% groupLim
    ylim <- ylim %||% valueLim
  } else {
    xlim <- xlim %||% valueLim
    ylim <- ylim %||% groupLim
  }
  
  # --- plotting -------------------------------------------------
  
  th <- .theme(
    grid = list(
      col = "grey", 
      lwd = 1, 
      lty = "dotted",
      nx=NA, 
      ny=NULL)
  )
  
  .withGraphicsState({
    
    .applyParFromDots(...,
          defaults = list(
              mar = c(
                left  = 5.1,
                top   = .marTop(main)
              ))
      )
    
    # axes = FALSE: both axes are drawn below. With only xaxt = "n", a
    # horizontal plot got a numeric y-axis (0.5 ... 2.5) underneath the
    # group labels
    if (!add) {
      plot(NA,
           xlim = xlim,
           ylim = ylim,
           main = main,
           xlab = xlab,
           ylab = ylab,
           type = "n",
           axes = FALSE,
           frame.plot = TRUE)
    }
    
    # --- grid ---------------------------------------------------
    
    bedrock::callIf(graphics::grid, grid,
                    defaults = th$grid[!startsWith(names(th$grid), "group.")])
    
    # --- violins ------------------------------------------------
    
    for (i in seq_len(n)) {
      
      dens <- dens_list[[i]]
      if (is.null(dens)) next
      
      y <- dens$y / max(dens$y) * 0.4
      
      if (!horiz) {
        polygon(
          c(at[i] + y, rev(at[i] - y)),
          c(dens$x, rev(dens$x)),
          col = rep_len(col, n)[i],
          border = rep_len(border, n)[i],
          lwd = rep_len(lwd, n)[i]
        )
      } else {
        polygon(
          c(dens$x, rev(dens$x)),
          c(at[i] + y, rev(at[i] - y)),
          col = rep_len(col, n)[i],
          border = rep_len(border, n)[i],
          lwd = rep_len(lwd, n)[i]
        )
      }
      
      # --- quantiles --------------------------------------------
      
      if (!is.null(quantiles)) {
        xi <- groups[[i]]
        xi <- xi[!is.na(xi)]
        
        qs <- quantile(xi, probs = quantiles)
        
        if (!horiz) {
          segments(at[i] - 0.1, qs,
                   at[i] + 0.1, qs)
        } else {
          segments(qs, at[i] - 0.1,
                   qs, at[i] + 0.1)
        }
      }
    }
    
    # --- box overlay --------------------------------------------
    
    bedrock::callIf(
      FUN = boxplot,
      arg = box,
      defaults = list(
        x = groups,
        at = at,
        add = TRUE,
        horizontal = horiz,
        axes = FALSE,
        outline = FALSE,
        boxwex = 0.1
      )
    )
    
    # --- axes ---------------------------------------------------
    
    if (!horiz) {
      axis(1, at = at, labels = names)
      axis(2)
    } else {
      axis(2, at = at, labels = names)
      axis(1)
    }
    
  }, stamp = stamp)
  
  invisible(NULL)
}




#' @rdname plotViolin
#' @method plotViolin formula
#' @export
plotViolin.formula <- function(
    # DATA
    formula,
    data,
    subset,
    na.action = na.omit,

    # LABELS
    main = NULL,
    xlab = "",
    ylab = "",

    # STRUCTURE
    horiz = FALSE,
    names = NULL,

    ...
) {
  
  # formula, data and subset are forwarded unevaluated, so that 'subset' is
  # evaluated in 'data' as in boxplot(); y ~ a:b yields the cells as one
  # grouping factor, y ~ a + b is rejected
  r <- bedrock::resolveFormulaFromCall(
    allowed   = c("two-sample-independent", "n-sample-independent"),
    na.action = na.action
  )
  
  split_data <- split(r$x, r$group)
  
  # --- default labels -------------------------------------------
  
  main <- .resolveTitle(main, default = r$dataName)
  
  grpName <- deparse1(formula[[3L]])
  resName <- deparse1(formula[[2L]])
  
  if (!nzchar(xlab)) xlab <- if (horiz) resName else grpName
  if (!nzchar(ylab)) ylab <- if (horiz) grpName else resName
  
  # --- call default method --------------------------------------
  # the remaining arguments (xlim, bw, col, box, ...) reach the default
  # method through ...
  
  plotViolin.default(
    split_data,
    main       = main,
    xlab       = xlab,
    ylab       = ylab,
    horiz      = horiz,
    names      = names %||% base::names(split_data),
    ...
  )
}
