
#' Circular Chord Diagram
#'
#' Draws a circular chord diagram from a matrix, showing flows between rows and columns
#' using sectors and ribbons. The plot is rendered using base graphics and supports
#' flexible styling via object-based arguments.
#'
#' @param x A numeric matrix. Rows and columns define the connections between sectors.
#'
#' @param sector sector styling. Can be:
#' \itemize{
#'   \item a logical (`TRUE`/`FALSE`) to enable/disable sectors,
#'   \item a vector of colors,
#'   \item or a list with elements \code{col} and \code{border}.
#' }
#' Colors are recycled to match the number of sectors (`nrow(x) + ncol(x)`).
#'
#' @param ribbon ribbon styling. Can be:
#' \itemize{
#'   \item a logical (`TRUE`/`FALSE`) to enable/disable ribbons,
#'   \item a vector of colors,
#'   \item or a list with elements \code{col} and \code{border}.
#' }
#' Colors are recycled to match the number of row categories (`nrow(x)`).
#'
#' @param labels label styling. Can be:
#' \itemize{
#'   \item a logical (`TRUE`/`FALSE`) to enable/disable labels,
#'   \item a character vector of labels,
#'   \item or a list with parameters passed to internal label drawing.
#' }
#'
#' @param gap numeric. Gap between sectors in degrees.
#'
#' @param main character. Main title of the plot.
#'
#' @param ... additional graphical parameters passed to internal plotting functions.
#'
#' @details
#' The function constructs a circular layout where:
#' \itemize{
#'   \item Columns of \code{x} are placed on one half of the circle
#'   \item Rows of \code{x} are placed on the opposite half
#'   \item Ribbon widths are proportional to matrix entries
#' }
#'
#' Sector sizes correspond to marginal sums of the matrix.
#'
#' Internally, angles are computed in radians and mapped to Cartesian coordinates.
#'
#' @return Invisibly returns a list with label positions:
#' \describe{
#'   \item{x}{x-coordinates of labels}
#'   \item{y}{y-coordinates of labels}
#' }
#'
#' 
#' @examples
#' set.seed(1)
#' x <- matrix(sample(1:10, 36, replace = TRUE), nrow = 6)
#' rownames(x) <- LETTERS[1:6]
#' colnames(x) <- LETTERS[1:6]
#'
#' plotCirc(x)
#'
#' # Custom colors
#' plotCirc(
#'   x,
#'   sector = list(col = rainbow(12), border = "grey50"),
#'   ribbon = list(col = rainbow(6), border = NA)
#' )
#'
#' # Custom labels
#' plotCirc(
#'   x,
#'   labels = list(cex = 0.8, col = "blue", las = 2)
#' )
#'



