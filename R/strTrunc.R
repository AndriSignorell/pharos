
#' Truncate Strings and Add Ellipses If a String is Truncated.
#' 
#' Truncates one or more strings to a specified length, adding an ellipsis
#' (...)  to those strings that have been truncated. The truncation can also be
#' performed using word boundaries.  Use [strAlign()] to justify
#' the strings if needed.
#' 
#' 
#' @param x a vector of strings
#' @param maxLen the maximum length of the returned strings (NOT counting the
#' appended ellipsis). `maxLen` is recycled.
#' @param ellipsis the string to be appended, if the string is longer than the
#' given maximal length. The default is `"..."`.
#' @param wordBound logical. Determines if the maximal length should be reduced to
#' the next smaller word boundary and so words are not chopped. Default is
#' `FALSE`.
#' @return The string(s) passed as \samp{x} now with a maximum length of
#' \samp{maxLen} + 3 (for the ellipsis).
#' 
#' @seealso [strAlign()], [strPad()]
#' 
#' @examples
#' 
#' x <- c("this is short", "and this is a longer text", 
#'        "whereas this is a much longer story, which could not be told shorter")
#' 
#' # simple truncation on 10 characters
#' strTrunc(x, maxLen=10)
#' 
#' # NAs remain NA
#' strTrunc(c(x, NA_character_), maxLen=15, wordBound=TRUE)
#' 
#' # using word boundaries
#' for(i in 0:20)
#'   print(strTrunc(x, maxLen=i, wordBound=TRUE))
#' 
#' # compare
#' for(i in 0:20)
#'   print(strTrunc(x, maxLen=i, wordBound=FALSE))
#' 




#' @seealso
#' [string-overview] for an overview of all string utilities in pharos.
#'
#' @concept string-manipulation
#' @concept formatting
#'
#'
#' @export
strTrunc <- function(x,
                     maxLen = 20,
                     ellipsis = "...",
                     wordBound = FALSE) {
  
  if (any(maxLen < 0, na.rm = TRUE)) {
    stop("'maxLen' must be >= 0")
  }
  
  valid <- !is.na(x)
  
  x2 <- x
  x2[!valid] <- ""
  
  maxLen <- rep(maxLen, length.out = length(x2))
  
  if (wordBound) {
    
    x2 <- stringi::stri_extract_first_regex(
      x2,
      paste0("^.{0,", maxLen, "}(?=\\b)")
    )
    
    # remove trailing whitespace before adding ellipsis
    x2 <- stringi::stri_trim_right(x2)
    
  } else {
    
    x2 <- stringi::stri_sub(x2, 1, maxLen)
  }
  
  res <- ifelse(
    stringi::stri_length(x) > maxLen,
    paste0(x2, ellipsis),
    x2
  )
  
  res[!valid] <- NA_character_
  
  res
}


