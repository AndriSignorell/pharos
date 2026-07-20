
#' Split a String into a Number of Sections of Defined Length 
#' 
#' Splitting a string into a number of sections of defined length is needed,
#' when we want to split a table given as a number of lines without separator
#' into columns. The cutting points can either be defined by the lengths of the
#' sections or directly by position. 
#' 
#' If length is going over the end of the string the last part will be
#' returned, so if the rest of the string is needed, it's possible to simply
#' enter a big number as last partlength.
#' 
#' \code{len} and \code{pos} can't be defined simultaneously, only
#' alternatively.
#' 
#' Typical usages are \preformatted{ strChop(x, len) strChop(x, pos) } 
#' 
#' @param x the string to be cut in pieces
#' @param len a vector with the lengths of the pieces
#' @param pos a vector of cutting positions. Will be ignored when \code{len}
#' has been defined.
#' @return a vector with the parts of the string.
#' @seealso \code{\link{strLeft}},
#' \code{\link{substr}}

#' @examples
#' 
#' x <- paste(letters, collapse="")
#' strChop(x=x, len = c(3,5,2))
#' 
#' # and with the rest integrated
#' strChop(x=x, len = c(3, 5, 2, nchar(x)))
#' 
#' # cutpoints at 5th and 10th position
#' strChop(x=x, pos=c(5, 10))
#' 



#' @seealso
#' [string-overview] for an overview of all string utilities in pharos.
#'
#' @concept string-manipulation
#' @concept reshape
#'
#'
#' @export
strChop <- function(x, len = NULL, pos = NULL) {
  
  if (!is.null(len) && !is.null(pos)) {
    stop("Specify either 'len' or 'pos', not both")
  }
  
  chop_one <- function(xi) {
    
    if (!is.null(len)) {
      cuts <- cumsum(len)
    } else {
      cuts <- pos
    }
    
    starts <- c(1, cuts + 1)
    ends <- c(cuts, stringi::stri_length(xi))
    
    keep <- starts <= ends
    
    starts <- starts[keep]
    ends   <- ends[keep]
    
    stringi::stri_sub(xi, starts, ends)
  }
  
  res <- lapply(x, chop_one)
  
  if (length(x) == 1) res[[1]] else res
}


