
#' Heatmap for Categorical Data
#'
#' Visualizes a contingency table using a heatmap representation. Cell values
#' are mapped to colors based on counts or proportions, optionally with text
#' labels overlaid.
#'
#' @param x a contingency table, matrix, or a pair of categorical vectors
#'   coercible via [table()].
#'
#' @param main main title of the plot. `NULL` (default) derives a
#'   title from the expression passed as `x` (via
#'   `deparse(match.call()$x)`), the same "substitute magic"
#'   convention used by [plotXY()]/[plotBox()]/
#'   [plotAssoc()] for their default titles - there's no
#'   formula pair here, just the single table argument, so the default
#'   is simply that expression's text (e.g. `plotHeatmap(tab)`
#'   titles itself `"tab"`). `""`, `NA`, or `FALSE`
#'   suppress the title entirely and compact the top margin; any other
#'   string is used as given (resolved internally via
#'   `.resolveTitle()`).
#' @param xlab label for the x-axis.
#' @param ylab label for the y-axis.
#'
#' @param xlim,ylim numeric vectors of length 2 specifying axis limits.
#'
#' @param scale character specifying how values are computed:
#'   \describe{
#'     \item{`"count"`}{absolute frequencies}
#'     \item{`"prop"`}{joint proportions \eqn{P(X, Y)}}
#'     \item{`"row"`}{row-wise proportions \eqn{P(Y \mid X)}}
#'     \item{`"col"`}{column-wise proportions \eqn{P(X \mid Y)}}
#'   }
#'
#' @param col optional vector of colors. Default is a hardcoded sequential
#'   white-to-navy ramp (`pal("Blues", n = 100)`) - deliberately not
#'   theme-driven: cell values here are sequential (one direction, no sign
#'   change), unlike the active theme's categorical `palette` or
#'   diverging `twin` pair, neither of which fits a heat scale.
#'
#' @param border color of tile borders. Defaults to `NA`.
#' @param naCol color used for missing values.
#'
#' @param text logical; if `TRUE`, cell values are printed on top of
#'   the tiles using `fm()` formatting.
#'
#' @param zlim numeric vector of length 2 specifying the range used for
#'   color scaling. If `NULL`, the range of the data is used.
#'
#' @param box controls drawing of the outer frame around the tile grid,
#'   drawn via `rect()` at the exact cell boundaries rather than
#'   [graphics::box()] (the initial plot suppresses the
#'   standard box via `frame.plot = FALSE`, since cell bounds differ
#'   from the default plot region). `.useTheme` (default) resolves
#'   border color/width from `getTheme()$box`. `TRUE`/`FALSE`,
#'   or a named list overriding `rect()` arguments for this call only.
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/
#'   `NULL`, or an explicit string, as for
#'   `.withGraphicsState()` (internal).
#'
#' @param ... further graphical parameters passed to
#'   [graphics::par()] via the internal framework.
#'
#' @details
#' The heatmap represents values in a contingency table using color intensity.
#' Depending on `scale`, the plot shows either absolute counts or different
#' types of proportions. Rows are drawn in reading order: the first table row
#' appears at the top, matching the printed table and the other bivariate
#' plots. This plot complements association and spine plots by
#' focusing on overall structure rather than conditional distributions or
#' statistical inference.
#'
#' @return Invisibly returns the matrix used for plotting.
#'
#' @seealso [plotAssoc()], [graphics::image()],
#'   [theme]
#'
#' @examples
#' \dontrun{
#' tab <- table(UCBAdmissions)
#'
#' plotHeatmap(tab,
#'             scale = "prop",
#'             text = TRUE)
#' }
#'



