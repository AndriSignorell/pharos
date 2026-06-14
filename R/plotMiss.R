
#' Plot Missing Data 
#' 
#' Takes a data frame and displays the location of missing data. The missings
#' can be clustered and be displayed together. 
#' 
#' A graphical display of the position of the missings can be help to detect
#' dependencies or patterns within the missings. 
#' 
#' @param x a data.frame to be analysed. 
#' @param col the colour of the missings. 
#' @param bg the background colour of the plot. 
#' @param clust logical, defining if the missings should be clustered. Default
#' is \code{FALSE}. 
#' @param main the main title. 
#' @param \dots the dots are passed to \code{\link{plot}}. 
#' @return if clust is set to TRUE, the new order will be returned invisibly.
#' @note Following an idea of Henk Harmsen <henk@@carbonmetrics.com> 
#' @seealso \code{\link{hclust}}, \code{\link[bedrock]{countCompCases}} 
#' 
#' @examples
#' 
#' plotMiss(airquality, main="Missing data (in orignal order)")
#' plotMiss(airquality, main="Missing data (clustered)", clust=TRUE)
#'


#' @family plot.special
#' @concept graphics
#' @concept missing-data
#'
#'
#' @export 
plotMiss <- function(x, 
                     col = "deeppink4", bg=fade("navajowhite3", 0.3), 
                     clust=FALSE,
                     main = NULL, ...){
  
  .withGraphicsState({

    .applyParFromDots(...)
    
    # special handling for cex
    cex <- bedrock::getDotsArg(list(...), "cex", par("cex"))
    
    
    if(is.null(main)) 
      main <- deparse(substitute(x))
    
    x <- as.data.frame(x)
    if(ncol(x) > 1)
      x <- x[, ncol(x):1]
    n <- ncol(x)

    
    missingIndex <- as.matrix(is.na(x))
    miss <- apply(missingIndex, 2, sum)
    
    
    right.labels <- gettextf(
      "%s (%s)",
      miss,
      sprintf("%.1f%%",
              100 * miss/nrow(missingIndex))
    )
    
    rmar <- max(
      2.1,
      .marginLines(
        right.labels,
        side = 4,
        cex = cex,
        pad = 1
      )
    )
    
    lmar <- .marginLines(
      colnames(x),
      side = 2,
      cex = cex,
      las = 1,
      pad = 2
    )
    
    canvas(xlim=c(0, nrow(x)+1), ylim=c(0, n), 
           asp=NA, xpd=TRUE, mar = c(5.1, lmar, .marTop(main), rmar), 
           main=main, usrbg=bg, ...)
    
    axis(side = 1)
    
    
    if(clust){
      orderIndex <- order.dendrogram(
                       as.dendrogram(hclust(dist(missingIndex * 1), 
                                             method = "mcquitty")))
      missingIndex <- missingIndex[orderIndex, ]
      res <- orderIndex
    } else {
      res <- NULL
    }
    
    sapply(1:ncol(missingIndex), function(i){
      xl <- which(missingIndex[,i])
      if(length(xl) > 0)
        rect(xleft=xl, xright=xl+1, ybottom=i-1, ytop=i, col=col, border=NA)
    })
    
    abline(h=1:ncol(x), col="white")
    
    
    # print(par("cex"))
    # print(par("cex.axis"))
    
    mtext(side = 2, text = colnames(x), at = (1:n)-0.5, las=1, adj = 1,
          line = 1, cex = cex)
    mtext(side = 4, text = gettextf("%s (%s)", miss, 
                                    sprintf("%.1f%%", 
                                            100 * miss/nrow(missingIndex))),
          at = (1:n)-0.5, las=1, adj = 0, line = 1, cex = cex)

  invisible(res)
  
  })
  
}


