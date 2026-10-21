
# =========================================================
# Color Representation Conversion
# =========================================================

#' Convert R Colors to RGB
#'
#' Convert any valid R color specification to an RGB matrix.
#'
#' @param col vector of valid R colors.
#' @param useAlphaChannel logical indicating whether the alpha
#'   channel should be included.
#'
#' @return Integer matrix with rows corresponding to RGB
#'   (and optionally alpha) channels.
#' 
#' @examples
#' 
#' rgbToCol(matrix(c(162,42,42), nrow=3))
#' 
#' rgbToLong(matrix(c(162,42,42), nrow=3))
#' 
#' colToRgb("peachpuff")
#' colToRgb(c(blu = "royalblue", reddish = "tomato")) # names kept
#' 
#' colToRgb(1:8)
#' 
#' 
#' @seealso [grDevices::col2rgb], [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#'
#' @export
colToRgb <- function(col, useAlphaChannel = FALSE)
  col2rgb(col, alpha = useAlphaChannel)


#' Convert Hex Colors to RGB
#'
#' Convert hexadecimal color strings to an RGB matrix.
#'
#' @param col character vector of hexadecimal colors.
#'
#' @return Integer matrix with RGB rows.
#'

#' @examples
#' hexToRgb(c("#A52A2A", "#FFDAB9"))
#'
#' # an alpha channel is kept
#' hexToRgb("#A52A2A80")
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#'
#' @export
hexToRgb <- function(col) {
  
  col <- gsub("^#", "", col)
  
  if (all(is.na(col)))
    return(matrix(NA, nrow = 3, ncol = length(col)))
  
  if (any(nchar(col) == 8)) {
    col[nchar(col) == 6] <- paste0(col[nchar(col) == 6], "FF")
    nChan <- 4
  } else {
    nChan <- 3
  }
  
  x <- sapply(col, function(z)
    c(
      red   = strtoi(substr(z, 1, 2), 16L),
      green = strtoi(substr(z, 3, 4), 16L),
      blue  = strtoi(substr(z, 5, 6), 16L),
      alpha = strtoi(substr(z, 7, 8), 16L)
    )
  )
  
  res <- cbind(x[1:nChan, ])
  
  if (ncol(res) == 1L)
    colnames(res) <- col
  
  res
}


#' Convert RGB to Hexadecimal Colors
#'
#' Convert RGB values to hexadecimal color strings.
#'
#' @param col RGB matrix with one color per column, as returned by
#'   [colToRgb()], or a vector with the channel values of a single color.
#'
#' @return Character vector of hexadecimal colors, one per color.
#'
#' @examples
#' rgbToHex(c(162, 42, 42))
#'
#' # one color per column, as returned by colToRgb()
#' rgbToHex(colToRgb(c("tomato", "royalblue")))
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
rgbToHex <- function(col) {

  toHex <- function(z)
    paste0("#", paste0(sprintf("%02X", as.integer(z)), collapse = ""))

  col <- round(col)

  # one colour per column, as returned by colToRgb(); a plain vector is a
  # single colour
  if (is.matrix(col))
    unname(apply(col, 2L, toHex))
  else
    toHex(col)
}


#' Convert R Colors to Hexadecimal Colors
#'
#' Convert any valid R color specification to hexadecimal colors.
#'
#' @param col vector of valid R colors.
#' @param opacity opacity value between 0 and 1.
#'
#' @return Character vector of hexadecimal colors.
#'
#' @examples
#' colToHex(c("tomato", "royalblue"))
#' colToHex("tomato", opacity = 0.5)
#'
#' # color numbers refer to the current palette
#' colToHex(1:3)
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
colToHex <- function(col, opacity = 1) {
  
  colRGB <- col2rgb(col)
  
  res <- apply(
    colRGB,
    2,
    function(x)
      sprintf("#%02X%02X%02X", x[1], x[2], x[3])
  )
  
  if (any(opacity != 1))
    res <- paste0(res, decToHex(round(opacity * 255, 0)))
  
  res
}


