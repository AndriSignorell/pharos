
#' Create a Bagplot (Bivariate Boxplot)
#'
#' Draws a bagplot (bivariate boxplot) based on halfspace (Tukey) depth.
#' The bag contains the innermost 50\% of the data, the loop is the convex
#' hull of all non-outlying points, and points outside the fence (the bag
#' inflated by \code{factor}, not drawn) are flagged as outliers.
#'
#' All graphical elements are controlled via an object-oriented interface:
#' each element can be specified as \code{TRUE}, \code{FALSE}, or a
#' \code{list(...)} of graphical parameters. Internally, this is handled
#' via \code{bedrock::callIf()}.
#'
#' @details
#' The construction follows Rousseeuw, Ruts and Tukey (1999):
#' \enumerate{
#'   \item The halfspace (Tukey) depth of every observation is computed
#'     using a direct port of the original Fortran routine \code{TUKDEPTH}
#'     (Rousseeuw & Ruts, 1996).
#'   \item The Tukey median is approximated by the mean of all
#'     observations with maximal depth.
#'   \item The \emph{bag} is obtained by radial interpolation between the
#'     convex hulls of two adjacent depth regions, calibrated such that
#'     it contains \eqn{\lfloor n/2 \rfloor} observations (up to ties on
#'     the polygon boundary).
#'   \item The \emph{fence} is the bag inflated by \code{factor} relative
#'     to the Tukey median. Following the original proposal it is used
#'     for classification only and not drawn by default.
#'   \item Observations outside the fence are flagged as \emph{outliers}.
#'   \item The \emph{loop} is the convex hull of all non-outlying
#'     observations, so it always lies within the data range.
#' }
#'
#' Two approximations remain relative to the strict theory: the Tukey
#' median is not computed via \code{HALFMED}, and the bag interpolates
#' hulls of sample depth regions rather than exact isodepth contours.
#' Borderline outlier classifications may therefore differ slightly from
#' other implementations (e.g. \pkg{aplpack}).
#'
#' Exact ties and collinear configurations violate the general-position
#' assumption of the depth algorithm; \code{dither} (default \code{TRUE})
#' adds negligible noise (order \code{eps}) to break them.
#'
#' @section Element Control:
#' Each of the following arguments accepts:
#' \itemize{
#'   \item \code{TRUE}  - draw element with defaults
#'   \item \code{FALSE} - suppress element
#'   \item \code{list(...)} - customize graphical parameters
#' }
#'
#' Supported elements (in drawing order):
#' \itemize{
#'   \item \code{grid}   - background grid
#'   \item \code{fence}  - classification boundary (default \code{FALSE})
#'   \item \code{loop}   - convex hull of the non-outlying points
#'   \item \code{bag}    - central 50\% region
#'   \item \code{points} - raw data points
#'   \item \code{out}    - outliers
#'   \item \code{median} - Tukey median
#'   \item \code{box}    - plot frame
#' }
#'
#' @param x a numeric matrix or data frame with exactly two columns, or a
#'   formula of the form \code{y ~ x} (see the formula method).
#' @param formula a formula of the form \code{y ~ x}, where both variables
#'   are numeric. \code{x} is drawn on the horizontal, \code{y} on the
#'   vertical axis.
#' @param data an optional data frame containing the variables in
#'   \code{formula}.
#' @param subset an optional expression indicating which observations to
#'   use.
#' @param na.action a function specifying how missing values are handled.
#'   Defaults to \code{\link[stats]{na.omit}}, as the depth computation
#'   requires complete pairs.
#' @param main,xlab,ylab character strings for plot annotations. The
#'   formula method derives \code{xlab} and \code{ylab} from the variable
#'   names if they are not supplied.
#' @param xlim,ylim numeric vectors of length 2 specifying axis limits.
#' @param factor inflation factor for the fence (default: 3).
#' @param eps numeric tolerance used in depth computation and geometry.
#' @param dither logical, whether to add small noise to break ties.
#' @param points,bag,loop,fence,out,median,grid,box
#'   object-oriented control of plot elements (see Details).
#' @param stamp optional stamp passed to \code{.withGraphicsState()}.
#' @param ... additional graphical parameters passed to \code{par()}.
#'
#' @return Invisibly returns a list of class \code{"bagplot"} with
#'   components:
#' \itemize{
#'   \item \code{center}   - Tukey median.
#'   \item \code{depth}    - depth of the innermost region bounding the bag.
#'   \item \code{bag}      - bag polygon (matrix).
#'   \item \code{fence}    - fence polygon (matrix, not drawn by default).
#'   \item \code{loop}     - loop polygon (matrix).
#'   \item \code{outliers} - outlier points (matrix).
#'   \item \code{depths}   - halfspace depth of all observations.
#' }
#'
#' @references P. J. Rousseeuw, I. Ruts, J. W. Tukey (1999):
#'     The bagplot: a bivariate boxplot, \emph{The American
#'     Statistician}, vol. 53, no. 4, 382--387.
#'
#' P. J. Rousseeuw, I. Ruts (1996): Algorithm AS 307: Bivariate location
#'     depth, \emph{Applied Statistics}, vol. 45, no. 4, 516--526.
#'
#' @examples
#' set.seed(1)
#' x <- cbind(rnorm(200), rnorm(200))
#'
#' # data of Rousseeuw et al. (1999): car weight vs engine displacement
#' cardata <- data.frame(
#'   Weight = c(2560, 2345, 1845, 2260, 2440,
#'            2285, 2275, 2350, 2295, 1900, 2390, 2075, 2330, 3320, 2885,
#'            3310, 2695, 2170, 2710, 2775, 2840, 2485, 2670, 2640, 2655,
#'            3065, 2750, 2920, 2780, 2745, 3110, 2920, 2645, 2575, 2935,
#'            2920, 2985, 3265, 2880, 2975, 3450, 3145, 3190, 3610, 2885,
#'            3480, 3200, 2765, 3220, 3480, 3325, 3855, 3850, 3195, 3735,
#'            3665, 3735, 3415, 3185, 3690),
#'   Disp = c(97, 114, 81, 91, 113, 97, 97,
#'          98, 109, 73, 97, 89, 109, 305, 153, 302, 133, 97, 125, 146,
#'          107, 109, 121, 151, 133, 181, 141, 132, 133, 122, 181, 146,
#'          151, 116, 135, 122, 141, 163, 151, 153, 202, 180, 182, 232,
#'          143, 180, 180, 151, 189, 180, 231, 305, 302, 151, 202, 182,
#'          181, 143, 146, 146)
#' )
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
#' # formula interface
#' plotBag(Disp ~ Weight, data = cardata)
#'
#' # example of Rousseeuw et al. (1999): car weight vs engine displacement
#' plotBag(cardata, xlab = "Weight", ylab = "Displacement")
#'
#' @family plot.bivariate
#' @concept bivariate
#' @concept robust-statistics
#'
#' @export

