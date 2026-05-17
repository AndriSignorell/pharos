
#' Mix Colors
#'
#' Mix two sets of colors in RGB space.
#'
#' @param col1 First vector of colors.
#' @param col2 Second vector of colors.
#' @param weight Numeric value between 0 and 1 specifying the
#'   contribution of \code{col2}. A value of 0 returns \code{col1},
#'   while 1 returns \code{col2}.
#'
#' @return Character vector of hexadecimal colors.
#'
#' @details
#' Colors are mixed linearly in RGB space:
#' \deqn{
#'   x_{mix} = (1 - weight) x_1 + weight x_2
#' }
#'
#' All arguments are recycled as necessary.
#'
#' @seealso
#' \code{\link{lighten}},
#' \code{\link{darken}}
#'
#' @family color.manipulation
#' @concept color-manipulation
#'
#' @export
mixColors <- function(col1, col2, weight = 0.5) {
  
  if (!is.numeric(weight) || length(weight) != 1L ||
      is.na(weight) || weight < 0 || weight > 1)
    stop("'weight' must be a number between 0 and 1.")
  
  n <- max(length(col1), length(col2))
  
  col1 <- rep(col1, length.out = n)
  col2 <- rep(col2, length.out = n)
  
  rgb1 <- col2rgb(col1)
  rgb2 <- col2rgb(col2)
  
  rgbMix <- (1 - weight) * rgb1 + weight * rgb2
  
  rgb(
    red   = rgbMix[1, ],
    green = rgbMix[2, ],
    blue  = rgbMix[3, ],
    maxColorValue = 255
  )
}

