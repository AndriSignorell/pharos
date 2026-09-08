
#' Mark a character vector as HTML
#'
#' Tags a character vector with the S3 class `"html"` so that it
#' prints via [preview.html()] as readable text instead of as
#' a raw character vector.
#'
#' @param x a character vector, typically containing HTML markup
#'
#' @return `x`, with class `"html"` added
#'
#' @examples
#' as.html("<b>bold</b>")
#'
#' @family html  
#' @concept html
#' @concept formatting
#'
#'
#' @export
as.html <- function(x) {
  structure(x, class = "html")
}


