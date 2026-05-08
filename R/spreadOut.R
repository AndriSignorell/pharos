
#' Spread Out a Vector of Numbers To a Minimum Interval
#' 
#' Spread the numbers of a vector so that there is a minimum interval between
#' any two numbers (in ascending or descending order). This is helpful when we
#' want to place textboxes on a plot and ensure, that they do not mutually
#' overlap.
#' 
#' \code{spreadOut()} starts at or near the middle of the vector and increases
#' the intervals between the ordered values. \code{NA}s are preserved.
#' \code{spreadOut()} first tries to spread groups of values with intervals
#' less than \code{mindist} out neatly away from the mean of the group. If this
#' doesn't entirely succeed, a second pass that forces values away from the
#' middle is performed.
#' 
#' \code{spreadOut()} can also be used to avoid overplotting of axis tick
#' labels where they may be close together.
#' 
#' @param x a numeric vector which may contain \code{NA}s.
#' @param mindist the minimum interval between any two values. If this is left
#' to \code{NULL} (default) the function will check if a plot is open and then
#' use 90%% of \code{\link{strheight}()}.
#' @param cex numeric character expansion factor; multiplied by
#' \code{\link{par}("cex")} yields the final character size; the default
#' \code{NULL} is equivalent to \code{1}.
#' @return On success, the spread out values. If there are less than two valid
#' values, the original vector is returned.
#' @note This function is based on \code{plotrix::spreadOut()} and has been
#' integrated here with some minor changes.
#' 
#' @note Based on code by Jim Lemon <jim@@bitwrit.com.au>
#' 
#' @seealso \code{\link{strheight}()}
#' @keywords misc
#' @examples
#' 
#' spreadOut(c(1, 3, 3, 3, 3, 5), 0.2)
#' spreadOut(c(1, 2.5, 2.5, 3.5, 3.5, 5), 0.2)
#' spreadOut(c(5, 2.5, 2.5, NA, 3.5, 1, 3.5, NA), 0.2)
#' 
#' # this will almost always invoke the brute force second pass
#' spreadOut(rnorm(10), 0.5)
#' 


#' @family plot.utils
#' @concept graphics
#' @concept vector-manipulation
#'
#'
#' @export
spreadOut <- function(x, mindist = NULL, cex = 1.0) {
  
  if(is.null(mindist))
    mindist <- 0.9 * max(strheight(x, "inch", cex = cex))
  
  if(sum(!is.na(x)) < 2) return(x)
  xorder <- order(x)
  goodx <- x[xorder][!is.na(x[xorder])]
  gxlen <- length(goodx)
  start <- end <- gxlen%/%2
  
  # nicely spread groups of short intervals apart from their mean
  while(start > 0) {
    while(end < gxlen && goodx[end+1] - goodx[end] < mindist) end <- end+1
    while(start > 1 && goodx[start] - goodx[start-1] < mindist) start <- start-1
    if(start < end) {
      nsqueezed <- 1+end-start
      newx <- sum(goodx[start:end]) / nsqueezed - mindist * (nsqueezed %/% 2 - (nsqueezed / 2 == nsqueezed %/% 2) * 0.5)
      for(stretch in start:end) {
        goodx[stretch] <- newx
        newx <- newx+mindist
      }
    }
    start <- end <- start-1
  }
  
  start <- end <- length(goodx) %/% 2 + 1
  while(start < gxlen) {
    while(start > 1 && goodx[start] - goodx[start-1] < mindist) start <- start-1
    while(end < gxlen && goodx[end+1] - goodx[end] < mindist) end <- end+1
    if(start < end) {
      nsqueezed <- 1 + end - start
      newx <- sum(goodx[start:end]) / nsqueezed - mindist * (nsqueezed %/% 2 - (nsqueezed / 2 == nsqueezed %/% 2) * 0.5)
      for(stretch in start:end) {
        goodx[stretch] <- newx
        newx <- newx+mindist
      }
    }
    start <- end <- end+1
  }
  
  # force any remaining short intervals apart
  if(any(diff(goodx) < mindist)) {
    start <- gxlen %/% 2
    while(start > 1) {
      if(goodx[start] - goodx[start-1] < mindist)
        goodx[start-1] <- goodx[start] - mindist
      start <- start-1
    }
    end <- gxlen %/% 2
    while(end < gxlen) {
      if(goodx[end+1] - goodx[end] < mindist)
        goodx[end+1] <- goodx[end]+mindist
      end <- end+1
    }
  }
  
  x[xorder][!is.na(x[xorder])] <- goodx
  return(x)
  
}
