
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
#' @param x A numeric vector, or a list of numeric vectors representing groups.
#' @param ... Additional graphical parameters passed to \code{par()}.
#'
#' @param formula A formula of the form \code{y ~ group}.
#' @param data Optional data frame.
#' @param subset Optional subset expression.
#' @param na.action Function to handle missing values.
#'
#' @param add Logical; if \code{TRUE}, adds to an existing plot.
#' @param bw Bandwidth for \code{\link[stats]{density}}.
#' @param scale Scaling factor for density height.
#' @param spacing Vertical spacing between ridges.
#'
#' @param col Fill color(s).
#' @param border Border color(s).
#' @param lwd Line width(s).
#' @param lty Line type(s).
#' @param fill Logical; fill area under densities.
#' @param grid Logical, \code{NA}, or list controlling grid.
#'
#' @param main,xlab,ylab Plot labels.
#' @param xlim,ylim Axis limits.
#'
#' @return Invisibly returns \code{NULL}.
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
#' @seealso \code{\link{plotDens}}
#'
#' @name plotRidge
NULL


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
  spacing = 1,
  
  # STYLE
  col = NULL,
  border = NULL,
  lwd = 1,
  lty = 1,
  fill = TRUE,
  grid = NA,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = "",
  
  # AXES
  xlim = NULL,
  ylim = NULL
  
) {
  
  dots <- list(...)
  named <- names(dots) != ""
  
  groups <- if (is.list(x)) x else c(list(x), dots[!named])
  n <- length(groups)
  
  if (n == 0) stop("invalid input")
  
  if (is.null(names(groups)))
    names(groups) <- seq_len(n)
  
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
  
  # normalize heights
  maxy <- max(unlist(lapply(dens_list, `[[`, "y")))
  dens_list <- lapply(dens_list, function(d) {
    d$y <- d$y / maxy * scale
    d
  })
  
  # --- ranges --------------------------------------------------
  
  xr <- range(unlist(lapply(dens_list, `[[`, "x")), na.rm = TRUE)
  yr <- c(0, n * spacing + scale)
  
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
           type = "n",
           yaxt = "n")
    }
    
    # grid
    .callIf(graphics::grid, grid,
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
          border = border %||% col[i],
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
    
  })
}




#' @rdname plotRidge
#' @method plotRidge formula
#' @export
plotRidge.formula <- function(
    
  # DATA
  formula,
  data = NULL,
  subset,
  na.action = na.omit,
  
  ...,
  
  # STRUCTURE
  add = FALSE,
  bw = "nrd0",
  scale = 1,
  spacing = 1,
  
  # STYLE
  col = NULL,
  border = NULL,
  lwd = 1,
  lty = 1,
  fill = TRUE,
  grid = NA,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = "",
  
  # AXES
  xlim = NULL,
  ylim = NULL
  
) {
  
  # --- model.frame (your safe pattern) -------------------------
  
  m <- match.call(expand.dots = FALSE)
  m$... <- NULL
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
  
  split_data <- split(y, g)
  
  if (xlab == "")
    xlab <- deparse(formula[[2]])
  
  plotRidge(
    split_data,
    add = add,
    bw = bw,
    scale = scale,
    spacing = spacing,
    col = col,
    border = border,
    lwd = lwd,
    lty = lty,
    fill = fill,
    grid = grid,
    main = main,
    xlab = xlab,
    ylab = ylab,
    xlim = xlim,
    ylim = ylim,
    ...
  )
}

