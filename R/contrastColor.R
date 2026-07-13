
#' Choose Optimal Text Color Based on WCAG Contrast
#'
#' Computes the optimal text color (default: black or white) for a given
#' background color based on the WCAG contrast ratio.
#'
#' This function implements the official relative luminance definition for
#' sRGB colors (including gamma correction) and selects the text color that
#' maximizes the contrast ratio according to the Web Content Accessibility
#' Guidelines (WCAG 2.1).
#'
#' Compared to simple heuristics (e.g., mean RGB), this approach is
#' perceptually more accurate and suitable for accessibility-critical
#' applications.
#'
#' @param col vector of colors. Can be any valid R color specification:
#'   color names, hexadecimal strings (e.g. `"#RRGGBB"` or `"#RRGGBBAA"`),
#'   or palette indices.
#' @param light color used for dark backgrounds (default: `"white"`).
#' @param dark color used for light backgrounds (default: `"black"`).
#'
#' @return A character vector of the same length as `col`, containing either
#'   `light` or `dark`, depending on which yields the higher contrast ratio.
#'
#' @details
#' The relative luminance is computed as:
#'
#' \deqn{L = 0.2126 R + 0.7152 G + 0.0722 B}
#'
#' where \eqn{R, G, B} are linearized sRGB components:
#'
#' \deqn{
#' c_{lin} =
#' \begin{cases}
#' \frac{c}{12.92} & c \le 0.04045 \\
#' \left(\frac{c + 0.055}{1.055}\right)^{2.4} & c > 0.04045
#' \end{cases}
#' }
#'
#' The contrast ratio between two luminance values \eqn{L1} and \eqn{L2} is:
#'
#' \deqn{
#' \frac{\max(L1, L2) + 0.05}{\min(L1, L2) + 0.05}
#' }
#'
#' The function compares contrast ratios against `light` and `dark` and
#' returns the better option.
#'
#' @examples
#' cols <- c("black", "white", "red", "blue", "yellow", "#777777")
#' contrastColor(cols)
#'
#' # custom text colors
#' contrastColor(cols, light = "#FFFFFF", dark = "#222222")
#'

  

#' @family color.lookup
#' @concept color
#' @concept classification
#'
#'
#' @export
contrastColor <- function(col,
                          light = "white",
                          dark = "black") {
  
  ## --- convert colors to RGB (0-255) ---
  rgb <- col2rgb(col) / 255
  
  ## --- sRGB -> linear RGB (gamma correction) ---
  to_linear <- function(c) {
    ifelse(c <= 0.04045,
           c / 12.92,
           ((c + 0.055) / 1.055)^2.4)
  }
  
  R <- to_linear(rgb[1, ])
  G <- to_linear(rgb[2, ])
  B <- to_linear(rgb[3, ])
  
  ## --- relative luminance ---
  L_bg <- 0.2126 * R + 0.7152 * G + 0.0722 * B
  
  ## --- luminance of candidate text colors ---
  lum <- function(color) {
    rgb <- col2rgb(color) / 255
    R <- to_linear(rgb[1, ])
    G <- to_linear(rgb[2, ])
    B <- to_linear(rgb[3, ])
    0.2126 * R + 0.7152 * G + 0.0722 * B
  }
  
  L_light <- lum(light)
  L_dark  <- lum(dark)
  
  ## --- contrast ratio function ---
  contrast_ratio <- function(L1, L2) {
    (pmax(L1, L2) + 0.05) / (pmin(L1, L2) + 0.05)
  }
  
  ## --- compute contrast ---
  CR_light <- contrast_ratio(L_bg, L_light)
  CR_dark  <- contrast_ratio(L_bg, L_dark)
  
  ## --- choose better contrast ---
  out <- ifelse(CR_light > CR_dark, light, dark)
  
  return(out)
}

