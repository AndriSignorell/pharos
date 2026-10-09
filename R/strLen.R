
#' String length
#'
#' Intuitive alias for [nchar()].
#'
#' @param x a character vector
#' @param ... further arguments passed to `nchar`
#'
#' @return An integer vector with the number of characters of the elements of
#' `x`, see [nchar()].
#'
#' @examples
#' strLen(c("pharos", "", NA))
#' strLen(month.name)
#'
#' # a number is converted to a string first
#' strLen(123456)
#'
#' @seealso [base::nchar()]
#'

#' @seealso
#' [string-overview] for an overview of all string utilities in pharos.
#'
#' @concept string-inspection
#' @concept summary
#'
#'
#' @export
strLen <- function(x, ...) nchar(x, ...)