#' Convert RGB Colors to the Nearest Named R Color
#'
#' Finds, for each color, the perceptually closest of the named R colors
#' ([grDevices::colors()]).
#'
#' The colors are converted from sRGB to the CIELAB color space with
#' [grDevices::convertColor()] (reference white D65), where distances
#' approximate perceived differences far better than in RGB or HSV. Two
#' color difference formulas are available:
#' \describe{
#'   \item{`"ciede2000"`}{CIEDE2000, the current CIE recommendation. It
#'     corrects the shortcomings of CIE76 in the blue region and for
#'     saturated and near-neutral colors.}
#'   \item{`"cie76"`}{CIE76, the Euclidean distance in CIELAB. Simpler,
#'     slightly less accurate.}
#' }
#'
#' @param col colors: an RGB matrix with one color per column and
#'   channels on a scale from 0 to 255, as returned by [colToRgb()], or a
#'   vector of R colors (hexadecimal or named). An alpha channel is
#'   ignored.
#' @param method color difference formula, `"ciede2000"` (default) or
#'   `"cie76"`, see Details.
#'
#' @return Character vector of named R colors, one per color in `col`;
#'   `NA` for a missing color.
#'
#' @references
#' Sharma, G., Wu, W., & Dalal, E. N. (2005). The CIEDE2000
#' color-difference formula: Implementation notes, supplementary test data,
#' and mathematical observations. *Color Research & Application*, 30(1),
#' 21--30. \doi{10.1002/col.20070}
#'
#' @examples
#' rgbToCol(matrix(c(162, 42, 42), nrow = 3))
#' rgbToCol(c("#A22A2A", "#4169E0"))
#'
#' # CIE76 instead of CIEDE2000
#' rgbToCol(c("#A22A2A", "#4169E0"), method = "cie76")
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
rgbToCol <- function(col, method = c("ciede2000", "cie76")) {

  method <- match.arg(method)

  # one color per column; col2rgb() would read the cells of an RGB matrix
  # as palette indices, so a matrix is taken as it is
  if (is.matrix(col)) {
    rgb <- col[1:3, , drop = FALSE]
    na  <- colSums(is.na(rgb)) > 0
  } else {
    # col2rgb() turns NA into white, so missing colors are set aside first
    na  <- is.na(col)
    rgb <- col2rgb(replace(col, na, "black"))
  }

  res <- rep(NA_character_, length(na))
  if (all(na))
    return(res)

  lab <- .rgbToLab(rgb[, !na, drop = FALSE])
  tab <- .namedColorsLab()

  nearest <- function(i) {
    one <- lab[rep(i, nrow(tab)), , drop = FALSE]
    d <- switch(method,
                ciede2000 = .deltaE2000(one, tab),
                cie76     = sqrt(rowSums((one - tab)^2)))
    which.min(d)
  }

  res[!na] <- colors()[vapply(seq_len(nrow(lab)), nearest, integer(1L))]
  res
}


#' Convert Hex Colors to Named R Colors
#'
#' Convert hexadecimal colors to the nearest named R colors.
#'
#' @inheritParams rgbToCol
#' @param col character vector of hexadecimal colors.
#'
#' @return Character vector of named R colors.
#'
#' @examples
#' hexToCol(c("#A22A2A", "#4169E0"))
#' hexToCol("#4169E0", method = "cie76")
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
hexToCol <- function(col, method = c("ciede2000", "cie76")) {

  rgbToCol(col, method = method)
}


# sRGB channels (rows, 0-255) to CIELAB (one color per row, D65)
.rgbToLab <- function(rgb)
  convertColor(t(rgb) / 255, from = "sRGB", to = "Lab")


# CIELAB values of the named R colors, computed once per session
.namedColorsLab <- local({
  tab <- NULL
  function() {
    if (is.null(tab))
      tab <<- .rgbToLab(col2rgb(colors()))
    tab
  }
})