#' @family plot.special  
#' @concept bar-chart
#'
#'
#' @export
plotCirc <- function(
    
  # DATA
  x,
  
  # STYLE (object-based!)
  sector = TRUE,
  ribbon = TRUE,
  labels = TRUE,
  
  gap = 5,

  # LABELS
  main = NULL
  , ...
  
  
) {
  
  if (!is.matrix(x))
    stop("x must be a matrix")

  # --- theme ---------------------------------------------------

  n <- sum(x)
  nc <- ncol(x)
  nr <- nrow(x)
  d <- degToRad(gap)    # the gap between the sectors in radiant
  
  innerR <- .95
  outerR <- 1
  
  # --- plotting ------------------------------------------------
  
  .withGraphicsState({
    
    .applyParFromDots(
      ...,
      defaults = list(
        mar = c(
          bottom = 2.1,
          left  = 2.1,
          top   = .marTop(main),
          right = 2.1
        ),
        fg = "grey30",
        xpd=NA, 
        asp=1
      )
    )

    canvas(main = main, 
           xlim=c(-1.2, 1.2), ylim=c(-1.2, 1.2))

        
    # --- sector angles ----------------------------------------
    
    left  <- rev(colSums(x)) / n * (pi - nc * d)
    right <- rev(rowSums(x)) / n * (pi - nr * d)
    
    mpts.left  <- c(0, cumsum(as.vector(rbind(left, d))))
    mpts.right <- cumsum(as.vector(rbind(right, d)))
    
    mpts <- c(mpts.left, mpts.right + pi) + pi/2 + d/2
    
    
    # --- sectors ----------------------------------------------
    

    polygon(ring(
      innerRadius = innerR,
      outerRadius = outerR,
      startAngle = mpts[seq_along(mpts) %% 2 == 1],
      endAngle = mpts[seq_along(mpts) %% 2 == 0]),
      col = sector,
      border = "grey"
    )

    
    # --- ribbons ----------------------------------------------
  
    tab <- x
    
    if(is.vector(sector))
      sector <- recycle(col=sector, border="grey", maxdim=nc+nr)
    else
      sector <- recycle(sector, maxdim=nc+nr)
    
    if(is.vector(ribbon))
      ribbon <- recycle(col=ribbon, border="grey", maxdim=nc+nr)
    else
      ribbon <- recycle(ribbon, maxdim=nc+nr)
    
    
    acol <- sector$col
    aborder <- sector$border
    rcol <- ribbon$col
    rborder <- ribbon$border
    
    mpts.left <- c(0, cumsum(as.vector(rbind(rev(apply(tab, 2, sum))/ 
                                               n * (pi - nc * d), d))))
    mpts.right <- cumsum(as.vector(rbind(rev(apply(tab, 1, sum))/ 
                                           n * (pi - nr * d), d)))
    mpts <- c(mpts.left, mpts.right + pi) + pi/2 + d/2

        
    if(is.null(labels)) labels <- rev(c(rownames(tab), colnames(tab)))
    
    ttab <- rbind(revX(tab, margin=2) / n * (pi - nc * d), d)
    pts.left <- (c(0, cumsum(as.vector(ttab))))
    
    ttab <- rbind(revX(t(tab), margin=2)/ n * (pi - nr * d), d)
    pts.right <- (c( cumsum(as.vector(ttab)))) + pi
    
    pts <- c(pts.left, pts.right) + pi/2 + d/2
    dpt <- data.frame(from=pts[-length(pts)], to=pts[-1])

    for( i in 1:nc) {
      for( j in 1:nr) {
        lang <- dpt[(i-1)*(nr+1)+j,]
        rang <- revX(dpt[-nrow(dpt),], margin=1)[(j-1)*(nc+1) + i,]
        
        .drawRibbon( angle1.beg=rang[,2], angle1.end=lang[,1], 
                     angle2.beg=rang[,1], angle2.end=lang[,2],
                     radius1 = outerR, radius2 = innerR-0.05, 
                     col = rcol[j], border = rborder[j])
      }}


    # --- labels -----------------------------------------------

    if(!is.list(labels))
      labels <- list(labels=labels)
    
    # calculate position for labels
    mid <- filter(mpts, rep(1/2, 2))
    idx <- seq(1, (nr + nc)*2, by = 2)
    pos <- polToCart(r = outerR + .2, theta = mid[idx])
    
    bedrock::callIf(
      .drawLabels, 
      labels, 
      defaults=list(pos=pos, labels=rev(LETTERS[1:(nr + nc)]),
                    cex = 1, col="black", las=1, adj=NULL, nr=nr, nc=nc))
    
  })
  
  invisible(pos)
  
}





# == internal helper functions =============================================


.drawLabels <- function(pos, labels, cex, col, las, adj, nr, nc){  
  
  labels <- rev(labels)
  
  if(las == 2){
    
    # radial alignment
    if(is.null(adj)) 
      adj <- c(rep(1, nr), rep(0, nc))
    
    adj <- rep(adj, length_out = length(labels))
    
    sapply(seq_along(labels),
           function(i) text(pos$x[i], pos$y[i], labels=labels[i], 
                            cex=cex,
                            srt=radToDeg(atan(pos$y[i]/pos$x[i])), adj=adj[i]))
    
  } else {
    # vertical or horizontal alignment
    text(pos$x, pos$y, labels = labels,
         cex = cex, col = col, srt=ifelse(las==3, 90, 0), adj=adj)
  }
  
}


# --- ribbon helper ------------------------------------------

.drawRibbon <- function(angle1.beg, angle1.end, 
                        angle2.beg, angle2.end,
                        radius1 = 10, radius2 = 9,
                        col, border) {
  
  xy1 <- polToCart(radius1, angle1.beg)
  xy2 <- polToCart(radius2, angle1.end)
  xy3 <- polToCart(radius1, angle2.beg)
  xy4 <- polToCart(radius2, angle2.end)
  
  bez1 <- arc(radiusX = radius2,
                          startAngle = angle1.end,
                          endAngle = angle2.end)
  
  bez2 <- bezier(
    x = c(xy4$x, 0, xy3$x),
    y = c(xy4$y, 0, xy3$y)
  )
  
  bez3 <- arc(
    radiusX = radius1,
    startAngle = angle2.beg,
    endAngle = angle1.beg)
  
  bez4 <- bezier(
    x = c(xy1$x, 0, xy2$x),
    y = c(xy1$y, 0, xy2$y))
  
  polygon(
    x = c(bez1$x, bez2$x, bez3$x, bez4$x),
    y = c(bez1$y, bez2$y, bez3$y, bez4$y),
    col = col,
    border = border
  )
  
}