plotBag <- function(x, ...) {
  UseMethod("plotBag")
}


#' @rdname plotBag
#' @export

plotBag.formula <- function(x, data = NULL, subset, na.action = na.omit,
                            main = "", xlab = NULL, ylab = NULL, ...) {

  # 'x' is the formula: the generic dispatches on the first argument, so the
  # formal must be named 'x' for consistent method signatures. Renamed here
  # for readability.
  formula <- x

  # capture subset unevaluated, following the resolveFormula() contract
  subset_expr <- if (!missing(subset)) substitute(subset) else NULL

  r <- resolveFormula(formula, data,
                      subset    = subset_expr,
                      na.action = na.action,
                      allowed   = "numeric-numeric")

  # y ~ x: predictor on the horizontal, response on the vertical axis
  if (is.null(xlab)) xlab <- names(r$mf)[2L]
  if (is.null(ylab)) ylab <- names(r$mf)[1L]

  res <- plotBag.default(cbind(r$predictor, r$x),
                         main = main, xlab = xlab, ylab = ylab, ...)

  res$data.name <- r$data.name

  invisible(res)
}


#' @rdname plotBag
#' @export

plotBag.default <- function(

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
  fence  = FALSE,
  out    = TRUE,
  median = TRUE,
  grid   = FALSE,
  box    = TRUE,

  # --- FRAMEWORK --------------------------------------------------
  stamp = NULL,

  ...
) {

  # --- normalize data --------------------------------------------
  x <- as.matrix(x)

  if (ncol(x) != 2)
    stop("x must be a 2-column matrix or data frame")

  if (!is.numeric(x))
    stop("x must be numeric")

  # --- compute bagplot -------------------------------------------
  res <- bagplot_compute_cpp(
    xy = x,
    factor = factor,
    eps = eps,
    dither = dither
  )

  .withGraphicsState({

    .applyParFromDots(...)

    # --- axis limits ---------------------------------------------
    if (is.null(xlim)) xlim <- range(x[, 1], na.rm = TRUE)
    if (is.null(ylim)) ylim <- range(x[, 2], na.rm = TRUE)

    # --- base plot -----------------------------------------------
    plot(NA,
         xlim = xlim,
         ylim = ylim,
         main = main,
         xlab = xlab,
         ylab = ylab)

    # --- grid ----------------------------------------------------
    bedrock::callIf(graphics::grid, grid)

    # --- fence (classification boundary, hidden by default) ------
    if (nrow(res$fence) >= 3) {
      bedrock::callIf(graphics::polygon, fence,
              defaults = list(
                x = res$fence[, 1],
                y = res$fence[, 2],
                col = NA,
                border = "grey60",
                lty = 3
              )
      )
    }

    # --- loop (below the bag, so a filled loop stays behind it) --
    if (nrow(res$loop) >= 3) {
      bedrock::callIf(graphics::polygon, loop,
              defaults = list(
                x = res$loop[, 1],
                y = res$loop[, 2],
                col = adjustcolor("skyblue", 0.25),
                border = "blue",
                lwd = 1,
                lty = 2
              )
      )
    }

    # --- bag -----------------------------------------------------
    if (nrow(res$bag) >= 3) {
      bedrock::callIf(graphics::polygon, bag,
              defaults = list(
                x = res$bag[, 1],
                y = res$bag[, 2],
                col = adjustcolor("skyblue", 0.5),
                border = "blue",
                lwd = 2
              )
      )
    }

    # --- points (on top of the polygons) -------------------------
    bedrock::callIf(graphics::points, points,
            defaults = list(
              x = x[, 1],
              y = x[, 2],
              col = "black",
              pch = 16
            )
    )

    # --- outliers ------------------------------------------------
    if (nrow(res$outliers) > 0) {
      bedrock::callIf(graphics::points, out,
              defaults = list(
                x = res$outliers[, 1],
                y = res$outliers[, 2],
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

  class(res) <- c("bagplot", class(res))

  invisible(res)
}
