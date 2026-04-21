
#' Plot Mathematical Functions
#'
#' Flexible plotting of mathematical functions in Cartesian, polar, and parametric form.
#'
#' The function automatically detects the type of input:
#' \itemize{
#'   \item \strong{Cartesian:} \code{y ~ f(x)}
#'   \item \strong{Polar:} \code{r ~ f(phi)} or \code{r ~ f(theta)}
#'   \item \strong{Parametric:} \code{list(x ~ f(t), y ~ g(t))}
#' }
#'
#' Additional parameters can be passed via \code{args}.
#'
#' @param expr Expression defining the function. Either a formula (\code{y ~ f(x)}),
#'   a polar formula (\code{r ~ f(phi)}), or a list of two formulas for parametric plots.
#'
#' @param main Character. Main title of the plot.
#' @param xlab Character. Label for x-axis.
#' @param ylab Character. Label for y-axis.
#'
#' @param xlim Numeric vector of length 2 defining x-axis limits.
#' @param ylim Numeric vector of length 2 defining y-axis limits.
#'
#' @param from Numeric. Lower bound of the parameter domain.
#' @param to Numeric. Upper bound of the parameter domain.
#' @param n Integer. Number of evaluation points.
#'
#' @param args Named list of additional parameters used in the function expression.
#'
#' @param col Color of the line.
#' @param lwd Line width.
#' @param lty Line type.
#' @param grid Logical, \code{NA}, or list. Controls grid display.
#'
#' @param add Logical. If \code{TRUE}, adds to existing plot.
#'
#' @param ... Additional graphical parameters passed to \code{par()}.
#'
#' @details
#' The plotting is performed using base graphics with a fixed aspect ratio (\code{asp = 1}),
#' ensuring geometrically correct representations.
#'
#' For Cartesian functions, \code{xlim} defaults to \code{c(from, to)}.
#' For polar and parametric plots, limits are derived from the data.
#'
#' @return Invisibly returns a list with components \code{x} and \code{y}.
#'
#' @examples
#' par(mfrow = c(3,4))
#'
#' # --- basic -------------------------------------------------
#' plotFun(y ~ x^2)
#'
#' # --- Cartesian leaf ----------------------------------------
#' plotFun(
#'   list(
#'     x ~ 3*2*z / (z^3 + 1 + 0.1),
#'     y ~ 3*2*z^2 / (z^3 + 1)
#'   ),
#'   from = -10, to = 10,
#'   col = "magenta", asp = 1, lwd = 2
#' )
#'
#' # --- damped oscillations -----------------------------------
#' plotFun(y ~ 3*exp(-x/5)*sin(4*x),
#'         from = 0, to = 10,
#'         col = "green")
#'
#' plotFun(y ~ 3*exp(-x/5)*sin(6*x),
#'         from = 0, to = 10,
#'         col = "darkgreen", add = TRUE)
#'
#' # --- cardioid (polar) --------------------------------------
#' plotFun(r ~ 2*(1 + cos(phi)),
#'         from = 0, to = 2*pi)
#'
#' # --- heart curve (parametric) -------------------------------
#' plotFun(
#'   list(
#'     x ~ 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t),
#'     y ~ 16*sin(t)^3
#'   ),
#'   from = 0, to = 2*pi,
#'   col = "red", lwd = 2
#' )
#'
#' # --- polar flower ------------------------------------------
#' plotFun(r ~ 6*sin(2*phi)*cos(2*phi),
#'         from = 0, to = 2*pi,
#'         col = "orange")
#'
#' # --- astroid -----------------------------------------------
#' plotFun(
#'   list(
#'     x ~ 2*cos(t)^3,
#'     y ~ 2*sin(t)^3
#'   ),
#'   from = 0, to = 2*pi,
#'   col = "red", lwd = 3
#' )
#'
#' # --- lemniscate --------------------------------------------
#' plotFun(r ~ (2*cos(2*phi))^2,
#'         from = 0, to = 2*pi,
#'         col = "darkblue")
#'
#' # --- cycloid -----------------------------------------------
#' plotFun(
#'   list(
#'     x ~ 0.5*(t - sin(t)),
#'     y ~ 0.5*(1 - cos(t))
#'   ),
#'   from = 0, to = 30,
#'   col = "orange"
#' )
#'
#' # --- involute ----------------------------------------------
#' plotFun(
#'   list(
#'     x ~ 0.2*(cos(t) + t*sin(t)),
#'     y ~ 0.2*(sin(t) - t*cos(t))
#'   ),
#'   from = 0, to = 50,
#'   col = "brown"
#' )
#'
#' # --- Lissajous ---------------------------------------------
#' plotFun(
#'   list(
#'     x ~ sin(t),
#'     y ~ sin(2*t)
#'   ),
#'   from = 0, to = 2*pi,
#'   col = "blue", lwd = 2
#' )
#'
#' # --- parameter sweep ---------------------------------------
#' for(a in 1:3) {
#'   plotFun(y ~ sin(a*x),
#'           args = list(a = a),
#'           from = 0, to = 2*pi,
#'           add = (a != 1),
#'           col = a)
#' }
#'
#' # --- polar sine --------------------------------------------
#' plotFun(r ~ sin(3*phi),
#'         from = 0, to = pi,
#'         col = "deeppink4", lwd = 2)
#'
#' # --- ripple ------------------------------------------------
#' plotFun(r ~ 1 + 0.1*sin(10*phi),
#'         from = 0, to = 2*pi,
#'         col = "deeppink4")
#'