# CIEDE2000 colour difference (Sharma, Wu & Dalal 2005), vectorised over
# the rows of two Lab matrices of equal size.
.deltaE2000 <- function(lab1, lab2) {

  rad <- pi / 180

  L1 <- lab1[, 1]; a1 <- lab1[, 2]; b1 <- lab1[, 3]
  L2 <- lab2[, 1]; a2 <- lab2[, 2]; b2 <- lab2[, 3]

  # a' with the chroma-dependent correction G
  Cb  <- (sqrt(a1^2 + b1^2) + sqrt(a2^2 + b2^2)) / 2
  G   <- 0.5 * (1 - sqrt(Cb^7 / (Cb^7 + 25^7)))
  a1p <- (1 + G) * a1
  a2p <- (1 + G) * a2

  C1p <- sqrt(a1p^2 + b1^2)
  C2p <- sqrt(a2p^2 + b2^2)
  h1p <- (atan2(b1, a1p) / rad) %% 360
  h2p <- (atan2(b2, a2p) / rad) %% 360

  achrom <- C1p * C2p == 0

  # differences
  dLp <- L2 - L1
  dCp <- C2p - C1p
  dhp <- h2p - h1p
  dhp <- ifelse(dhp > 180, dhp - 360, ifelse(dhp < -180, dhp + 360, dhp))
  dhp[achrom] <- 0
  dHp <- 2 * sqrt(C1p * C2p) * sin(dhp / 2 * rad)

  # means
  Lbp <- (L1 + L2) / 2
  Cbp <- (C1p + C2p) / 2
  hsum <- h1p + h2p
  hbp <- ifelse(abs(h1p - h2p) <= 180, hsum / 2,
                ifelse(hsum < 360, (hsum + 360) / 2, (hsum - 360) / 2))
  hbp[achrom] <- hsum[achrom]

  # weighting functions
  Tt <- 1 - 0.17 * cos((hbp - 30) * rad) + 0.24 * cos(2 * hbp * rad) +
    0.32 * cos((3 * hbp + 6) * rad) - 0.20 * cos((4 * hbp - 63) * rad)
  SL <- 1 + 0.015 * (Lbp - 50)^2 / sqrt(20 + (Lbp - 50)^2)
  SC <- 1 + 0.045 * Cbp
  SH <- 1 + 0.015 * Cbp * Tt
  RT <- -sin(2 * 30 * exp(-((hbp - 275) / 25)^2) * rad) *
    2 * sqrt(Cbp^7 / (Cbp^7 + 25^7))

  sqrt((dLp / SL)^2 + (dCp / SC)^2 + (dHp / SH)^2 +
         RT * (dCp / SC) * (dHp / SH))
}


#' Convert R Colors to HSV
#'
#' Convert any valid R color specification to HSV.
#'
#' @param col vector of valid R colors.
#' @param useAlphaChannel logical indicating whether the alpha
#'   channel should be included.
#'
#' @return Numeric HSV matrix with one column per color. With
#'   `useAlphaChannel = TRUE` the alpha channel is added as fourth row,
#'   scaled to the range from 0 to 1 like the other rows.
#'
#' @examples
#' colToHsv(c("tomato", "royalblue"))
#'
#' # the alpha channel is added as fourth row, on a scale from 0 to 1
#' colToHsv("#FF634780", useAlphaChannel = TRUE)
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
colToHsv <- function(col, useAlphaChannel = FALSE) {

  x <- colToRgb(col, useAlphaChannel = useAlphaChannel)

  # rgb2hsv() takes exactly three rows; the alpha channel is carried along
  # on the same [0, 1] scale as h, s and v
  res <- rgb2hsv(x[1:3, , drop = FALSE])

  if (useAlphaChannel)
    res <- rbind(res, x["alpha", , drop = FALSE] / 255)

  res
}


#' Convert RGB to Long Integers
#'
#' Encode RGB colors as long integers.
#'
#' @param col RGB matrix.
#'
#' @return Integer vector.
#'
#' @examples
#' rgbToLong(colToRgb(c("red", "green", "blue")))
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
rgbToLong <- function(col)
  (c(1, 256, 256^2) %*% col)[1, ]


#' Convert Long Integers to RGB
#'
#' Decode long integers into RGB values.
#'
#' @param col integer vector.
#'
#' @return RGB matrix.
#'
#' @examples
#' longToRgb(c(255, 65280, 16711680))
#'
#' # there and back again
#' rgbToHex(longToRgb(rgbToLong(colToRgb("tomato"))))
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
longToRgb <- function(col)
  sapply(
    col,
    function(x)
      c(
        red   = x %% 256,
        green = (x %/% 256) %% 256,
        blue  = (x %/% 256^2) %% 256
      )
  )


# =========================================================
# Color Space Conversion
# =========================================================

