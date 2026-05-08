
#' Add a Linear Regression Line 
#' 
#' Add a linear regression line to an existing plot. The function first
#' calculates the prediction of a \code{lm} object for a reasonable amount of
#' points, then adds the line to the plot and inserts a polygon with the
#' confidence and, if required, the prediction intervals. In addition to
#' \code{\link{abline}} the function will also display polynomial models.
#' 
#' It's sometimes illuminating to plot a regression line with its prediction,
#' resp. confidence intervals over an existing scatterplot. This only makes
#' sense, if just a simple linear model explaining a target variable by (a
#' function of) one single predictor is to be visualized. 
#' 
#' @param x linear model object as result from lm(y~x).
#' @param col linecolor of the line. Default is the color returned by
#' \code{pal()[1]}. 
#' @param lwd line width of the line. %% ~~Describe \code{lwd} here~~
#' @param lty line type of the line. %% ~~Describe \code{lwd} here~~
#' @param type character indicating the type of plotting; actually any of the
#' \code{types} as in \code{\link{plot.default}}. Type of plot, defaults to
#' \code{"l"}. 
#' @param n number of points used for plotting the fit. 
#' @param conf.level confidence level for the confidence interval. Set this to
#' \code{NA}, if no confidence band should be plotted.  Default is \code{0.95}.
#' @param args.cband list of arguments for the confidence band, such as color
#' or border (see \code{\link{drawBand}}). 
#' @param pred.level confidence level for the prediction interval. Set this to
#' NA, if no prediction band should be plotted.  Default is \code{0.95}. 
#' @param args.pband list of arguments for the prediction band, such as color
#' or border (see \code{\link{drawBand}}). 
#' @param xpred a numeric vector \code{c(from, to)}, if the x limits can't be
#' defined based on available data, xpred can be used to provide the range
#' where the line and especially the confidence intervals should be plotted.
#' @param \dots further arguments are not used specifically. 
#' @return nothing 
#' @seealso \code{\link{lines}}, \code{\link{lines.loess}}, \code{\link{lm}} 
#' @keywords aplot math
#' @examples
#' op <- par(no.readonly = TRUE)
#' par(mfrow=c(1,2))
#' 
#' plot(hp ~ wt, mtcars)
#' lines(lm(hp ~ wt, mtcars), col="steelblue")
#' 
#' # add the prediction intervals in different color
#' plot(hp ~ wt, mtcars)
#' r.lm <- lm(hp ~ wt, mtcars)
#' lines(r.lm, col="red", pred.level=0.95, args.pband=list(col=alpha("grey",0.3)) )
#' 
#' # works with transformations too
#' plot(dist ~ sqrt(speed), cars)
#' lines(lm(dist ~ sqrt(speed), cars), col="deeppink4")
#' 
#' plot(dist ~ log(speed), cars)
#' lines(lm(dist ~ log(speed), cars), col="deeppink4")
#' 
#' # and with more specific variables based on only one predictor
#' plot(dist ~ speed, cars)
#' lines(lm(dist ~ poly(speed, degree=2), cars), col="deeppink4")
#' 
#' par(op)
#' 

#' @rdname linesLm
#' @method lines lm
#' @family plot.utils
#' @concept graphics
#' @concept regression
#'
#'
#' @export
lines.lm <- function (x, col = pal()[1], lwd = 2, lty = "solid",
                      type = "l", n = 100, conf.level = 0.95, args.cband = NULL,
                      pred.level = NA, args.pband = NULL, xpred=NULL, ...) {
  
  z <- .calcTrendline(x, n=n, conf.level=conf.level, pred.level=pred.level, xpred=xpred)  
  .drawTrendLine(z, col=col, lwd=lwd, lty=lty, args.cband=args.cband, args.pband=args.pband)
  
}


