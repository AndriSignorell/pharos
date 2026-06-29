
#' Create a Line Separator String
#'
#' Generates a character string that can be used as a horizontal line
#' separator in console output.
#'
#' @param sep A character string used as separator. If \code{NULL},
#'   a default Unicode box-drawing character (\code{"\u2500"}) is used.
#'   If \code{sep} consists of a single visible character, it is
#'   repeated to match the current console width (minus two characters).
#'
#' @details
#' ANSI escape sequences (e.g., color codes) are removed using
#' \code{cli::ansi_strip()} when determining the visible width.
#'
#' The console width is determined via \code{getOption("width", 80)}.
#'
#' @return A character string representing a horizontal separator line.
#'
#' @examples
#' lineSep()
#' lineSep("-")
#' lineSep(cli::col_red("="))
#'



#' @family graphics.utils  
#' @concept annotation
#'
#'
#' @export
lineSep <- function(sep = .getOption("linesep")) {
  
  sep <- sep %||% "\u2500"
  
  visible <- nchar(cli::ansi_strip(sep))
  
  if (visible == 1) {
    width <- getOption("width", 80)
    sep <- strrep(sep, width - 2)
  }
  
  sep
  
}
