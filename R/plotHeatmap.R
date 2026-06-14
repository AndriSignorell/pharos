
#' Heatmap for Categorical Data
#'
#' Visualizes a contingency table using a heatmap representation. Cell values
#' are mapped to colors based on counts or proportions, optionally with text
#' labels overlaid.
#'
#' @param x a contingency table, matrix, or a pair of categorical vectors
#'   coercible via \code{\link{table}}.
#'
#' @param main main title of the plot.
#' @param xlab label for the x-axis.
#' @param ylab label for the y-axis.
#'
#' @param xlim,ylim numeric vectors of length 2 specifying axis limits.
#'
#' @param scale character specifying how values are computed:
#'   \describe{
#'     \item{\code{"count"}}{absolute frequencies}
#'     \item{\code{"prop"}}{joint proportions \eqn{P(X, Y)}}
#'     \item{\code{"row"}}{row-wise proportions \eqn{P(Y \mid X)}}
#'     \item{\code{"col"}}{column-wise proportions \eqn{P(X \mid Y)}}
#'   }
#'
#' @param col optional vector of colors. If \code{NULL}, a sequential
#'   blue palette is used.
#'
#' @param border color of tile borders. Defaults to \code{NA}.
#' @param naCol color used for missing values.
#'
#' @param text logical; if \code{TRUE}, cell values are printed on top of
#'   the tiles using \code{fm()} formatting.
#'
#' @param zlim numeric vector of length 2 specifying the range used for
#'   color scaling. If \code{NULL}, the range of the data is used.
#'
#' @param ... further graphical parameters passed to
#'   \code{\link[graphics]{par}} via the internal framework.
#'
#' @details
#' The heatmap represents values in a contingency table using color intensity.
#' Depending on \code{scale}, the plot shows either absolute counts or different
#' types of proportions. This plot complements association and spine plots by
#' focusing on overall structure rather than conditional distributions or
#' statistical inference.
#'
#' @return Invisibly returns the matrix used for plotting.
#'
#' @seealso \code{\link{plotAssoc}}, \code{\link[graphics]{image}}
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
#' @concept graphics
#' @concept descriptive-statistics
#' @concept table-manipulation
#'
#'
#' @export
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
  
  # STRUCTURE
  scale = c("count", "prop", "row", "col"),
  
  # STYLE
  col = NULL,
  border = NA,
  naCol = "gray90",
  
  # FEATURES
  text = FALSE,
  zlim = NULL,
  box = TRUE,
  
  ...
  
) {
  
  .withGraphicsState({
    
    # --- Input ------------------------------------------------------------
    
    if (!is.matrix(x) && !is.table(x))
      x <- table(x)
    
    tab <- as.matrix(x)
    
    if (length(dim(tab)) != 2L)
      stop("Only 2D tables supported.")
    
    scale <- match.arg(scale)
    
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
    
    if (is.null(col)) {
      
      pal <- colorRampPalette(
        c("#F7FBFF", "#08306B")
      )
      
      ncol_pal <- 100L
      cols_all <- pal(ncol_pal)
      
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
    ypos <- seq_len(nr)
    
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
          i - 0.5,
          j + 0.5,
          i + 0.5,
          col = cols[i, j],
          border = border
        )
        
      }
      
    }
    
    
    # --- Draw tiles -------------------------------------------------------
    
    if (!isFALSE(box)) {
      
      bedrock::callIf(
        rect,
        box,
        defaults = list(
          xleft   = 0.5,
          ybottom = 0.5,
          xright  = nc + 0.5,
          ytop    = nr + 0.5,
          border  = "grey50",
          lwd     = 1,
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
              y = i,
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
    
  })
  
  invisible(z)
  
}

