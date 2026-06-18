
#' Mark a character vector as HTML
#'
#' Tags a character vector with the S3 class \code{"html"} so that it
#' prints via \code{\link{preview.html}} as readable text instead of as
#' a raw character vector.
#'
#' @param x a character vector, typically containing HTML markup
#'
#' @return \code{x}, with class \code{"html"} added
#'
#' @seealso \code{\link{preview.html}}, \code{\link{toHtmlTable}}
#'
#' @examples
#' as.html("<b>bold</b>")
#'
#' @export
as.html <- function(x) {
  structure(x, class = "html")
}


