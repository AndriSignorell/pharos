
#' Returns the Left Or the Right Part Of a String 
#' 
#' Returns the left part or the right part of a string. The number of
#' characters are defined by the argument \code{n}. If \code{n} is negative,
#' this number of characters will be cut off from the other side. 
#' 
#' The functions \code{strLeft} and \code{strRight} are simple wrappers to
#' \code{substr}.
#' 
#' @name strLeftRight
#' @aliases strRight strLeft
#' @param x a vector of strings
#' @param n a positive or a negative integer, the number of characters to cut.
#' If n is negative, this number of characters will be cut off from the right
#' with \code{strLeft} and from the left with \code{strRight}. \cr n will be
#' recycled. 
#' @return the left (right) n characters of x 
#' @examples
#' 
#' strLeft("Hello world!", n=5)
#' strLeft("Hello world!", n=-5)
#' 
#' strRight("Hello world!", n=6)
#' strRight("Hello world!", n=-6)
#' 
#' strLeft(c("Lorem", "ipsum", "dolor","sit","amet"), n=2)
#' 
#' strRight(c("Lorem", "ipsum", "dolor","sit","amet"), n=c(2,3))
#' 
#' 
#' 
#' @rdname strLeftRight
#' @seealso
#' [string-overview] for an overview of all string utilities in pharos.
#' @concept string-manipulation
#' @concept reshape
#'
#' @export
strLeft <- function(x, n) {
  n <- rep(n, length.out = length(x))
  
  mapply(function(xi, ni) {
    if (is.na(xi)) return(NA_character_)
    
    if (ni >= 0) {
      stringi::stri_sub(xi, 1, ni)
    } else {
      stringi::stri_sub(xi, 1, stringi::stri_length(xi) + ni)
    }
  }, x, n, USE.NAMES = FALSE)
}


#' @rdname strLeftRight
#' @export
strRight <- function(x, n) {
  n <- rep(n, length.out = length(x))
  
  mapply(function(xi, ni) {
    if (is.na(xi)) return(NA_character_)
    
    len <- stringi::stri_length(xi)
    
    if (ni >= 0) {
      stringi::stri_sub(xi, len - ni + 1, len)
    } else {
      stringi::stri_sub(xi, -ni + 1, len)
    }
  }, x, n, USE.NAMES = FALSE)
}



