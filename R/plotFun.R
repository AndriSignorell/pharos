
#' Plot Mathematical Functions
#'
#' Flexible plotting of mathematical functions in Cartesian, polar, and
#' parametric form.
#'
#' The function automatically detects the type of input:
#' \itemize{
#'   \item \strong{Cartesian:} \code{y ~ f(x)}
#'   \item \strong{Polar:} \code{r ~ f(phi)} or \code{r ~ f(theta)}
#'   \item \strong{Parametric:} \code{list(x ~ f(t), y ~ g(t))}
#' }
#'
#' Additional parameters fixed for the expression can be passed via
#' \code{args}.
#'
#' @param expr Expression defining the function. Either a formula
#'   (\code{y ~ f(x)}), a polar formula (\code{r ~ f(phi)}), or a list
#'   of two formulas for parametric plots.
#'
#' @param main main title of the plot. \code{NULL} (default) derives a
#'   title from \code{expr}. \code{""}, \code{NA}, or \code{FALSE}
#'   suppress the title and compact the top margin.
#' @param xlab,ylab labels for the axes.
#'
#' @param xlim,ylim numeric vectors of length 2 defining axis limits.
#'   For Cartesian functions, \code{xlim} defaults to \code{c(from, to)}.
#'   For polar and parametric plots, limits are derived from the data.
#'   If only \code{xlim} is supplied for polar/parametric plots, \code{ylim}
#'   mirrors it (ensures \code{asp=1} renders correctly).
#'
#' @param from,to numeric; lower and upper bound of the parameter domain.
#'   Default \code{from=0}, \code{to=1}.
#' @param n integer; number of evaluation points. Default \code{500}.
#' @param args named list of additional parameters fixed for the function
#'   expression (e.g. \code{list(a = 2)} for \code{y ~ sin(a*x)}).
#'
#' @param col color of the line. \code{.useTheme} (default) resolves to
#'   \code{getTheme()$twin[1]} - the primary accent color, consistent with
#'   \code{\link{lines.loess}} and \code{plotQQ()}.
#' @param lwd line width. Default \code{1}.
#' @param lty line type. Default \code{1}.
#' @param grid controls drawing of the background grid. \code{.useTheme}
#'   (default) follows the active theme (\code{getTheme()$grid}).
#'   \code{TRUE}/\code{FALSE}/\code{NA}, or a named list, as for
#'   \code{\link[graphics]{grid}}.
#'
#' @param add logical; if \code{TRUE}, adds to an existing plot without
#'   redrawing axes or grid. Default \code{FALSE}.
#'
#' @param stamp controls the corner stamp. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$stamp}. \code{TRUE}/\code{FALSE}/
#'   \code{NULL}, a string, or a named list for \code{\link{stamp}()}.
#' @param \dots further graphical parameters passed to
#'   \code{\link[graphics]{par}} via the internal framework.
#'
#' @return Invisibly returns a list with components \code{x} and \code{y}
#'   (the plotted coordinates after finite filtering).
#'
#' @examples
#' # Cartesian
#' plotFun(y ~ x^2)
#'
#' # Damped oscillation - add second curve to existing plot
#' plotFun(y ~ 3*exp(-x/5)*sin(4*x), from = 0, to = 10)
#' plotFun(y ~ 3*exp(-x/5)*sin(6*x), from = 0, to = 10, add = TRUE)
#'
#' # Cardioid (polar)
#' plotFun(r ~ 2*(1 + cos(phi)), from = 0, to = 2*pi)
#'
#' # Heart curve (parametric)
#' plotFun(
#'   list(
#'     x ~ 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t),
#'     y ~ 16*sin(t)^3
#'   ),
#'   from = 0, to = 2*pi, lwd = 2
#' )
#'
#' # Parameter sweep
#' for (a in 1:3)
#'   plotFun(y ~ sin(a*x), args = list(a = a),
#'           from = 0, to = 2*pi,
#'           add = (a != 1), col = a)
#'

