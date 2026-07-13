#' Count Words in Strings
#'
#' Counts the number of words in each element of a character vector.
#'
#' @param x a character vector
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




#' @seealso
#' [string-overview] for an overview of all string utilities in lyra.
#'
#' @concept string-inspection
#' @concept summary
#'
#'
#' @export
strCountW <- function(x) {
  stringi::stri_count_words(x)
}

