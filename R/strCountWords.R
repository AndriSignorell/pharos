#' Count Words in Strings
#'
#' Counts the number of words in each element of a character vector.
#'
#' @param x a character vector
#'
#' @return An integer vector giving the number of words in each element of
#'   `x`.
#'
#' @details
#' Words are detected using Unicode-aware word boundaries as implemented in
#' \pkg{stringi}. This ensures robust handling of different languages,
#' punctuation, and whitespace.
#'
#' @seealso [stringi::stri_count_words()]
#'
#' @examples
#' strCountWords("This is a sentence.")
#'
#' strCountWords(c("One word", "Two words here", NA))
#'




#' @seealso
#' [string-overview] for an overview of all string utilities in pharos.
#'
#' @concept string-inspection
#' @concept summary
#'
#'
#' @export
strCountWords <- function(x) {
  stringi::stri_count_words(x)
}

