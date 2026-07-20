#' Color Conversion Functions in pharos
#'
#' @description
#' pharos provides a family of functions for converting colors between
#' representations. Read each matrix as **row -> column**: the cell at
#' row X, column Y is the function that converts a color from
#' representation X to representation Y. \code{-} marks the diagonal
#' (no self-conversion), \code{.} marks a combination with no direct
#' function. RGB is the hub between the two tables below.
#'
#' @section R color, hex, HSV, and RGB:
#'
#' | From \\ To | Col | Hex | HSV | RGB |
#' |---|---|---|---|---|
#' | **Col** | - | [colToHex()] | [colToHSV()] | [colToRGB()] |
#' | **Hex** | [hexToCol()] | - | . | [hexToRGB()] |
#' | **HSV** | . | . | - | . |
#' | **RGB** | [rgbToCol()] | [rgbToHex()] | . | - |
#'
#' \emph{"Col" is any valid R color specification (name, hex string, or
#' palette index) as accepted by} \code{\link[grDevices]{col2rgb}}.
#' No function starts from HSV: it is only ever a conversion target
#' (via \code{\link{colToHSV}}), not a source -- see the note below the
#' second table for the reason this gap is left open.
#'
#' @section RGB, CMY, CMYK, and long integer:
#'
#' | From \\ To | CMY | CMYK | Long | RGB |
#' |---|---|---|---|---|
#' | **CMY**  | - | [cmyToCmyk()] | . | . |
#' | **CMYK** | [cmykToCmy()] | - | . | [cmykToRgb()] |
#' | **Long** | . | . | - | [longToRGB()] |
#' | **RGB**  | [rgbToCmy()] | . | [rgbToLong()] | - |
#'
#' @section Not part of either conversion matrix:
#' Two related functions transform a color without changing its
#' representation, so they don't fit a row/column slot above:
#'
#' | Function | Purpose |
#' |---|---|
#' | [colToOpaque()] | Computes the equivalent opaque color for a transparent color against a background -- Hex stays Hex |
#' | [grayScale()] | Converts colors to grayscale using luminance weighting -- Col stays Col |
#'
#' @section Why HSV has no source functions:
#' Base R already provides the HSV -> Col/Hex direction via
#' \code{\link[grDevices]{hsv}()}, which builds a hex color string
#' directly from h/s/v values -- the same role \code{\link{rgb}()}
#' plays for RGB triplets. pharos deliberately doesn't duplicate it;
#' chain \code{hsv()} into \code{\link{colToRGB}()} or
#' \code{\link{colToHex}()} instead (see examples).
#'
#' @examples
#' # A "." in the matrix means chaining two functions through a hub
#' # (usually RGB or Col), not a missing feature.
#'
#' # CMY -> RGB: no direct function: CMY -> CMYK -> RGB
#' c(0.2, 0.6, 0.9) |> cmyToCmyk() |> cmykToRgb()
#'
#' # Long integer -> R color name: Long -> RGB -> Col
#' 255 |> longToRGB() |> rgbToCol()
#'
#' # HSV -> RGB: base R's hsv() bridges the gap noted above
#' hsv(h = 0.6, s = 0.8, v = 0.9) |> colToRGB()
#'
#' @name color-conversion-overview
#' @seealso [grDevices::col2rgb()], [grDevices::hsv()]
NULL
