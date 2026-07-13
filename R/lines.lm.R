
#' Add a Linear Regression Line
#'
#' Add a linear regression line to an existing plot. The function first
#' calculates predictions from an \code{lm} object and then adds the fitted
#' line together with optional confidence and prediction bands.
#'
#' In contrast to \code{\link{abline}}, polynomial models and transformed
#' predictors are supported as long as the model contains exactly one predictor.
#'
#' Confidence and prediction bands are controlled via \code{cbandArgs} and
#' \code{pbandArgs}. These arguments can be:
#' \itemize{
#'   \item \code{FALSE}, \code{NULL} or \code{NA}: suppress the band
#'   \item \code{TRUE}: draw the band with default settings
#'   \item a named list: customize the band appearance and confidence level
#' }
#'
#' @param x linear model object as returned by \code{\link{lm}}.
#' @param col line color. Defaults to \code{pal()[1]}.
#' @param lwd line width.
#' @param lty line type.
#' @param type plotting type passed to \code{\link{lines}}.
#' @param n number of points used for plotting the fit.
#' @param cbandArgs controls the confidence band. May be \code{TRUE},
#'   \code{FALSE}, \code{NULL}, \code{NA}, or a named list. The confidence
#'   level is specified via \code{conf.level}. Default is
#'   \code{list(conf.level=0.95)}.
#' @param pbandArgs controls the prediction band. May be \code{TRUE},
#'   \code{FALSE}, \code{NULL}, \code{NA}, or a named list. The confidence
#'   level is specified via \code{conf.level}. Default is \code{NA}.
#' @param xpred optional numeric vector defining the range over which
#'   predictions should be calculated.
#' @param \dots currently ignored.
#'
#' @return No return value; called for its side effect.
#'
#' @seealso \code{\link{lines}}, \code{\link{lm}}
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
    pbandArgs = pbandArgs
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
    pbandArgs = pbandArgs
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
  
  if (is.null(xpred)) {
    
    if (!is.null(model$model)) {
      
      xpred <- model$model[[predictor]]
      
    } else if (!is.null(model$call$data)) {
      
      xpred <- eval(
        model$call$data,
        envir = environment(formula(model))
      )[[predictor]]
      
    }
    
  }
  
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
  
  if (
    is.call(rhs) &&
    identical(rhs[[1]], as.name("poly"))
  ) {
    rawx
  } else {
    eval(rhs, rawx)
  }
  
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
  
  ci <- callIf(
    .calcInterval,
    cbandArgs,
    defaults = list(
      model = x,
      newdata = rawx,
      interval = "confidence",
      conf.level = 0.95
    ),
    forbidden = c("col", "border")
  )
  
  pci <- callIf(
    .calcInterval,
    pbandArgs,
    defaults = list(
      model = x,
      newdata = rawx,
      interval = "prediction",
      conf.level = 0.95
    ),
    forbidden = c("col", "border")
  )
  
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
    pbandArgs = NA
) {
  
  callIf(
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
  
  callIf(
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
    type = type
  )
  
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

