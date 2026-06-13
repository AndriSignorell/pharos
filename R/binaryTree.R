
#' Binary Tree 
#' 
#' Create a binary tree of a given number of nodes \code{n}. Can be used to
#' organize a sorted numeric vector as a binary tree. 
#' 
#' If we index the nodes of the tree as 1 for the top, 2--3 for the next
#' horizontal row, 4--7 for the next, \ldots then the parent-child traversal
#' becomes particularly easy. The basic idea is that the rows of the tree start
#' at indices 1, 2, 4, \ldots.
#' 
#' binaryTree(13) yields the vector \code{c(8, 4, 9, 2, 10, 5, 11, 1, 12, 6, 13,
#' 3, 7)} meaning that the smallest element will be in position 8 of the tree,
#' the next smallest in position 4, etc.
#' 
#' @aliases binaryTree plotBinaryTree
#' @param x numeric vector to be organized as binary tree. 
#' @param main main title of the plot. 
#' @param horiz logical, should the plot be oriented horizontally or
#' vertically (default).
#' @param line properties of the line segments (\code{col}, 
#' \code{lwd}, \code{lty}). 
#' @param text properties of the text, can be any of the arguments
#'  of \code{\link{boxedText}} (besides geometry and label). 
#' @param \dots the dots are sent to \code{\link{canvas}}. 
#' 
#' @return an integer vector of length n 
#' 
#' @note 
#' Substantially based on code by Terry Therneau, with major extensions 
#' and improvements by the package author.
#' 
#' @examples
#' 
#' bedrock::binaryTree(12)
#' 
#' x <- sort(sample(100, 24))
#' z <- plotBinaryTree(x, cex=0.8)
#' 
#' plotBinaryTree(LETTERS[1:15], 
#'                text=list(col="deeppink4", cex=2),
#'                line=list(col="navajowhite3", lwd=2))
#' 
#' 
#' # Plot example - Titanic data, for once from a somwhat different perspective
#' tab <- apply(Titanic, c(2,3,4), sum)
#' cprob <- c(1, prop.table(apply(tab, 1, sum))
#'            , as.vector(aperm(prop.table(apply(tab, c(1,2), sum), 1), c(2, 1)))
#'            , as.vector(aperm(prop.table(tab, c(1,2)), c(3,2,1)))
#' )
#' 
#' plotBinaryTree(round(cprob[bedrock::binaryTree(length(cprob))],2), horiz=TRUE, cex=0.8,
#'             main="Titanic")
#' text(c("sex","age","survived"), y=0, x=c(1,2,3)+1)
#' 


#' @rdname binaryTree
#' @family plot.special
#' @concept graphics
#' @concept data-structures
#'
#'
#' @export
plotBinaryTree <- function(x, main = "Binary tree", horiz = FALSE,
                        text=TRUE, line=TRUE, ...) {
  

  col <- "black"
    
  .withGraphicsState({
    
    .applyParFromDots(..., 
                      defaults=list(
                        mar=c(top=2)
            ))

    n <- length(x)
    if(n < 1L)
      stop("x must have positive length")
    
    s <- floor(log2(n))
    
    # build tree structure (positions)
    lst <- vector("list", s + 1L)
    lst[[s + 1L]] <- seq_len(2^s)
    
    for(i in s:1) {
      lst[[i]] <- bimean(lst[[i + 1L]])
    }
    
    # coordinates
    coords <- data.frame(
      xpos = unlist(lst),
      ypos = -rep(seq_along(lst), lengths(lst)),
      pos  = seq_len(2^(s + 1L) - 1L)
    )
    
    # map values to positions
    binpos <- bedrock::binaryTree(n)
    df <- coords[binpos, ]
    df$x <- x
    
    # ---- plotting ----
    
    if(horiz) {
      
      canvas(xlim = c(1, s + 1.5), ylim = c(0, 2^s + 1),
             main = main, ...)
      
      ii <- 0L
      for(i in seq_len(length(lst) - 1L)) {
        for(j in seq_along(lst[[i]])) {
          
          ii <- ii + 1L
          if(ii < n)
            .drawSegments(y0 = lst[[i]][j], x0 = i,
                     y1 = lst[[i + 1L]][2*(j - 1L) + 1L], x1 = i + 1L,
                     line = line)
          
          ii <- ii + 1L
          if(ii < n)
            .drawSegments(y0 = lst[[i]][j], x0 = i,
                     y1 = lst[[i + 1L]][2*(j - 1L) + 2L], x1 = i + 1L,
                     line = line)
        }
      }
      
      # rotate coordinates
      tmp <- df$xpos
      df$xpos <- -df$ypos
      df$ypos <- tmp
      
    } else {
      
      canvas(xlim = c(0, 2^s + 1), ylim = c(-s, 1) - 1.5,
             main = main, ...)
      
      ii <- 0L
      for(i in seq_len(length(lst) - 1L)) {
        for(j in seq_along(lst[[i]])) {
          
          ii <- ii + 1L
          if(ii < n)
            .drawSegments(x0 = lst[[i]][j], y0 = -i,
                     x1 = lst[[i + 1L]][2*(j - 1L) + 1L], y1 = -i - 1L,
                     line = line)
          
          ii <- ii + 1L
          if(ii < n)
            .drawSegments(x0 = lst[[i]][j], y0 = -i,
                     x1 = lst[[i + 1L]][2*(j - 1L) + 2L], y1 = -i - 1L,
                     line = line)
        }
      }
    }
    

    # --- Text Layer ---
    bedrock::callIf(boxedText,
            text,
            defaults = list(
              x = df$xpos, y = df$ypos, 
              labels = df$x,
              xpad = 0.5, ypad = 0.5,
              border = FALSE, bg=addAlpha("white", 0.9)
            ),
            forbidden = c("x","y","labels"),
            warn = TRUE
    )

  })
  
  invisible(df)
  
  
}


# == internal helper functions =======================================


.drawSegments <- function(x0, y0, x1, y1, line){
  
  bedrock::callIf(segments,
          line,
          defaults = list(
            x0=x0, y0=y0, x1=x1, y1=y1,
            col="black", 
            lwd=1,
            lty=1
          ),
          forbidden = c("x0", "y0", "x1", "y1"),
          warn = TRUE
  )
  
}


# helper: pairwise means
bimean <- function(x) {
  (x[seq(1, length(x), by = 2)] +
     x[seq(2, length(x), by = 2)]) / 2
}




