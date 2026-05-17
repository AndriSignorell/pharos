
#' Create a Treemap 
#' 
#' Creates a treemap where rectangular regions of different size, color, and
#' groupings visualize the elements.
#' 
#' A treemap is a two-dimensional visualization for quickly analyzing large,
#' hierarchical data sets. Treemaps are unique among visualizations because
#' they provide users with the ability to see both a high level overview of
#' data as well as fine-grained details. Users can find outliers, notice
#' trends, and perform comparisons using treemaps. Each data element contained
#' in a treemap is represented with a rectangle, or a cell. Treemap cell
#' arrangement, size, and color are each mapped to an attribute of that
#' element. Treemap cells can be grouped by common attributes. Within a group,
#' larger cells are placed towards the bottom left, and smaller cells are
#' placed at the top right. 
#' 
#' @param x a vector storing the values to be used to calculate the areas of
#' rectangles. 
#' @param grp a vector specifying the group (i.e. country, sector, etc.) to
#' which each element belongs. 
#' @param labels a vector specifying the labels. 
#' @param cex the character extension for the area labels. Default is 1. 
#' @param text.col the text color of the area labels. Default is "black". 
#' @param col a vector storing the values to be used to calculate the color of
#' rectangles. 
#' @param labels.grp a character vector specifying the labels for the groups.
#' @param cex.grp the character extension for the group labels. Default is 3.
#' @param text.col.grp the text color of the group labels. Default is "black".
#' @param border.grp the border color for the group rectangles. Default is
#' "grey50". Set this to \code{NA} if no special border is desired. 
#' @param lwd.grp the linewidth of the group borders. Default is 5. 
#' @param main a title for the plot. 
#' @param ... Additional graphical parameters (via \code{\link[graphics]{par}}).
#'   
#' @return returns a list with groupwise organized midpoints in x and y for the
#' rectangles within a group and for the groups themselves. 
#' 
#' @note
#' Parts of the code contributed by Jeff Enos.
#' 
#' @seealso \code{\link{plotCirc}}, \code{\link{mosaicplot}},
#' \code{\link{barplot}}
#' 
#' @examples
#' 
#' set.seed(1789)
#' N <- 20
#' area <- rlnorm(N)
#' 
#' plotTreemap(x=sort(area, decreasing=TRUE), labels=letters[1:20], 
#'             col=pal("RedToBlack", 20))
#' 
#' 
#' grp <- sample(x=1:3, size=20, replace=TRUE, prob=c(0.2,0.3,0.5))
#' 
#' z <- bedrock::sortX(data.frame(area=area, grp=grp), c("grp","area"), 
#'            decreasing=c(FALSE,TRUE))
#' z$col <- addAlpha(c("steelblue","green","yellow")[z$grp],
#'                   unlist(lapply(split(z$area, z$grp),
#'                   function(...) bedrock::linScale(..., 
#'                       newLow=0.1, newHigh=0.6))))
#' 
#' plotTreemap(x=z$area, grp=z$grp, labels=letters[1:20], col=z$col)
#' 
#' 
#' b <- plotTreemap(x=z$area, grp=z$grp, labels=letters[1:20], labels.grp=NA,
#'                  col=z$col, main="Treemap")
#' 
#' # the function returns the midpoints of the areas
#' # extract the group midpoints from b
#' mid <- do.call(rbind, lapply(lapply(b, "[", 1), data.frame))
#' 
#' # and draw some visible text
#' boxedText(x=mid$grp.x, y=mid$grp.y, labels=LETTERS[1:3], 
#'           cex=3, border=NA,
#'           col=addAlpha("white",0.7) )
#' 
#' 


