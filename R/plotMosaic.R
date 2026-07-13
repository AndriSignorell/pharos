
#' Compute Mosaic Tile Geometry for 2-Way Tables
#'
#' Internal geometry engine for [plotMosaic()]. Computes rectangular tile
#' coordinates for a mosaic plot from a 2-way contingency table, using a
#' spine-plot-style proportional split: the first table dimension determines
#' tile widths (x-axis), the second dimension determines the conditional
#' heights within each resulting column.
#'
#' @param x a 2-way contingency table, matrix, or array coercible via
#'   `as.table()`. Higher-dimensional arrays must be collapsed first, e.g.
#'   via `apply(x, c(1,2), sum)`.
#' @param swap logical. If `TRUE`, the two dimensions of `x` are transposed
#'   before computing tile geometry, swapping which variable determines the
#'   x-axis split and which determines the fill/conditional split.
#'   Default `FALSE`.
#'   
#' @return A `data.frame` with one row per tile and the columns:
#'   \describe{
#'     \item{`<rowVar>`, `<colVar>`}{factor levels of the first and second
#'       table dimension, named after `dimnames(x)` (or `Var1`/`Var2` if
#'       unnamed)}
#'     \item{`x0`, `x1`}{left/right tile boundaries in `[0, 1]`}
#'     \item{`y0`, `y1`}{bottom/top tile boundaries in `[0, 1]`}
#'     \item{`n`}{absolute cell frequency}
#'     \item{`p`}{cell frequency as proportion of the table total}
#'     \item{`pCond`}{cell frequency as proportion of its row total}
#'   }
#'   The `varNames` attribute holds the names of the two table dimensions.
#'
#' @details Rows of `x` with a row total of zero produce tiles of height
#'   zero (`y0 == y1`, `pCond == 0`) rather than `NaN`, so empty categories
#'   do not propagate missing values into the geometry.
#'
#' @examples
#' tiles <- .computeMosaicTiles(apply(HairEyeColor, c(1, 2), sum))
#' sum(tiles$p)
#'
#'
#' @noRd
.computeMosaicTiles <- function(x, swap = FALSE) {
  
  x <- as.table(x)
  if (length(dim(x)) != 2L) {
    stop("'.computeMosaicTiles' currently supports 2-way tables only. ",
         "Collapse higher-dimensional arrays first, e.g. via apply(x, c(1,2), sum).")
  }
  
  if (swap) x <- t(x)
  
  dn <- dimnames(x)
  varNames <- names(dn)
  if (is.null(varNames) || any(varNames == "")) {
    varNames <- c("Var1", "Var2")
  }
  
  total     <- sum(x)
  rowTotals <- unname(rowSums(x))
  
  # x-Achse: Breiten proportional zu Zeilen-Randsummen
  width <- rowTotals / total
  x1 <- cumsum(width)
  x0 <- x1 - width
  
  out <- vector("list", nrow(x))
  
  for (i in seq_len(nrow(x))) {
    
    rowTotal  <- rowTotals[i]
    rowCounts <- unname(x[i, ])
    height    <- if (rowTotal > 0) rowCounts / rowTotal else rep(0, ncol(x))
    y1 <- cumsum(height)
    y0 <- y1 - height
    
    out[[i]] <- data.frame(
      row   = dn[[1]][i],
      col   = dn[[2]],
      x0    = x0[i], x1 = x1[i],
      y0    = y0,    y1 = y1,
      n     = rowCounts,
      p     = rowCounts / total,
      pCond = height,
      stringsAsFactors = FALSE
    )
  }
  
  tiles <- do.call(rbind, out)
  names(tiles)[1:2] <- varNames
  rownames(tiles) <- NULL
  attr(tiles, "varNames") <- varNames
  
  tiles
}


## ---- Rendering -------------------------------------------------------------

