
#' Themed Barplot with Grid, Labels and Optional Connecting Lines
#'
#' Creates a themed wrapper around [graphics::barplot()] with
#' support for consistent styling, optional grid lines, value labels,
#' and connecting lines for stacked barplots.
#'
#' The function first initializes the plotting region invisibly using
#' [graphics::barplot()], optionally adds grid lines, and then
#' draws the actual bars and additional layers (axis, connecting lines,
#' text labels).
#'
#' @param height A vector or matrix of bar heights passed directly to
#'   [graphics::barplot()].
#'
#' @param main main title. `NULL` (default) draws none. `""`, `NA` or
#'   `FALSE` also suppress it; the top margin is compacted whenever no
#'   title is drawn.
#' @param xlab,ylab optional axis labels. Defaults follow base graphics
#'   behaviour.
#'
#' @param yax controls drawing of the numeric axis.
#'
#'   Supported values are
#'   \describe{
#'     \item{`TRUE`}{draw axis using package defaults}
#'     \item{`FALSE`}{suppress axis}
#'     \item{`NULL`}{do not draw a numeric axis at all}
#'     \item{`list(...)`}{custom axis parameters passed to the axis drawing routine}
#'   }
#'
#' @param beside logical. If `TRUE`, bars are drawn side-by-side.
#'   If `FALSE` (default), bars are stacked.
#'
#' @param horiz logical. If `TRUE`, bars are drawn horizontally.
#'   Defaults to `FALSE`.
#'
#' @param col bar fill colours. `.useTheme` (default) resolves to
#'   `getTheme()$bar$col` for a vector. For a matrix with several rows,
#'   whose rows are the segments (stacked) or the bars within a group
#'   (`beside = TRUE`), it becomes a ramp from a dark to a light shade of
#'   that color, one per row, so the rows can be told apart.
#' @param border bar border colour. `.useTheme` (default) resolves to
#'   `getTheme()$bar$border`.
#'
#' @param grid controls drawing of grid lines.
#'   Can be:
#'   \itemize{
#'     \item `.useTheme` (default): follow the active theme
#'       (`getTheme()$grid`), restricted to the axis perpendicular to
#'       the value axis (e.g. horizontal lines only for vertical bars)
#'     \item `TRUE`: draw grid with theme settings
#'     \item `FALSE`, `NULL`, or `NA`: suppress grid
#'     \item a named list: arguments passed to [graphics::grid()],
#'       overriding the theme/function defaults for this call only
#'   }
#'
#' @param box controls drawing of the plot box. `.useTheme` (default)
#'   resolves to `getTheme()$box`. `TRUE`/`FALSE`/`NA`,
#'   or a named list, as for `grid`.
#'
#' @param text optional list of arguments passed to [barText()]
#'   to draw value labels on bars.
#'
#' @param legend controls the legend explaining the rows of a matrix.
#'   `TRUE` (default) draws one whenever `height` is a matrix with several
#'   named rows; it is placed in the right margin, which is widened for it
#'   unless `mar` in `...` sets the right side. `FALSE`, `NULL` or `NA`
#'   suppress it. A named list overrides arguments of
#'   [graphics::legend()]; giving `x` there places the legend inside the
#'   plot instead (e.g. `list(x = "topleft")`). Not drawn when
#'   `legend.text` is passed on to [graphics::barplot()].
#'
#' @param connLines optional list of arguments controlling connecting
#'   lines between stacked bars. Only supported when
#'   `beside = FALSE`.
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`,
#'   or an explicit string, as for `.withGraphicsState()` (internal).
#'   
#' @param ... additional arguments passed to [graphics::barplot()]
#'   and graphical parameters (via [graphics::par()]).
#'
#' @details
#' The function internally performs the following steps:
#' \enumerate{
#'   \item Draws an invisible `barplot` to establish the coordinate system.
#'   \item Optionally adds grid lines.
#'   \item Draws the bars.
#'   \item Draws the numeric axis if enabled.
#'   \item Optionally adds connecting lines for stacked bars.
#'   \item Optionally adds value labels via [barText()].
#'   \item Optionally draws a box around the plot region.
#' }
#'
#' Graphical parameters such as `bg`, `cex`, `las`,
#' `mar`, etc. can be supplied via `...`.
#'
#' The precedence of theme-aware settings (`col`, `border`,
#' `grid`, `box`, `stamp`) is
#'
#' \preformatted{
#' explicit argument  >  function-specific default  >  active theme (getTheme())
#' }
#'
#' @return Invisibly returns the midpoints of the bars as returned by
#'   [graphics::barplot()].
#'
#' @seealso [graphics::barplot], [barText], [theme]
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
#'         connLines = list(col = "black"))
#'
#' # a matrix: one shade per row, with a legend
#' plotBar(VADeaths)
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
#'         text = list(col="red", bg=addOpacity("white", 0.7), border=NA))
#' 
#' plotBar(VADeaths, connLines = list(lwd=1, col="blue"), 
#'         box=FALSE, las=1, main="Connecting Lines")
#' 
#' ptab <- proportions(VADeaths, margin=2)
#' plotBar(ptab,
#'         las=1, main="VADeaths in %",
#'         box=FALSE, horiz=TRUE, 
#'         col=(cols <- gray.colors(nrow(VADeaths))),
#'         beside=FALSE,
#'         text = list(labels=fm(ptab, fmt="%"), border=NA, 
#'                     col=contrastCol(cols)))
#' 
#' plotBar(VADeaths/1e3,  box=FALSE, bg="lightyellow", main="VADeaths",
#'         horiz=TRUE, 
#'         text=list(border=FALSE, cex=0.8, col=c("blue", "green","orange")), 
#'         mar=c(right=5), 
#'         yax = list(fmt="%", d=0, big=",", 
#'                    col="red", col.axis="blue", lwd=2))
#' 



#' @family plot.univariate  
#' @concept bar-chart
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
                    col    = .useTheme,
                    border = .useTheme,
                    grid   = .useTheme,
                    box    = FALSE, # .useTheme,
                    
                    # FEATURES
                    text = NULL,
                    legend = TRUE,
                    connLines = NULL,
                    
                    # FRAMEWORK
                    stamp = .useTheme,
                    ...) {
  
  dots  <- list(...)
  
  # NULL, "", NA and FALSE all mean "no title", resolved to "" so that
  # .marTop() compacts the top margin (it reads NULL as a title present)
  main <- .resolveTitle(main)
  
  # A matrix with several rows has segments (stacked) or several bars per
  # group (beside) that must be told apart: the theme's single bar color
  # then becomes a dark-to-light ramp around it, one shade per row.
  byRow <- is.matrix(height) && nrow(height) > 1L
  
  col <- if (identical(col, .useTheme) && byRow)
    .barRamp(.useThemeValue(.useTheme, "bar", "col"), nrow(height))
  else
    .useThemeValue(col, "bar", "col")
  
  border <- .useThemeValue(border, "bar", "border")
  
  # the legend explains the rows; barplot()'s own legend.text replaces it
  legendLabels <- if (byRow) rownames(height)
  if (is.null(legendLabels) || "legend.text" %in% names(dots))
    legend <- FALSE
  
  # placed in the right margin unless the caller gives a position
  legendInMargin <- !(is.list(legend) && !is.null(legend$x))
  
  .withGraphicsState({
    
    
    .applyParFromDots(...,
          defaults=list(
            mar=c(left=5, top=.marTop(main))
      )
    )
    
    # read back the *effective* las (user dots may have changed it via
    # .applyParFromDots); needed below for axis()/margin computation
    las <- par("las")
    
    labels <- .getBarplotAxisLabels(height, dots)
    
    # --- margin-corrections ---
    # only the sides not set by a 'mar' in ... are widened automatically
    userMar <- .userMarSides(dots)

    if (horiz && !"left" %in% userMar && par("yaxt") != "n") {
      .adjustMargin(labels, side = 2)
    }
    if (!horiz && !"bottom" %in% userMar && las == 2 && par("xaxt") != "n") {
      .adjustMargin(labels, side = 1, las = 2)
    }
    
    # room for the legend in the right margin: the widest label plus fill
    # box, spacing and the gap to the plot (about 3 lines together)
    drawLegend <- !(isFALSE(legend) || is.null(legend) || isNA(legend))
    if (drawLegend && legendInMargin && !"right" %in% userMar) {
      textLines <- max(strwidth(legendLabels, units = "inches")) /
        (par("csi") * par("mex"))
      mar <- par("mar")
      mar[4L] <- max(mar[4L], textLines + 3)
      par(mar = mar)
      .checkMargins()
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
    # bars have no continuous scale along the categorical axis, so only
    # the direction perpendicular to the value axis gets gridlines
    .drawGrid(
      grid,
      defaults = list(
        nx = if (horiz) NULL else NA,
        ny = if (horiz) NA   else NULL
      )
    )
    
    # --- echte Balken ---
    barplot(height = height,
            col    = col,
            border = border,
            add    = TRUE,
            axes   = FALSE,
            beside = beside, 
            horiz  = horiz, 
            ...)
    
    # --- Connecting Lines (stacked only) ---
    if (!is.null(connLines)) {
      
      if (isTRUE(beside)) {
        warning("Connecting lines only supported for stacked barplots.")
        
      } else {
        
        bedrock::callIf(
          .drawConnLines,
          connLines,
          defaults = list(
            height = height,
            b      = b,
            horiz  = horiz,
            width  = 1,
            col    = "grey40",
            lwd    = 1,
            lty    = 2
          ),
          forbidden = c("height","b","horiz","width"),
          warn = TRUE
        )
      }
    }
    
    # --- Text Layer ---
    bedrock::callIf(barText,
                    text,
                    defaults = list(
                      height = height,
                      mids   = b,
                      horiz  = horiz,
                      beside = beside,
                      labels = height,
                      pos    = "mid",
                      offset = 0
                    ),
                    forbidden = c("height","mids","horiz", "beside"),
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
    
    
    # --- legend ---
    # Listed in the order the rows appear: top-down for stacked vertical
    # bars, where the last row lies on top, otherwise in row order.
    if (drawLegend) {
      
      ord <- seq_along(legendLabels)
      if (!beside && !horiz)
        ord <- rev(ord)
      
      fill <- rep_len(col, length(legendLabels))
      usr  <- par("usr")
      
      bedrock::callIf(
        graphics::legend,
        legend,
        defaults = .legendDefaults(c(
          if (legendInMargin)
            list(x = usr[2] + 0.02 * diff(usr[1:2]), y = usr[4],
                 xjust = 0, yjust = 1, xpd = NA, bty = "n"),
          list(legend = legendLabels[ord],
               fill   = fill[ord],
               border = if (all(is.na(border))) "grey50" else border)
        ))
      )
    }
    
    # --- box ---
    .drawBox(box, defaults = list(which = "plot"))
    
    
  }, stamp = stamp)
  
  invisible(b)
  
}



# == internal helper functions =======================================
# (.applyFmt, .splitAxisArgs, .drawAxis, .drawConnLines,
#  .getBarplotAxisLabels unverändert)

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
  
  if ("cex" %in% names(axis)) {
    axis$cex.axis <- axis$cex
    axis$cex <- NULL
  }
  
  if ("font" %in% names(axis)) {
    axis$font.axis <- axis$font
    axis$font <- NULL
  }  
  
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



# Sides of the margin set explicitly by the caller via 'mar' in '...'.
# A partial, named spec like mar = c(right = 5) only blocks the sides it
# names; an unnamed (full) or unrecognized spec puts the caller in charge
# of all four sides. Used by the plot functions (plotBar, plotBox) to
# decide whether a margin may still be widened by .adjustMargin().
.userMarSides <- function(dots) {

  sides <- c("bottom", "left", "top", "right")

  if (!"mar" %in% names(dots))
    return(character(0))

  nm <- names(dots$mar)
  if (is.null(nm) || any(!nzchar(nm)) || anyNA(pmatch(nm, sides)))
    return(sides)

  sides[pmatch(nm, sides)]
}



# Dark-to-light ramp around one base color, one shade per row of a
# matrix: from base darkened by 60 % to base lightened by 60 % (for the
# default grey80 roughly grey32 to grey92, the neutral ramp the suite uses
# for unordered category fills elsewhere).
.barRamp <- function(base, n) {
  grDevices::colorRampPalette(c(darken(base, 0.6), lighten(base, 0.6)))(n)
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

