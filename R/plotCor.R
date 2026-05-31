#' Correlation Matrix Plot with Theming and Optional Labels
#'
#' Draws a correlation matrix using \code{\link[graphics]{image}} with
#' optional clustering, triangular display, grid lines, color legend,
#' and numeric labels inside the cells.
#'
#' The function follows the DescToolsX plotting conventions:
#'
#' \itemize{
#'   \item User arguments override theme settings.
#'   \item Theme settings override base graphics defaults.
#'   \item Graphical parameters (e.g. \code{cex}, \code{las}, \code{mar})
#'         can be supplied via \code{...}.
#' }
#'
#' @param x A numeric correlation matrix.
#'
#' @param main,xlab,ylab Optional plot labels.
#'
#' @param xax,yax Controls drawing of the axes.
#'
#'   Supported values are
#'   \describe{
#'     \item{\code{TRUE}}{draw axis using default settings}
#'     \item{\code{FALSE}}{suppress axis}
#'     \item{\code{list(...)}}{custom axis parameters passed to \code{\link[graphics]{axis}}}
#'   }
#'
#' @param cluster Logical; if \code{TRUE}, variables are reordered by
#'   hierarchical clustering to place similar correlations together.
#'
#' @param mincor Numeric threshold; correlations with absolute value
#'   smaller than this are suppressed (set to \code{NA}).
#'
#' @param triangle Which part of the matrix to display.
#'   One of
#'   \code{"full"}, \code{"upper"}, or \code{"lower"}.
#'
#' @param diag Logical; should the diagonal be displayed.
#'
#' @param col Color palette used for the correlation values.
#'
#' @param grid Logical or list controlling grid lines between cells.
#'
#'   Supported values are
#'   \describe{
#'     \item{\code{TRUE}}{draw grid using theme defaults}
#'     \item{\code{FALSE}}{no grid}
#'     \item{\code{list(...)}}{custom grid parameters}
#'   }
#'
#' @param box Logical; draw a box around the plot region.
#'
#' @param legend Logical; draw a color legend for the correlation scale.
#'
#' @param text Controls numeric labels drawn inside the matrix cells.
#'
#'   Supported values are
#'   \describe{
#'     \item{\code{FALSE}}{no labels}
#'     \item{\code{TRUE}}{default labels based on the correlation values}
#'     \item{\code{list(...)}}{custom parameters passed to the internal text drawing routine}
#'   }
#'
#' @param ... Additional graphical parameters passed to
#'   \code{\link[graphics]{par}} and \code{\link[graphics]{image}}.
#'
#' @details
#' The function internally:
#'
#' \enumerate{
#'   \item Optionally reorders the matrix using hierarchical clustering.
#'   \item Masks parts of the matrix according to \code{triangle} and \code{diag}.
#'   \item Adjusts plot margins based on label sizes.
#'   \item Draws the matrix using \code{\link[graphics]{image}}.
#'   \item Optionally adds grid lines, numeric labels, axes, and a color legend.
#' }
#'
#' @return Invisibly returns the (possibly reordered) matrix used for plotting.
#'
#' @seealso \code{\link[graphics]{image}}, \code{\link[stats]{cor}}
#' 
#' @examples
#' m <- cor(swiss)
#'
#' # full correlation matrix
#' plotCor(m, legend=FALSE)
#'
#' # upper triangle only
#' plotCor(m, triangle = "upper")
#'
#' # clustered variables
#' plotCor(m, cluster = TRUE)
#'
#' # with correlation values
#' plotCor(m, text = TRUE)
#'
#' # customized labels
#' plotCor(m,
#'          text = list(col = "black", cex = 0.9))
#'
#' # hide grid
#' plotCor(m, grid = FALSE)
#'
#' plotCor(m, cols=colorRampPalette(c("red", "black", "green"), space = "rgb")(20))
#' plotCor(m, cols=colorRampPalette(c("red", "black", "green"), space = "rgb")(20),
#'          args.colLegend=NA)
#' 
#' m <- cor(mtcars)
#' plotCor(m, col=pal("RedWhiteBlue1", 100), border="grey",
#'          args.colLegend=list(labels=format(seq(-1,1,.25), digits=2), frame="grey"))
#' 
#' # display only correlation with a value > 0.7
#' plotCor(m, mincor = 0.7)
#' x <- matrix(rep(1:ncol(m),each=ncol(m)), ncol=ncol(m))
#' y <- matrix(rep(ncol(m):1,ncol(m)), ncol=ncol(m))
#' txt <- format(m, digits=3)
#' idx <- upper.tri(matrix(x, ncol=ncol(m)), diag=FALSE)
#' 
#' # place the text on the upper triagonal matrix
#' text(x=x[idx], y=y[idx], label=txt[idx], cex=0.8, xpd=TRUE)
#' 
#' # put similiar correlations together
#' plotCor(m, clust=TRUE)
#' 
#' # same as
#' idx <- order.dendrogram(as.dendrogram(
#'           hclust(dist(m), method = "mcquitty")
#'        ))
#' plotCor(m[idx, idx])
#' 
#' # plot only upper triangular matrix and move legend to bottom
#' m <- cor(mtcars)
#' m[lower.tri(m, diag=TRUE)] <- NA
#' 
#' # get the p-values
#' p <- outer(
#'   (vars <- colnames(mtcars)), vars,
#'   Vectorize(function(v1, v2)
#'     cor.test(mtcars[[v1]], mtcars[[v2]], method = "pearson")$p.value
#'   )
#' )
#' dimnames(p) <- list(vars, vars)
#' m[p > 0.05] <- NA
#' 
#' plotCor(m, mar=c(8,8,8,8), yaxt="n",
#'          args.colLegend = list(x="bottom", inset=-.15, horiz=TRUE, 
#'                                  height=abs(lineToUser(line = 2.5, side = 1)), 
#'                                  width=ncol(m)))
#' mtext(text = rev(rownames(m)), side = 4, at=1:ncol(m), las=1, line = -5, cex=0.8)
#' 