#' Mosaic Plot for 2-Way Contingency Tables
#'
#' Draws a mosaic plot (spine plot) for a 2-way contingency table, with
#' proportional tile areas, optional cell labels (counts or percentages),
#' and a "Few"-style minimal appearance (white tile separators, muted
#' palette, optional legend).
#'
#' @param x a 2-way contingency table, matrix, or array coercible via
#'   `as.table()`. Higher-dimensional arrays must be collapsed first, e.g.
#'   via `apply(x, c(1,2), sum)`.
#' @param main character. Plot title. Default `""` (no title).
#' @param xlab,ylab character or `NULL`. Axis labels. Default `NULL`
#'   (no labels), since the category levels together with `main` and the
#'   legend title are usually self-explanatory.
#' @param swap logical. If `TRUE`, transpose the two dimensions of `x`
#'   before plotting, so the second table dimension determines the x-axis
#'   split and the first becomes the fill/legend variable. Default `FALSE`.
#' @param horiz logical. If `TRUE`, draw the mosaic horizontally: the first
#'   table dimension is shown top-to-bottom on the y-axis instead of
#'   left-to-right on the x-axis. Default `FALSE`.
#' @param gap numeric. Width of the white separator drawn between adjacent
#'   tiles, in plot-region units (`[0, 1]`). Default `0.01`.
#' @param col vector of colors for the fill/legend variable (the second
#'   table dimension, or first if `swap = TRUE`). `.useTheme` (default)
#'   resolves to `pal(getTheme()$palette, n = <number of levels>)` - the
#'   active theme's qualitative palette (see [theme]),
#'   sampled or interpolated to match the number of category levels.
#'   A diverging or sequential color ramp is deliberately not used here:
#'   the fill variable is an unordered categorical variable, and a ramp
#'   would visually suggest an ordering between levels that doesn't exist.
#' @param border color of the tile borders. Default `"white"`.
#' @param legend logical. Draw a legend for the fill variable.
#'   Default `TRUE`.
#' @param labels character, one of `"p"`, `"n"`, `"none"`. Cell labels
#'   showing the proportion of the table total (`"p"`), the absolute
#'   frequency (`"n"`), or no labels (`"none"`). Labels are only drawn for
#'   tiles large enough to hold them. Default `"p"`.
#' @param labCex numeric. Character expansion factor for cell labels.
#'   Default `0.8`.
#' @param labDigits integer. Number of decimal digits for percentage cell
#'   labels when `labels = "p"`. Default `1`.
#' @param stamp controls the corner stamp. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$stamp}. \code{TRUE}/\code{FALSE}/
#'   \code{NULL}, or an explicit string, as for
#'   \code{.withGraphicsState()} (internal).
#' @param ... further graphical parameters passed to `par()` via
#'   `.applyParFromDots()`, e.g. `mar`, `cex.axis`, `las`.
#'
#' @return Invisibly, the `data.frame` of tile geometry as produced by
#'   `.computeMosaicTiles()`, with columns `x0`, `x1`, `y0`, `y1`, `n`, `p`,
#'   `pCond` and one column per table dimension. This allows users to add
#'   further annotations (e.g. via `rect()` or `text()`) on top of the plot.
#'
#' @details Cells belonging to a row with a row total of zero are drawn as
#'   zero-height tiles and receive no label, but do not cause an error or
#'   `NaN` in the geometry.
#'
#' When `horiz = TRUE`, only the first table dimension (shown on the y-axis)
#' receives an axis, since its split points are constant across the whole
#' plot. The second dimension's split points vary by row/column and is
#' represented via the legend only.
#'
#' @examples
#' tab <- apply(HairEyeColor, c(1, 2), sum)
#'
#' plotMosaic(tab)
#' plotMosaic(tab, swap = TRUE)
#' plotMosaic(tab, horiz = TRUE, main = "Hair ~ Eyecolor")
#'
#' @seealso [plotCatDist()], [plotBar()], [getTheme()]
#'
#'

