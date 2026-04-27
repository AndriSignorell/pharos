

#' Capitalize Strings
#'
#' Capitalizes character strings in different ways: first letter,
#' each word, or title case.
#'
#' @param x A character vector.
#' @param method Character string specifying the capitalization method:
#' \itemize{
#'   \item \code{"first"}: capitalize the first letter of the string
#'   \item \code{"word"}: capitalize the first letter of each word
#'   \item \code{"title"}: title case, excluding common stopwords
#' }
#'
#' @return A character vector with capitalized strings.
#'
#' @details
#' The function uses Unicode-aware transformations from the
#' \pkg{stringi} package.
#'
#' For \code{method = "title"}, common stopwords (e.g., \code{"a"},
#' \code{"the"}, \code{"of"}) remain lowercase unless they appear
#' as part of another word.
#'
#' @seealso \code{\link[stringi]{stri_trans_totitle}},
#'   \code{\link[stringi]{stri_split_boundaries}}
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
#' @family topic.text
#' @concept string-processing
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
      w[w %notin% low] <- stringi::stri_trans_totitle(w[w %notin% low])
      paste(w, collapse = "")
    })
  }
  
  res[na] <- NA_character_
  res
}