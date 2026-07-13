
#' String length
#'
#' Intuitive alias for \code{\link{nchar}}.
#'
#' @param x a character vector
#' @param ... further arguments passed to \code{nchar}
#'
#' @seealso \code{\link[base]{nchar}}
#'

#' @seealso
#' [string-overview] for an overview of all string utilities in lyra.
#'
#' @concept string-inspection
#' @concept summary
#'
#'
#' @export
strLen <- function(x, ...) nchar(x, ...)

