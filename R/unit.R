#' Get or Set Unit Attribute
#'
#' Retrieves or assigns a unit attribute to an R object.
#'
#' The unit is stored as a simple character string in the `"unit"` attribute.
#' This provides a lightweight mechanism for attaching unit metadata to objects,
#' without enforcing any automatic conversion or validation.
#'
#' @param x An R object.
#' @param value A single character string specifying the unit, or \code{NULL}
#'   to remove the unit attribute.
#'
#' @details
#' The setter does not validate whether the unit is physically meaningful.
#' Validation and conversion should be handled externally (e.g., via
#' a unit conversion engine such as \code{ConvUnit7}).
#'
#' Assigning \code{NULL} removes the unit attribute.
#'
#' @return
#' \itemize{
#'   \item \code{unit(x)} returns the unit as a character string or \code{NULL}.
#'   \item \code{unit(x) <- value} returns \code{x} with updated unit attribute.
#' }
#'
#' @examples
#' x <- 10
#' unit(x) <- "m"
#' unit(x)
#'
#' y <- 5
#' unit(y) <- "kg"
#'
#' # remove unit
#' unit(y) <- NULL
#'
#' @name unit

#' @family graphics.utils  
#' @concept annotation
#'
#'
#' @export
unit <- function(x) {
  attr(x, "unit", exact = TRUE)
}


#' @rdname unit
#' @export
`unit<-` <- function(x, value) {
  
  if (!is.null(value) && (!is.character(value) || length(value) != 1L)) {
    stop("value must be a single character string or NULL")
  }
  
  attr(x, "unit") <- value
  
  if (!is.null(value))
    class(x) <- unique(c("Unit", class(x)))
  
  x
}


#' Print Object with Unit
#'
#' S3 method for printing objects with a \code{"Unit"} class.
#' Displays the value along with its associated unit.
#'
#' @param x An object with class \code{"Unit"}.
#' @param ... Additional arguments passed to \code{print()}.
#'
#' @return Invisibly returns \code{x}.
#'
#' @examples
#' x <- 10
#' unit(x) <- "m"
#' class(x) <- "Unit"
#' print(x)
#'

#' @export
print.Unit <- function(x, ...) {
  cat(x, "[", unit(x), "]\n")
  invisible(x)
}

