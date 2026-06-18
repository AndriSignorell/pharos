
#' HTML notation for hat and bar diacritics
#'
#' Append the HTML entity for a circumflex (\dQuote{hat}, as in an
#' estimator \eqn{\hat{x}}) or macron (\dQuote{bar}, as in a sample mean
#' \eqn{\bar{x}}) to a label.
#'
#' @param x a character vector, typically a variable name or symbol
#'
#' @return a character vector with the diacritic's HTML entity appended
#'
#' @examples
#' htmlHat("p")  # -> "p&#770;"   (renders as p with a circumflex)
#' htmlBar("x")  # -> "x&#772;"   (renders as x with a macron)
#'
#' @name notation
NULL

#' @rdname notation
#' @export
htmlHat <- function(x) {
  gettextf("%s&#770;", x)
}

#' @rdname notation
#' @export
htmlBar <- function(x) {
  gettextf("%s&#772;", x)
}


#' Subscript notation
#'
#' Infix operator producing an HTML subscript, e.g. for indexed symbols
#' such as \eqn{x_i}.
#'
#' @param x a character vector (the base symbol)
#' @param i a character vector (the subscript), recycled against \code{x}
#'
#' @return a character vector: \code{x} followed by \verb{<sub>i</sub>}
#'
#' @examples
#' "x" %_% "i"  # -> "x<sub>i</sub>"
#'
#' @export
`%_%` <- function(x, i) {
  gettextf("%s<sub>%s</sub>", x, i)
}
