
#' Helsana Colors
#'
#' Retrieve one or more colors from the Helsana palette.
#'
#' @param ... Character strings naming the colors to retrieve. Valid names are:
#'   \code{"blue"}, \code{"red"}, \code{"orange"}, \code{"yellow"},
#'   \code{"ecru"}, \code{"green"}, \code{"pink"}, \code{"moss"},
#'   \code{"slate"}, \code{"sand"}, \code{"brown"}, \code{"plum"}.
#'   If none are provided, the full palette is returned.
#'
#' @return A named character vector of hex color codes.
#'


#' @examples
#' hcol("blue", "green")
#' hcol()

#' @export
hcol <- function(...) {
  nms <- c(...)
  if (is.null(nms)) .pal_data$discrete$Helsana
  else .pal_data$discrete$Helsana[nms]
}

