
#' Themed Barplot with Grid, Labels and Optional Connecting Lines
#'
#' Creates a themed wrapper around \code{\link[graphics]{barplot}} with
#' support for consistent styling, optional grid lines, value labels,
#' and connecting lines for stacked barplots.
#'
#' The function first initializes the plotting region invisibly using
#' \code{\link[graphics]{barplot}}, optionally adds grid lines, and then
#' draws the actual bars and additional layers (axis, connecting lines,
#' text labels).
#'
#' @param height A vector or matrix of bar heights passed directly to
#'   \code{\link[graphics]{barplot}}.
#'
#' @param main,xlab,ylab Optional plot labels. Defaults follow
#'   base graphics behaviour.
#'
#' @param yax Controls drawing of the numeric axis.
#'
#'   Supported values are
#'   \describe{
#'     \item{\code{TRUE}}{draw axis using package defaults}
#'     \item{\code{FALSE}}{suppress axis}
#'     \item{\code{NULL}}{use package option \code{DescToolsX.yax}}
#'     \item{\code{list(...)}}{custom axis parameters passed to the axis drawing routine}
#'   }
#'
#' @param beside Logical. If \code{TRUE}, bars are drawn side-by-side.
#'   If \code{FALSE} (default), bars are stacked.
#'
#' @param horiz Logical. If \code{TRUE}, bars are drawn horizontally.
#'   Defaults to \code{FALSE}.
#'
#' @param col Bar fill colours. Defaults to the theme value
#'   \code{bar.col} if not specified.
#'
#' @param border Bar border colour. Defaults to the theme value
#'   \code{bar.border}.
#'
#' @param grid Controls drawing of grid lines.
#'
#'   Supported values are
#'   \describe{
#'     \item{\code{TRUE}}{draw grid using theme defaults}
#'     \item{\code{FALSE}}{suppress grid}
#'     \item{\code{NULL}}{use package option \code{DescToolsX.grid}}
#'     \item{\code{list(...)}}{custom grid parameters such as \code{col}, \code{lty}, \code{lwd}}
#'   }
#'
#' @param box Logical indicating whether a box should be drawn around the
#'   plot region.
#'
#' @param text Optional list of arguments passed to \code{\link{barText}}
#'   to draw value labels on bars.
#'
#' @param connlines Optional list of arguments controlling connecting
#'   lines between stacked bars. Only supported when
#'   \code{beside = FALSE}.
#'
#' @param stamp Logical indicating whether a package stamp should be
#'   drawn. Default is \code{TRUE}.
#'
#' @param ... Additional arguments passed to \code{\link[graphics]{barplot}}
#'   and graphical parameters (via \code{\link[graphics]{par}}).
#'
#' @details
#' The function internally performs the following steps:
#' \enumerate{
#'   \item Draws an invisible \code{barplot} to establish the coordinate system.
#'   \item Optionally adds grid lines.
#'   \item Draws the bars.
#'   \item Draws the numeric axis if enabled.
#'   \item Optionally adds connecting lines for stacked bars.
#'   \item Optionally adds value labels via \code{\link{barText}}.
#'   \item Optionally draws a box around the plot region.
#' }
#'
#' Graphical parameters such as \code{bg}, \code{cex}, \code{las},
#' \code{mar}, etc. can be supplied via \code{...}.
#'
#' The precedence of graphical settings is
#'
#' \preformatted{
#' user arguments  >  DescToolsX theme  >  base defaults
#' }
#'
#' @return Invisibly returns the midpoints of the bars as returned by
#'   \code{\link[graphics]{barplot}}.
#'
#' @seealso \code{\link[graphics]{barplot}}, \code{\link{barText}}
#' 
#' @family topic.graphics
#' @concept base-graphics
#' @concept plotting
#' 
#'
#' @examples
#' # Simple barplot
#' plotBar(1:5)
#'
#' # With grid lines
#' plotBar(1:5, grid = TRUE)
#'
#' # Stacked bars with labels and connecting lines
#' m <- matrix(c(3,2,4,1,5,2), nrow = 2)
#' plotBar(m,
#'         text = list(pos = "mid"),
#'         connlines = list(col = "black"))
#'
#' # Grouped bars
#' plotBar(VADeaths,
#'         beside = TRUE,
#'         col = gray.colors(nrow(VADeaths)))
#'
#' # Horizontal bars
#' plotBar(VADeaths,
#'         horiz = TRUE,
#'         las = 1)
#'         
#'         
#' plotBar(VADeaths, ylim=c(0,250),
#'         grid=list(col = "grey", lty="dotted"), 
#'         las=1, main="MyTitle", 
#'         text = list(labels=VADeaths, 
#'         border = NA, srt=45, bg="navajowhite"))
#'
#' plotBar(VADeaths, ylim=c(0,80),
#'         las=1, main="MyTitle",
#'         box=FALSE, 
#'         col=gray.colors(nrow(VADeaths)),
#'         beside=TRUE, 
#'         text = list(col="red", bg=addAlpha("white", 0.7), border=NA))
#' 
#' plotBar(VADeaths, connlines = list(lwd=1, col="blue"), 
#'         box=FALSE, las=1, main="Connecting Lines")
#' 
#' ptab <- proportions(VADeaths, margin=2)
#' plotBar(ptab,
#'         las=1, main="VADeaths in %",
#'         box=FALSE, horiz=TRUE, 
#'         col=(cols <- gray.colors(nrow(VADeaths))),
#'         beside=FALSE, mar=c(right=5),
#'         text = list(labels=fm(ptab, fmt="%"), border=NA, 
#'                     col=contrastColor(cols)))
#' legend(x="right", fill=cols, legend=rownames(VADeaths))
#' 
#' plotBar(VADeaths/1e3,  box=FALSE, bg="lightyellow", main="VADeaths",
#'         horiz=TRUE, 
#'         text=list(border=FALSE, cex=0.8, col=c("blue", "green","orange")), 
#'         mar=c(right=5), 
#'         yax = list(fmt="%", d=0, big=",", 
#'                    col="red", col.axis="blue", lwd=2))
#' 