#' @family plot.bivariate  
#' @concept frequency-table  
#' @concept bivariate
#'
#'
#' @export
plotMosaic <- function(x,
                       # LABELS
                       main      = "",
                       xlab      = NULL,
                       ylab      = NULL,
                       
                       # STRUCTURE
                       swap      = FALSE,
                       horiz     = FALSE,
                       gap       = 0.01,
                       
                       # STYLE
                       col       = .useTheme,
                       border    = "white",
                       
                       # FEATURES
                       legend    = TRUE,
                       labels    = c("p", "n", "none"),
                       labCex    = 0.8,
                       labDigits = 1,
                       
                       # FRAMEWORK
                       stamp = .useTheme,
                       
                       ...) {
  
  labels <- match.arg(labels)
  tiles  <- .computeMosaicTiles(x, swap = swap)
  varNames <- attr(tiles, "varNames")
  rowVar <- varNames[1]; colVar <- varNames[2]
  
  rowLevels <- unique(tiles[[rowVar]])
  colLevels <- unique(tiles[[colVar]])
  
  # horiz: x<->y vertauschen + vertikal spiegeln,
  # sodass die erste Kategorie oben liegt (analog DescTools-Layout)
  if (horiz) {
    tiles[c("x0", "x1", "y0", "y1")] <-
      list(tiles$y0, tiles$y1, 1 - tiles$x1, 1 - tiles$x0)
  }
  
  if (identical(col, .useTheme))
    col <- pal(getTheme()$palette, n = length(colLevels))
  
  fillCol <- col[match(tiles[[colVar]], colLevels)]

  lmar <- max(
    5.1,
    .marginLines(if(horiz) rowLevels else colLevels, 
                 side = 2, las = 1, pad = 1)
  )
  
  
  .withGraphicsState({
    
    .applyParFromDots(..., 
                      defaults = list(
                          mar = c(if (horiz) 1 else 3, 
                                  lmar, 
                                  .marTop(main), 
                                  if (legend) 6 else 1)
                        ))
    
    plot.new()
    plot.window(xlim = c(0, 1), ylim = c(0, 1), xaxs = "i", yaxs = "i")
    
    # Gaps nur fürs Zeichnen, Geometrie bleibt exakt proportional
    # TODO: Clamping falls gap > kleinste Tile-Dimension
    rect(tiles$x0 + gap/2, tiles$y0 + gap/2,
         tiles$x1 - gap/2, tiles$y1 - gap/2,
         col = fillCol, border = border, lwd = 1)
    
    if (labels != "none") {
      labTxt <- switch(labels,
                       n = fm(tiles$n,             digits = 0,         sciThreshold = Inf),
                       p = paste0(fm(tiles$p * 100, digits = labDigits, sciThreshold = Inf), "%")
      )
      
      show <- (tiles$x1 - tiles$x0) > 0.03 &
        (tiles$y1 - tiles$y0) > 0.03 &
        tiles$n > 0
      
      text((tiles$x0 + tiles$x1)[show] / 2,
           (tiles$y0 + tiles$y1)[show] / 2,
           labels = labTxt[show], cex = labCex)
    }
    
    if (horiz) {
      # y-Achse: rowVar an Tile-Zentren (eindeutig, erste Splitdimension)
      rowInfo <- unique(tiles[c(rowVar, "y0", "y1")])
      axis(2, at = (rowInfo$y0 + rowInfo$y1) / 2,
           labels = rowInfo[[rowVar]], tick = FALSE, las = 1)
      # colVar: Splits variieren je Zeile -> keine Achse, nur Legende
    } else {
      rowInfo <- unique(tiles[c(rowVar, "x0", "x1")])
      axis(1, at = (rowInfo$x0 + rowInfo$x1) / 2,
           labels = rowInfo[[rowVar]], tick = FALSE, las = 1)
      axis(2, las = 1)
    }
    
    if (legend) {
      legend(x = 1, y = 1, legend = colLevels, fill = col,
             bty = "n", xpd = TRUE, xjust = 0, yjust = 1, title = colVar)
    }
    
    title(main = main, xlab = xlab, ylab = ylab)
  }, stamp=stamp)
  
  invisible(tiles)
}
