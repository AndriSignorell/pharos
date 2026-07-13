
#' Place a Break Mark on an Axis
#' 
#' Places a break mark on an axis on an existing plot.
#' 
#' The \samp{pos} argument is not needed unless the user has specified a
#' different position from the default for the axis to be broken.
#' 
#' @param axis which axis to break
#' @param breakpos where to place the break in user units
#' @param pos position of the axis (see \link{axis})
#' @param bgcol the color of the plot background
#' @param breakcol the color of the "break" marker
#' @param style either \samp{gap}, \samp{slash} or \samp{zigzag}
#' @param brw break width relative to plot width
#' 
#' @note There is some controversy about the propriety of using discontinuous
#' coordinates for plotting, and thus axis breaks. Discontinuous coordinates
#' allow widely separated groups of values or outliers to appear without
#' devoting too much of the plot to empty space. \cr The major objection seems
#' to be that the reader will be misled by assuming continuous coordinates.
#' The \samp{gap} style that clearly separates the two sections of the plot is
#' probably best for avoiding this.
#' @note Based on code by Jim Lemon and Ben Bolker, adapted to conform to package
#' standards
#'  
#' @examples
#' 
#' plot(3:10, main="Axis break test")
#' 
#' # put a break at the default axis and position
#' axisBreak()
#' axisBreak(2, 2.9, style="zigzag")
#' 
#' @family graphics.layout
#' @concept annotation
#' @concept label
#'
#'
#' @export
axisBreak <- function (axis = 1, breakpos = NULL, pos = NA, bgcol = "white",
                       breakcol = "black", style = "slash", brw = 0.02) {
  
  figxy <- par("usr")
  xaxl <- par("xlog")
  yaxl <- par("ylog")
  xw <- (figxy[2] - figxy[1]) * brw
  yw <- (figxy[4] - figxy[3]) * brw
  if (!is.na(pos))
    figxy <- rep(pos, 4)
  if (is.null(breakpos))
    breakpos <- ifelse(axis%%2, figxy[1] + xw * 2, figxy[3] +
                         yw * 2)
  if (xaxl && (axis == 1 || axis == 3))
    breakpos <- log10(breakpos)
  if (yaxl && (axis == 2 || axis == 4))
    breakpos <- log10(breakpos)
  switch(axis, br <- c(breakpos - xw/2, figxy[3] - yw/2, breakpos +
                         xw/2, figxy[3] + yw/2), br <- c(figxy[1] - xw/2, breakpos -
                                                           yw/2, figxy[1] + xw/2, breakpos + yw/2), br <- c(breakpos -
                                                                                                              xw/2, figxy[4] - yw/2, breakpos + xw/2, figxy[4] + yw/2),
         br <- c(figxy[2] - xw/2, breakpos - yw/2, figxy[2] +
                   xw/2, breakpos + yw/2), stop("Improper axis specification."))
  old.xpd <- par("xpd")
  par(xpd = TRUE)
  if (xaxl)
    br[c(1, 3)] <- 10^br[c(1, 3)]
  if (yaxl)
    br[c(2, 4)] <- 10^br[c(2, 4)]
  if (style == "gap") {
    if (xaxl) {
      figxy[1] <- 10^figxy[1]
      figxy[2] <- 10^figxy[2]
    }
    if (yaxl) {
      figxy[3] <- 10^figxy[3]
      figxy[4] <- 10^figxy[4]
    }
    if (axis == 1 || axis == 3) {
      rect(breakpos, figxy[3], breakpos + xw, figxy[4],
           col = bgcol, border = bgcol)
      xbegin <- c(breakpos, breakpos + xw)
      ybegin <- c(figxy[3], figxy[3])
      xend <- c(breakpos, breakpos + xw)
      yend <- c(figxy[4], figxy[4])
      if (xaxl) {
        xbegin <- 10^xbegin
        xend <- 10^xend
      }
    }
    else {
      rect(figxy[1], breakpos, figxy[2], breakpos + yw,
           col = bgcol, border = bgcol)
      xbegin <- c(figxy[1], figxy[1])
      ybegin <- c(breakpos, breakpos + yw)
      xend <- c(figxy[2], figxy[2])
      yend <- c(breakpos, breakpos + yw)
      if (xaxl) {
        xbegin <- 10^xbegin
        xend <- 10^xend
      }
    }
    par(xpd = TRUE)
  }
  else {
    rect(br[1], br[2], br[3], br[4], col = bgcol, border = bgcol)
    if (style == "slash") {
      if (axis == 1 || axis == 3) {
        xbegin <- c(breakpos - xw, breakpos)
        xend <- c(breakpos, breakpos + xw)
        ybegin <- c(br[2], br[2])
        yend <- c(br[4], br[4])
        if (xaxl) {
          xbegin <- 10^xbegin
          xend <- 10^xend
        }
      }
      else {
        xbegin <- c(br[1], br[1])
        xend <- c(br[3], br[3])
        ybegin <- c(breakpos - yw, breakpos)
        yend <- c(breakpos, breakpos + yw)
        if (yaxl) {
          ybegin <- 10^ybegin
          yend <- 10^yend
        }
      }
    }
    else {
      if (axis == 1 || axis == 3) {
        xbegin <- c(breakpos - xw/2, breakpos - xw/4,
                    breakpos + xw/4)
        xend <- c(breakpos - xw/4, breakpos + xw/4, breakpos +
                    xw/2)
        ybegin <- c(ifelse(yaxl, 10^figxy[3 + (axis ==
                                                 3)], figxy[3 + (axis == 3)]), br[4], br[2])
        yend <- c(br[4], br[2], ifelse(yaxl, 10^figxy[3 +
                                                        (axis == 3)], figxy[3 + (axis == 3)]))
        if (xaxl) {
          xbegin <- 10^xbegin
          xend <- 10^xend
        }
      }
      else {
        xbegin <- c(ifelse(xaxl, 10^figxy[1 + (axis ==
                                                 4)], figxy[1 + (axis == 4)]), br[1], br[3])
        xend <- c(br[1], br[3], ifelse(xaxl, 10^figxy[1 +
                                                        (axis == 4)], figxy[1 + (axis == 4)]))
        ybegin <- c(breakpos - yw/2, breakpos - yw/4,
                    breakpos + yw/4)
        yend <- c(breakpos - yw/4, breakpos + yw/4, breakpos +
                    yw/2)
        if (yaxl) {
          ybegin <- 10^ybegin
          yend <- 10^yend
        }
      }
    }
  }
  segments(xbegin, ybegin, xend, yend, col = breakcol, lty = 1)
  par(xpd = FALSE)
}

