
#' Check if Character Strings Represent Numeric Values
#'
#' Determines whether elements of a character vector represent valid numeric values.
#' Unlike \code{as.numeric()}, this function performs a regex-based validation and
#' does not produce warnings.
#'
#' @param x A character vector to be tested.
#' @param scientific Logical; if \code{TRUE}, scientific notation (e.g., \code{"1e3"})
#'   is allowed. Defaults to \code{FALSE}.
#'
#' @return A logical vector of the same length as \code{x}, indicating whether each
#'   element represents a numeric value.
#'
#' @details
#' The function uses regular expressions via \pkg{stringi} to validate numeric formats.
#' Valid formats include optional leading sign (\code{+} or \code{-}), optional decimal
#' point, and digits. If \code{scientific = TRUE}, exponential notation using \code{e}
#' or \code{E} is also supported.
#'
#' Note that special values such as \code{"Inf"}, \code{"-Inf"}, and \code{"NaN"} are
#' not considered numeric by this function.
#'
#' @examples
#' x <- c("123", "-3.141", "1e3", "foo", "Inf")
#'
#' strIsNumeric(x)
#' strIsNumeric(x, scientific = TRUE)
#'
#' @seealso \code{\link{as.numeric}}
#' @family topic.text
#' @concept string-processing
#' 
#'


#' @importFrom stringi stri_detect_regex
#' @export
strIsNumeric <- function(x, scientific = FALSE) {
  if(scientific){
    stringi::stri_detect_regex(x, "^[+-]?([0-9]*\\.?[0-9]+)([eE][+-]?[0-9]+)?$")
  } else {
    stringi::stri_detect_regex(x, "^[+-]?[0-9]*\\.?[0-9]+$")
  }
}