
#' Bland-Altman Plot
#'
#' Plots a Bland-Altman agreement analysis.
#'
#' Objects of class `"BlandAltman"` are typically created with
#' `DescToolsX::blandAltmanData()`. The method uses the elements `mean`
#' and `diff` (one value per pair), `bias`, `loaLower` and `loaUpper`, and
#' for the confidence bands `biasCI`, `loaLowerCI` and `loaUpperCI` (each
#' a vector of length 2).
#'
#' @param x an object of class `"BlandAltman"`.
#'
#' @param main plot title.
#' @param xlab X-axis label.
#' @param ylab Y-axis label.
#'
#' @param xlim X-axis limits.
#' @param ylim Y-axis limits.
#'
#' @param pch plotting symbol.
#' @param col point colour.
#'
#' @param grid logical; draw a background grid.
#' @param meanLine logical; draw the bias line.
#' @param limits logical; draw the limits of agreement.
#' @param cband logical; draw confidence bands.
#' @param trend logical; draw a regression line of
#' differences versus means.
#' @param showText logical; annotate bias and limits.
#'
#' @param stamp optional plot stamp.
#' @param ... further arguments passed to `plot()`.
#'
#' @return
#' Invisibly returns `x`.
#'
#' @examples
#' # two measurement methods applied to the same 40 subjects; the object is
#' # built by hand here, normally DescToolsX::blandAltmanData() returns it
#' set.seed(1)
#' a <- rnorm(40, mean = 100, sd = 15)
#' b <- a + rnorm(40, mean = 2, sd = 5)
#'
#' d   <- a - b
#' n   <- length(d)
#' s   <- sd(d)
#' tq  <- qt(0.975, df = n - 1)
#' loa <- mean(d) + c(-1, 1) * 1.96 * s
#' seLoa <- sqrt(3 * s^2 / n)
#'
#' ba <- structure(list(
#'   mean       = (a + b) / 2,
#'   diff       = d,
#'   bias       = mean(d),
#'   biasCI     = mean(d) + c(-1, 1) * tq * s / sqrt(n),
#'   loaLower   = loa[1],
#'   loaUpper   = loa[2],
#'   loaLowerCI = loa[1] + c(-1, 1) * tq * seLoa,
#'   loaUpperCI = loa[2] + c(-1, 1) * tq * seLoa
#' ), class = "BlandAltman")
#'
#' plot(ba, main = "Method A vs. method B")
#' plot(ba, cband = TRUE, trend = TRUE)
#'

#' @family plot.s3  
#' @concept agreement  
#' @concept method-comparison
#'
#'
#' @export
plot.BlandAltman <- function(
    x,
    
    main = "",
    xlab = "Mean",
    ylab = "Difference",
    
    xlim = NULL,
    ylim = NULL,
    
    pch = 16,
    col = NULL,
    
    grid = TRUE,
    
    meanLine = TRUE,
    limits = TRUE,
    
    cband = FALSE,
    trend = FALSE,
    
    showText = TRUE,
    
    stamp = NULL,
    
    ...
){
  
  xx <- x$mean
  yy <- x$diff
  
  if(is.null(xlim))
    xlim <- range(xx, na.rm = TRUE)
  
  if(is.null(ylim))
    ylim <- range(
      c(
        yy,
        x$loaLower,
        x$loaUpper,
        x$loaLowerCI,
        x$loaUpperCI
      ),
      na.rm = TRUE
    )
  
  .withGraphicsState({
    
    plot(
      xx, yy,
      main = main,
      xlab = xlab,
      ylab = ylab,
      xlim = xlim,
      ylim = ylim,
      pch = pch,
      col = col,
      ...
    )
    
    if(grid)
      graphics::grid()
    
    if(cband){
      
      rect(
        xlim[1], x$biasCI[1],
        xlim[2], x$biasCI[2],
        border = NA,
        col = grDevices::adjustcolor(
          "skyblue",
          alpha.f = 0.3
        )
      )
      
      rect(
        xlim[1], x$loaLowerCI[1],
        xlim[2], x$loaLowerCI[2],
        border = NA,
        col = grDevices::adjustcolor(
          "skyblue",
          alpha.f = 0.3
        )
      )
      
      rect(
        xlim[1], x$loaUpperCI[1],
        xlim[2], x$loaUpperCI[2],
        border = NA,
        col = grDevices::adjustcolor(
          "skyblue",
          alpha.f = 0.3
        )
      )
      
    }
    
    if(meanLine)
      abline(
        h = x$bias,
        col = "brown",
        lwd = 2
      )
    
    if(limits)
      abline(
        h = c(
          x$loaLower,
          x$loaUpper
        ),
        col = "darkgreen",
        lty = 2,
        lwd = 2
      )
    
    if(trend){
      
      fit <- lm(
        yy ~ xx
      )
      
      abline(
        fit,
        col = "red",
        lwd = 2
      )
      
    }
    
    if(showText){
      
      xpos <- xlim[2]
      
      text(
        xpos,
        x$loaUpper,
        pos = 2,
        labels = sprintf(
          "Upper LoA = %.2f",
          x$loaUpper
        )
      )
      
      text(
        xpos,
        x$bias,
        pos = 2,
        labels = sprintf(
          "Bias = %.2f",
          x$bias
        )
      )
      
      text(
        xpos,
        x$loaLower,
        pos = 2,
        labels = sprintf(
          "Lower LoA = %.2f",
          x$loaLower
        )
      )
      
    }
    
    if(!is.null(stamp))
      mtext(
        stamp,
        side = 1,
        line = 4,
        adj = 1
      )
    
  })
  
  invisible(x)
  
}