# Principle for the plot part of aurora:
# * User arguments override theme
# * Theme overrides base defaults
# .apply pars describe!!*********


#' @family plot.univariate
#' @concept graphics
#' @concept descriptive-statistics
#' @concept frequency-analysis
#'
#'
#' @export
plotBar <- function(height,
                    
                    # LABELS
                    main = NULL,
                    xlab = NULL,
                    ylab = NULL,                    

                    # AXES
                    yax = NULL,
                    
                    # STRUCTURE
                    beside = FALSE,
                    horiz  = FALSE,
                    
                    # STYLE
                    col = NULL,
                    border = NULL,
                    grid = NULL,
                    box=FALSE,
                    
                    # FEATURES
                    text = NULL,
                    connlines = NULL,
                    
                    # FRAMEWORK
                    stamp = TRUE,
                    ...) {

  th <- .theme(
    bar = list(col=col, border=border)
  )
  col <- th$col
  border <- th$border

  dots  <- list(...)
  
  .withGraphicsState({
    
        
    # par() aus ...
    .applyParFromDots(...)

    # set by .applyParFromDots(...) and needed afterwards...
    las   <- par("las")
    
    labels <- .getBarplotAxisLabels(height, dots)
    
    # --- margin-corrections ---
    if (horiz && !(par("yaxt")=="n")) {
      .adjustMargin(labels, side=2)
      # .adjustLeftMarginForLabels(labels)
    }
    
    if (!horiz && las == 2 && !(par("xaxt")=="n")) {
      .adjustMargin(labels, side=1, las=2)
      # .adjustBottomMarginForLas2(labels)
    }
    
    # --- Setup (invisible) ---
    dots[c("col", "border", "axes")] <- NULL
    b <- do.call(barplot, c(list(
                     height = height, 
                     col    = NA, 
                     border = NA, 
                     axes   = FALSE,
                     main   = main, 
                     xlab   = xlab, 
                     ylab   = ylab,
                     beside = beside,
                     horiz  = horiz
                     ), 
                     dots))

    # --- GRID Layer ---
    if (!is.null(grid)) {
      
      if(isTRUE(grid))
        grid <- NULL
      
      grid <- mergeArgs(
        defaults = list(
          horiz = horiz,
          col   = "grey85",
          lty   = 1,
          lwd   = 1
        ),
        user = grid,
        forbidden = c("horiz"),
        warn = TRUE
      )
      
      if (!horiz) {
        abline(h = axTicks(2),
               col = grid$col,
               lty = grid$lty,
               lwd = grid$lwd)
      } else {
        abline(v = axTicks(1),
               col = grid$col,
               lty = grid$lty,
               lwd = grid$lwd)
      }
    }
    
    # --- echte Balken ---
    barplot(height = height,
            col    = col,
            border = border,
            add    = TRUE,
            axes   = FALSE,
            beside = beside, 
            horiz  = horiz, 
            ...)
    
    # --- Zero-Linie nach Balken ---
    # ******* ???? do we need a zero line ???? ************
    
    # usr <- par("usr")
    # 
    # if (!horiz) {
    #   if (!par("ylog") && usr[3] <= 0 && usr[4] >= 0) {
    #     abline(h = 0, lwd = 1.5)
    #   }
    # } else {
    #   if (!par("xlog") && usr[1] <= 0 && usr[2] >= 0) {
    #     abline(v = 0, lwd = 1.5)
    #   }
    # }
    
    # --- Connecting Lines (stacked only) ---
    if (!is.null(connlines)) {
      
      if (isTRUE(beside)) {
        warning("Connecting lines only supported for stacked barplots.")
        
      } else {
        
        # width <- dots$width %||% 1
        
        if(isTRUE(connlines))
          connlines <- NULL
        
        connlines <- mergeArgs(
          defaults = list(
            height = height,
            b      = b,
            horiz  = horiz,
            width  = 1,
            col    = "grey40",
            lwd    = 1,
            lty    = 2
          ),
          user = connlines,
          forbidden = c("height","b","horiz","width"),
          warn = TRUE
        )
        
        do.call(.drawConnLines, connlines)
      }
    }
    
    # --- Text Layer ---
    bedrock::callIf(barText,
            text,
            defaults = list(
                height = height,
                b      = b,
                horiz  = horiz,
                beside = beside,
                labels = height,
                pos    = "mid",
                offset = 0
              ),
              forbidden = c("height","b","horiz", "beside"),
              warn = TRUE
            )

    
    # --- numeric axis ---
    if (!isFALSE(yax)) {
      
      if (!horiz) {
        .drawAxis(2, yax)
      } else {
        .drawAxis(1, yax)
      }
    }    

        
    # draw box if box != FALSE || NA
    bedrock::callIf(graphics::box, 
            box,
            defaults=list(which="plot"))
    
    
  }, stamp = stamp)
  
  invisible(b)
  
}



