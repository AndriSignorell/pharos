
#' Add a Spline Smoother
#'
#' Fit a smoothing spline and optionally add confidence bands.
#'
#' Confidence bands are controlled via \code{bandArgs}. These arguments can be:
#' \itemize{
#'   \item \code{FALSE}, \code{NULL} or \code{NA}: suppress the band
#'   \item \code{TRUE}: draw the band with default settings
#'   \item a named list: customize the band appearance and confidence level
#' }
#'
#' @name splineCI
#' @aliases lines.splineX lines.SplineX
#' @inheritParams Formulas
#' @param weights optional vector of weights of the same length as x.
#' @param x spline object returned by \code{splineX()}.
#' @param col line color of the smoother.
#' @param lwd line width.
#' @param lty line type.
#' @param type plotting type passed to \code{\link{lines}}.
#' @param bandArgs controls the confidence band. May be \code{TRUE},
#'   \code{FALSE}, \code{NULL}, \code{NA}, or a named list. The confidence
#'   level is specified via \code{conf.level}. Default is
#'   \code{list(conf.level = 0.95)}.
#' @param \dots further arguments passed to
#'   \code{\link[stats:smooth.spline]{smooth.spline}}.
#'
#' @seealso \code{\link{loess}}, \code{\link{scatter.smooth}}
#'
#' @keywords math aplot
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
#' plot(dist ~ speed, cars)
#' lines(
#'   splineX(dist ~ speed, cars),
#'   bandArgs = list(
#'     conf.level = 0.99,
#'     col = addAlpha("red", 0.3),
#'     border = "black"
#'   )
#' )
#'
#' par(op)
#'
#' @rdname splineCI
#' @family plot.utils
#' @concept graphics
#' @concept regression
#'
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
  
  if (!inherits(formula, "formula"))
    stop("'formula' must be a formula")
  
  if (length(attr(terms(formula), "term.labels")) != 1)
    stop("Formula must be of the form y ~ x")
  
  args <- list(
    formula = formula,
    na.action = na.action,
    allowed = c(
      "two-sample-independent",
      "n-sample-independent"
    )
  )
  
  if (!missing(data))
    args$data <- data
  
  if (!missing(subset))
    args$subset <- substitute(subset)
  
  d <- do.call(bedrock::resolveFormula, args)
  
  mf <- d$mf
  
  y <- mf[[1]]
  x <- mf[[2]]
  
  w <- NULL
  
  if (!missing(weights)) {
    
    w <- eval(
      substitute(weights),
      envir = mf,
      enclos = parent.frame()
    )
    
  }
  
  res <- stats::smooth.spline(
    x = x,
    y = y,
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
    bandArgs = list(conf.level = 0.95),
    ...
) {
  
  fit <- predict(
    x,
    x = x$x
  )
  
  ci <- callIf(
    .calcSplineCI,
    bandArgs,
    defaults = list(
      spline = x,
      fit = fit,
      conf.level = 0.95
    ),
    forbidden = c("col", "border")
  )
  
  callIf(
    .drawBandCI,
    bandArgs,
    defaults = list(
      x = fit$x,
      ci = ci,
      col = col
    ),
    forbidden = "conf.level",
    warn = FALSE
  )
  
  lines(
    x = fit$x,
    y = fit$y,
    col = col,
    lwd = lwd,
    lty = lty,
    type = type
  )
  
}
