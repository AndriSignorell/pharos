#' Metric Prefixes
#'
#' SI metric prefixes from yotta (\eqn{10^{24}}) down to yocto
#' (\eqn{10^{-24}}), with their name, symbol and multiplier. Used as default
#' lookup table by \code{\link{convUnit}} and for SI-prefix formatting in
#' \code{\link{fm}}.
#'
#' @docType data
#' @name Prefix
#' @aliases constants
#' @format A \code{data.frame} with 20 rows and 3 columns:
#' \describe{
#'   \item{pref}{\code{character}, name of the prefix (e.g. \code{"kilo"}).}
#'   \item{abbr}{\code{character}, symbol of the prefix (e.g. \code{"k"});
#'     \code{"u"} is used for micro.}
#'   \item{mult}{\code{numeric}, multiplier, i.e. the power of ten the
#'     prefix stands for (e.g. \code{1000}).}
#' }
#' @returns A \code{data.frame} as described under \emph{Format}; the object
#'   is a constant, not a function.
#' @keywords datasets
#' @examples
#' Prefix
#' Prefix[Prefix$abbr == "k", ]
#' @export
Prefix <- data.frame(
  pref = c("yotta", "zetta", "exa", "peta", "tera", "giga", "mega", "kilo", 
           "hecto", "deca", "deci", "centi", "milli", "micro", "nano", 
           "pico", "femto", "atto", "zepto", "yocto"), 
  abbr = c("Y", "Z", "E", "P", "T", "G", "M", "k", "h", "da", "d", "c", 
           "m", "u", "n", "p", "f", "a", "z", "y"), 
  mult = c(1e+24, 1e+21, 1e+18, 1e+15, 1e+12, 1000000000, 1000000, 1000, 100, 
           10, 0.1, 0.01, 0.001, 0.000001, 0.000000001, 1e-12, 1e-15, 
           1e-18, 1e-21, 1e-24)
)

