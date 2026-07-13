
#' Equivalent Opaque Color for Transparent Color 
#' 
#' Determine the equivalent opaque RGB color for a given partially transparent
#' RGB color against a background of any color.  
#' 
#' Reducing the opacity against a white background is a good way to find usable
#' lighter and less saturated tints of a base color. For doing so, we sometimes
#' need to get the equivalent opaque color for the transparent color. 
#' 
#' @param col the color as hex value (use converters below if it's not
#' available). \code{col} and \code{opacity} are recycled. 
#' @param opacity the opacity value, if left to NULL the alpha channels of the
#' colors are used 
#' @param bg the background color to be used to calculate against (default is
#' "white") 
#' 
#' @return An named vector with the hexcodes of the opaque colors. 
#' 
#' @examples
#' 
#' cols <- c(addOpacity("limegreen", 0.4), 
#'           colToOpaque(colToHex("limegreen"), 0.4), 
#'           "limegreen")
#' barplot(c(1, 1.2, 1.3), col=cols, panel.first=abline(h=0.4, lwd=10, col="grey35"))
#' 
#' @family color.manipulation
#' @concept color
#' @concept transformation
#'
#'
#' @export
colToOpaque <- function(col, opacity=NULL, bg=NULL){
  
  # col is Hex color, opacity is numeric from 0..1
  
  # https://graphicdesign.stackexchange.com/questions/113007/how-to-determine-the-equivalent-opaque-rgb-color-for-a-given-partially-transpare
  # round(255 - opacity * (255-colToRgb(col)))
  if(is.null(bg))
    bg <- colToRGB("white")
  
  if(is.null(opacity)){
    # try to get the alpha channel from the color
    # this generates an incomprehensible error message, if there's no 4th dim:
    # Error in sapply(col, HexToRgb)[4, ] : subscript out of bounds
    opacity <- sapply(col, hexToRGB)[4,] / 255
    
  } else {
    opacity[na <- (opacity < 0 | opacity > 1)] <- NA
  }
  
  # recycle col and opacity
  lst <- recycle(rgb=lapply(col, hexToRGB), opacity=opacity)
  
  
  # algorithm:    res <- round(bg - opacity * (bg - col))
  
  res <- sapply(1:attr(lst, "maxdim"), function(i)
            # discard any alpha channel by only using rows 1:3
            round(bg - lst[["opacity"]][[i]] * (bg - lst[["rgb"]][[i]][1:3, ])))
  colnames(res) <- paste0(lapply(lst[["rgb"]], function(z) rgbToHex(z[1:3, ])), 
                      decToHex(round(lst[["opacity"]] * 255))) 
  
  res <- apply(res, 2, rgbToHex)
  
  return(res)
  
}


#' Fade Colors
#'
#' Apply transparency and remove the alpha channel afterwards.
#'
#' @inheritParams addOpacity
#'
#' @return Character vector of colors.
#'
#' @family color.manipulation
#' @concept color
#' @concept transformation
#'
#' @export
fade <- function(col, opacity = 0.5) {
  colToOpaque(addOpacity(col, opacity))
}


