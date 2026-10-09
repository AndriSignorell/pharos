
#' Flat Contingency Table for tapply-Like Lists
#'
#' Creates a flat contingency table from a list array, such as the result of
#' [tapply()] when the applied function returns a named vector.
#'
#' Each list element is expanded into an additional dimension corresponding to
#' the names of the returned vector. The resulting array is then passed to
#' [ftable()].
#'
#' This is particularly useful for displaying multi-dimensional summaries such
#' as confidence intervals returned by `meanCI()`, where each cell contains
#' several statistics (e.g. estimate, lower CI, upper CI).
#'
#' @param x A list with a `dim` attribute, typically produced by
#'   [tapply()]. Each element must be a vector of equal length and
#'   have identical names.
#' @param row.vars row variables passed to [ftable()].
#'   Defaults to all dimensions except those specified in `col.vars`.
#' @param col.vars column variables passed to [ftable()].
#'   Defaults to the dimension created from the names of the list elements.
#' @param ... further arguments passed to [ftable()].
#'
#' @details
#' The names of the vectors stored in the list elements become an additional
#' dimension of the resulting array. By default, this new dimension is shown
#' in the columns of the flat contingency table.
#'
#' @return
#' An object of class `"ftable"`.
#'
#' @examples
#' # a function returning a named vector, here the mean and its
#' # confidence interval (as e.g. lumen::meanCI() returns them)
#' meanCI <- function(z) {
#'   ci <- t.test(z)$conf.int
#'   c(est = mean(z), lci = ci[1], uci = ci[2])
#' }
#'
#' x <- with(
#'   warpbreaks,
#'   tapply(
#'     breaks,
#'     list(wool, tension),
#'     meanCI
#'   )
#' )
#'
#' # the statistics form the columns
#' ftable(x)
#'
#' # the second grouping variable in the columns as well
#' ftable(
#'   x,
#'   row.vars = 2,
#'   col.vars = c(3, 1)
#' )
#'
#' @seealso
#' [tapply()],
#' [ftable()]
#'



#' @family tables  
#' @concept frequency-table
#'
#'
#' @export
ftable.list <- function(x, row.vars = NULL, col.vars = NULL, ...) {
  
  if (is.null(dim(x)))
    stop("'x' must be a list with a 'dim' attribute (e.g. from tapply)")
  
  dm  <- dim(x)
  dn  <- dimnames(x)
  
  # Elemente aufdröseln: jedes Element ist ein benannter Vektor
  inner_names <- names(x[[1]])
  n_inner     <- length(inner_names)
  
  # Array: dim = c(inner, dim(x))
  arr <- array(
    unlist(x),
    dim      = c(n_inner, dm),
    dimnames = c(list(inner_names), dn)
  )
  
  # defaults: inner dimension als Spalten, rest als Zeilen
  if (is.null(col.vars)) col.vars <- 1
  if (is.null(row.vars)) row.vars <- seq_along(dim(arr))[-col.vars]
  
  ftable(arr, row.vars = row.vars, col.vars = col.vars, ...)
}

