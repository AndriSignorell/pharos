
#' Extract Numeric Values from Strings
#'
#' Extracts numeric values from character strings using regular expressions.
#' The function supports integers, decimal numbers, and scientific notation.
#'
#' @param x A character vector.
#' @param paste Logical; if \code{TRUE}, all extracted numbers per element of
#'   \code{x} are concatenated into a single string. Otherwise, a list of
#'   character vectors is returned.
#' @param as.numeric Logical; if \code{TRUE}, extracted values are converted
#'   to numeric.
#' @param dec Character; decimal separator used in the input. Defaults to
#'   \code{getOption("OutDec")}.
#'
#' @return
#' If \code{paste = FALSE}, a list of character vectors (or numeric vectors if
#' \code{as.numeric = TRUE}) containing the extracted values for each element
#' of \code{x}.  
#' If \code{paste = TRUE}, a character vector (or numeric vector if
#' \code{as.numeric = TRUE}) with concatenated values per element.
#'
#' @details
#' The function detects numeric values including optional signs, decimal parts,
#' and scientific notation (e.g., \code{"1.23e-4"}).
#'
#' Whitespace between sign and number (e.g., \code{"- 2.5"}) is tolerated and
#' removed before returning results.
#'
#' If \code{as.numeric = TRUE} and the decimal separator \code{dec} differs
#' from the current system setting (\code{getOption("OutDec")}), values are
#' converted accordingly before coercion.
#'
#' @seealso \code{\link{as.numeric}}, \code{\link[stringi]{stri_extract_all_regex}}
#'
#' @examples
#' x <- c("value = 12.5", "x = -3.2e2 and 7", "no numbers here")
#'
#' # extract as character
#' strVal(x)
#'
#' # extract as numeric
#' strVal(x, as.numeric = TRUE)
#'
#' # concatenate values
#' strVal(x, paste = TRUE)
#'
#' # different decimal separator
#' strVal("value = 3,14", dec = ",", as.numeric = TRUE)
#'

#' @family string.manipulation
#' @concept string-manipulation
#' @concept data-manipulation
#'
#'
#' @export
strVal <- function(x, paste = FALSE, as.numeric = FALSE, dec = getOption("OutDec")) {
  
  pat <- paste0("([+-]\\s?)?\\d+(", ifelse(dec==".", "\\.", dec), "\\d+)?([eE][+-]?\\d+)?")
  
  vals <- stringi::stri_extract_all_regex(x, pat)
  
  vals <- lapply(vals, function(v) stringi::stri_replace_all_fixed(v, " ", ""))
  
  if (paste) {
    vals <- sapply(vals, paste, collapse = "")
    
    if (as.numeric) {
      if (dec != getOption("OutDec")) {
        vals <- stringi::stri_replace_all_fixed(vals, dec, getOption("OutDec"))
      }
      vals <- as.numeric(vals)
    }
    
  } else {
    if (as.numeric) {
      vals <- lapply(vals, as.numeric)
    }
  }
  
  vals
}
