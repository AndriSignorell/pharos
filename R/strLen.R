
#' String length
#'
#' Intuitive alias for [nchar()].
#'
#' @param x a character vector
#' @param ... further arguments passed to `nchar`
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

