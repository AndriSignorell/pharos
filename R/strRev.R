
#' Reverse Strings
#'
#' Reverses each element of a character vector.
#'
#' @param x a character vector
#'
#' @return A character vector with each string reversed.
#'
#' @details
#' This function uses \code{\link[stringi]{stri_reverse}}, which correctly
#' handles Unicode characters and multi-byte encodings.
#'
#' @seealso \code{\link[stringi]{stri_reverse}}
#'
#' @examples
#' strRev("abc")
#'
#' strRev(c("hello", "world"))
#'
#' # Unicode-safe
#' strRev("äöü")
#'


#' @seealso
#' [string-overview] for an overview of all string utilities in lyra.
#'
#' @concept string-manipulation
#'
#'
#' @export
strRev <- function(x) {
  stringi::stri_reverse(x)
}

