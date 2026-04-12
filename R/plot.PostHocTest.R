
#' Plot Method for PostHocTest Objects
#'
#' Visualizes pairwise comparisons from a \code{PostHocTest} object using dot plots.
#' Each component of \code{x} is plotted separately, showing estimated differences
#' along with confidence intervals. A vertical reference line at zero is added.
#'
#'
#' @param x An object of class \code{"PostHocTest"}, typically returned by
#'   \code{\link[lumen]{postHocTest}}.
#' @param ... Additional graphical parameters passed to
#'   \code{\link{plotDot}} and base plotting functions.
#'
#' @details
#' For each factor in \code{x}, a dot plot is produced displaying pairwise
#' differences in means and their confidence intervals. The confidence level
#' is taken from the \code{"conf.level"} attribute of \code{x}.
#'
#' @return
#' Invisibly returns \code{NULL}.
#'
#' @seealso
#' \code{\link[lumen]{postHocTest}},
#' \code{\link{plotDot}}
#'
#' @examples
#' # see lumen::postHocTest()


#' @method plot PostHocTest
#' @export
plot.PostHocTest <- function(x, ...){
  for (i in seq_along(x)) {
    
    xi <- x[[i]][, -4L, drop = FALSE]
    
    aurora::plotDot(xi, items=rownames(xi), ...)
    
    abline(v = 0, lty = 2, lwd = 0.5, ...)
    title(main = paste0(format(100 * attr(x, "conf.level"), digits = 2L), 
                        "% family-wise confidence level\n"),
          xlab = paste("Differences in mean levels of", names(x)[i]))
  }
}