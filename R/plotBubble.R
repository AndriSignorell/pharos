

#' Bubble Plot
#'
#' Draws a bubble plot where the position is given by \code{x} and \code{y},
#' and the size of each bubble is proportional to \code{area}.
#'
#' The function supports both a default interface and a formula interface
#' of the form \code{y ~ x | area}.
#'
#' @details
#' Bubble sizes are interpreted as areas and internally converted to radii
#' via \eqn{r = \sqrt{area / \pi}}. Aspect ratio is corrected to ensure
#' visually accurate circles.
#'
#' Graphical elements such as grids are controlled via the unified plot
#' design system using \code{bedrock::callIf()} and \code{.theme()}.
#'
#' @param x Numeric vector of x positions.
#' @param y Numeric vector of y positions.
#' @param area Numeric vector controlling bubble sizes (interpreted as area).
#' @param ... Additional graphical parameters passed to \code{par()}.
#'
#' @param col Fill color(s) of the bubbles.
#' @param border Border color(s) of the bubbles.
#' @param cex Scaling factor applied to bubble areas.
#'
#' @param add Logical; if \code{TRUE}, adds to an existing plot.
#'
#' @param grid Logical, \code{NA}, or list controlling background grid.
#'
#' @param xlim,ylim Axis limits.
#'
#' @param main,xlab,ylab Plot labels.
#'
#' @param na.rm Logical; remove missing values.
#'
#' @param formula A formula of the form \code{y ~ x | area}.
#' @param data Optional data frame.
#' @param subset Optional subset expression.
#' @param na.action Function to handle missing values.
#'
#' @return Invisibly returns \code{NULL}.
#' 
#' @family topic.graphics
#' @concept base-graphics
#' @concept plotting
#' 
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(100)
#' y <- rnorm(100)
#' a <- runif(100, 1, 10)
#'
#' plotBubble(x, y, a)
#'
#' df <- data.frame(x = x, y = y, a = a)
#' plotBubble(y ~ x | a, data = df)
#'
#' @seealso \code{\link{symbols}}
#'
#' @name plotBubble
NULL


#' @export
plotBubble <- function(x, ...) {
  UseMethod("plotBubble")
}


#' @rdname plotBubble
#' @method plotBubble default
#' @export
plotBubble.default <- function(
    
  # DATA
  x, y, area,
  
  ...,
  
  # STRUCTURE
  add = FALSE,

  # STYLE
  col = NA,
  border = NULL,
  cex = 1,
  grid = NA,
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # DATA HANDLING
  na.rm = FALSE,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = ""
  
) {
  
  # --- data prep ------------------------------------------------
  
  d.frm <- as.data.frame(
    recycle(
      x = x,
      y = y,
      area = area,
      col = col,
      border = border %||% par("fg"),
      ry = sqrt((area * cex) / pi)
    ),
    stringsAsFactors = FALSE
  )
  
  d.frm <- bedrock::sortX(d.frm, ord = 3, decreasing = TRUE)
  
  if (na.rm)
    d.frm <- d.frm[complete.cases(d.frm), ]
  
  if (nrow(d.frm) == 0)
    stop("no valid observations")
  
  # --- ranges (bubble-aware) -----------------------------------
  
  if (is.null(xlim)) {
    xr <- range(d.frm$x, na.rm = TRUE)
    r  <- d.frm$ry
    xlim <- range(pretty(xr + c(-max(r), max(r))))
  }
  
  if (is.null(ylim)) {
    yr <- range(d.frm$y, na.rm = TRUE)
    r  <- d.frm$ry
    ylim <- range(pretty(yr + c(-max(r), max(r))))
  }
  
  # --- theme ---------------------------------------------------
  
  th <- .theme(
    grid = list(col = "grey90", lwd = 1, lty = "dotted")
  )
  
  # --- plotting ------------------------------------------------
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    if (!add) {
      plot(
        NA,
        xlim = xlim,
        ylim = ylim,
        main = main,
        xlab = xlab,
        ylab = ylab,
        type = "n"
      )
    }
    
    # --- grid --------------------------------------------------

    bedrock::callIf(graphics::grid, grid,
            defaults = th$grid[!startsWith(names(th$grid), "group.")])  
    
    # --- aspect correction -------------------------------------
    
    asp <- (diff(par("usr")[1:2]) / par("pin")[1]) /
      (diff(par("usr")[3:4]) / par("pin")[2])
    
    rx <- d.frm$ry / asp
    
    
    # --- draw bubbles ------------------------------------------
    
    polygon(ellipse(
      x = d.frm$x,
      y = d.frm$y,
      radiusX = rx,
      radiusY = d.frm$ry),
      col = d.frm$col,
      border = d.frm$border
    )
    
  })
}

#' @rdname plotBubble
#' @method plotBubble formula
#' @export
plotBubble.formula <- function(
    
  # DATA
  formula,
  data = NULL,
  subset,
  na.action = na.omit,
  
  ...,
  
  # STRUCTURE
  add = FALSE,
  
  # STYLE
  col = NA,
  border = NULL,
  cex = 1,
  grid = NA,
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = ""
  
) {
  
  # --- formula parsing -----------------------------------------
  
  rhs <- formula[[3]]
  
  if (length(rhs) != 3 || rhs[[1]] != as.name("|"))
    stop("formula must be of the form y ~ x | area")
  
  y_var <- formula[[2]]
  x_var <- rhs[[2]]
  a_var <- rhs[[3]]
  
  # --- rewrite formula for model.frame -------------------------
  
  f <- as.formula(
    paste(deparse(y_var), "~", deparse(x_var), "+", deparse(a_var))
  )
  
  # --- model.frame (DEINE saubere Lösung!) ---------------------
  
  m <- match.call(expand.dots = FALSE)
  m$formula <- f
  m[[1L]] <- quote(stats::model.frame)
  
  if (!missing(subset)) {
    m$subset <- substitute(subset)
  } else {
    m$subset <- NULL
  }
  
  mf <- eval(m, parent.frame())
  
  # --- extract -------------------------------------------------
  
  y <- mf[[1]]
  x <- mf[[2]]
  a <- mf[[3]]
  
  # --- default labels ------------------------------------------
  
  if (xlab == "")
    xlab <- deparse(x_var)
  
  if (ylab == "")
    ylab <- deparse(y_var)
  
  # --- call default method -------------------------------------
  
  plotBubble(
    x = x,
    y = y,
    area = a,
    add = add,
    col = col,
    border = border,
    cex = cex,
    grid = grid,
    xlim = xlim,
    ylim = ylim,
    main = main,
    xlab = xlab,
    ylab = ylab,
    ...
  )
}


