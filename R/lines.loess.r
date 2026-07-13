
#' Add a Loess Smoother and Its Confidence Band
#'
#' Add a loess smoother to an existing plot. The function first calculates
#' predictions from a \code{loess} object and then adds the fitted smoother
#' together with an optional confidence band.
#'
#' The confidence band is controlled via \code{bandArgs}. This argument may be:
#' \itemize{
#'   \item \code{FALSE}, \code{NULL} or \code{NA}: suppress the band
#'   \item \code{TRUE}: draw the band with default settings
#'   \item a named list: customize the band appearance and confidence level
#' }
#'
#' @param x a fitted \code{\link{loess}} object.
#' @param col line color of the smoother. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$twin[1]} - the first of the theme's
#'   two-color pair (see [theme]).
#' @param lwd line width.
#' @param lty line type.
#' @param type plotting type passed to \code{\link{lines}}.
#' @param n number of points used for plotting the fit.
#' @param bandArgs controls the confidence band. May be \code{TRUE},
#'   \code{FALSE}, \code{NULL}, \code{NA}, or a named list. The confidence
#'   level is specified via \code{conf.level}. Default is
#'   \code{list(conf.level = 0.95)}.
#' @param \dots currently ignored.
#'
#' @note Loess can result in substantial computational load for large datasets.
#'
#' @examples
#' x <- runif(100)
#' y <- rnorm(100)
#'
#' plot(x, y)
#' lines(loess(y ~ x))
#'
#' plot(dist ~ speed, cars)
#' lines(
#'   loess(dist ~ speed, cars),
#'   bandArgs = list(
#'     conf.level = 0.99,
#'     col = addOpacity("red", 0.4),
#'     border = "black"
#'   )
#' )
#'
#' @seealso \code{\link{loess}}, \code{\link{scatter.smooth}},
#'   \code{\link{smooth.spline}}
#' @family graphics.trendlines  
#'
#' @method lines loess
#' @concept regression
#' @concept annotation
#'
#' @export
lines.loess <- function(
    x,
    col = .useTheme,
    lwd = 2,
    lty = "solid",
    type = "l",
    n = 100,
    bandArgs = list(conf.level = 0.95),
    ...
) {
  
  col <- if (identical(col, .useTheme)) getTheme()$twin[1] else col
  
  newx <- seq(
    from = min(x$x, na.rm = TRUE),
    to = max(x$x, na.rm = TRUE),
    length.out = n
  )
  
  conf.level <- if (is.list(bandArgs))
    bandArgs$conf.level %||% 0.95
  else
    0.95
  
  fit <- predict(
    x,
    newdata = newx,
    se = !isFALSE(bandArgs) &&
      !is.null(bandArgs) &&
      !isNA(bandArgs)
  )
  
  callIf(
    .drawBandCI,
    bandArgs,
    defaults = list(
      x = newx,
      ci = {
        z <- qnorm((1 - conf.level) / 2)
        
        cbind(
          fit$fit + fit$se.fit * z,
          fit$fit - fit$se.fit * z
        )
      },
      col = col
    ),
    forbidden = "conf.level",
    warn = FALSE
  )
  
  if (is.list(fit))
    fit <- fit$fit
  
  lines(
    x = newx,
    y = fit,
    col = col,
    lwd = lwd,
    lty = lty,
    type = type
  )
  
}

