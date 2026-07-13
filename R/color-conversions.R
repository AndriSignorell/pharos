
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
#' colToRGB("peachpuff")
#' colToRGB(c(blu = "royalblue", reddish = "tomato")) # names kept
#' 
#' colToRGB(1:8)
#' 
#' 
#' @seealso [grDevices::col2rgb], [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#'
#' @export
colToRGB <- function(col, useAlphaChannel = FALSE)
  col2rgb(col, alpha = useAlphaChannel)


#' Convert Hex Colors to RGB
#'
#' Convert hexadecimal color strings to an RGB matrix.
#'
#' @param hex character vector of hexadecimal colors.
#'
#' @return Integer matrix with RGB rows.
#'

#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#'
#' @export
hexToRGB <- function(hex) {
  
  hex <- gsub("^#", "", hex)
  
  if (all(is.na(hex)))
    return(matrix(NA, nrow = 3, ncol = length(hex)))
  
  if (any(nchar(hex) == 8)) {
    hex[nchar(hex) == 6] <- paste0(hex[nchar(hex) == 6], "FF")
    nChan <- 4
  } else {
    nChan <- 3
  }
  
  x <- sapply(hex, function(z)
    c(
      red   = strtoi(substr(z, 1, 2), 16L),
      green = strtoi(substr(z, 3, 4), 16L),
      blue  = strtoi(substr(z, 5, 6), 16L),
      alpha = strtoi(substr(z, 7, 8), 16L)
    )
  )
  
  res <- cbind(x[1:nChan, ])
  
  if (ncol(res) == 1L)
    colnames(res) <- hex
  
  res
}


#' Convert RGB to Hexadecimal Colors
#'
#' Convert RGB values to hexadecimal color strings.
#'
#' @param col RGB matrix.
#'
#' @return Character vector of hexadecimal colors.
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
rgbToHex <- function(col) {
  col <- round(col)
  paste0("#", paste0(sprintf("%02X", as.integer(col)), collapse = ""))
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
#' Match RGB colors to the nearest named R color.
#'
#' @param col RGB matrix or hexadecimal colors.
#' @param method color space used for matching.
#' @param metric distance metric.
#'
#' @return Character vector of named R colors.
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
rgbToCol <- function(col,
                     method = c("rgb", "hsv"),
                     metric = c("euclidean", "manhattan")) {
  
  method <- match.arg(method)
  metric <- match.arg(metric)
  
  if (method == "hsv") {
    
    col <- colToHSV(col)
    colTab <- colToHSV(colors())
    
  } else {
    
    if (!is.matrix(col)) {
      col <- lapply(col, function(x)
        c(
          strtoi(substr(x, 2, 3), 16L),
          strtoi(substr(x, 4, 5), 16L),
          strtoi(substr(x, 6, 7), 16L)
        )
      )
      
      col <- do.call("cbind", col)
    }
    
    colTab <- col2rgb(colors())
  }
  
  FUN <- switch(
    metric,
    euclidean = function(x)
      which.min(apply(apply(colTab, 2, "-", x)^2, 2, sum)),
    
    manhattan = function(x)
      which.min(apply(abs(apply(colTab, 2, "-", x)), 2, sum))
  )
  
  colors()[apply(col, 2, FUN)]
}


#' Convert Hex Colors to Named R Colors
#'
#' Convert hexadecimal colors to the nearest named R colors.
#'
#' @inheritParams rgbToCol
#' @param hex character vector of hexadecimal colors.
#'
#' @return Character vector of named R colors.
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
hexToCol <- function(hex,
                     method = c("rgb", "hsv"),
                     metric = c("euclidean", "manhattan")) {
  
  rgbToCol(hex, method = method, metric = metric)
}


#' Convert R Colors to HSV
#'
#' Convert any valid R color specification to HSV.
#'
#' @param col vector of valid R colors.
#' @param useAlphaChannel logical indicating whether the alpha
#'   channel should be included.
#'
#' @return Numeric HSV matrix.
#'
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
colToHSV <- function(col, useAlphaChannel = FALSE)
  rgb2hsv(colToRGB(col, useAlphaChannel = useAlphaChannel))


#' Convert RGB to Long Integers
#'
#' Encode RGB colors as long integers.
#'
#' @param col RGB matrix.
#'
#' @return Integer vector.
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
#' @seealso [color-conversion-overview]
#' @concept color
#' @concept color-conversion
#'
#' @export
longToRGB <- function(col)
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
#' @param col RGB matrix or hexadecimal colors.
#' @param maxColorValue maximum channel value.
#'
#' @return Numeric CMY matrix.
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
    
    col <- do.call("cbind", col)
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
# colToRgb  <- colToRGB
# colToHsv  <- colToHSV
# 
# rgbToCol  <- rgbToCol
# 
# hexToRgb  <- hexToRGB
# rgbToHex  <- rgbToHex
# 
# rgbToLong <- rgbToLong
# longToRgb <- longToRGB
# 
# rgbToCmy  <- rgbToCmy
# cmyToCmyk <- cmyToCmyk
# 
# cmykToCmy <- cmykToCmy
# cmykToRgb <- cmykToRgb
# 
# alpha     <- addOpacity
# 
# colToGrey <- grayscale
# colToGray <- grayscale

