#' Count Words in Strings
#'
#' Counts the number of words in each element of a character vector.
#'
#' @param x A character vector.
#'
#' @return An integer vector giving the number of words in each element of
#'   \code{x}.
#'
#' @details
#' Words are detected using Unicode-aware word boundaries as implemented in
#' \pkg{stringi}. This ensures robust handling of different languages,
#' punctuation, and whitespace.
#'
#' @seealso \code{\link[stringi]{stri_count_words}}
#'
#' @examples
#' strCountW("This is a sentence.")
#'
#' strCountW(c("One word", "Two words here", NA))
#'



#' @family string.manipulation
#' @concept string-manipulation
#' @concept data-inspection
#'
#'
#' @export
strCountW <- function(x) {
  stringi::stri_count_words(x)
}

