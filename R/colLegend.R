
#' Add a Color Legend to a Plot
#'
#' Draw a color legend (color strip) inside an existing plot region.
#'
#' The legend can be positioned either by explicit coordinates or by
#' keyword placement such as \code{"topright"} or \code{"left"}.
#'
#' Labels may either be aligned with the edges of the color strip or
#' centered within the color blocks.
#'
#' @param x Left x-coordinate of the legend or a keyword specifying
#'   automatic placement:
#'   \code{"bottomright"}, \code{"bottom"}, \code{"bottomleft"},
#'   \code{"left"}, \code{"topleft"}, \code{"top"},
#'   \code{"topright"}, \code{"right"}, \code{"center"}.
#' @param y Top y-coordinate of the legend when \code{x} is numeric.
#' @param col Vector of colors.
#' @param labels Optional vector of labels.
#' @param width Width of the legend in user coordinates.
#' @param height Height of the legend in user coordinates.
#' @param horiz Logical; if \code{TRUE}, draw horizontally.
#' @param xjust Horizontal justification.
#' @param yjust Vertical justification.
#' @param inset Inset distance(s) when keyword positioning is used.
#' @param region Character string specifying the reference region
#'   used for keyword placement. One of:
#'   \code{"plot"}, \code{"figure"}, or \code{"device"}.
#' @param border Border color of individual color rectangles.
#' @param box Optional specification of an enclosing box around the
#'   whole legend. Can be:
#'   \itemize{
#'     \item \code{FALSE}, \code{NULL}, or \code{NA}: no box
#'     \item \code{TRUE}: draw box with defaults
#'     \item named list of arguments passed to \code{\link{rect}}
#'   }
#' @param labelAdj Placement of labels relative to the color blocks:
#'   \describe{
#'     \item{\code{"edge"}}{
#'       Labels are aligned with the strip edges.
#'     }
#'     \item{\code{"center"}}{
#'       Labels are centered within color blocks.
#'     }
#'   }
#' @param adj Text alignment passed to \code{\link{text}}.
#' @param cex Character expansion for labels.
#' @param title Optional title.
#' @param titleAdj Horizontal title adjustment.
#' @param ... Additional arguments passed to \code{\link{text}}.
#'
#' @return
#' Invisibly returns a list with components:
#' \describe{
#'   \item{rect}{
#'     List describing the color strip geometry with components
#'     \code{width}, \code{height}, \code{left}, and \code{top}.
#'   }
#'   \item{text}{
#'     List containing the label coordinates \code{x} and \code{y}.
#'   }
#' }
#'
#' 
#' @examples
#' 
#' plot(1:15,, xlim=c(0,10), type="n", xlab="", ylab="", main="Colorstrips")
#' 
#' # A
#' colLegend(x="right", inset=5, labels=c(1:10))
#' 
#' # B: Center the labels
#' colLegend(x=1, y=9, height=6, col=colorRampPalette(c("blue", "white", "red"),
#'   space = "rgb")(5), labels=1:5, labelAdj = "center")
#' 
#' # C: Outer frame
#' colLegend(x=3, y=9, height=6, col=colorRampPalette(c("blue", "white", "red"),
#'   space = "rgb")(5), labels=1:4, box=list(border="grey", lty="dashed"))
#' 
#' # D
#' colLegend(x=5, y=9, height=6, col=colorRampPalette(c("blue", "white", "red"),
#'   space = "rgb")(10), labels=sprintf("%.1f",seq(0,1,0.1)), cex=0.8)
#' 
#' # E: horizontal shape
#' colLegend(x=1, y=2, width=6, height=0.2, col=rainbow(500), labels=1:5,horiz=TRUE)
#' 
#' # F
#' colLegend(x=1, y=14, width=6, height=0.5, col=colorRampPalette(
#'   c("black","blue","green","yellow","red"), space = "rgb")(100), 
#'   horiz=TRUE, box = TRUE)
#' 
#' # G
#' colLegend(x=1, y=12, width=6, height=1, col=colorRampPalette(c("black","blue",
#'             "green","yellow","red"), space = "rgb")(10), horiz=TRUE, 
#'             border="black", title="From black to red", titleAdj=0)
#' 
#' text(x = c(8,0.5,2.5,4.5,0.5,0.5,0.5)+.2, y=c(14,9,9,9,2,14,12), LETTERS[1:7], cex=2)
#' 
#' @seealso
#' \code{\link{legend}},
#' \code{\link{abcCoords}}
#'
#' @family plot.annotation
#' @concept graphics
#' @concept plot-annotation
#' 
#' @export
colLegend <- function(
    x,
    y = NULL,
    col = rev(heat.colors(100)),
    labels = NULL,
    width = NULL,
    height = NULL,
    horiz = FALSE,
    xjust = 0,
    yjust = 1,
    inset = 0,
    region = c("plot", "figure", "device"),
    border = NA,
    box = FALSE,
    labelAdj = c("edge", "center"),
    adj = NULL,
    cex = 1,
    title = NULL,
    titleAdj = 0.5,
    ...
) {
  
  region   <- match.arg(region)
  labelAdj <- match.arg(labelAdj)
  
  if (is.null(adj)) {
    adj <- if (horiz) c(0.5, 1) else c(1, 0.5)
  }
  
  usr <- par("usr")
  
  if (is.null(width))
    width <- strwidth("mn", cex = cex)
  
  if (is.null(height))
    height <- (usr[4] - usr[3]) *
    if (horiz) 0.08 else 0.92
  
  # --- positioning ---------------------------------------------------
  
  if (is.character(x)) {
    
    xy <- abcCoords(
      x      = x,
      region = region,
      cex    = cex,
      inset  = inset
    )
    
    left <- switch(
      x,
      right = ,
      topright = ,
      bottomright = xy$xy$x - width,
      
      center = ,
      top = ,
      bottom = xy$xy$x - width / 2,
      
      xy$xy$x
    )
    
    top <- switch(
      x,
      bottom = ,
      bottomleft = ,
      bottomright = xy$xy$y + height,
      
      center = ,
      left = ,
      right = xy$xy$y + height / 2,
      
      xy$xy$y
    )
    
  } else {
    
    left <- x - xjust * width
    top  <- y + (1 - yjust) * height
    
  }
  
  # coordinates returned invisibly
  xLbl <- yLbl <- NULL
  
  # --- graphics ------------------------------------------------------
  
  .withGraphicsState({
    
    par(xpd = TRUE)
    
    nCol <- length(col)
    nLbl <- length(labels)
    
    # --- draw rectangles ---------------------------------------------
    
    if (horiz) {
      
      breaks <- seq(0, width, length.out = nCol + 1)
      
      rect(
        xleft   = left + breaks[-length(breaks)],
        xright  = left + breaks[-1],
        ybottom = top - height,
        ytop    = top,
        col     = col,
        border  = border
      )
      
    } else {
      
      breaks <- seq(0, height, length.out = nCol + 1)
      
      rect(
        xleft   = left,
        xright  = left + width,
        ybottom = top - breaks[-1],
        ytop    = top - breaks[-length(breaks)],
        col     = rev(col),
        border  = border
      )
      
    }
    
    # --- labels ------------------------------------------------------
    
    if (!is.null(labels)) {
      
      if (horiz) {
        
        if (labelAdj == "center") {
          
          if (nLbl > 1L) {
            xLbl <- left + width / (2 * nCol) + (width - width / nCol) /
              (nLbl - 1L) * seq(0, nLbl - 1L)
            
          } else {
            xLbl <- left + width / 2
          }
          
        } else {
          if (nLbl > 1L) {
            xLbl <- left + width / (nLbl - 1L) * seq(0, nLbl - 1L)
          } else {
            xLbl <- left + width / 2
          }
          
        }
        
        yLbl <- top - height - max(strheight(labels, cex = cex)) * 1.2
        
      } else {
        
        if (labelAdj == "center") {
          
          if (nLbl > 1L) {
            yLbl <- top - height / (2 * nCol) - (height - height / nCol) /
              (nLbl - 1L) * seq(0, nLbl - 1L)
            
          } else {
            yLbl <- top - height / 2
            
          }
          
        } else {
          if (nLbl > 1L) {
            yLbl <- top - height / (nLbl - 1L) * seq(0, nLbl - 1L)
            
          } else {
            yLbl <- top - height / 2
            
          }
        }
        
        yLbl <- rev(yLbl)
        
        xLbl <- left + width + strwidth("0", cex = cex) +
                  max(strwidth(labels, cex = cex)) * adj[1]
        
      }
      
      text(
        x = xLbl, y = yLbl, labels = labels,
        adj = adj, cex = cex, ...
      )
      
    }
    
    # --- enclosing box -----------------------------------------------
    
    callIf(
      rect,
      box,
      defaults = list(
        xleft   = left,
        xright  = left + width,
        ytop    = top,
        ybottom = top - height,
        col     = NA
      ),
      forbidden = "col"
    )
    
    # --- title -------------------------------------------------------
    
    if (!is.null(title)) {
      
      text(
        x = left + width * titleAdj,
        y = top + strheight("M", cex = cex) * 1.4,
        labels = title,
        adj = c(titleAdj, 0),
        cex = cex
      )
      
    }
    
  })
  
  invisible(list(
    rect = list(
      width = width,
      height = height,
      left = left,
      top = top
    ),
    text = list(
      x = xLbl,
      y = yLbl
    )
  ))
  
}

