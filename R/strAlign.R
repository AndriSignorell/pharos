

#' Align Strings
#'
#' Aligns a character vector to the left, right, center, or with respect
#' to the first occurrence of a specified separator.
#'
#' Alignment is achieved by padding strings with spaces so that all elements
#' have equal width. This is mainly useful for monospaced output.
#'
#' @param x A character vector.
#' @param sep A character specifying the alignment mode:
#' \itemize{
#'   \item \code{"\\l"}: left alignment
#'   \item \code{"\\r"}: right alignment (default)
#'   \item \code{"\\c"}: centered alignment
#'   \item any other character: align at the first occurrence of this separator
#' }
#'
#' @return A character vector of aligned strings.
#'
#' @details
#' For left, right, and center alignment, strings are padded to the maximum
#' width using spaces.
#'
#' If a separator is provided, strings are aligned such that the first
#' occurrence of the separator is vertically aligned. If a string does not
#' contain the separator, it is treated as if the separator occurred at the end.
#'
#' This function uses Unicode-aware string handling via the \pkg{stringi}
#' package.
#'
#' @seealso \code{\link[stringi]{stri_pad}},
#'   \code{\link[stringi]{stri_sub}},
#'   \code{\link[stringi]{stri_trim_right}}
#'
#' @examples
#' x <- c("here", "there", "everywhere")
#'
#' # right align (default)
#' strAlign(x)
#'
#' # left align
#' strAlign(x, "\\l")
#'
#' # center align
#' strAlign(x, "\\c")
#'
#' # align at decimal separator
#' z <- c("6.0", "45.12", "784")
#' strAlign(z, ".")
#'


#' @family string.format
#' @concept string-formatting
#' @concept graphics
#'
#'
#' @export
strAlign <- function(x, sep = "\\r") {
  
  id.na <- is.na(x)
  
  if (sep == "\\c") {
    return(stringi::stri_pad(x,
                             width = max(stringi::stri_length(x), na.rm = TRUE),
                             side = "both"))
  }
  
  x <- stringi::stri_pad(x,
                         width = max(stringi::stri_length(x), na.rm = TRUE))
  
  if (sep == "\\l") {
    return(stringi::stri_replace_first_regex(x, "^( +)(.+)", "$2$1"))
  }
  
  if (sep == "\\r") {
    return(stringi::stri_replace_first_regex(x, "(.+?)( +$)", "$2$1"))
  }
  
  pos <- stringi::stri_locate_first_fixed(x, sep)[,1]
  pos <- ifelse(is.na(pos), stringi::stri_length(x), pos)
  
  bef <- stringi::stri_sub(x, 1, pos)
  aft <- stringi::stri_sub(x, pos + 1)
  
  aft <- stringi::stri_trim_right(aft)
  
  res <- paste(
    stringi::stri_pad(bef, max(stringi::stri_length(bef), na.rm = TRUE), side = "left"),
    stringi::stri_pad(aft, max(stringi::stri_length(aft), na.rm = TRUE), side = "right"),
    sep = ""
  )
  
  res[id.na] <- NA
  res
}
