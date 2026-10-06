
#' Add a Spline Smoother
#'
#' Fit a smoothing spline and optionally add confidence bands.
#'
#' Confidence bands are controlled via `band`. These arguments can be:
#' \itemize{
#'   \item `FALSE`, `NULL` or `NA`: suppress the band
#'   \item `TRUE`: draw the band with default settings
#'   \item a named list: customize the band appearance and confidence level
#' }
#'
#' @name splineCI
#' @aliases lines.splineX lines.SplineX
#' @inheritParams Formulas
#' @param weights optional vector of weights, a column of `data` or a
#'   vector of the length of the original data. It is subject to `subset`
#'   and `na.action` like the variables of the formula.
#' @param x spline object returned by `splineX()`.
#' @param col line color of the smoother.
#' @param lwd line width.
#' @param lty line type.
#' @param type plotting type passed to [lines()].
#' @param band controls the confidence band. May be `TRUE`,
#'   `FALSE`, `NULL`, `NA`, or a named list. The confidence
#'   level is specified via `conf.level`, all other elements are
#'   graphical parameters of the band. Default is
#'   `list(conf.level = 0.95)`.
#' @param \dots for `splineX()`, further arguments passed to
#'   [stats::smooth.spline()]; for `lines()`, further graphical parameters
#'   passed to [lines()].
#'
#' @examples
#' op <- par(no.readonly = TRUE)
#' par(mfrow = c(1, 2))
#'
#' x <- runif(100)
#' y <- rnorm(100)
#'
#' plot(x, y)
#' lines(splineX(y ~ x))
#'
#' plot(dist ~ speed, cars)
#' lines(splineX(dist ~ speed, cars))
#'
#' # subset and weights, both evaluated in data
#' plot(dist ~ speed, cars)
#' lines(splineX(dist ~ speed, cars, subset = speed > 10,
#'               weights = sqrt(speed)))
#'
#' plot(dist ~ speed, cars)
#' lines(
#'   splineX(dist ~ speed, cars),
#'   band = list(
#'     conf.level = 0.99,
#'     col = addOpacity("red", 0.3),
#'     border = "black"
#'   )
#' )
#'
#' par(op)
#'
#' @seealso [loess()], [scatter.smooth()]
#'
#' @family graphics.trendlines  
#' @concept regression
#' @concept annotation
#'
#' @rdname splineCI
#' @export
splineX <- function(x, ...) {
  UseMethod("splineX")
}


#' @rdname splineCI
#' @export
splineX.default <- function(x, ...) {
  
  res <- stats::smooth.spline(x, ...)
  
  class(res) <- c("SplineX", class(res))
  
  res
  
}


#' @rdname splineCI
#' @export
splineX.formula <- function(
    formula,
    data,
    subset,
    na.action = na.omit,
    weights,
    ...
) {
  
  # formula, data and subset are forwarded unevaluated, so that 'subset' is
  # evaluated in 'data' as in lm(); resolveFormula() also checks for a
  # single numeric predictor
  r <- bedrock::resolveFormulaFromCall(
    allowed   = "numeric-numeric",
    na.action = na.action
  )
  
  w <- NULL
  
  if (!missing(weights)) {
    
    # Evaluated in 'data', not in the model frame: the model frame holds
    # only the variables of the formula, so a weights column was never
    # found. The result has the length of the original data and is aligned
    # with the model frame via r$rows, which accounts for subset and
    # na.action.
    w <- eval(substitute(weights),
              envir  = if (missing(data)) environment(formula) else data,
              enclos = environment(formula))
    
    if (is.null(r$rows))
      stop("'weights' cannot be aligned with the model frame", call. = FALSE)
    
    w <- w[r$rows]
  }
  
  res <- stats::smooth.spline(
    x = r$predictor,
    y = r$x,
    w = w,
    ...
  )
  
  class(res) <- c("SplineX", class(res))
  
  res
  
}


.calcSplineCI <- function(
    spline,
    fit,
    conf.level = 0.95
) {
  
  res <- (spline$yin - spline$y) / (1 - spline$lev)
  
  sigma <- sqrt(var(res))
  
  z <- qnorm((1 - conf.level) / 2)
  
  cbind(
    fit$y - z * sigma * sqrt(spline$lev),
    fit$y + z * sigma * sqrt(spline$lev)
  )
  
}


#' @rdname splineCI
#' @export
lines.SplineX <- function(
    x,
    col = pal()[1],
    lwd = 2,
    lty = "solid",
    type = "l",
    band = list(conf.level = 0.95),
    ...
) {
  
  fit <- predict(
    x,
    x = x$x
  )
  
  # conf.level is taken out here, the other elements of band style the
  # band: routing the whole list through callIf() into .calcSplineCI()
  # handed it every graphical parameter (band = list(lty = 2) failed
  # with "unused argument")
  bandOn <- !isFALSE(band) && !is.null(band) &&
            !bedrock::isNA(band)
  
  if (bandOn) {
    
    confLevel <- (if (is.list(band)) band$conf.level) %||% 0.95
    
    ci <- .calcSplineCI(spline = x, fit = fit, conf.level = confLevel)
    
    bedrock::callIf(
      .drawBandCI,
      band,
      defaults = list(
        x = fit$x,
        ci = ci,
        col = col
      ),
      forbidden = "conf.level",
      warn = FALSE
    )
  }
  
  lines(
    x = fit$x,
    y = fit$y,
    col = col,
    lwd = lwd,
    lty = lty,
    type = type,
    ...
  )
  
  invisible(NULL)
}
