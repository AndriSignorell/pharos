

#' Extract Substrings Between Patterns
#'
#' Extracts substrings that occur between two delimiters.
#'
#' @param x A character vector.
#' @param left A character string or regular expression marking the left
#'   boundary.
#' @param right A character string or regular expression marking the right
#'   boundary.
#' @param greedy Logical; if \code{TRUE}, the match is greedy (longest match).
#'   If \code{FALSE} (default), the match is non-greedy (shortest match).
#'
#' @return A character vector containing the extracted substrings. If no match
#'   is found, \code{NA} is returned for that element.
#'
#' @details
#' The function uses regular expressions to extract the first substring
#' between \code{left} and \code{right}. Internally, it constructs a pattern
#' of the form:
#' \itemize{
#'   \item greedy: \code{left (.*) right}
#'   \item non-greedy: \code{left (.*?) right}
#' }
#'
#' Extraction is performed using \code{\link[stringi]{stri_match_first_regex}},
#' which returns the first captured group.
#'
#' @seealso \code{\link[stringi]{stri_match_first_regex}},
#'   \code{\link{strExtract}}
#'
#' @examples
#' x <- c("a[123]b", "x[abc]y", "no match")
#'
#' # non-greedy (default)
#' strExtractBetween(x, "\\[", "\\]")
#'
#' # greedy
#' strExtractBetween("a[1]b[2]c", "\\[", "\\]", greedy = TRUE)
#'
#' @family topic.text
#' @concept string-processing
#' @concept regular expressions
#'


#' @export
strExtractBetween <- function(x, left, right, greedy = FALSE) {
  
  pattern <- if (greedy) {
    paste0(left, "(.*)", right)
  } else {
    paste0(left, "(.*?)", right)
  }
  
  res <- stringi::stri_match_first_regex(x, pattern)[,2]
  
  res[is.na(res)] <- NA_character_
  res
}