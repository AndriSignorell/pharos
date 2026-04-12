
#' Add a Loess Smoother and Its Confidence Intervals
#' 
#' Add a loess smoother to an existing plot. The function first calculates the
#' prediction of a loess object for a reasonable amount of points, then adds
#' the line to the plot and inserts a polygon with the confidence intervals. 
#' 
#' 
#' @aliases lines.loess 
#' @param x the loess object to be plotted.
#' @param col linecolor of the smoother. Default is DescTools's \code{col1}. 
#' @param lwd line width of the smoother.
#' @param lty line type of the smoother. 
#' @param type type of plot, defaults to \code{"l"}. 
#' @param n number of points used for plotting the fit. 
#' @param conf.level confidence level for the confidence interval. Set this to
#' NA, if no confidence band should be plotted.  Default is 0.95. 
#' @param args.band list of arguments for the confidence band, such as color or
#' border (see \code{\link{drawBand}}). 
#' @param \dots further arguments are passed to the \code{loess()} smoother 
#' @note Loess can result in heavy computational load if there are many points!
#' @seealso \code{\link{loess}}, \code{\link{scatter.smooth}},
#' \code{\link{smooth.spline}}   %%, \code{\link{smoothSpline}} 
#' @keywords math aplot
#' @examples
#' 
#' op <- par(no.readonly = TRUE)
#' par(mfrow=c(1,2))
#' 
#' x <- runif(100)
#' y <- rnorm(100)
#' plot(x, y)
#' lines(loess(y~x))
#' 
#' plot(dist ~ speed, data=cars)
#' lines(loess(dist ~ speed, data=cars))
#' 
#' plot(dist ~ speed, data=cars)
#' lines(loess(dist ~ speed, data=cars), conf.level = 0.99,
#'             args.band = list(col=alpha("red", 0.4), border="black") )
#' 
#' # the default values from scatter.smooth
#' lines(loess(dist ~ speed, data=cars,
#'             span=2/3, degree=1, family="symmetric"), col="red")
#' 
#' par(op)
#' 


#' @method lines loess
#' @export
lines.loess <- function(x, col = Pal()[1], lwd = 2, lty = "solid", type = "l",  n = 100
                        , conf.level = 0.95, args.band = NULL, ...){
  
  newx <- seq(from = min(x$x, na.rm=TRUE), to = max(x$x, na.rm=TRUE), length = n)
  fit <- predict(x, newdata=newx, se = !is.na(conf.level) )
  
  if (!is.na(conf.level)) {
    
    # define default arguments for ci.band
    args.band1 <- list(col = alpha(col, 0.30), border = NA)
    # override default arguments with user defined ones
    if (!is.null(args.band)) args.band1[names(args.band)] <- args.band
    
    # add a confidence band before plotting the smoother
    lwr.ci <- fit$fit + fit$se.fit * qnorm((1 - conf.level)/2)
    upr.ci <- fit$fit - fit$se.fit * qnorm((1 - conf.level)/2)
    do.call("drawBand", c(args.band1, list(x=c(newx, rev(newx))), list(y=c(lwr.ci, rev(upr.ci)))) )
    # reset fit for plotting line afterwards
    fit <- fit$fit
  }
  
  lines( y = fit, x = newx, col = col, lwd = lwd, lty = lty, type = type)
  
}

