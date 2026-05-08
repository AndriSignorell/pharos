
#' Ternary Plot
#'
#' Draws a ternary plot for compositional data consisting of three non-negative
#' components per observation. Each row is interpreted as a composition and
#' internally rescaled to sum to 1 if necessary.
#'
#' @details
#' A ternary plot represents three-part compositions on an equilateral triangle.
#' Each observation \eqn{(x_1, x_2, x_3)} is mapped to 2D coordinates using
#' barycentric transformation. If rows do not sum to 1, they are automatically
#' normalized with a warning.
#'
#' Graphical elements such as grids are controlled via the unified plot
#' design system using \code{bedrock::callIf()} and \code{.theme()}.
#'
#' @param x A numeric vector, matrix, or data frame. If \code{y} and \code{z}
#'   are provided, \code{x}, \code{y}, and \code{z} are combined into a matrix.
#'   Otherwise, \code{x} must contain exactly three columns.
#' @param y Optional numeric vector for the second component.
#' @param z Optional numeric vector for the third component.
#'
#' @param ... Additional graphical parameters passed to \code{par()}.
#'
#' @param col Point color(s).
#' @param pch Plotting symbol.
#' @param cex Point size.
#'
#' @param grid Logical, \code{NA}, or list controlling the ternary grid.
#'
#' @param lbl Character vector of length 3 specifying axis labels.
#' @param main Plot title.
#'
#' @param xlim,ylim Plot limits (usually left at defaults).
#'
#' @param add Logical; if \code{TRUE}, adds to an existing plot.
#'
#' @return Invisibly returns \code{NULL}.
#'
#' @examples
#' set.seed(1)
#' x <- runif(100)
#' y <- runif(100)
#' z <- runif(100)
#'
#' plotTernary(x, y, z)
#'
#' # matrix input
#' M <- cbind(x, y, z)
#' plotTernary(M, lbl = c("A", "B", "C"))
#'
#' @seealso \code{\link{plotDens}}, \code{\link{plotRidge}}


#' @family plot.special
#' @concept graphics
#' @concept geometry
#'
#'
#' @export
plotTernary <- function(
    
  # DATA
  x,
  y = NULL,
  z = NULL,
  
  ...,
  
  # STRUCTURE
  add = FALSE,
  
  # STYLE
  col = NULL,
  pch = 16,
  cex = 1,
  grid = NA,
  
  # LABELS
  lbl = NULL,
  main = "",
  
  # AXES / FRAME
  xlim = c(-1, 1),
  ylim = c(-0.5, 1)
  
) {
  
  # --- data parsing --------------------------------------------
  
  if (!(is.null(y) && is.null(z))) {
    
    if (is.null(lbl))
      lbl <- c(names(x), names(y), names(z))
    
    x <- cbind(x, y, z)
    
  } else {
    
    if (is.null(lbl))
      lbl <- colnames(x)
    
    x <- as.matrix(x)
  }
  
  if (ncol(x) != 3)
    stop("need exactly 3 components for ternary plot")
  
  if (any(x < 0))
    stop("values must be non-negative")
  
  s <- rowSums(x)
  
  if (any(s <= 0))
    stop("each row must have a positive sum")
  
  if (max(abs(s - 1)) > 1e-6) {
    warning("rows are rescaled to sum to 1")
    x <- x / s
  }
  
  # --- coords --------------------------------------------------
  
  sq3 <- sqrt(3) / 2
  
  px <- (x[, 2] - x[, 3]) * sq3
  py <- x[, 1] * 1.5 - 0.5
  
  # --- theme ---------------------------------------------------
  
  th <- .theme(
    grid = list(col = "grey90", lwd = 1, lty = "dotted", nx = 5),
    point = list(col = col %||% par("fg"), pch = pch, cex = cex),
    border = list(col = par("fg"), lwd = 1)
  )
  
  # --- plotting ------------------------------------------------
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    if (!add) {
      plot(NA,
           xlim = xlim,
           ylim = ylim,
           main = main,
           xlab = "",
           ylab = "",
           axes = FALSE,
           type = "n")
    }
    
    # --- grid --------------------------------------------------
    
    bedrock::callIf(function(col, lty, nx) {
      
      d <- seq(0, 2 * sq3, length.out = nx + 1)
      x0 <- -sq3 + d
      
      segments(x0, -0.5,
               x0 + sq3 - d * 0.5,
               1 - d * sq3,
               col = col, lty = lty)
      
      segments(x0, -0.5,
               -rev(x0 + sq3 - d * 0.5),
               rev(1 - d * sq3),
               col = col, lty = lty)
      
      segments(x0 + sq3 - d * 0.5,
               1 - d * sq3,
               rev(x0 - d * 0.5),
               1 - d * sq3,
               col = col, lty = lty)
      
    },
    grid,
    defaults = th$grid[!startsWith(names(th$grid), "group.")]
    )
    
    # --- triangle ----------------------------------------------
    
    tri <- drawRegPolygon(nv = 3, rot = pi / 2, radius.x = 1, plot = FALSE)
    
    polygon(tri,
            border = th$border$col,
            lwd = th$border$lwd,
            col = NA)
    
    # --- labels ------------------------------------------------
    
    if (!is.null(lbl)) {
      
      eps <- 0.15
      pts <- drawRegPolygon(nv = 3, rot = pi / 2,
                            radius.x = 1 + eps,
                            plot = FALSE)
      
      text(pts, labels = lbl[c(1, 3, 2)])
    }
    
    # --- points ------------------------------------------------
    
    points(px, py,
           col = th$point$col,
           pch = th$point$pch,
           cex = th$point$cex)
    
  })
}



