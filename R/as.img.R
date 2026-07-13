
#' Embed a plot as an inline HTML image
#'
#' Evaluates a plotting expression in a temporary PNG device and returns
#' the resulting image as a self-contained, base64-encoded \verb{<img>}
#' tag (class \code{"html"}, see \code{\link{as.html}}) suitable for
#' embedding directly in HTML text.
#'
#' @param x a string containing a plotting expression, e.g.
#'   \code{"plot(1:10)"} -- evaluated via \code{eval(parse(text = x))}
#'   in the caller's environment
#' @param ... further arguments passed to \code{\link[grDevices]{png}}
#'   (e.g. \code{width}, \code{height})
#'
#' @return an object of class \code{"html"} containing an \verb{<img>}
#'   tag with a \code{data:image/png;base64,...} source
#'



#' @family html  
#' @concept html
#' @concept formatting
#'
#'
#' @export
as.img <- function(x, ...) {
  
  fn <- tempfile(fileext = ".png")
  on.exit(unlink(fn))
  
  grDevices::png(fn, ...)
  eval(parse(text = x), envir = parent.frame())
  grDevices::dev.off()
  
  as.html(gettextf('<img src="data:image/png;base64,%s">',
                   base64enc::base64encode(fn)))
}


