
#' Add a Linear Regression Line
#'
#' Add a linear regression line to an existing plot. The function first
#' calculates predictions from an `lm` object and then adds the fitted
#' line together with optional confidence and prediction bands.
#'
#' In contrast to [abline()], polynomial models and transformed
#' predictors are supported as long as the model contains exactly one predictor
#' variable. A polynomial, `y ~ poly(x, 2)` or `y ~ x + I(x^2)`, is drawn
#' against `x`; a single transformed term such as `y ~ log(x)` is drawn
#' against the transformed values, matching `plot(y ~ log(x))`.
#'
#' Confidence and prediction bands are controlled via `cbandArgs` and
#' `pbandArgs`. These arguments can be:
#' \itemize{
#'   \item `FALSE`, `NULL` or `NA`: suppress the band
#'   \item `TRUE`: draw the band with default settings
#'   \item a named list: customize the band appearance and confidence level
#' }
#'
#' @param x linear model object as returned by [lm()].
#' @param col line color. Defaults to `pal()[1]`.
#' @param lwd line width.
#' @param lty line type.
#' @param type plotting type passed to [lines()].
#' @param n number of points used for plotting the fit.
#' @param cbandArgs controls the confidence band. May be `TRUE`,
#'   `FALSE`, `NULL`, `NA`, or a named list. The confidence
#'   level is specified via `conf.level`, all other elements are graphical
#'   parameters of the band. Default is `list(conf.level=0.95)`.
#' @param pbandArgs controls the prediction band, as `cbandArgs`. Default
#'   is `NA`.
#' @param xpred optional numeric vector defining the range over which
#'   predictions should be calculated.
#' @param \dots further graphical parameters passed to [lines()] for the
#'   fitted line.
#'
#' @return No return value; called for its side effect.
#'
#' @seealso [lines()], [lm()]
#' 
#' @family graphics.trendlines  
#' @concept regression  
#' @concept annotation
#'
#'
#' @rdname linesLm
#' @method lines lm
#' @export
lines.lm <- function(
    x,
    col = pal()[1],
    lwd = 2,
    lty = "solid",
    type = "l",
    n = 100,
    cbandArgs = list(conf.level = 0.95),
    pbandArgs = NA,
    xpred = NULL,
    ...
) {
  
  z <- .calcTrendline(
    x,
    n = n,
    cbandArgs = cbandArgs,
    pbandArgs = pbandArgs,
    xpred = xpred
  )
  
  .drawTrendLine(
    z,
    col = col,
    lwd = lwd,
    lty = lty,
    type = type,
    cbandArgs = cbandArgs,
    pbandArgs = pbandArgs,
    ...
  )
  
}


#' @rdname linesLm
#' @method lines lmlog
#' @export
lines.lmlog <- function(
    x,
    col = pal()[1],
    lwd = 2,
    lty = "solid",
    type = "l",
    n = 100,
    cbandArgs = list(conf.level = 0.95),
    pbandArgs = NA,
    xpred = NULL,
    ...
) {
  
  z <- .calcTrendline(
    x,
    n = n,
    cbandArgs = cbandArgs,
    pbandArgs = pbandArgs,
    xpred = xpred
  )
  
  z <- .transformTrendline(z, exp)
  
  .drawTrendLine(
    z,
    col = col,
    lwd = lwd,
    lty = lty,
    type = type,
    cbandArgs = cbandArgs,
    pbandArgs = pbandArgs,
    ...
  )
  
}


# == internal helper functions ================================================

.getPredictor <- function(model) {
  
  pred <- all.vars(formula(model)[[3]])
  
  if (length(pred) != 1L)
    stop("Can't plot a linear model with more than 1 predictor.")
  
  pred
  
}


.getPredictionGrid <- function(
    model,
    predictor,
    n = 100,
    xpred = NULL
) {
  
  # The predictor is searched in the model frame, then in the data of the
  # call, then in the formula's environment. The model frame alone does not
  # hold it for poly(x, 2) (the column is the basis matrix "poly(x, 2)"),
  # and the data was only consulted when there was no model frame at all -
  # so y ~ poly(x, 2) always failed without xpred.
  if (is.null(xpred))
    xpred <- model$model[[predictor]]
  
  if (is.null(xpred) && !is.null(model$call$data))
    xpred <- eval(model$call$data,
                  envir = environment(formula(model)))[[predictor]]
  
  if (is.null(xpred))
    xpred <- get0(predictor, envir = environment(formula(model)))
  
  if (is.null(xpred))
    stop(
      "Could not recover predictor values from model. ",
      "Provide xpred = c(from, to)."
    )
  
  if (!is.numeric(xpred)) {
    xpred <- as.numeric(xpred)
    warning("Nonnumeric predictor has been cast as numeric.")
  }
  
  rawx <- data.frame(
    seq(
      from = min(xpred, na.rm = TRUE),
      to = max(xpred, na.rm = TRUE),
      length.out = n
    )
  )
  
  names(rawx) <- predictor
  
  rawx
  
}