#' @family plot.special
#' @concept graphics
#' @concept frequency-analysis
#'
#'
#' @export
plotTreemap <- function(x, grp=NULL, labels=NULL,  
                        text.col="black", col=rainbow(length(x)),
                        labels.grp=NULL, cex.grp=3, text.col.grp="black", 
                        border.grp="grey50",
                        lwd.grp=5, main="", ...) {
  

  dots  <- list(...)
  
  .withGraphicsState({
    
    
    # par() aus ...
    .applyParFromDots(...)

    if(is.null(grp)) grp <- rep(1, length(x))
    if(is.null(labels)) labels <- names(x)
    
    # we need to sort the stuff
    ord <- order(grp, -x)
    x <- x[ord]
    grp <- grp[ord]
    labels <- labels[ord]
    col <- col[ord]
    
    
    # get the groups rects first
    zg <- .sqMap(sort(tapply(x, grp, sum), decreasing=TRUE))
    
    # the transformation information: x0 translation, xs stretching
    tm <- cbind(zg[,1:2], xs=zg$x1 - zg$x0, ys=zg$y1 - zg$y0)
    gmidpt <- data.frame(x=apply(zg[, c("x0", "x1")], 1, mean),
                         y=apply(zg[, c("y0", "y1")], 1, mean))
    
    if(is.null(labels.grp))
      if(nrow(zg)>1) {
        labels.grp <- rownames(zg)
      } else {
        labels.grp <- NA
      }
    
    canvas(c(0,1), xpd=TRUE, asp=NA, main=main)
    
    res <- list()
    
    for( i in 1:nrow(zg)){
      
      # get the group index
      idx <- grp == rownames(zg)[i]
      xg.rect <- .sqMap(sort(x[idx], decreasing=TRUE))
      
      # transform
      xg.rect[,c(1,3)] <- xg.rect[,c(1,3)] * tm[i,"xs"] + tm[i,"x0"]
      xg.rect[,c(2,4)] <- xg.rect[,c(2,4)] * tm[i,"ys"] + tm[i,"y0"]
      
      .plotSqMap(xg.rect, col=col[idx], add=TRUE)
      
      res[[i]] <- list(grp=gmidpt[i,],
                       child= cbind(x=apply(xg.rect[,c("x0","x1")], 1, mean),
                                    y=apply(xg.rect[,c("y0","y1")], 1, mean)))
      
      text( x=apply(xg.rect[, c("x0", "x1")], 1, mean),
            y=apply(xg.rect[, c("y0", "y1")], 1, mean),
            labels=labels[idx], col=text.col )
    }
    
    names(res) <- rownames(zg)
    
    .plotSqMap(zg, col=NA, add=TRUE, border=border.grp, lwd=lwd.grp)
    
    text( x=apply(zg[, c("x0", "x1")], 1, mean),
          y=apply(zg[, c("y0", "y1")], 1, mean),
          labels=labels.grp, cex=cex.grp, col=text.col.grp)
    
  
  })
  
  invisible(res)

}



# == internal helper functions =============================================

.sqMap <- function(x) {
  
  .calcsqmap <- function(z, x0 = 0, y0 = 0, x1 = 1, y1 = 1, lst=list()) {
    
    cz <- cumsum(z$area)/sum(z$area)
    n <- which.min(abs(log(max(x1/y1, y1/x1) * sum(z$area) * ((cz^2)/z$area))))
    more <- n < length(z$area)
    a <- c(0, cz[1:n])/cz[n]
    if (y1 > x1) {
      lst <- list( data.frame(idx=z$idx[1:n],
                              x0=x0 + x1 * a[1:(length(a) - 1)],
                              y0=rep(y0, n), x1=x0 + x1 * a[-1], 
                              y1=rep(y0 + y1 * cz[n], n)))
      if (more) {
        lst <- append(lst, Recall(z[-(1:n), ], x0, y0 + y1 * cz[n], 
                                  x1, y1 * (1 - cz[n]), lst))
      }
    } else {
      lst <- list( data.frame(idx=z$idx[1:n],
                              x0=rep(x0, n), y0=y0 + y1 * a[1:(length(a) - 1)],
                              x1=rep(x0 + x1 * cz[n], n), y1=y0 + y1 * a[-1]))
      if (more) {
        lst <- append(lst, Recall(z[-(1:n), ], x0 + x1 * cz[n], 
                                  y0, x1 * (1 - cz[n]), y1, lst))
      }
    }
    
    lst
    
  }
  
  # z <- data.frame(idx=seq_along(z), area=z)
  
  if(is.null(names(x))) names(x) <- seq_along(x)
  x <- data.frame(idx=names(x), area=x)
  
  res <- do.call(rbind, .calcsqmap(x))
  rownames(res) <- x$idx
  
  return(res[,-1])
  
}


.plotSqMap <- function(z, col = NULL, border=NULL, lwd=par("lwd"), add=FALSE){
  
  if(is.null(col)) col <- as.character(z$col)
  
  # plot squarified treemap
  if(!add) canvas(c(0, 1), xpd=TRUE)
  
  for(i in 1:nrow(z)){
    rect(xleft=z[i,]$x0, ybottom=z[i,]$y0, xright=z[i,]$x1, ytop=z[i,]$y1,
         col=col[i], border=border, lwd=lwd)
  }
  
}


