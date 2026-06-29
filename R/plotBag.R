
#' Create a Bagplot (Bivariate Boxplot)
#'
#' Draws a bagplot (bivariate boxplot) based on halfspace (Tukey) depth.
#' The bag contains approximately the innermost 50\% of the data, the loop
#' is an inflated version of the bag, and points outside the loop are
#' flagged as outliers.
#'
#' All graphical elements are controlled via an object-oriented interface:
#' each element can be specified as \code{TRUE}, \code{FALSE}, or a
#' \code{list(...)} of graphical parameters. Internally, this is handled
#' via \code{bedrock::callIf()}.
#'
#' @section Details:
#' The halfspace (Tukey) depth is computed using a direct port of the
#' original Fortran routine \code{TUKDEPTH} (Rousseeuw & Ruts, 1996),
#' ensuring a numerically faithful implementation of the depth itself.
#'
#' The resulting bagplot is based on standard practical approximations:
#' the bag is constructed as the convex hull of all observations with
#' depth greater than or equal to the 50\% depth threshold, and the loop
#' is obtained by affine inflation of the bag around the Tukey median.
#'
#' While this approach is consistent with common implementations, it does
#' not represent the exact continuous depth regions defined in the
#' original theory. In particular, the loop is not derived from an
#' isodepth contour but from a geometric scaling of the bag. Consequently,
#' small deviations from other implementations (e.g. \code{aplpack}) may
#' occur, especially in the shape of the loop and the classification of
#' borderline outliers.
#' 
#' @section Element Control:
#' Each of the following arguments accepts:
#' \itemize{
#'   \item \code{TRUE}  – draw element with defaults
#'   \item \code{FALSE} – suppress element
#'   \item \code{list(...)} – customize graphical parameters
#' }
#'
#' Supported elements:
#' \itemize{
#'   \item \code{points} – raw data points
#'   \item \code{bag}    – central 50\% region (convex hull)
#'   \item \code{loop}   – inflated bag (fence)
#'   \item \code{out}    – outliers
#'   \item \code{median} – Tukey median
#'   \item \code{grid}   – background grid
#'   \item \code{box}    – plot frame
#' }
#'
#' @param x A numeric matrix or data frame with exactly two columns.
#'
#' @param main,xlab,ylab Character strings for plot annotations.
#'
#' @param xlim,ylim Numeric vectors of length 2 specifying axis limits.
#'
#' @param factor Inflation factor for the loop (default: 3).
#'
#' @param eps Numeric tolerance used in depth computation and geometry.
#'
#' @param dither Logical; whether to add small noise to break ties.
#'
#' @param points,bag,loop,out,median,grid,box
#' Object-oriented control of plot elements (see Details).
#'
#' @param stamp Optional stamp passed to \code{.withGraphicsState()}.
#'
#' @param ... Additional graphical parameters passed to \code{par()}.
#'
#' @return Invisibly returns a list with components:
#' \itemize{
#'   \item \code{center}   – Tukey median
#'   \item \code{depth}    – depth threshold defining the bag
#'   \item \code{bag}      – bag polygon (matrix)
#'   \item \code{loop}     – loop polygon (matrix)
#'   \item \code{outliers} – outlier points (matrix)
#'   \item \code{depths}   – depth of all observations
#' }
#'
#' @references P. J. Rousseeuw, I. Ruts, J. W. Tukey (1999):
#'     The bagplot: a bivariate boxplot, \emph{The American
#'       Statistician}, vol. 53, no. 4, 382--387 
#' 
#' @examples
#' set.seed(1)
#' x <- cbind(rnorm(200), rnorm(200))
#'
#' plotBag(x)
#'
#' # Custom styling
#' plotBag(x,
#'   bag = list(col = adjustcolor("green", 0.3), border = "darkgreen"),
#'   loop = list(border = "black", lty = 3),
#'   out = list(col = "red", pch = 17),
#'   grid = TRUE
#' )
#'
#' # Minimal plot
#' plotBag(x, points = FALSE, median = FALSE)
#'
#' # example of Rousseeuw et al.
#'cardata <- data.frame( 
#' Weight= c(2560,2345,1845,2260,2440,
#'           2285, 2275, 2350, 2295, 1900, 2390, 2075, 2330, 3320, 2885,
#'           3310, 2695, 2170, 2710, 2775, 2840, 2485, 2670, 2640, 2655,
#'           3065, 2750, 2920, 2780, 2745, 3110, 2920, 2645, 2575, 2935,
#'           2920, 2985, 3265, 2880, 2975, 3450, 3145, 3190, 3610, 2885,
#'           3480, 3200, 2765, 3220, 3480, 3325, 3855, 3850, 3195, 3735,
#'           3665, 3735, 3415, 3185, 3690),
#' Disp=c(97, 114, 81, 91, 113, 97, 97,
#'        98, 109, 73, 97, 89, 109, 305, 153, 302, 133, 97, 125, 146,
#'        107, 109, 121, 151, 133, 181, 141, 132, 133, 122, 181, 146,
#'        151, 116, 135, 122, 141, 163, 151, 153, 202, 180, 182, 232,
#'        143, 180, 180, 151, 189, 180, 231, 305, 302, 151, 202, 182,
#'        181, 143, 146, 146)
#' )
#' # Minimal plot
#' plotBag(x, points = FALSE, median = FALSE)
#'