#' @family plot.bivariate
#' @concept graphics
#' @concept correlation
#' @concept descriptive-statistics
#'
#'
#' @export
plotCor <- function(
    x,
    
    # LABELS
    main = NULL,
    xlab = NULL,
    ylab = NULL,
    
    # AXES
    xax = TRUE,
    yax = TRUE,
    
    # STRUCTURE
    cluster = FALSE,
    mincor = 0,
    triangle = c("full","upper","lower"),
    diag = TRUE, 
    
    # STYLE
    col = colorRampPalette(c(pal()[2], "white", pal()[1]), space="rgb")(20),
    grid = TRUE,
    box = TRUE,
    
    # FEATURES
    legend = TRUE,
    text = FALSE,
    
    ...
){

  if(is.null(xlab)) xlab <- ""
  if(is.null(ylab)) ylab <- ""

  
#  x <- t(x)
  
  if(isTRUE(cluster)){
    idx <- order.dendrogram(
      as.dendrogram(
        hclust(dist(x), method="mcquitty")
      )
    )
    x <- x[idx, idx]
  }
  
    
  triangle <- match.arg(triangle)
  
  if(triangle=="upper")
    x[lower.tri(x, diag = !diag)] <- NA
  
  if(triangle=="lower")
    x[upper.tri(x, diag = !diag)] <- NA
  
  if(triangle=="full" && !diag)
    x[row(x) == col(x)] <- NA
  
  
  .withGraphicsState({
    
    .applyParFromDots(...)

    if(mincor > 0)
      x[abs(x) < mincor] <- NA
    
    x <- x[, ncol(x):1]
    
    labx <- rownames(x)
    laby <- colnames(x)
    
    .adjustMargin(rownames(x), side = 3, las = 2)
    .adjustMargin(colnames(x), side = 2)
    .adjustMargin("XXXXXXX", side = 4)

    breaks <- seq(-1,1,length.out=length(col)+1)
    
    image(
      x = 1:nrow(x),
      y = 1:ncol(x),
      z = x,
      xaxt="n",
      yaxt="n",
      col=col,
      breaks=breaks,
      xlab=xlab,
      ylab=ylab
      #, asp = list(...)$asp %||% 1
    )
    
    if(!isFALSE(text)){
      
      defaults <- list(
        labels = fm(x, digits=2, naForm = "."),
        col    = "black",
        cex    = 0.8
      )
      
      bedrock::callIf(.drawCorrText, text, defaults)
    }
    
    if(!isFALSE(xax))
      axis(3, at=1:nrow(x), labels=labx, las=2, lwd=-1)
    
    if(!isFALSE(yax))
      axis(2, at=1:ncol(x), labels=laby, las=1, lwd=-1)
    
    if(!isFALSE(grid)){
      
      th <- .theme(grid=grid)$grid
      usr <- par("usr")
      
      clip(0.5,nrow(x)+0.5,0.5,ncol(x)+0.5)
      
      abline(
        h=seq(0.5,ncol(x)+0.5,1),
        v=seq(0.5,nrow(x)+0.5,1),
        col=th$col,
        lty=1,
        lwd=th$lwd
      )
      
      do.call("clip", as.list(usr))
    }
    
    if(isTRUE(box))
      box(col="grey")
    
    if(!isFALSE(legend)){
      
      digits <- round(1 - log10(diff(range(breaks))))
      
      colLegend(
        labels=sprintf("%.*f", digits,
                       breaks[seq(1,length(breaks),2)]),
        x=nrow(x)+0.5+nrow(x)/20,
        y=ncol(x)+0.5,
        width=nrow(x)/20,
        height=ncol(x),
        cols=col,
        cex=0.8
      )
    }
    
    if(!is.null(main))
      title(main)
    
  })
  
}



