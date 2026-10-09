
#' Add a Loess Smoother and Its Confidence Band
#'
#' Add a loess smoother to an existing plot. The function first calculates
#' predictions from a `loess` object and then adds the fitted smoother
#' together with an optional confidence band.
#'
#' The confidence band is controlled via `band`. This argument may be:
#' \itemize{
#'   \item `FALSE`, `NULL` or `NA`: suppress the band
#'   \item `TRUE`: draw the band with default settings
#'   \item a named list: customize the band appearance and confidence level
#' }
#'
#' @param x a fitted [loess()] object.
#' @param col line color of the smoother. `.useTheme` (default)
#'   resolves to `getTheme()$twin[1]` - the first of the theme's
#'   two-color pair (see [theme]).
#' @param lwd line width.
#' @param lty line type.
#' @param type plotting type passed to [lines()].
#' @param n number of points used for plotting the fit.
#' @param band controls the confidence band. May be `TRUE`,
#'   `FALSE`, `NULL`, `NA`, or a named list. The confidence
#'   level is specified via `conf.level`, all other elements are graphical
#'   parameters of the band. Default is `list(conf.level = 0.95)`.
#' @param \dots further graphical parameters passed to [lines()] for the
#'   smoother.
#'
#' @return No return value (invisible `NULL`), called for its side effect of
#' adding the smoother and its confidence band to the current plot.
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
#'   band = list(
#'     conf.level = 0.99,
#'     col = addOpacity("red", 0.4),
#'     border = "black"
#'   )
#' )
#'
#' @seealso [loess()], [scatter.smooth()],
#'   [smooth.spline()]
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
    band = list(conf.level = 0.95),
    ...
) {
  
  col <- if (identical(col, .useTheme)) getTheme()$twin[1] else col
  
  newx <- seq(
    from = min(x$x, na.rm = TRUE),
    to = max(x$x, na.rm = TRUE),
    length.out = n
  )
  
  # the band is computed only when it is drawn: with se = FALSE, predict()
  # returns a plain vector, and fit$fit in the band's defaults worked only
  # because callIf() leaves its defaults unevaluated for a suppressed band
  bandOn <- !isFALSE(band) && !is.null(band) && !bedrock::isNA(band)
  
  fit <- predict(x, newdata = newx, se = bandOn)
  
  if (bandOn) {
    
    conf.level <- (if (is.list(band)) band$conf.level) %||% 0.95
    z <- qnorm((1 - conf.level) / 2)
    
    bedrock::callIf(
      .drawBandCI,
      band,
      defaults = list(
        x  = newx,
        ci = cbind(fit$fit + fit$se.fit * z,
                   fit$fit - fit$se.fit * z),
        col = col
      ),
      forbidden = "conf.level",
      warn = FALSE
    )
    
    fit <- fit$fit
  }
  
  lines(
    x = newx,
    y = fit,
    col = col,
    lwd = lwd,
    lty = lty,
    type = type,
    ...
  )
  
  invisible(NULL)
}