#' @family plot.bivariate  
#' @concept bivariate  
#' @concept robust-statistics
#'
#'
#' @export
plotBag <- function(
    
  # --- DATA -------------------------------------------------------
  x,
  
  # --- LABELS -----------------------------------------------------
  main = "",
  xlab = "",
  ylab = "",
  
  # --- AXES -------------------------------------------------------
  xlim = NULL,
  ylim = NULL,
  
  # --- STRUCTURE --------------------------------------------------
  factor = 3,
  eps = 1e-8,
  dither = TRUE,
  
  # --- STYLE (object-oriented) -----------------------------------
  points = TRUE,
  bag    = TRUE,
  loop   = TRUE,
  out    = TRUE,
  median = TRUE,
  grid   = FALSE,
  box    = TRUE,
  
  # --- FRAMEWORK --------------------------------------------------
  stamp = NULL,
  
  ...
) {
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # --- normalize data ------------------------------------------
    x <- as.matrix(x)
    if (ncol(x) != 2)
      stop("x must be a 2-column matrix or data frame")
    
    # --- compute bagplot -----------------------------------------
    res <- bagplot_compute(
      xy = x,
      factor = factor,
      eps = eps,
      dither = dither
    )
    
    # --- axis limits ---------------------------------------------
    if (is.null(xlim)) xlim <- range(x[,1], na.rm = TRUE)
    if (is.null(ylim)) ylim <- range(x[,2], na.rm = TRUE)
    
    # --- base plot -----------------------------------------------
    plot(NA,
         xlim = xlim,
         ylim = ylim,
         main = main,
         xlab = xlab,
         ylab = ylab)
    
    # --- grid ----------------------------------------------------
    bedrock::callIf(graphics::grid, grid)
    
    # --- points --------------------------------------------------
    bedrock::callIf(graphics::points, points,
            defaults = list(
              x = x[,1],
              y = x[,2],
              col = "black",
              pch = 16
            )
    )
    
    # --- bag -----------------------------------------------------
    if (nrow(res$bag) >= 3) {
      bedrock::callIf(graphics::polygon, bag,
              defaults = list(
                x = res$bag[,1],
                y = res$bag[,2],
                col = adjustcolor("skyblue", 0.5),
                border = "blue",
                lwd = 2
              )
      )
    }
    
    # --- loop ----------------------------------------------------
    if (nrow(res$loop) >= 3) {
      bedrock::callIf(graphics::polygon, loop,
              defaults = list(
                x = res$loop[,1],
                y = res$loop[,2],
                col = NA,
                border = "blue",
                lwd = 2,
                lty = 2
              )
      )
    }
    
    # --- outliers ------------------------------------------------
    if (nrow(res$outliers) > 0) {
      bedrock::callIf(graphics::points, out,
              defaults = list(
                x = res$outliers[,1],
                y = res$outliers[,2],
                col = "red",
                pch = 16
              )
      )
    }
    
    # --- median --------------------------------------------------
    bedrock::callIf(graphics::points, median,
            defaults = list(
              x = res$center[1],
              y = res$center[2],
              pch = 4,
              lwd = 2,
              cex = 1.5,
              col = "blue"
            )
    )
    
    # --- box -----------------------------------------------------
    bedrock::callIf(graphics::box, box)
    
  }, stamp = stamp)
  
  invisible(res)
}