#' @rdname linesLm
#' @method lines lmlog
#' @export
lines.lmlog <- function (x, col = pal()[1], lwd = 2, lty = "solid",
                         type = "l", n = 100, conf.level = 0.95, args.cband = NULL,
                         pred.level = NA, args.pband = NULL, ...) {
  
  # expects a model of the form log(y) ~ x
  
  z <- .calcTrendline(x, n=n, conf.level=conf.level, pred.level=pred.level)
  # exponentiate y and all ci results, but not x (,1)
  i <- which(!sapply(z[2:4], is.null)) + 1
  z[i] <- lapply(z[i], exp)
  
  .drawTrendLine(z, col=col, lwd=lwd, lty=lty, args.cband=args.cband, args.pband=args.pband)
  
}


# == internal helper functions ================================================

.calcTrendline <- function (x, n = 100, conf.level = 0.95, 
                            pred.level = 0.95, xpred=NULL, ...) {
  
  # this takes the model x and calculates a set of n points
  # including the function, confidence band for E[X] and for the prediction
  
  mod <- x$model
  
  # all.vars returns all used variables in the model, even when poly models are used
  # the result will be the name of the predictor
  pred <- all.vars(formula(x)[[3]])
  if (length(pred) > 1) {
    stop("Can't plot a linear model with more than 1 predictor.")
  }
  
  # xpred <- model.frame(x)[, pred]
  # we cannot simply take the model frame here as we would miss poly(..) models
  # which could well be plotted as well   
  
  # we can't access the raw data for the plot from the model frame, so
  # we try to reevaluate in parent.frame
  # this will fail if we are called from a function, where the parent.frame
  # does not contain the data
  if(is.null(xpred))
    xpred <- eval(x$call$data, parent.frame(n=2))[, pred]
  
  if(!is.numeric(xpred)){
    # predictor might be a factor
    xpred <- as.numeric(xpred)
    warning("Nonnumerc predictor has been casted as numeric.")
  }
  
  
  if(is.null(xpred))
    stop("Data can't be accessed in parent.frame. Provide x-range for prediction (xpred=c(from, to)).")
  
  rawx <- data.frame(seq(from = min(xpred, na.rm = TRUE), 
                         to = max(xpred, na.rm = TRUE), length = n))
  colnames(rawx) <- pred
  
  fit <- predict(x, newdata = rawx)
  
  # check if polynomial model, for then we need the rawx to calculate xy.coord
  isPolyMod <- grepl("poly,", toString(formula(x)[[3]]))
  if(isPolyMod)
    newx <- rawx
  else 
    newx <- eval(formula(x)[[3]], rawx)
  
  if (!(is.na(conf.level))) {
    ci <- predict(x, interval = "confidence", newdata = rawx, 
                  level = conf.level)[, -1]
  } else ci <- NULL
  
  if (!(is.na(pred.level))) {
    pci <- predict(x, interval = "prediction", newdata = rawx, 
                   level = pred.level)[, -1]
  } else pci <- NULL
  
  return(list(x=newx, y=fit, ci=ci, pci=pci))
  
}


.drawTrendLine <- function(z, col = pal()[1], lwd = 2, lty = "solid", type = "l", 
                           args.cband = NULL,  args.pband = NULL) {
  
  # this draws a trendline in an existing plot
  
  args.pband1 <- list(col = alpha(col, 0.12), border = NA)
  if (!identical(args.pband, NA) && !is.null(z$pci)) {
    if (!is.null(args.pband))
      args.pband1[names(args.pband)] <- args.pband
    do.call("drawBand", c(args.pband1, list(x = c(unlist(z$x), rev(unlist(z$x)))), 
                          list(y = c(z$pci[, 1], rev(z$pci[, 2])))))
  }
  
  args.cband1 <- list(col = alpha(col, 0.12), border = NA)
  if (!identical(args.cband, NA) && !is.null(z$ci)) {
    if (!is.null(args.cband))
      args.cband1[names(args.cband)] <- args.cband
    do.call("drawBand", c(args.cband1, list(x = c(unlist(z$x), rev(unlist(z$x)))), 
                          list(y = c(z$ci[, 1], rev(z$ci[, 2])))))
  }
  
  lines(y = z$y, x = unlist(z$x), col = col, lwd = lwd, lty = lty,
        type = type)
  
}

