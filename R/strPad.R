
#' Pad a String With Justification
#' 
#' \code{strPad} will fill a string x with defined characters to fit a given
#' length.
#' 
#' If a string x has more characters than width, it will be chopped on the
#' length of width.
#' 
#' @param x a vector of strings to be padded.
#' @param width resulting width of padded string. If x is a vector and width is
#' left to NULL, it will be set to the length of the largest string in x.
#' @param pad string to pad with. Will be repeated as often as necessary.
#' Default is " ".
#' @param adj adjustement of the old string, one of \code{"left"},
#' \code{"right"}, \code{"center"}. If set to \code{"left"} the old string will
#' be adjusted on the left and the new characters will be filled in on the
#' right side.
#' @return the string
#' 
#' @examples
#' 
#' strPad("My string", 25, "XoX", "center")
#'  # [1] "XoXXoXXoMy stringXXoXXoXX"
#' 


#' @family string.format
#' @concept string-formatting
#' @concept string-manipulation
#'
#'
#' @export
strPad <- function(x, width = NULL, pad = " ", adj = "left") {
  
  adj <- match.arg(adj, c("left", "right", "center"))
  
  if (is.null(width)) {
    width <- max(stringi::stri_length(x), na.rm = TRUE)
  }
  
  n <- stringi::stri_length(x)
  free <- pmax(0, width - n)
  
  make_pad <- function(npad) {
    if (npad == 0) return("")
    stringi::stri_sub(
      paste(rep(pad, ceiling(npad / stringi::stri_length(pad))), collapse = ""),
      1, npad
    )
  }
  
  left_pad  <- sapply(free %/% 2, make_pad)
  right_pad <- sapply(free - free %/% 2, make_pad)
  
  if (adj == "left") {
    res <- paste0(x, sapply(free, make_pad))
  } else if (adj == "right") {
    res <- paste0(sapply(free, make_pad), x)
  } else {
    res <- paste0(left_pad, x, right_pad)
  }
  
  res
}




