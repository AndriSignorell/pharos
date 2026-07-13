
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
#' @param col Color palette used for the correlation values. \code{.useTheme}
#'   (default) builds a diverging ramp from \code{getTheme()$twin} - the
#'   active theme's two-color pair - through white: \code{twin[1]} at the
#'   negative end (\eqn{-1}), white at zero, \code{twin[2]} at the positive
#'   end (\eqn{+1}).
#'
#' @param grid Controls drawing of cell-separator grid lines at the
#'   half-integer matrix boundaries (clipped to the matrix extent, so they
#'   never bleed into the margins). Can be:
#'   \itemize{
#'     \item \code{.useTheme} (default): follow the active theme
#'       (\code{getTheme()$grid$col}/\code{$lwd})
#'     \item \code{TRUE}: draw with theme settings
#'     \item \code{FALSE}, \code{NULL}, or \code{NA}: suppress
#'     \item a named list: override \code{col}/\code{lwd} for this call only
#'   }
#'
#' @param box Controls drawing of the plot box. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$box}. \code{TRUE}/\code{FALSE}/\code{NA},
#'   or a named list, as for \code{grid}.
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
#' Grid lines are drawn via clipped \code{\link[graphics]{abline}()} calls
#' at the matrix's half-integer cell boundaries rather than via
#' \code{\link[graphics]{grid}()}: \code{grid()}'s \code{nx}/\code{ny}
#' divide the full plot region (\code{par("usr")}), which may carry axis
#' padding unrelated to \code{image()}'s integer cell geometry, whereas the
#' clipped approach stays exact regardless of that padding.
#'
#' @return Invisibly returns the (possibly reordered) matrix used for plotting.
#'
#' @seealso \code{\link[graphics]{image}}, \code{\link[stats]{cor}},
#'   \code{\link{getTheme}}
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
#' plotCor(m, col=pal("red-white-blue-1", 100), border="grey",
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
#' @concept correlation  
#' @concept bivariate
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
    col  = .useTheme,
    grid = .useTheme,
    box  = .useTheme,
    
    # FEATURES
    legend = TRUE,
    text = FALSE,
    
    ...
){
  
  if (identical(col, .useTheme)) {
    twin <- getTheme()$twin
    col  <- colorRampPalette(c(twin[1], "white", twin[2]), space = "rgb")(20)
  }
  
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
    x[upper.tri(x, diag = !diag)] <- NA
  
  if(triangle=="lower")
    x[lower.tri(x, diag = !diag)] <- NA
  
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
    
    # --- grid: cell separators at half-integer matrix boundaries ---
    # NOTE: .drawGrid()/graphics::grid() is not used here - its nx/ny
    # divide the *full plot region* (par("usr")), which may carry axis
    # padding unrelated to image()'s integer cell geometry. The clipped
    # abline() approach below stays independent of that.
    if (!isFALSE(grid) && !is.null(grid) && !isTRUE(suppressWarnings(is.na(grid)))) {
      
      gridSpec <- if (identical(grid, .useTheme) || isTRUE(grid)) list() else grid
      th       <- getTheme()$grid
      
      gridArgs <- utils::modifyList(
        list(col = th$col, lwd = th$lwd, lty = 1),   # lty=1: solid separators,
        gridSpec                                      # not the theme's dotted default
      )
      
      usr <- par("usr")
      clip(0.5, nrow(x) + 0.5, 0.5, ncol(x) + 0.5)
      
      abline(
        h   = seq(0.5, ncol(x) + 0.5, 1),
        v   = seq(0.5, nrow(x) + 0.5, 1),
        col = gridArgs$col,
        lty = gridArgs$lty,
        lwd = gridArgs$lwd
      )
      
      do.call("clip", as.list(usr))
    }
    
    # --- box ---
    .drawBox(box)
    
    
    bedrock::callIf(
      colLegend,
      legend,
      defaults = list(
        labels = sprintf(
          "%.*f",
          digits = round(1 - log10(diff(range(breaks))))
          ,
          breaks[seq(1, length(breaks), 2)]
        ),
        x      = nrow(x) + 0.5 + nrow(x)/20,
        y      = ncol(x) + 0.5,
        width  = nrow(x)/20,
        height = ncol(x),
        col   = col,
        cex    = 0.8
      )
    )
    
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

