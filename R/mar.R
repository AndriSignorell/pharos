
#' Get or set plot margins conveniently
#'
#' Convenience wrapper around [graphics::par()] for getting and setting
#' plot margins (`mar`) or outer margins (`oma`). Individual sides can
#' be modified without affecting the others.
#'
#' @param bottom,left,top,right numeric scalars specifying the margin size
#'   (in lines) for each side. If `NULL`, the current value is retained.
#' @param outer logical; if `TRUE`, outer margins (`oma`) are used
#'   instead of inner margins (`mar`).
#'
#' @return
#' If no arguments are provided, returns the current margin vector (numeric of length 4).
#' Otherwise, sets the margins and returns the new values invisibly.
#'
#' @details
#' This function simplifies partial updates of `par("mar")` or `par("oma")`.
#' It avoids the need to manually query and reconstruct the full margin vector.
#'
#' For restoring graphical parameters, the recommended base R approach is:
#' \preformatted{
#' op <- par(no.readonly = TRUE)
#' on.exit(par(op))
#' }
#'
#' @examples
#' # Get current margins
#' mar()
#'
#' # Set bottom margin only
#' mar(bottom = 2)
#'
#' # Set multiple margins
#' mar(bottom = 2, left = 2)
#'
#' # Modify outer margins
#' mar(top = 1, outer = TRUE)
#'
#' @family graphics.layout
#' @concept geometry
#' @concept numerical-methods
#'
#'
#' @export
mar <- function(bottom = NULL, left = NULL, top = NULL, right = NULL,
                outer = FALSE) {
  
  .checkNumeric(bottom, "bottom")
  .checkNumeric(left,   "left")
  .checkNumeric(top,    "top")
  .checkNumeric(right,  "right")
  
  param <- if (outer) "oma" else "mar"
  
  inputs <- list(bottom, left, top, right)
  
  # --- return current margins if nothing specified ---
  if (all(vapply(inputs, is.null, logical(1)))) {
    return(par(param))
  }
  
  current <- par(param)
  
  # --- update only specified margins ---
  new <- mapply(function(x, cur) if (is.null(x)) cur else x,
                inputs, current,
                USE.NAMES = FALSE)
  
  par(setNames(list(new), param))
  
  invisible(new)
}



# == internal helper functions ===============================================


# input validation ---

.checkNumeric <- function(x, name) {
  if (!is.null(x) && (!is.numeric(x) || length(x) != 1 || is.na(x))) {
    stop(sprintf("'%s' must be a non-missing numeric scalar", name), call. = FALSE)
  }
}



