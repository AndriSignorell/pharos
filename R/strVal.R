
#' Extract Numeric Values from Strings
#'
#' Extracts numeric values from character strings using regular expressions.
#' The function supports integers, decimal numbers, and scientific notation.
#'
#' @param x a character vector
#' @param collapse logical; if `TRUE`, all extracted numbers per element
#'   of `x` are concatenated into a single string. Otherwise, a list of
#'   character vectors is returned.
#' @param output character; controls the type of the returned values.
#'   `"character"` (default) returns strings; `"numeric"` coerces
#'   extracted values to numeric.
#' @param dec character; decimal separator used in the input. Defaults to
#'   `getOption("OutDec")`.
#'
#' @return
#' If `collapse = FALSE`, a list of character or numeric vectors
#' containing the extracted values for each element of `x`.
#' If `collapse = TRUE`, a character or numeric vector with
#' concatenated values per element.
#'
#' @details
#' The function detects numeric values including optional signs, decimal parts,
#' and scientific notation (e.g., `"1.23e-4"`).
#'
#' Whitespace between sign and number (e.g., `"- 2.5"`) is tolerated and
#' removed before returning results.
#'
#' If `output = "numeric"` and the decimal separator `dec` differs
#' from the current system setting (`getOption("OutDec")`), values are
#' converted accordingly before coercion.
#'
#' @seealso [as.numeric()], [stringi::stri_extract_all_regex()]
#'
#' @examples
#' x <- c("value = 12.5", "x = -3.2e2 and 7", "no numbers here")
#'
#' # extract as character
#' strVal(x)
#'
#' # extract as numeric
#' strVal(x, output = "numeric")
#'
#' # concatenate values
#' strVal(x, collapse = TRUE)
#'
#' # different decimal separator
#' strVal("value = 3,14", dec = ",", output = "numeric")
#'

#' @seealso
#' [string-overview] for an overview of all string utilities in pharos.
#'
#' @concept string-manipulation
#' @concept number-formatting
#' @concept pattern-matching
#'
#'
#' @export
strVal <- function(x,
                   collapse = FALSE,
                   output   = c("character", "numeric"),
                   dec      = getOption("OutDec")) {
  
  output <- match.arg(output)
  
  pat  <- paste0("([+-]\\s?)?\\d+(", ifelse(dec == ".", "\\.", dec), "\\d+)?([eE][+-]?\\d+)?")
  vals <- stringi::stri_extract_all_regex(x, pat)
  vals <- lapply(vals, function(v) stringi::stri_replace_all_fixed(v, " ", ""))
  
  if (output == "numeric" && dec != getOption("OutDec")) {
    vals <- lapply(vals, function(v)
      stringi::stri_replace_all_fixed(v, dec, getOption("OutDec")))
  }
  
  if (collapse) {
    vals <- sapply(vals, paste, collapse = "")
    if (output == "numeric")
      vals <- as.numeric(vals)
  } else {
    if (output == "numeric")
      vals <- lapply(vals, as.numeric)
  }
  
  vals
}


