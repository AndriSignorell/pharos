
#' Lighten Colors
#'
#' Lighten colors by mixing them with white.
#'
#' @param col vector of valid R colors.
#' @param amount numeric value between 0 and 1 specifying the
#'   amount of lightening. A value of 0 leaves the color unchanged,
#'   while 1 returns white.
#'
#' @return Character vector of hexadecimal colors.
#'
#' @details
#' Colors are mixed linearly with white in RGB space:
#' \deqn{
#'   x_{new} = x + amount \cdot (255 - x)
#' }
#'


#' @family color.manipulation
#' @concept color
#' @concept transformation
#'
#'
#' @export
lighten <- function(col, amount = 0.2) {
  
  if (!is.numeric(amount) || length(amount) != 1L ||
      is.na(amount) || amount < 0 || amount > 1)
    stop("'amount' must be a number between 0 and 1.")
  
  rgb <- col2rgb(col)
  
  rgb <- rgb + amount * (255 - rgb)
  
  rgb(
    red   = rgb[1, ],
    green = rgb[2, ],
    blue  = rgb[3, ],
    maxColorValue = 255
  )
}