# == internal helper functions =======================================

.applyFmt <- function(x, fmt) {
  
  if (is.null(fmt))
    return(x)
  
  if (isTRUE(fmt))
    return(fm(x))
  
  if (is.function(fmt))
    return(fmt(x))
  
  do.call(fm, modifyList(list(x = x), fmt))
}



.splitAxisArgs <- function(ax) {
  
  if (is.null(ax))
    return(list(fmt = NULL, axis = NULL))
  
  fm_names <- names(formals(fm))
  
  # axis + par-Achsenparameter erlauben
  axis_names <- unique(c(
    names(formals(graphics::axis)),
    grep("\\.axis$", names(par()), value = TRUE),
    "col", "lwd", "lty", "tck", "las", "cex", "font"
  ))
  
  fmt  <- ax[names(ax) %in% fm_names]
  axis <- ax[names(ax) %in% axis_names]
  
  axis <- axis[names(axis) != "labels"]
  
  # intuitive interpretation
  # col is the color of the axis labels, col.axis the one of the axis
  has_col      <- "col" %in% names(axis)
  has_col_axis <- "col.axis" %in% names(axis)

  if (has_col && has_col_axis){
    tmp <- axis$col.axis
    axis$col.axis <- axis$col
    axis$col <- tmp
  }

  
  if (has_col && !has_col_axis){
    axis$col.axis <- axis$col
    axis$col <- par("col.axis")
  }
  
  if (!has_col && has_col_axis){
    axis$col <- axis$col.axis
    axis$col.axis <- par("col")
  }
  
  if("cex" %in% names(axis))
    axis$cex.axis <- axis$cex
  
  if("font" %in% names(axis))
    axis$font.axis <- axis$font
  
  
  list(fmt = fmt, axis = axis)
}



.drawAxis <- function(side, ax) {
  
  at <- axTicks(side)
  
  sp <- .splitAxisArgs(ax)
  
  labs <- if (length(sp$fmt)) {
    do.call(fm, modifyList(list(x=at), sp$fmt))
  } else {
    at
  }
  
  do.call(
    graphics::axis,
    c(list(side=side, at=at, labels=labs), sp$axis)
  )
}


.drawGridY <- function(horiz, col, lty, lwd, ...) {
  abline(h = axTicks(2), col = col, lty = lty, lwd = lwd, ...)
}
.drawGridX <- function(horiz, col, lty, lwd, ...) {
  abline(v = axTicks(1), col = col, lty = lty, lwd = lwd, ...)
}


.drawConnLines <- function(height, b, horiz = FALSE,
                          width = 1,
                          col = 1, lwd = 1, lty = 2, ...) {
  
  if (!is.matrix(height)) {
    warning("Connecting lines only supported for stacked barplots.")
    return(invisible())
  }
  
  cumh <- apply(height, 2, cumsum)
  
  nc <- ncol(height)
  nr <- nrow(height)
  
  # width kann Vektor oder Skalar sein
  if (length(width) == 1)
    width <- rep(width, nc)
  
  left  <- b - width/2
  right <- b + width/2
  
  for (i in seq_len(nr)) {
    
    if (!horiz) {
      # vertikal: Linie von rechtem Rand zur linken nächsten Bar
      
      x0 <- right[-nc]
      x1 <- left[-1]
      y0 <- cumh[i, -nc]
      y1 <- cumh[i, -1]
      
      segments(x0, y0, x1, y1,
               col = col, lwd = lwd, lty = lty, ...)
      
    } else {
      # horizontal
      
      y0 <- right[-nc]
      y1 <- left[-1]
      x0 <- cumh[i, -nc]
      x1 <- cumh[i, -1]
      
      segments(x0, y0, x1, y1,
               col = col, lwd = lwd, lty = lty, ...)
    }
  }
  
  invisible()
}



.getBarplotAxisLabels <- function(height, dots) {
  
  if (!is.null(dots$names.arg))
    return(dots$names.arg)
  
  if (is.matrix(height)) {
    labs <- colnames(height)
    if (!is.null(labs))
      return(labs)
  }
  
  names(height)
}

