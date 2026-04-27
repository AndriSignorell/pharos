
#' Association Plot for Categorical Data
#'
#' Visualizes the association between two categorical variables based on a
#' contingency table. Cell-wise deviations from independence are represented
#' by rectangles whose size and color reflect the magnitude and direction of
#' Pearson residuals from a chi-squared test.
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
#' @param margin character, either \code{"row"} or \code{"col"}.
#'   Currently reserved for future extensions.
#'
#' @param reorder logical; if \code{TRUE}, rows and columns are reordered by
#'   marginal frequencies (largest first) to improve visual structure.
#'
#' @param cutoff numeric; minimum absolute Pearson residual required for a
#'   cell to be displayed. Cells with \code{|residual| < cutoff} are omitted.
#'   A value of \code{2} corresponds approximately to statistical significance.
#'
#' @param col optional matrix of colors for the cells. If \code{NULL},
#'   a diverging palette (blue–white–red) is used based on standardized
#'   residuals.
#'
#' @param border color of rectangle borders. Defaults to \code{NA}.
#'
#' @param grid logical; if \code{TRUE}, a grid is added to the plot.
#' @param box logical; if \code{TRUE}, a box is drawn around the plot.
#'
#' @param legend logical; if not \code{FALSE}, a simple legend is added.
#'
#' @param stamp optional annotation passed to the plotting framework.
#'
#' @param ... further graphical parameters passed to
#'   \code{\link[graphics]{par}} via the internal framework.
#'
#' @details
#' The plot is based on Pearson residuals from a chi-squared test of
#' independence. For each cell:
#' \itemize{
#'   \item Rectangle \strong{area} is proportional to the magnitude of the residual.
#'   \item Rectangle \strong{color} indicates direction (negative vs positive)
#'   and strength of deviation.
#' }
#'
#' This function provides a flexible alternative to
#' \code{\link[graphics]{assocplot}}, with full control over styling and layout.
#'
#' @return Invisibly returns the matrix of Pearson residuals.
#'
#' @seealso \code{\link[stats]{chisq.test}}, \code{\link[graphics]{assocplot}}
#'
#' @examples
#' \dontrun{
#' tab <- table(UCBAdmissions)
#'
#' plotAssoc(tab,
#'           main = "Association plot",
#'           cutoff = 2,
#'           reorder = TRUE)
#' }
#'


#' @export
plotAssoc <- function(
    
  # DATA
  x,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = "",
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # STRUCTURE
  margin = c("row", "col"),
  reorder = FALSE,
  cutoff = 0,
  
  # STYLE
  col = NULL,
  border = NA,
  grid = FALSE,
  box = TRUE,
  
  # FEATURES
  legend = NA,
  
  # FRAMEWORK
  stamp = NULL,
  
  ...
) {
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # --- Input --------------------------------------------------------------
    if (!is.matrix(x) && !is.table(x))
      x <- table(x)
    
    tab <- as.matrix(x)
    
    if (any(tab < 0))
      stop("table must contain non-negative counts")
    
    margin <- match.arg(margin)
    
    # --- Reordering ---------------------------------------------------------
    if (isTRUE(reorder)) {
      
      # reorder rows by total frequency
      r_ord <- order(rowSums(tab), decreasing = TRUE)
      c_ord <- order(colSums(tab), decreasing = TRUE)
      
      tab <- tab[r_ord, c_ord, drop = FALSE]
    }
    
    # --- Residuals ----------------------------------------------------------
    rs <- suppressWarnings(chisq.test(tab)$residuals)
    
    # --- Coordinates --------------------------------------------------------
    nr <- nrow(tab)
    nc <- ncol(tab)
    
    xpos <- seq_len(nc)
    ypos <- seq_len(nr)
    
    plot(NA,
         xlim = c(0.5, nc + 0.5),
         ylim = c(0.5, nr + 0.5),
         xaxt = "n",
         yaxt = "n",
         xlab = xlab,
         ylab = ylab,
         main = main)
    
    # --- Colors -------------------------------------------------------------
    if (is.null(col)) {
      pal <- colorRampPalette(c("#2C7BB6", "#F7F7F7", "#D7191C"))
      z   <- rs / max(abs(rs), na.rm = TRUE)
      cols <- pal(100)[ceiling((z + 1) / 2 * 100)]
      cols <- matrix(cols, nrow = nr)
    } else {
      cols <- col
    }
    
    # --- Draw rectangles ----------------------------------------------------
    max_size <- max(sqrt(abs(rs)), na.rm = TRUE)
    
    for (i in seq_len(nr)) {
      for (j in seq_len(nc)) {
        
        val <- rs[i, j]
        
        # --- Cutoff (NEW) ---------------------------------------------------
        if (abs(val) < cutoff)
          next
        
        size <- sqrt(abs(val)) / max_size
        
        w <- 0.4 * size
        h <- 0.4 * size
        
        rect(j - w, i - h,
             j + w, i + h,
             col = cols[i, j],
             border = border)
      }
    }
    
    # --- Axes ---------------------------------------------------------------
    axis(1, at = xpos, labels = colnames(tab))
    axis(2, at = ypos, labels = rownames(tab), las = 1)
    
    # --- Grid / Box ---------------------------------------------------------
    .callIf(graphics::grid, grid)
    if (isTRUE(box)) box()
    
    # --- Legend (placeholder) ----------------------------------------------
    if (!identical(legend, FALSE)) {
      pal <- colorRampPalette(c("#2C7BB6", "#F7F7F7", "#D7191C"))
      legend("topright",
             legend = c("negative", "zero", "positive"),
             fill = pal(3),
             border = NA,
             bty = "n")
    }
    
  }, stamp = stamp)
}

