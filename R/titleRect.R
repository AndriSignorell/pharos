
#' Plot Boxed Annotation 
#' 
#' The function can be used to add a title to a plot surrounded by a
#' rectangular box. This is useful for plotting several plots in narrow
#' distances. 
#' 
#' 
#' @param label the main title
#' @param bg the background color of the box.
#' @param border the border color of the box
#' @param col the font color of the title
#' @param xjust the x-justification of the text. This can be \code{c(0, 0.5,
#' 1)} for left, middle- and right alignement.
#' @param line on which MARgin line, starting at 0 counting outwards
#' @param \dots the dots are passed to the \code{\link{text}} function, which
#' can be used to change font and similar arguments.
#' 
#' @return nothing is returned
#' @seealso \code{\link{title}}
#' @keywords aplot
#' @examples
#' 
#' plot(pressure)
#' titleRect("pressure")
#' 

#' @family plot.annotation
#' @concept graphics
#' @concept string-formatting
#'
#'
#' @export
titleRect <- function(label, bg = "grey", border=1, 
                      col="black", xjust=0.5, line=2, ...){
  
  xpd <- par(xpd=TRUE); on.exit(par(xpd))
  
  usr <- par("usr")
  rect(xleft = usr[1], ybottom = usr[4], xright = usr[2], ytop = lineToUser(line,3),
       col="white", border = border)
  rect(xleft = usr[1], ybottom = usr[4], xright = usr[2], ytop = lineToUser(line,3),
       col=bg, border = border)
  
  if(xjust==0) {
    x <- usr[1]
  } else if(xjust==0.5) {
    x <- mean(usr[c(1,2)])
  } else {
    x <- usr[2]
  }
  
  text(x = x, y = mean(c(usr[4], lineToUser(line,3))), labels=label,
       adj = c(xjust, 0.5), col=col, ...)
}

