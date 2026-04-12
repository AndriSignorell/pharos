
#' Add a Spline Smoother
#' 
#' Add a spline smoother to an existing plot. The function first calculates the
#' prediction of a spline object for a reasonable amount of points, then adds
#' the line to the plot and inserts a polygon with the confidence intervals. 
#' 
#' @name splineCI
#' @aliases lines.smooth.spline lines.SmoothSpline
#' @inheritParams Formulas
#' @param weights optional vector of weights of the same length as x; defaults to all 1.
#' @param x the smooth.spline object to be plotted.
#' @param col linecolor of the smoother. Default is DescTools's \code{col1}. 
#' @param lwd line width of the smoother.
#' @param lty line type of the smoother. 
#' @param type type of plot, defaults to \code{"l"}. 
#' @param conf.level confidence level for the confidence interval. Set this to
#' NA, if no confidence band should be plotted.  Default is 0.95. 
#' @param args.band list of arguments for the confidence band, such as color or
#' border (see \code{\link{drawBand}}). 
#' @param \dots further arguments are passed to the smoother \code{SmoothSpline()}). 
#' @seealso \code{\link{loess}}, \code{\link{scatter.smooth}}
#' @keywords math aplot
#' @examples
#' 
#' op <- par(no.readonly = TRUE)
#' par(mfrow=c(1,2))
#' 
#' x <- runif(100)
#' y <- rnorm(100)
#' plot(x, y)
#' lines(smooth.spline(y ~ x))
#' 
#' plot(dist ~ speed, data=cars)
#' lines(smoothSpline(dist ~ speed, data=cars))
#' 
#' par(op)
#' 


#' @rdname splineCI
#' @export
smoothSpline <- function(x, ...) {
  UseMethod("smoothSpline")
}


#' @rdname splineCI
#' @export
smoothSpline.default <- function(x, ...) {
  stats::smooth.spline(x, ...)
}


#' @rdname splineCI
#' @export
smoothSpline.formula <- function(formula,
                                 data,
                                 subset,
                                 na.action,
                                 weights,
                                 ...) {
  
  if (!inherits(formula, "formula"))
    stop("'formula' must be a formula.")
  
  if (length(attr(terms(formula), "term.labels")) != 1)
    stop("Formula must be of the form y ~ x.")
  
  # match.call Trick wie in lm()
  mf <- match.call(expand.dots = FALSE)
  mf[[1]] <- quote(stats::model.frame)
  
  if (missing(weights))
    mf$weights <- NULL
  
  mf$... <- NULL
  
  mf <- eval(mf, parent.frame())
  
  y <- model.response(mf)
  x <- mf[[2]]
  w <- model.weights(mf)
  
  stats::smooth.spline(x = x, y = y, w = w, ...)
}


#' @rdname splineCI
#' @export
lines.SmoothSpline <- function (x, col = Pal()[1], lwd = 2, lty = "solid",
                                type = "l", conf.level = 0.95, args.band = NULL,
                                ...) {
  # just pass on to lines
  lines.smooth.spline(x, col, lwd, lty,
                      type, conf.level, args.band,  ...)
}


#' @rdname splineCI
#' @export
lines.smooth.spline <- function (x, col = Pal()[1], lwd = 2, lty = "solid",
                                 type = "l", conf.level = 0.95, args.band = NULL,
                                 ...) {
  
  # newx <- seq(from = min(x$x, na.rm = TRUE), to = max(x$x, na.rm = TRUE), length = n)
  newx <- x$x
  
  fit <- predict(x, newdata = newx)
  
  if (!is.na(conf.level)) {
    args.band1 <- list(col = alpha(col, 0.3), border = NA)
    if (!is.null(args.band))
      args.band1[names(args.band)] <- args.band
    
    res <- (x$yin - x$y)/(1-x$lev)      # jackknife residuals
    sigma <- sqrt(var(res))                     # estimate sd
    upr.ci <- fit$y + qnorm((1 - conf.level)/2) * sigma * sqrt(x$lev)   # upper 95% conf. band
    lwr.ci <- fit$y - qnorm((1 - conf.level)/2) * sigma * sqrt(x$lev)   # lower 95% conf. band
    
    do.call("drawBand", c(args.band1, list(x = c(newx, rev(newx))),
                          list(y = c(lwr.ci, rev(upr.ci)))))
    
  }
  
  lines(y = fit$y, x = fit$x, col = col, lwd = lwd, lty = lty, type = type)
}

