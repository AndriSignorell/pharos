
#' Bland-Altman Plot
#'
#' Plots a Bland-Altman agreement analysis.
#'
#' Objects of class \code{"blandAltman"} are typically created with
#' \code{DescToolsX::blandAltmanData()}.
#'
#' @param x An object of class \code{"blandAltman"}.
#'
#' @param main Plot title.
#' @param xlab X-axis label.
#' @param ylab Y-axis label.
#'
#' @param xlim X-axis limits.
#' @param ylim Y-axis limits.
#'
#' @param pch Plotting symbol.
#' @param col Point colour.
#'
#' @param grid Logical; draw a background grid.
#' @param meanLine Logical; draw the bias line.
#' @param limits Logical; draw the limits of agreement.
#' @param conf.band Logical; draw confidence bands.
#' @param trend Logical; draw a regression line of
#' differences versus means.
#' @param showText Logical; annotate bias and limits.
#'
#' @param stamp Optional plot stamp.
#' @param ... Further arguments passed to \code{plot()}.
#'
#' @return
#' Invisibly returns \code{x}.
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
    
    conf.band = FALSE,
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
    
    if(conf.band){
      
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

