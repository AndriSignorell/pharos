
#' Date/Time/Directory Stamp the Current Plot
#' 
#' Stamp the current plot in the extreme lower right corner. A free text or
#' expression can be defined as text to the stamp.
#' 
#' The text can be freely defined as option. If user and date should be
#' included by default, the following option using an expression will help:
#' \preformatted{setDescToolsXOption(stamp=expression(gettextf('%s/%s',
#' Sys.getenv('USERNAME'), Today() )))}
#' 
#' For \R results may not be satisfactory if \code{par(mfrow=)} is in effect.
#' 
#' @param text Character string, expression, or toggle controlling the
#'   stamp text. \code{.useTheme} (default) or \code{TRUE} resolve to
#'   \code{getTheme()$stamp}, evaluated lazily at draw time. \code{FALSE},
#'   \code{NULL}, or \code{NA} suppress the stamp. Any other string or
#'   unevaluated \code{expression()} is used as given.
#' @param las orientation; see \code{\link[graphics]{par}}. \code{NULL}
#'   (default) inherits the current \code{par("las")}. \code{las = 3}
#'   places the stamp vertically along the right edge instead of
#'   horizontally along the bottom.
#' @param cex,col size and color of the stamp text.
#' 
#' @seealso \code{\link{text}}
#' @keywords aplot
#' @examples
#' 
#' plot(1:20)
#' stamp()




#'

#' @family graphics.utils  
#' @concept annotation
#'
#'
#' @export
stamp <- function(text = .useTheme, las = NULL, cex = 0.6, col = "grey40") {
  
  resolved <- if (identical(text, .useTheme) || isTRUE(text)) {
    
    themeStamp <- getTheme()$stamp
    if (isFALSE(themeStamp)) "" else eval(themeStamp)
    
  } else if (isFALSE(text) || is.null(text) ||
             (length(text) == 1L && !is.character(text) && !is.expression(text) &&
              isTRUE(suppressWarnings(is.na(text))))) {
    
    ""
    
  } else if (is.expression(text)) {
    
    eval(text)
    
  } else {
    
    text
  }
  
  if (!nzchar(resolved))
    return(invisible(""))
  
  ## handle las locally
  old_las <- par("las")
  if (is.null(las)) {
    las <- old_las
  } else {
    op_las <- par(las = las)
    on.exit(par(op_las), add = TRUE)
  }
  
  ## IMPORTANT: line is NEGATIVE for outer text
  line_pos <- -(0.3 + 1.4 * cex)
  
  if (las == 3) {
    ## vertical stamp (right bottom)
    mtext(
      paste0("  ", resolved),
      side  = 4,
      line  = line_pos,
      adj   = 0,
      srt   = 90,
      outer = TRUE,
      cex   = cex,
      col   = col
    )
    
  } else {
    ## horizontal stamp (bottom right)
    # las explicitly forced to 1 (always horizontal) here, regardless of
    # what 'las' value was requested - only las = 3 selects the dedicated
    # vertical branch above; any other value (0, 1, 2, or the ambient
    # par("las") this function just set via op_las) must not rotate this
    # mtext() call via inherited orientation.
    mtext(
      paste0(resolved, "  "),
      side  = 1,
      line  = line_pos,
      adj   = 1,
      las   = 1,
      outer = TRUE,
      cex   = cex,
      col   = col
    )
  }
  
  invisible(resolved)
}

