
#' Convert Colors to grayScale
#'
#' Convert colors to grayScale using luminance weighting.
#'
#' @param col vector of valid R colors.
#'
#' @return Character vector of grayScale colors.
#'
#' @details
#' grayScale conversion uses the standard luminance approximation:
#' \deqn{0.3 R + 0.59 G + 0.11 B}
#' 
#' 
#' @examples
#' op <- par(no.readonly = TRUE)
#' par(mfcol=c(2,2))
#' 
#' tmp <- 1:3
#' names(tmp) <- c('red','green','blue')
#' 
#' barplot(tmp, col=c('red','green','blue'))
#' barplot(tmp, col=grayScale(c('red','green','blue')))
#' 
#' barplot(tmp, col=c('red','#008100','#3636ff'))
#' barplot(tmp, col=grayScale(c('red','#008100','#3636ff')))
#' 
#' par(op)
#' 
#' @seealso [color-conversion-overview]
#' @concept color  
#' @concept color-conversion
#'
#'
#' @export
grayScale <- function(col) {
  
  rgb <- col2rgb(col)
  g <- rbind(c(0.3, 0.59, 0.11)) %*% rgb
  
  rgb(g, g, g, maxColorValue = 255)
  
}


