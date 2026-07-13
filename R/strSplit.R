
#' Split Strings
#'
#' Splits character vectors into substrings. This is a convenience wrapper
#' around \code{\link[stringi]{stri_split_fixed}} and
#' \code{\link[stringi]{stri_split_regex}} with simplified defaults.
#'
#' If the input \code{x} has length 1, the result is returned as a character
#' vector instead of a list for convenience.
#'
#' @param x a character vector to be split
#' @param split a character string specifying the delimiter (if
#'   \code{fixed = TRUE}) or a regular expression (if \code{fixed = FALSE})
#' @param fixed logical; if \code{TRUE}, \code{split} is treated as a fixed
#'   string. Otherwise, it is interpreted as a regular expression.
#'
#' @return A list of character vectors. If \code{x} has length 1, a character
#'   vector is returned.
#'
#' @details
#' This function provides a simplified interface to string splitting using
#' the \pkg{stringi} package. It avoids some of the complexity of
#' \code{\link[base]{strsplit}} while providing consistent and Unicode-aware
#' behavior.
#'
#' @seealso \code{\link[stringi]{stri_split_fixed}},
#' \code{\link[stringi]{stri_split_regex}}, \code{\link[base]{strsplit}}
#'
#' @examples
#' strSplit("a,b,c", ",", fixed = TRUE)
#'
#' strSplit(c("a b", "c d"), " ")
#'
#' # regex splitting
#' strSplit("a1b2c3", "\\d")
#'


#' @seealso
#' [string-overview] for an overview of all string utilities in lyra.
#'
#' @concept string-manipulation
#' @concept reshape
#' @concept pattern-matching
#'
#'
#' @export
strSplit <- function(x, split = "", fixed = FALSE) {
  
  if (fixed) {
    res <- stringi::stri_split_fixed(x, split)
  } else {
    res <- stringi::stri_split_regex(x, split)
  }
  
  if (length(res) == 1) res[[1]] else res
}
