
#' Helsana Colors
#'
#' Retrieve one or more colors from the helsana palette.
#'
#' @param ... character strings naming the colors to retrieve. Valid names are:
#'   `"blue"`, `"red"`, `"orange"`, `"yellow"`,
#'   `"ecru"`, `"green"`, `"pink"`, `"moss"`,
#'   `"slate"`, `"sand"`, `"brown"`, `"plum"`.
#'   If none are provided, the full palette is returned.
#'
#' @return A named character vector of hex color codes.
#'


#' @examples
#' hcol("blue", "green")
#' hcol()


#' @family color.palettes
#' @concept color
#' @concept palette
#'
#'
#' @export
hcol <- function(...) {
  nms <- c(...)
  if (is.null(nms)) .pal_data$discrete$helsana
  else .pal_data$discrete$helsana[nms]
}

