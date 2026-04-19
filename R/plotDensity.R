

#' Grouped Density Plot
#'
#' Draws kernel density estimates for one or more groups as line plots.
#' Groups can be supplied either as a list of numeric vectors or via a
#' formula interface of the form \code{y ~ group}.
#'
#' @details
#' For each group, a kernel density estimate is computed using
#' \code{\link[stats]{density}}. The resulting curves are drawn as lines,
#' optionally with filled areas under the curve.
#'
#' Graphical elements such as grids are controlled via the unified plot
#' design system using \code{.callIf()} and \code{.theme()}.
#'
#' @param x A numeric vector, or a list of numeric vectors representing groups.
#' @param ... Additional graphical parameters passed to \code{par()}.
#'
#' @param formula A formula of the form \code{y ~ group}.
#' @param data Optional data frame.
#' @param subset Optional subset expression.
#' @param na.action Function to handle missing values.
#'
#' @param add Logical; if \code{TRUE}, adds to an existing plot.
#' @param bw Bandwidth selector passed to \code{\link[stats]{density}}.
#'
#' @param col Line color(s) for the density curves.
#' @param lwd Line width(s).
#' @param lty Line type(s).
#' @param fill Logical or list; if \code{TRUE}, fills the area under each density.
#' @param grid Logical, \code{NA}, or list controlling background grid.
#'
#' @param main,xlab,ylab Plot labels.
#'
#' @param xlim,ylim Axis limits.
#'
#' @param stamp Optional stamp passed to \code{.withGraphicsState()}.
#'
#' @return Invisibly returns \code{NULL}.
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(100)
#' y <- rnorm(100, 1)
#'
#' # default interface
#' plotDensity(x, y)
#'
#' # grouped via list
#' plotDensity(list(A = x, B = y), fill = TRUE)
#'
#' # formula interface
#' df <- data.frame(
#'   value = c(x, y),
#'   group = rep(c("A", "B"), each = 100)
#' )
#'
#' plotDensity(value ~ group, data = df, fill = TRUE)
#'
#' @seealso \code{\link[stats]{density}}
#'
#' @name plotDensity
NULL

#' @export
plotDensity <- function(x, ...) {
  UseMethod("plotDensity")
}

#' @rdname plotDensity
#' @method plotDensity default
#' @export
plotDensity.default <- function(
    
  # DATA
  x,
  ...,
  
  # STRUCTURE
  add = FALSE,
  bw = "nrd0",
  
  # STYLE
  col = NULL,
  lwd = 2,
  lty = 1,
  fill = FALSE,
  grid = NA,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = "density",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # FRAMEWORK
  stamp = NULL
) {
  
  dots <- list(...)
  named <- names(dots) != ""
  
  groups <- if (is.list(x)) x else c(list(x), dots[!named])
  n <- length(groups)
  
  if (n == 0) stop("invalid input")
  
  # --- densities precompute -----------------------------------
  
  dens_list <- lapply(groups, function(xi) {
    xi <- xi[!is.na(xi)]
    if (length(xi) < 2) return(NULL)
    density(xi, bw = bw)
  })
  
  # remove NULLs
  valid <- !sapply(dens_list, is.null)
  dens_list <- dens_list[valid]
  n <- length(dens_list)
  
  if (n == 0) stop("no valid groups")
  
  # --- ranges --------------------------------------------------
  
  xr <- range(unlist(lapply(dens_list, `[[`, "x")), na.rm = TRUE)
  yr <- range(unlist(lapply(dens_list, `[[`, "y")), na.rm = TRUE)
  
  xlim <- xlim %||% xr
  ylim <- ylim %||% yr
  
  # --- colors --------------------------------------------------
  
  if (is.null(col))
    col <- .getOption("palette", grDevices::palette())[seq_len(n)]
  
  # --- theme ---------------------------------------------------
  
  th <- .theme(
    grid = list(col = "grey90", lwd = 1, lty = "dotted")
  )
  
  # --- plotting ------------------------------------------------
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    if (!add) {
      plot(NA,
           xlim = xlim,
           ylim = ylim,
           main = main,
           xlab = xlab,
           ylab = ylab,
           type = "n")
    }
    
    # grid
    .callIf(graphics::grid, grid, defaults = th$grid)
    
    # densities
    for (i in seq_len(n)) {
      
      d <- dens_list[[i]]
      
      if (isTRUE(fill)) {
        polygon(
          c(d$x, rev(d$x)),
          c(d$y, rep(0, length(d$y))),
          col = adjustcolor(col[i], alpha.f = 0.3),
          border = NA
        )
      }
      
      lines(
        d$x, d$y,
        col = col[i],
        lwd = rep_len(lwd, n)[i],
        lty = rep_len(lty, n)[i]
      )
    }
    
  }, stamp = stamp)
}

#' @rdname plotDensity
#' @method plotDensity formula
#' @export
plotDensity.formula <- function(
    
  # DATA
  formula,
  data = NULL,
  subset,
  na.action = na.omit,
  
  ...,
  
  # STRUCTURE
  add = FALSE,
  bw = "nrd0",
  
  # STYLE
  col = NULL,
  lwd = 2,
  lty = 1,
  fill = FALSE,
  grid = NA,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = "density",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # FRAMEWORK
  stamp = NULL
) {
  
  # --- model.frame (your correct pattern!) ---------------------
  
  m <- match.call(expand.dots = FALSE)
  
  # 🔥 NUR relevante Argumente behalten
  keep <- c("formula", "data", "subset", "na.action")
  m <- m[c(1, match(keep, names(m), nomatch = 0))]
  
  m[[1L]] <- quote(stats::model.frame)
  
  if (!missing(subset)) {
    m$subset <- substitute(subset)
  } else {
    m$subset <- NULL
  }
  
  mf <- eval(m, parent.frame())
  
  if (ncol(mf) < 2)
    stop("formula must be of the form y ~ group")
  
  y <- mf[[1]]
  g <- mf[[2]]
  
  # --- split ---------------------------------------------------
  
  split_data <- split(y, g)
  
  # --- labels --------------------------------------------------
  
  if (xlab == "")
    xlab <- deparse(formula[[2]])
  
  # --- call default --------------------------------------------
  
  plotDensity(
    split_data,
    add = add,
    bw = bw,
    col = col,
    lwd = lwd,
    lty = lty,
    fill = fill,
    grid = grid,
    main = main,
    xlab = xlab,
    ylab = ylab,
    xlim = xlim,
    ylim = ylim,
    stamp = stamp,
    ...
  )
}