#' @family plot.bivariate  
#' @concept bivariate
#'
#'
#' @export
plotHeatmap <- function(
    # DATA
    x,

    # LABELS
    main = NULL,
    xlab = "",
    ylab = "",

    # AXES
    xlim = NULL,
    ylim = NULL,
    zlim = NULL,

    # STATISTICS
    scale = c("count", "prop", "row", "col"),

    # STYLE
    col    = .useTheme,
    border = NA,
    naCol  = "gray90",
    box    = .useTheme,

    # FEATURES
    text = FALSE,

    # FRAMEWORK
    stamp = .useTheme,

    ...
) {
  
  # Default title follows the same "substitute magic" convention as
  # plotXY()/plotBox()/plotAssoc() (deparse() of the call's argument
  # expression) - there's no y ~ x formula pair here, just the single
  # table argument 'x', so the default is simply deparse(mc$x) (e.g.
  # plotHeatmap(tab) titles itself "tab").
  mc <- match.call()
  
  .withGraphicsState({
    
    # --- Input ------------------------------------------------------------
    
    if (!is.matrix(x) && !is.table(x))
      x <- table(x)
    
    tab <- as.matrix(x)
    
    if (length(dim(tab)) != 2L)
      stop("Only 2D tables supported.")
    
    scale <- match.arg(scale)
    
    main <- .resolveTitle(main, default = deparse(mc$x))
    
    # --- Scaling ----------------------------------------------------------
    
    z <- switch(
      scale,
      count = tab,
      prop  = prop.table(tab),
      row   = prop.table(tab, 1),
      col   = prop.table(tab, 2)
    )
    
    nr <- nrow(z)
    nc <- ncol(z)
    
    # --- Margins ----------------------------------------------------------
    
    lmar <- max(
      2.1,
      .marginLines(
        rownames(z),
        side = 2,
        las = 1,
        pad = 1
      )
    )
    
    bmar <- max(
      4.1,
      .marginLines(
        colnames(z),
        side = 1,
        pad = 1
      )
    )
    
    .applyParFromDots(
      ...,
      defaults = list(
        mar = c(
          bottom = bmar,
          left   = lmar,
          top    = .marTop(main),
          right  = 2.1
        )
      )
    )
    
    # --- Limits -----------------------------------------------------------
    
    if (is.null(zlim))
      zlim <- range(z, na.rm = TRUE)
    
    if (diff(zlim) == 0)
      zlim <- zlim + c(-0.5, 0.5)
    
    # --- Colors -----------------------------------------------------------
    
    if (identical(col, .useTheme)) {
      cols_all <- pal("steelblue-white", n = 100)
      ncol_pal <- length(cols_all)
    } else {
      cols_all <- col
      ncol_pal <- length(col)
    }
    
    z_scaled <- (z - zlim[1]) / diff(zlim)
    z_scaled[is.na(z_scaled)] <- NA
    
    idx <- ceiling(
      z_scaled * (ncol_pal - 1)
    ) + 1
    
    idx[idx < 1] <- 1
    idx[idx > ncol_pal] <- ncol_pal
    
    cols <- matrix(
      cols_all[idx],
      nrow = nrow(z)
    )
    
    cols[is.na(z)] <- naCol
    
    # --- Coordinates ------------------------------------------------------
    
    xpos <- seq_len(nc)
    # Leserichtung: Zeile 1 der Tabelle liegt OBEN (wie print(tab) und
    # die uebrigen bivariaten Plots), nicht unten wie in der
    # Standard-y-Orientierung - ypos[i] ist das y-Zentrum von Zeile i.
    ypos <- rev(seq_len(nr))
    
    plot(
      NA,
      xlim = xlim %||% c(0.5, nc + 0.5),
      ylim = ylim %||% c(0.5, nr + 0.5),
      xaxt = "n",
      yaxt = "n",
      xlab = xlab,
      ylab = ylab,
      main = main,
      frame.plot = FALSE
    )
    
    # --- Draw tiles -------------------------------------------------------
    
    for (i in seq_len(nr)) {
      
      for (j in seq_len(nc)) {
        
        rect(
          j - 0.5,
          ypos[i] - 0.5,
          j + 0.5,
          ypos[i] + 0.5,
          col = cols[i, j],
          border = border
        )
        
      }
      
    }
    
    
    # --- Outer frame --------------------------------------------------
    # NOTE: rect() at exact cell boundaries, not graphics::box()/.drawBox() -
    # the initial plot() call suppresses the standard box (frame.plot=FALSE)
    # since the cell grid extends 0.5 beyond the nominal plot region.
    
    boxSpec <- .resolveToggle(box, getTheme()$box)
    
    if (!isFALSE(boxSpec)) {
      
      boxTheme <- getTheme()$box
      
      bedrock::callIf(
        rect,
        boxSpec,
        defaults = list(
          xleft   = 0.5,
          ybottom = 0.5,
          xright  = nc + 0.5,
          ytop    = nr + 0.5,
          border  = boxTheme$col,
          lwd     = boxTheme$lwd,
          col     = NA
        )
      )
      
    }
    
    # --- Text overlay -----------------------------------------------------
    
    if (isTRUE(text)) {
      
      lab <- if (scale == "count") {
        fm(z, fmt = "abs.sty")
      } else {
        fm(z, fmt = "per.sty")
      }
      
      for (i in seq_len(nr)) {
        
        for (j in seq_len(nc)) {
          
          if (!is.na(z[i, j])) {
            
            graphics::text(
              x = j,
              y = ypos[i],
              labels = lab[i, j]
            )
            
          }
          
        }
        
      }
      
    }
    
    # --- Labels only (no axes) -------------------------------------------
    
    mtext(
      side = 1,
      text = colnames(z),
      at = xpos,
      line = 1
    )
    
    mtext(
      side = 2,
      text = rownames(z),
      at = ypos,
      las = 1,
      line = 1
    )
    
  }, stamp = stamp)
  
  invisible(z)
  
}

