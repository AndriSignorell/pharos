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
#' via a flexible interface using \code{TRUE}, \code{FALSE}, \code{NA}, or
#' \code{list(...)} and are evaluated using \code{.callIf()}.
#'
#' @section Data Handling:
#' The function accepts:
#' \itemize{
#'   \item a numeric vector
#'   \item multiple vectors via \code{...}
#'   \item a list of numeric vectors
#' }
#' Groups are handled similarly to \code{boxplot()}.
#'
#' @param x Numeric vector, list of numeric vectors, or first group.
#'
#' @param ... Additional data vectors (unnamed) or graphical parameters
#'   passed to \code{par()}.
#'
#' @param horizontal Logical; if \code{TRUE}, draws horizontal violins.
#' @param at Numeric positions of the groups.
#' @param names Optional group labels.
#' @param add Logical; if \code{TRUE}, adds to an existing plot.
#' @param bw Bandwidth specification passed to \code{density()}.
#' @param col Fill color(s) of the violins.
#' @param border Border color(s) of the violins.
#' @param lwd Line width for violin borders.
#' @param box Logical or list controlling the boxplot overlay
#'   (see Details).
#' @param grid Logical, \code{NA}, or list controlling background grid.
#' @param quantiles Optional numeric vector of probabilities for drawing
#'   quantile lines inside each violin.
#' @param main,xlab,ylab Plot labels.
#' @param xlim,ylim Axis limits.
#' 
#' @param formula A formula of the form y ~ group.
#' @param data Optional data frame.
#' @param subset Optional subset expression.
#' @param na.action Function to handle missing values.
#' 
#' @name plotViolin
#' 
#' @return Invisibly returns \code{NULL}.
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(100)
#' y <- rnorm(100, 1)
#'
#' plotViolin(x, y)
#'
#' # horizontal violins
#' plotViolin(x, y, horizontal = TRUE)
#'
#' # with quantiles
#' plotViolin(x, y, quantiles = c(0.25, 0.5, 0.75))
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
#' @seealso \code{\link{boxplot}}, \code{\link{density}}
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
  
  # STRUCTURE (boxplot-like)
  horizontal = FALSE,
  at = NULL,
  names = NULL,
  add = FALSE,
  bw = "nrd0",
  
  # STYLE
  col = "grey80",
  border = "black",
  lwd = 1,
  box = TRUE,
  grid = NA,
  
  # FEATURES
  quantiles = NULL,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = "",
  
  # AXES
  xlim = NULL,
  ylim = NULL
  
) {
  
  m <- match.call(expand.dots = FALSE)
  dots <- list(...)
  
  # --- data parsing (boxplot-style) -----------------------------
  
  named <- names(dots) != ""
  groups <- if (is.list(x)) x else c(list(x), dots[!named])
  
  n <- length(groups)
  if (n == 0) stop("invalid first argument")
  
  if (is.null(names))
    names <- names(groups) %||% seq_len(n)
  
  if (is.null(at)) at <- seq_len(n)
  
  # --- densities precompute -------------------------------------
  
  dens_list <- vector("list", n)
  
  for (i in seq_len(n)) {
    xi <- groups[[i]]
    xi <- xi[!is.na(xi)]
    if (length(xi) < 2) next
    
    dens_list[[i]] <- density(xi, bw = bw)
  }
  
  # --- ranges based on densities --------------------------------
  
  dens_range <- range(
    unlist(lapply(dens_list, function(d) if (!is.null(d)) d$x)),
    na.rm = TRUE
  )
  
  if (is.null(xlim) || is.null(ylim)) {
    
    if (!horizontal) {
      
      xlim <- xlim %||% (range(at) + c(-0.5, 0.5))
      ylim <- ylim %||% dens_range
      
    } else {
      
      xlim <- xlim %||% dens_range
      ylim <- ylim %||% (range(at) + c(-0.5, 0.5))
    }
  }
  
  # --- optional padding (nice visual margin) ---------------------
  
  if (!horizontal) {
    pad <- 0.02 * diff(ylim)
    ylim <- ylim + c(-pad, pad)
  } else {
    pad <- 0.02 * diff(xlim)
    xlim <- xlim + c(-pad, pad)
  }
  
  # --- plotting -------------------------------------------------
  
  th <- .theme(
    grid = list(col = "grey", lwd = 1, lty = "dotted")
  )
  
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
           xaxt = "n")
    }
    
    # --- grid ---------------------------------------------------
    
    .callIf(graphics::grid, grid,
            defaults = th$grid[!startsWith(names(th$grid), "group.")])  
    
    # --- violins ------------------------------------------------
    
    for (i in seq_len(n)) {
      
      dens <- dens_list[[i]]
      if (is.null(dens)) next
      
      y <- dens$y / max(dens$y) * 0.4
      
      if (!horizontal) {
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
        
        if (!horizontal) {
          segments(at[i] - 0.1, qs,
                   at[i] + 0.1, qs)
        } else {
          segments(qs, at[i] - 0.1,
                   qs, at[i] + 0.1)
        }
      }
    }
    
    # --- box overlay --------------------------------------------
    
    .callIf(
      fun = boxplot,
      arg = box,
      defaults = list(
        x = groups,
        at = at,
        add = TRUE,
        horizontal = horizontal,
        axes = FALSE,
        outline = FALSE,
        boxwex = 0.1
      )
    )
    
    # --- axes ---------------------------------------------------
    
    if (!horizontal) {
      axis(1, at = at, labels = names)
      axis(2)
    } else {
      axis(2, at = at, labels = names)
      axis(1)
    }
    
  })
}