#' @export
plotFun <- function(
    
  # DATA
  expr,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = "",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # STRUCTURE
  from = 0,
  to = 1,
  n = 500,
  args = NULL,
  
  # STYLE
  col = 1,
  lwd = 1,
  lty = 1,
  grid = NA,
  
  # FEATURES
  add = FALSE,
  
  ...
) {
  
  # --- type detection -----------------------------------------
  
  type <- if (is.list(expr)) {
    "parametric"
  } else {
    rhs <- as.list(expr)[[3]]
    var <- all.vars(rhs)[1]
    if (var %in% c("phi", "theta"))
      "polar"
    else
      "cartesian"
  }
  
  # --- theme --------------------------------------------------
  
  th <- .theme(
    grid = list(col = "grey90", lty = 1, lwd = 1)
  )
  
  # --- plotting -----------------------------------------------
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # --- data evaluation -------------------------------------
    
    env <- new.env(parent = parent.frame())
    
    # --- inject args ------------------------------------------
    
    if (!is.null(args)) {
      if (!is.list(args))
        stop("args must be a named list")
      
      for (nm in names(args)) {
        val <- args[[nm]]
        
        if (length(val) > 1) {
          val <- val[1]
          warning(sprintf("first element used of '%s'", nm))
        }
        
        assign(nm, val, envir = env)
      }
    }
    
    t <- seq(from, to, length.out = n)
    
    # --- CARTESIAN --------------------------------------------
    
    if (type == "cartesian") {
      
      rhs <- as.list(expr)[[3]]
      vars <- all.vars(rhs)
      
      if (!is.null(args)) {
        vars <- setdiff(vars, names(args))
      }
      
      if (length(vars) == 0)
        stop("no free variable found in expression")
      
      var <- vars[1]
      assign(var, t, envir = env)
      
      x <- t
      y <- eval(rhs, envir = env)
    }
    
    # --- POLAR ------------------------------------------------
    
    if (type == "polar") {
      
      rhs <- as.list(expr)[[3]]
      vars <- all.vars(rhs)
      
      if (!is.null(args)) {
        vars <- setdiff(vars, names(args))
      }
      
      if (length(vars) == 0)
        stop("no free variable found in expression")
      
      var <- vars[1]
      assign(var, t, envir = env)
      
      r <- eval(rhs, envir = env)
      
      x <- r * cos(t)
      y <- r * sin(t)
    }
    
    # --- PARAMETRIC -------------------------------------------
    
    if (type == "parametric") {
      
      if (!inherits(expr[[1]], "formula") || !inherits(expr[[2]], "formula"))
        stop("parametric: use list(x ~ ..., y ~ ...)")
      
      assign("t", t, envir = env)
      assign("z", t, envir = env)
      
      x <- eval(as.list(expr[[1]])[[3]], envir = env)
      y <- eval(as.list(expr[[2]])[[3]], envir = env)
    }
    
    # --- finite filter ----------------------------------------
    
    ok <- is.finite(x) & is.finite(y)
    x <- x[ok]
    y <- y[ok]
    
    # --- axes limits ------------------------------------------
    
    if (is.null(xlim)) {
      
      if (type != "cartesian") {
        xlim <- range(x)
        ylim <- range(y)
      } else {
        xlim <- c(from, to)
      }
    }
    
    if (is.null(ylim)) {
      ylim <- xlim
    }
    
    # --- plot -------------------------------------------------
    
    if (!add) {
      plot(x, y,
           type = "n",
           asp = 1,
           xlim = xlim,
           ylim = ylim,
           xlab = xlab,
           ylab = ylab,
           main = main)
      
      # --- grid -----------------------------------------------
      
      .callIf(graphics::grid, grid,
              defaults = th$grid[!startsWith(names(th$grid), "group.")])
    }
    
    lines(x, y, col = col, lwd = lwd, lty = lty)
    
  })
  
  invisible(list(x = x, y = y))
}