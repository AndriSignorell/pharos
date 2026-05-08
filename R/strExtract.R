
#' Extract First Match from Strings
#'
#' Extracts the first substring matching a regular expression from each
#' element of a character vector.
#'
#' @param x A character vector.
#' @param pattern A character string containing a regular expression to match.
#' @param ... Additional arguments passed to
#'   \code{\link[stringi]{stri_extract_first_regex}}.
#'
#' @return A character vector containing the first match for each element of
#'   \code{x}. If no match is found, \code{NA} is returned.
#'
#' @details
#' This function is a thin wrapper around
#' \code{\link[stringi]{stri_extract_first_regex}} providing a simplified
#' interface for extracting the first match of a pattern.
#'
#' @seealso \code{\link[stringi]{stri_extract_first_regex}},
#'   \code{\link{strExtractBetween}}
#'
#' @examples
#' x <- c("abc123", "no digits", "456xyz")
#'
#' # extract first number
#' strExtract(x, "\\d+")
#'
#' # extract words
#' strExtract("hello world", "\\w+")
#'



#' @family string.manipulation
#' @concept string-manipulation
#' @concept data-manipulation
#'
#'
#' @export
strExtract <- function(x, pattern, ...) {
  
  res <- stringi::stri_extract_first_regex(x, pattern, ...)
  
  res[is.na(res)] <- NA_character_
  res
}
