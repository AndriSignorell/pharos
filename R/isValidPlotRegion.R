
#' Check Whether the Current Plot Region Is Large Enough
#'
#' Tests whether the plot region of the active graphics device meets a
#' minimal size requirement. This is useful before drawing into small
#' devices or heavily subdivided layouts (\code{mfrow}, \code{layout()},
#' Shiny render panes), where an undersized region would otherwise fail
#' with the rather cryptic error \code{"figure margins too large"}.
#'
#' @param minPin numeric vector of length 2, giving the minimal required
#'   width and height of the plot region in inches. Defaults to the option
#'   \code{DescToolsX.plot.minPin} and falls back to \code{c(0.5, 0.5)}
#'   if the option is not set.
#'
#' @details
#' The plot region is the area inside the figure margins, as reported by
#' \code{par("pin")}. Its size results from the device dimensions minus
#' the current margins (\code{mar}, \code{oma}), so both a small device
#' and oversized margins can render it degenerate.
#'
#' If no graphics device is open (\code{dev.cur() == 1}), the function
#' returns \code{TRUE}, since the next high-level plot call will open a
#' fresh device with default dimensions. Note that querying \code{par()}
#' in this state would itself open a device as a side effect, which this
#' function deliberately avoids.
#'
#' The function has no side effects and never throws; it is meant as a
#' guard for conditional plotting, e.g.
#' \code{if (isValidPlotRegion()) plot(x) else message("device too small")}.
#'
#' @return a single logical: \code{TRUE} if the plot region is at least
#'   \code{minPin} inches in both dimensions (or if no device is open),
#'   \code{FALSE} otherwise.
#'
#' @seealso \code{\link{par}} (entries \code{pin}, \code{fin}, \code{mar}),
#'   \code{\link{dev.cur}}
#'
#' @examples
#' # guard a plot against a degenerate region
#' if (isValidPlotRegion()) {
#'   plot(rnorm(20))
#' } else {
#'   message("plot region too small")
#' }
#'
#' # require a larger region, e.g. for a wide correlation plot
#' isValidPlotRegion(minPin = c(4, 3))
#'
#'
#' @family graphics.layout 
#' @export
isValidPlotRegion <- function(minPin = .getOption("plot.minPin", c(0.5, 0.5))) {
  if (dev.cur() == 1L) return(TRUE)
  pin <- par("pin")
  all(is.finite(pin)) && all(pin >= minPin)
}