.getPlotX <- function(model, rawx) {
  
  rhs <- formula(model)[[3]]
  
  # Only a single, transformed term is drawn against its transformed values
  # (y ~ log(x) as in plot(y ~ log(x))). A polynomial is drawn against x:
  # evaluating the whole right-hand side of y ~ x + I(x^2) computed x + x^2
  # as the x-coordinates.
  singleTerm <- length(attr(terms(formula(model)), "term.labels")) == 1L
  isPoly     <- is.call(rhs) && identical(rhs[[1]], as.name("poly"))
  
  if (singleTerm && !isPoly)
    eval(rhs, rawx)
  else
    rawx
  
}


# The confidence level of a band spec: NULL if the band is suppressed,
# otherwise conf.level from the list or 0.95. The spec itself is not routed
# into the interval calculation - apart from conf.level it holds graphical
# parameters of the band.
.bandLevel <- function(spec) {
  if (isFALSE(spec) || is.null(spec) || bedrock::isNA(spec))
    return(NULL)
  (if (is.list(spec)) spec$conf.level) %||% 0.95
}


.calcInterval <- function(
    model,
    newdata,
    interval,
    conf.level = 0.95
) {
  
  predict(
    model,
    interval = interval,
    newdata = newdata,
    level = conf.level
  )[, -1, drop = FALSE]
  
}


.transformTrendline <- function(z, fun) {
  
  for (nm in c("y", "ci", "pci")) {
    if (!is.null(z[[nm]]))
      z[[nm]] <- fun(z[[nm]])
  }
  
  z
  
}


.calcTrendline <- function(
    x,
    n = 100,
    cbandArgs = list(conf.level = 0.95),
    pbandArgs = NA,
    xpred = NULL
) {
  
  pred <- .getPredictor(x)
  
  rawx <- .getPredictionGrid(
    x,
    predictor = pred,
    n = n,
    xpred = xpred
  )
  
  fit <- predict(x, newdata = rawx)
  
  newx <- .getPlotX(x, rawx)
  
  # conf.level only, see .bandLevel(): with the whole spec, every graphical
  # parameter other than col/border reached .calcInterval()
  # (cbandArgs = list(lty = 2) failed with "unused argument")
  cLevel <- .bandLevel(cbandArgs)
  pLevel <- .bandLevel(pbandArgs)
  
  ci  <- if (!is.null(cLevel))
    .calcInterval(x, newdata = rawx, interval = "confidence",
                  conf.level = cLevel)
  
  pci <- if (!is.null(pLevel))
    .calcInterval(x, newdata = rawx, interval = "prediction",
                  conf.level = pLevel)
  
  list(
    x = newx,
    y = fit,
    ci = ci,
    pci = pci
  )
  
}


.drawTrendLine <- function(
    z,
    col = pal()[1],
    lwd = 2,
    lty = "solid",
    type = "l",
    cbandArgs = list(conf.level = 0.95),
    pbandArgs = NA,
    ...
) {
  
  bedrock::callIf(
    .drawBandCI,
    pbandArgs,
    defaults = list(
      x = z$x,
      ci = z$pci,
      col = col
    ),
    forbidden = "conf.level",
    warn = FALSE
  )
  
  bedrock::callIf(
    .drawBandCI,
    cbandArgs,
    defaults = list(
      x = z$x,
      ci = z$ci,
      col = col
    ),
    forbidden = "conf.level",
    warn = FALSE
  )
  
  lines(
    x = unlist(z$x),
    y = z$y,
    col = col,
    lwd = lwd,
    lty = lty,
    type = type,
    ...
  )
  
  invisible(NULL)
}


.drawBandCI <- function(x, ci, col, ...) {
  
  if (is.null(ci))
    return(invisible(NULL))
  
  bandArgs <- mergeArgs(
    defaults = list(
      col = addOpacity(col, 0.12),
      border = NA
    ),
    user = list(...),
    forbidden = "conf.level",
    warn = FALSE
  )
  
  xy <- band(
    x = c(unlist(x), rev(unlist(x))),
    y = c(ci[, 1], rev(ci[, 2]))
  )
  
  do.call(
    polygon,
    c(
      as.list(xy[c("x", "y")]),
      bandArgs
    )
  )
  
}

