
#' Place Value Labels on a Barplot 
#' 
#' It can sometimes make sense to display data values directly on the bars in a
#' barplot. There are a handful of obvious alternatives for placing the labels,
#' either on top of the bars, right below the upper end, in the middle or at
#' the bottom. Determining the required geometry - although not difficult - is
#' cumbersome and the code is distractingly long within an analysis code. The
#' present function offers a short way to solve the task. It can place text
#' either in the middle of the stacked bars, on top or on the bottom of a
#' barplot (side by side or stacked).  
#' 
#' The x coordinates of the labels can be found by using
#' [barplot()] result, if they are to be centered at the top of
#' each bar. `barText()` calculates the rest.
#' 
#' \ifelse{html}{\figure{barText.png}{options: width="700" alt="Positions for the text"}}{\figure{barText.png}{Positions for the text}}
#'   
#' Notice that when the labels are placed on top of the bars, they may be
#' clipped. This can be avoided by setting `xpd=TRUE`.
#' 
#' @param height either a vector or matrix of values describing the bars which
#' make up the plot exactly as used for creating the barplot. 
#' @param mids the returned mid points as returned by `b <- barplot(...)`. 
#' @param labels the labels to be placed on the bars. 
#' @param beside a logical value. If `FALSE`, the columns of height are
#' portrayed as stacked bars, and if `TRUE` the columns are portrayed as
#' juxtaposed bars. 
#' @param horiz a logical value. If `FALSE`, the bars are drawn vertically
#' with the first bar to the left. If `TRUE`, the bars are drawn
#' horizontally with the first at the bottom. 
#' @param cex numeric character expansion factor; multiplied by
#' [par()]`("cex")` yields the final character size. `NULL`
#' and `NA` are equivalent to `1.0`.
#' @param adj one or two values in \verb{[0, 1]} which specify the x (and optionally
#' y) adjustment of the labels. On most devices values outside that interval
#' will also work.
#' @param pos one of `"top-out"`, `"top-in"`, `"mid"`,
#' `"bottom-in"`, `"bottom-out"`, defining if the labels should be
#' placed on top of the bars (inside or outside) or at the bottom of the bars
#' (inside or outside).
#' @param offset a vector indicating how much the bars should be shifted
#' relative to the x axis.
#' @param col the color and to be used, possibly a vector (default in par("col")).
#' @param \dots the dots are passed to the [boxedText()]. 
#' 
#' @return returns the geometry of the labels invisibly
#' 
#' 
#' @examples
#' 
#' # simple vector
#' x <- c(353, 44, 56, 34)
#' b <- barplot(x)
#' barText(x, b, x)
#' 
#' # more complicated
#' b <- barplot(VADeaths, horiz = FALSE, col="steelblue", beside = TRUE)
#' barText(VADeaths, mids=b, horiz = FALSE, beside = TRUE, cex=0.8)
#' barText(VADeaths, mids=b, horiz = FALSE, beside = TRUE, cex=0.8, pos="bottom-in",
#'         col="white", font=2)
#' 
#' b <- barplot(VADeaths, horiz = TRUE, col="steelblue", beside = TRUE)
#' barText(VADeaths, mids=b, horiz = TRUE, beside = TRUE, cex=0.8)
#' 
#' b <- barplot(VADeaths)
#' barText(VADeaths, mids=b)
#' 
#' b <- barplot(VADeaths, horiz = TRUE)
#' barText(VADeaths, mids=b, horiz = TRUE, col="red", cex=1.5)
#' 
#' @family graphics.annotation
#' @concept annotation
#' @concept label
#'
#'
#' @export
barText <- function(height, mids, labels = height, beside = FALSE, horiz = FALSE,
                    cex = par("cex"),
                    adj = NULL,
                    pos = c("top-out", "top-in", "mid", "bottom-in", "bottom-out"),
                    offset = 0, col = NULL, ...) {
  
  pos <- match.arg(pos)
  
  ## ------------------------------------------------------------------
  ## helper: boxed text wrapper
  ## ------------------------------------------------------------------
  .btext <- function(x, y = NULL, labels, adj = NULL,
                     cex = 1, col = NULL, ...) {
    boxedText(x = x, y = y, labels = labels,
              adj = adj, cex = cex, col = col, ...)
  }
  
  ## ------------------------------------------------------------------
  ## normalize input
  ## ------------------------------------------------------------------
  if (is.vector(height) || (is.array(height) && length(dim(height)) == 1)) {
    height <- cbind(height)
    beside <- TRUE
  }
  
  if(!is.null(col))
    col    <- t(matrix(rep_len(col, length(height)), nrow = nrow(height)))
  # else leave NULL
  
  offset <- rep_len(as.vector(offset), length(height))
  
  char_w <- par("cxy")[1] * cex
  char_h <- par("cxy")[2] * cex
  
  ## ==================================================================
  ## BESIDE MODE
  ## ==================================================================
  if (beside) {
    
    if (horiz) {
      
      adjy <- 0.5
      if (is.null(adj)) adj <- 0
      
      shift <- 1.2 * sign(height) * char_w
      
      x <- switch(pos,
                  "top-out"    = height + offset + shift,
                  "top-in"     = height + offset - shift,
                  mid          = offset + height / 2,
                  "bottom-in"  = offset + shift,
                  "bottom-out" = offset - shift
      )
      
      adjx <- switch(pos,
                     "top-out"    = -sign(height),
                     "top-in"     =  sign(height),
                     mid          =  0.5,
                     "bottom-in"  = -sign(height),
                     "bottom-out" =  sign(height)
      )
      
      pp <- recycle(b = mids, x = x, labels = labels,
                    adjx = adjx, adjy = adjy)
      
      for (i in seq_len(attr(pp, "maxdim"))) {
        with(pp,
             .btext(
               x = x[i], y = mids[i],
               labels = labels[i],
               adj = c(adjx[i], adjy[i]),
               cex = cex, col = col, xpd = TRUE, ...
             )
        )
      }
      
      return(invisible(pp$x))
    }
    
    ## -------- vertical beside --------
    
    if (is.null(adj)) adj <- 0.5
    shift <- sign(height) * char_h
    
    y <- switch(pos,
                "top-out"    = height + offset + shift,
                "top-in"     = height + offset - shift,
                mid          = offset + height / 2,
                "bottom-in"  = offset + shift,
                "bottom-out" = offset - shift
    )
    
    .btext(x = mids, y = y, labels = labels,
           adj = adj, cex = cex, col = col,
           xpd = TRUE, ...)
    
    return(invisible(y))
  }
  
  ## ==================================================================
  ## STACKED MODE
  ## ==================================================================
  
  shift <- if (horiz) char_w * 0.5 else char_h * 0.25
  
  cum_height <- apply(offset + height, 2, cumsum)
  
  x <- switch(pos,
              "top-out"    = t(cum_height + sign(height) * shift),
              "top-in"     = t(cum_height - sign(height) * shift),
              mid          = t(apply(offset + height, 2, midx,
                                  inclZero = TRUE, cumulate = TRUE)),
              "bottom-in"  = t(head(rbind(0, cum_height), -1) +
                              sign(height) * shift),
              "bottom-out" = t(head(rbind(0, cum_height), -1) -
                              sign(height) * shift)
  )
  
  adj_base <- switch(pos,
                     "top-out"    = 0,
                     "top-in"     = 1,
                     mid          = 0.5,
                     "bottom-in"  = 0,
                     "bottom-out" = 1
  )
  
  if (is.null(adj)) adj <- 0.5
  
  if (horiz) {
    .btext(x = x, y = mids,
           labels = t(labels),
           adj = c(adj_base, 0.5),
           cex = cex, col = col, ...)
  } else {
    .btext(x = mids, y = x,
           labels = t(labels),
           adj = c(0.5, adj_base),
           cex = cex, col = col, ...)
  }
  
  invisible(x)
}