#' @family plot.distribution  
#' @concept distribution-summary
#'
#'
#' @export
plotFun <- function(
    
  # DATA
  expr,
  
  # LABELS
  main = NULL,
  xlab = "",
  ylab = "",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # STRUCTURE
  from = 0,
  to   = 1,
  n    = 500,
  args = NULL,
  add  = FALSE,
  
  # STYLE
  col  = .useTheme,
  lwd  = 1,
  lty  = 1,
  grid = .useTheme,
  
  # FRAMEWORK
  stamp = .useTheme,
  
  ...
) {
  
  if (identical(col, .useTheme))
    col <- getTheme()$twin[1]
  
  # --- type detection -------------------------------------------
  type <- if (is.list(expr)) {
    "parametric"
  } else {
    var <- all.vars(as.list(expr)[[3]])[1]
    if (var %in% c("phi", "theta")) "polar" else "cartesian"
  }
  
  # Derive default title from expr before .withGraphicsState()
  defaultTitle <- if (is.list(expr))
    paste(deparse(expr[[1]]), "/", deparse(expr[[2]]))
  else
    deparse(expr)
  
  .withGraphicsState({
    
    .applyParFromDots(...,
                      defaults = list(
                        mar = c(left = 5, top = .marTop(main))
                      ))
    
    main <- .resolveTitle(main, default = defaultTitle)
    
    # --- inject args into evaluation environment ----------------
    env <- new.env(parent = parent.frame())
    
    if (!is.null(args)) {
      if (!is.list(args))
        stop("'args' must be a named list")
      
      for (nm in names(args)) {
        val <- args[[nm]]
        if (length(val) > 1) {
          val <- val[1]
          warning(sprintf("first element used for '%s'", nm))
        }
        assign(nm, val, envir = env)
      }
    }
    
    t <- seq(from, to, length.out = n)
    
    # --- CARTESIAN ----------------------------------------------
    if (type == "cartesian") {
      
      rhs  <- as.list(expr)[[3]]
      vars <- setdiff(all.vars(rhs), names(args))
      
      if (length(vars) == 0L)
        stop("no free variable found in expression")
      
      assign(vars[1], t, envir = env)
      x <- t
      y <- eval(rhs, envir = env)
    }
    
    # --- POLAR --------------------------------------------------
    if (type == "polar") {
      
      rhs  <- as.list(expr)[[3]]
      vars <- setdiff(all.vars(rhs), names(args))
      
      if (length(vars) == 0L)
        stop("no free variable found in expression")
      
      assign(vars[1], t, envir = env)
      r <- eval(rhs, envir = env)
      x <- r * cos(t)
      y <- r * sin(t)
    }
    
    # --- PARAMETRIC ---------------------------------------------
    if (type == "parametric") {
      
      if (!inherits(expr[[1]], "formula") || !inherits(expr[[2]], "formula"))
        stop("parametric: use list(x ~ f(t), y ~ g(t))")
      
      assign("t", t, envir = env)
      assign("z", t, envir = env)   # convenience alias
      x <- eval(as.list(expr[[1]])[[3]], envir = env)
      y <- eval(as.list(expr[[2]])[[3]], envir = env)
    }
    
    # --- finite filter ------------------------------------------
    ok <- is.finite(x) & is.finite(y)
    x  <- x[ok]
    y  <- y[ok]
    
    # --- axis limits --------------------------------------------
    if (is.null(xlim)) {
      if (type != "cartesian") {
        xlim <- range(x)
        ylim <- range(y)
      } else {
        xlim <- c(from, to)
      }
    }
    
    if (is.null(ylim))
      ylim <- xlim   # mirror for polar/parametric so asp=1 renders correctly
    
    # --- draw ---------------------------------------------------
    if (!add) {
      plot(x, y,
           type = "n", asp = 1,
           xlim = xlim, ylim = ylim,
           xlab = xlab, ylab = ylab,
           main = main, ...)
      
      .drawGrid(grid)
    }
    
    lines(x, y, col = col, lwd = lwd, lty = lty)
    
  }, stamp = stamp)
  
  invisible(list(x = x, y = y))
}