# == internal helper functions ==================================

.drawCorrText <- function(labels, col="black", cex=0.8){
  
  nr <- nrow(labels)
  nc <- ncol(labels)
  
  for(i in seq_len(nr))
    for(j in seq_len(nc))
      if(!is.na(labels[i,j]))
        text(i, j, labels[i,j], col=col, cex=cex)
  
}



# == old stuff - not used anymore ========================



#' plotCor <- function(x, cols = colorRampPalette(c(pal()[2], "white", Pal()[1]), space = "rgb")(20)
#'                      , breaks = seq(-1, 1, length = length(cols)+1), border="grey", lwd=1
#'                      , args.colLegend = NULL, xaxt = par("xaxt"), yaxt = par("yaxt"), cex.axis = 0.8, las = 2
#'                      , mar = c(3,8,8,8), mincor=0, main="", clust=FALSE, ...){
#'   
#'   # example:
#'   # m <- cor(d.pizza[,WhichNumerics(d.pizza)][,1:5], use="pairwise.complete.obs")
#'   # plotCor(m)
#'   # plotCor(m, args.colLegend="n", las=1)
#'   # plotCor(m, cols=colorRampPalette(c("red", "white", "blue"), space = "rgb")(4), args.colLegend=list(xlab=sprintf("%.1f", seq(1,-1, length=5))) )
#'   # plotCor(m, cols=colorRampPalette(c("red", "black", "green"), space = "rgb")(10))
#'   
#'   # plotCor(round(CramerV(d.pizza[,c("driver","operator","city", "quality")]),3))
#'   
#'   pars <- par(mar=mar); on.exit(par(pars))
#'   
#'   # matrix should be transposed to allow upper.tri with the corresponding representation
#'   x <- t(x)
#'   
#'   if(clust==TRUE) {
#'     # cluster correlations in order to put similar values together
#'     idx <- order.dendrogram(as.dendrogram(
#'       hclust(dist(x), method = "mcquitty")
#'     ))
#'     
#'     x <- x[idx, idx]
#'   }
#'   
#'   # if mincor is set delete all correlations with abs. val. < mincor
#'   if(mincor!=0)
#'     x[abs(x) < abs(mincor)] <- NA
#'   
#'   x <- x[,ncol(x):1]
#'   image(x=1:nrow(x), y=1:ncol(x), xaxt="n", yaxt="n", z=x, frame.plot=FALSE, xlab="", ylab=""
#'         , col=cols, breaks=breaks, ... )
#'   if(xaxt!="n") axis(side=3, at=1:nrow(x), labels=rownames(x), cex.axis=cex.axis, las=las, lwd=-1)
#'   if(yaxt!="n") axis(side=2, at=1:ncol(x), labels=colnames(x), cex.axis=cex.axis, las=las, lwd=-1)
#'   
#'   if((is.list(args.colLegend) || is.null(args.colLegend))){
#'     
#'     # bugfix dmurdoch 7.2.2022
#'     digits <- round(1 - log10(diff(range(breaks))))
#'     args.colLegend1 <- list( labels=sprintf("%.*f", digits,
#'                                               breaks[seq(1,length(breaks), by = 2)])
#'                                # args.colLegend1 <- list( labels=sprintf("%.1f", seq(-1,1, length=length(cols)/2+1))
#'                                , x=nrow(x)+0.5 + nrow(x)/20, y=ncol(x)+0.5
#'                                , width=nrow(x)/20, height=ncol(x), cols=cols, cex=0.8 )
#'     if ( !is.null(args.colLegend) ) { args.colLegend1[names(args.colLegend)] <- args.colLegend }
#'     
#'     do.call("colLegend", args.colLegend1)
#'   }
#'   
#'   if(!is.na(border)) {
#'     usr <- par("usr")
#'     rect(xleft=0.5, xright=nrow(x)+0.5, ybottom=0.5, ytop=nrow(x)+0.5,
#'          lwd=lwd, border=border)
#'     usr <- par("usr")
#'     clip(0.5, nrow(x)+0.5, 0.5, nrow(x)+0.5)
#'     abline(h=seq(-2, nrow(x)+1,1)-0.5, v=seq(1,nrow(x)+1,1)-0.5, col=border,lwd=lwd)
#'     do.call("clip", as.list(usr))
#'   }
#'   
#'   if(!is.null(.getOption("stamp")))
#'     stamp()
#'   
#'   if(main!="") title(main=main)
#'   
#' }
#' 
#' ###
