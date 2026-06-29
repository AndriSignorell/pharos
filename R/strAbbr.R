
#' Abbreviate Strings Uniquely
#'
#' Creates abbreviations of character strings such that they remain
#' distinguishable within the input vector.
#'
#' @param x A character vector.
#' @param minchar Integer; minimum number of characters to retain.
#' @param method Character string specifying the abbreviation strategy:
#' \itemize{
#'   \item \code{"left"}: abbreviate each string individually to the shortest
#'     unique prefix
#'   \item \code{"fix"}: use a common prefix length for all strings such that
#'     they are distinguishable
#' }
#'
#' @return A character vector of abbreviated strings.
#'
#' @details
#' The function ensures that abbreviations are unique (within the given
#' vector) while respecting the minimum length \code{minchar}.
#'
#' For \code{method = "left"}, each string is shortened individually to the
#' shortest prefix that distinguishes it from all others.
#'
#' For \code{method = "fix"}, a single prefix length is chosen such that all
#' strings are distinguishable.
#'
#' Unicode-aware substring operations are performed using the \pkg{stringi}
#' package.
#'
#' @seealso \code{\link[stringi]{stri_sub}},
#'   \code{\link[stringi]{stri_length}}
#'
#' @examples
#' x <- c("apple", "apricot", "banana")
#'
#' # individual minimal abbreviations
#' strAbbr(x, method = "left")
#'
#' # fixed length abbreviations
#' strAbbr(x, method = "fix")
#'





#' @family string  
#' @concept string-manipulation
#'
#'
#' @export
strAbbr <- function(x,
                    minchar = 1,
                    method = c("left", "fix")) {
  
  method <- match.arg(method)
  
  nlen <- stringi::stri_length(x)
  
  if (method == "left") {
    
    idx <- rep(minchar, length(x))
    maxlen <- max(nlen, na.rm = TRUE)
    
    repeat {
      abbr <- stringi::stri_sub(x, 1, idx)
      dup <- duplicated(abbr) | duplicated(abbr, fromLast = TRUE)
      if (!any(dup))
        break
      
      idx[dup] <- pmin(idx[dup] + 1L, nlen[dup])
      
      # stop if no further refinement possible
      if (all(idx >= nlen))
        break
    }
    
    res <- stringi::stri_sub(x, 1, idx)
    
  } else {
    
    i <- minchar
    while (sum(duplicated(stringi::stri_sub(x, 1, i))) > 0) {
      i <- i + 1
    }
    
    res <- stringi::stri_sub(x, 1, pmax(minchar, i))
  }
  
  res
  
}

