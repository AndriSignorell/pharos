
#' Embed a plot as an inline HTML image
#'
#' Evaluates a plotting expression in a temporary PNG device and returns
#' the resulting image as a self-contained, base64-encoded \verb{<img>}
#' tag (class `"html"`, see [asHtml()]), suitable for
#' embedding directly in HTML text -- a report, a question, an e-mail.
#'
#' The expression is passed unevaluated and carries its own environment, so
#' a plot built inside a function sees that function's local variables.
#' Several statements are given in braces, as in the examples below.
#'
#' @param expr a plotting expression, evaluated once inside the device.
#'   A character string is not accepted: pass the plotting code itself,
#'   e.g. `asImg(plot(1:10))` instead of `asImg("plot(1:10)")`.
#' @param width,height size of the device in pixels
#' @param res nominal resolution in dpi, which also scales the text: raise
#'   it for a larger picture with the same relative proportions
#' @param ... further arguments passed to [grDevices::png()]
#'
#' @return an object of class `c("html", "character")` containing an
#'   \verb{<img>} tag with a `data:image/png;base64,...` source
#'
#' @examples
#' img <- asImg(plot(1:10))
#'
#' # several statements, and local variables
#' f <- function(n) {
#'   x <- seq_len(n)
#'   asImg({
#'     plot(x, x^2, type = "b")
#'     abline(h = mean(x^2), lty = 2)
#'   })
#' }
#' substr(f(10), 1, 30)
#'
#' @family html
#' @concept html
#' @concept formatting
#'
#' @export
asImg <- function(expr, width = 520, height = 440, res = 96, ...) {

  fn <- tempfile(fileext = ".png")
  on.exit(unlink(fn), add = TRUE)

  grDevices::png(fn, width = width, height = height, res = res, ...)

  # The expression carries its own environment and is evaluated here, once;
  # the device is closed even when the plot fails, so that a broken
  # expression does not leave the session drawing into a dead file.
  # Code given as a string would have to be parsed and evaluated, which the
  # design rules exclude (§2.3); a string evaluates to itself and draws
  # nothing, so it is rejected instead of returning an empty image.
  tryCatch({
    if (is.character(expr))
      stop("'expr' must be plotting code, not a character string: ",
           "use asImg(plot(1:10)) instead of asImg(\"plot(1:10)\")",
           call. = FALSE)
  }, finally = grDevices::dev.off())

  asHtml(gettextf('<img src="data:image/png;base64,%s">', embedFile(fn)))
}
