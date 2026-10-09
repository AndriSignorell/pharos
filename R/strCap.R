

#' Capitalize Strings
#'
#' Capitalizes character strings in different ways: first letter,
#' each word, or title case.
#'
#' @param x a character vector
#' @param method character string specifying the capitalization method:
#' \itemize{
#'   \item `"first"`: capitalize the first letter of the string
#'   \item `"word"`: capitalize the first letter of each word
#'   \item `"title"`: title case, excluding common stopwords
#' }
#'
#' @return A character vector with capitalized strings.
#'
#' @details
#' The function uses Unicode-aware transformations from the
#' \pkg{stringi} package.
#'
#' For `method = "title"`, common stopwords (e.g., `"a"`,
#' `"the"`, `"of"`) remain lowercase unless they appear
#' as part of another word.
#'
#' @seealso [stringi::stri_trans_totitle()],
#'   [stringi::stri_split_boundaries()]
#'
#' @examples
#' x <- c("hello world", "the lord of the rings")
#'
#' # first letter
#' strCap(x, "first")
#'
#' # each word
#' strCap(x, "word")
#'
#' # title case
#' strCap(x, "title")
#'


#' @seealso
#' [string-overview] for an overview of all string utilities in pharos.
#'
#' @concept string-manipulation
#' @concept formatting
#'
#'
#' @export
strCap <- function(x, method = c("first", "word", "title")) {
  
  method <- match.arg(method)
  na <- is.na(x)
  
  if (method == "first") {
    res <- stringi::stri_trans_totitle(x)
    
  } else if (method == "word") {
    res <- stringi::stri_trans_totitle(x)
    
  } else {
    low <- c("a","an","the","at","by","for","in","of","on","to","up","and","as","but","or","nor","s")
    
    words <- stringi::stri_split_boundaries(tolower(x), type = "word")
    
    res <- sapply(words, function(w) {
      up <- !w %in% low
      w[up] <- stringi::stri_trans_totitle(w[up])
      paste(w, collapse = "")
    })
  }
  
  res[na] <- NA_character_
  res
}