#' Convert RGB to CMY
#'
#' Convert RGB colors to the CMY color space.
#'
#' @param col RGB matrix with one color per row (columns red, green and
#'   blue), or a vector of hexadecimal colors.
#' @param maxColorValue maximum channel value of `col`. Use 255 for
#'   hexadecimal colors.
#'
#' @return Numeric CMY matrix with one color per row.
#'
#' @examples
#' # one color per row, channels on a scale from 0 to 1
#' rgbToCmy(matrix(c(1, 0.39, 0.28), nrow = 1))
#'
#' # the channels of hexadecimal colors run from 0 to 255
#' rgbToCmy(c("#FF6347", "#4169E1"), maxColorValue = 255)
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#' 
#' @export
rgbToCmy <- function(col, maxColorValue = 1) {
  
  if (!is.matrix(col)) {
    
    col <- lapply(col, function(x)
      c(
        strtoi(substr(x, 2, 3), 16L),
        strtoi(substr(x, 4, 5), 16L),
        strtoi(substr(x, 6, 7), 16L)
      )
    )
    
    # one colour per row, as for a matrix
    col <- do.call("rbind", col)
  }
  
  cbind(
    C = 1 - (col[, 1] / maxColorValue),
    M = 1 - (col[, 2] / maxColorValue),
    Y = 1 - (col[, 3] / maxColorValue)
  )
}


#' Convert CMY to CMYK
#'
#' Convert CMY colors to CMYK.
#'
#' @param col numeric CMY matrix.
#'
#' @return Numeric CMYK matrix.
#'
#' @examples
#' cmy <- rgbToCmy(c("#FF6347", "#4169E1"), maxColorValue = 255)
#' cmyToCmyk(cmy)
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
cmyToCmyk <- function(col) {
  
  if (is.null(dim(col)) && length(col) > 2)
    col <- matrix(col, ncol = 3, byrow = TRUE)
  
  K <- rep(1, nrow(col))
  
  K <- pmin(K, col[, 1], col[, 2], col[, 3])
  
  cbind(
    C = (col[, 1] - K) / (1 - K),
    M = (col[, 2] - K) / (1 - K),
    Y = (col[, 3] - K) / (1 - K),
    K = K
  )
}


#' Convert CMYK to CMY
#'
#' Convert CMYK colors to CMY.
#'
#' @param col numeric CMYK matrix.
#'
#' @return Numeric CMY matrix.
#'
#' @examples
#' cmy <- rgbToCmy(c("#FF6347", "#4169E1"), maxColorValue = 255)
#' cmyk <- cmyToCmyk(cmy)
#'
#' # the way back
#' cmykToCmy(cmyk)
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
cmykToCmy <- function(col) {
  
  if (is.null(dim(col)) && length(col) > 3)
    col <- matrix(col, ncol = 4, byrow = TRUE)
  
  cbind(
    C = col[, 1] * (1 - col[, 4]) + col[, 4],
    M = col[, 2] * (1 - col[, 4]) + col[, 4],
    Y = col[, 3] * (1 - col[, 4]) + col[, 4]
  )
}


#' Convert CMYK to RGB
#'
#' Convert CMYK colors to RGB.
#'
#' @param col numeric CMYK matrix (columns C, M, Y, K).
#' @param maxColorValue maximum channel value.
#'
#' @return Numeric RGB matrix.
#'
#' @examples
#' cmyk <- cmyToCmyk(rgbToCmy(c("#FF6347", "#4169E1"), maxColorValue = 255))
#' cmykToRgb(cmyk)
#'
#' # back to hexadecimal colors
#' rgbToHex(t(cmykToRgb(cmyk) * 255))
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
cmykToRgb <- function(col, maxColorValue = 1) {
  
  if (is.null(dim(col)) && length(col) > 3)
    col <- matrix(col, ncol = 4, byrow = TRUE)
  
  cbind(
    R = (maxColorValue - col[, 1]) * (maxColorValue - col[, 4]) / maxColorValue,
    G = (maxColorValue - col[, 2]) * (maxColorValue - col[, 4]) / maxColorValue,
    B = (maxColorValue - col[, 3]) * (maxColorValue - col[, 4]) / maxColorValue
  )
}



# # =========================================================
# # DescTools Backward Compatibility Aliases - docu
# # =========================================================
# 
# colToRgb  <- colToRgb
# colToHsv  <- colToHsv
# 
# rgbToCol  <- rgbToCol
# 
# hexToRgb  <- hexToRgb
# rgbToHex  <- rgbToHex
# 
# rgbToLong <- rgbToLong
# longToRgb <- longToRgb
# 
# rgbToCmy  <- rgbToCmy
# cmyToCmyk <- cmyToCmyk
# 
# cmykToCmy <- cmykToCmy
# cmykToRgb <- cmykToRgb
# 
# alpha     <- addOpacity
# 
# colToGrey <- grayScale
# colToGray <- grayScale

