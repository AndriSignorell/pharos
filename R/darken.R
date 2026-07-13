
#' Darken Colors
#'
#' Darken colors by mixing them with black.
#'
#' @param col Vector of valid R colors.
#' @param amount Numeric value between 0 and 1 specifying the
#'   amount of darkening. A value of 0 leaves the color unchanged,
#'   while 1 returns black.
#'
#' @return Character vector of hexadecimal colors.
#'
#' @details
#' Colors are mixed linearly with black in RGB space:
#' \deqn{
#'   x_{new} = x \\cdot (1 - amount)
#' }
#'



#' @family color.manipulation
#' @concept color
#'
#'
#' @export
darken <- function(col, amount = 0.2) {
  
  if (!is.numeric(amount) || length(amount) != 1L ||
      is.na(amount) || amount < 0 || amount > 1)
    stop("'amount' must be a number between 0 and 1.")
  
  rgb <- col2rgb(col)
  
  rgb <- rgb * (1 - amount)
  
  rgb(
    red   = rgb[1, ],
    green = rgb[2, ],
    blue  = rgb[3, ],
    maxColorValue = 255
  )
}