#' @rdname plotViolin
#' @method plotViolin formula
#' @export
plotViolin.formula <- function(
    
  # DATA
  formula,
  data = NULL,
  subset,
  na.action = na.omit,
  
  ...,
  
  # STRUCTURE
  horizontal = FALSE,
  at = NULL,
  names = NULL,
  add = FALSE,
  bw = "nrd0",
  
  # STYLE
  col = "grey80",
  border = "black",
  lwd = 1,
  box = TRUE,
  grid = NA,
  
  # FEATURES
  quantiles = NULL,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = "",
  
  # AXES
  xlim = NULL,
  ylim = NULL
  
) {
  
  # --- model frame (wie boxplot.formula) ------------------------
  
  m <- match.call(expand.dots = FALSE)
  m$... <- NULL
  m[[1]] <- as.name("model.frame")
  
  mf <- eval(m, parent.frame())
  
  if (ncol(mf) < 2)
    stop("formula must be of the form y ~ group")
  
  response <- mf[[1]]
  groups   <- mf[-1]
  
  # --- split wie boxplot ----------------------------------------
  
  if (ncol(groups) == 1) {
    
    # einfacher Fall: y ~ g
    g <- groups[[1]]
    split_data <- split(response, g)
    
  } else {
    
    # mehrere Faktoren: interaction (wie boxplot)
    g <- interaction(groups, drop = TRUE)
    split_data <- split(response, g)
  }
  
  # --- default labels -------------------------------------------
  
  if (is.null(names))
    names <- names(split_data)
  
  if (xlab == "" && !horizontal)
    xlab <- deparse(formula[[3]])
  
  if (ylab == "" && !horizontal)
    ylab <- deparse(formula[[2]])
  
  if (xlab == "" && horizontal)
    xlab <- deparse(formula[[2]])
  
  if (ylab == "" && horizontal)
    ylab <- deparse(formula[[3]])
  
  # --- call default method --------------------------------------
  
  plotViolin(
    split_data,
    horizontal = horizontal,
    at = at,
    names = names,
    add = add,
    bw = bw,
    col = col,
    border = border,
    lwd = lwd,
    box = box,
    grid = grid,
    quantiles = quantiles,
    main = main,
    xlab = xlab,
    ylab = ylab,
    xlim = xlim,
    ylim = ylim,
    ...
  )
}

