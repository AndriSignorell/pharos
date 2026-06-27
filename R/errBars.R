
#' Add Error Bars to an Existing Plot
#'
#' Add vertical or horizontal error bars to an existing plot.
#'
#' This is a lightweight wrapper around \code{\link{arrows}} with
#' optional point symbols added via \code{\link{points}}.
#'
#' @details
#' Additional graphical arguments in \code{...} are passed to
#' \code{\link{arrows}} and may be used to control the appearance
#' of the error bars.
#'
#' Common examples include:
#' \itemize{
#'   \item \code{col}: line color
#'   \item \code{lwd}: line width
#'   \item \code{lty}: line type
#'   \item \code{code}: which end caps to draw
#'   \item \code{length}: length of the end caps
#' }
#'
#' Point symbols may optionally be added:
#' \itemize{
#'   \item \code{points = TRUE}: draw default points halfway between
#'     \code{from} and \code{to}
#'   \item \code{points = numeric}: use these values as point coordinates
#'   \item \code{points = list(...)}: fully specify point coordinates
#'     and graphical parameters
#' }
#'
#' Example:
#' \preformatted{
#' points = list(
#'   val = estimate,
#'   pch = 21,
#'   bg  = "gold",
#'   col = "black",
#'   cex = 1.2
#' )
#' }
#' 
#' The default orientation is horizontal (\code{horiz = TRUE}), which
#' suits the typical use case of adding confidence intervals to a
#' \code{\link{dotchart}}.  Set \code{horiz = FALSE} for vertical bars
#' on barplots or similar.
#'
#' @param from Coordinates of the lower end of the error bars.
#'
#'   If \code{to = NULL} and \code{from} is a matrix:
#'   \itemize{
#'     \item a 2-column matrix is interpreted as
#'       \code{cbind(from, to)}
#'     \item a 3-column matrix is interpreted as
#'       \code{cbind(point, from, to)}
#'   }
#'
#' @param to Coordinates of the upper end of the error bars.
#'
#' @param pos Position of the error bars.
#'
#'   For vertical bars this corresponds to x-positions;
#'   for horizontal bars to y-positions.
#'
#' @param horiz Logical; if \code{TRUE}, horizontal error bars
#'   are drawn.
#'
#' @param points Optional point specification.
#'
#' @param ... Additional graphical arguments passed to
#'   \code{\link{arrows}}.
#'
#' @return
#' Invisibly returns a list with components:
#' \describe{
#'   \item{from}{Lower endpoints}
#'   \item{to}{Upper endpoints}
#'   \item{pos}{Positions of the error bars}
#'   \item{points}{Point coordinates}
#' }
#'
#' @seealso
#' \code{\link{arrows}},
#' \code{\link{points}}
#'
#' @examples
#' op <- par(no.readonly = TRUE)
#' par(mfrow = c(2, 2))
#'
#' b <- barplot(1:5, ylim = c(0, 6))
#'
#' errBars(
#'   from = 1:5 - 0.5,
#'   to = 1:5 + 0.5,
#'   pos = b,
#'   length = 0.15
#' )
#'
#' # midpoint symbols
#' b <- barplot(1:5, ylim = c(0, 6))
#'
#' errBars(
#'   from = 1:5 - 0.5,
#'   to = 1:5 + 0.5,
#'   pos = b,
#'   points = TRUE
#' )
#'
#' # custom points
#' dotchart(1:5, xlim = c(0, 6))
#'
#' errBars(
#'   from = 1:5 - 0.2,
#'   to = 1:5 + 0.2,
#'   horiz = TRUE,
#'   points = list(
#'     val = 1:5,
#'     pch = 21,
#'     bg = "gold",
#'     col = "black",
#'     cex = 1.2
#'   )
#' )
#'
#' par(op)
#'
#' @family plot.augmentation
#' @concept graphics
#' @concept plot-augmentation
#'

#' @export
errBars <- function(
    from,
    to = NULL,
    pos = NULL,
    horiz = TRUE,
    points = NULL,
    ...
) {
  
  # --- matrix interface ----------------------------------------------
  
  if (is.null(to)) {
    
    if (!is.matrix(from) || !(ncol(from) %in% c(2L, 3L))) {
      
      stop(
        "'from' must be a 2- or 3-column matrix ",
        "when 'to' is NULL."
      )
      
    }
    
    if (ncol(from) == 2L) {
      
      to   <- from[, 2L]
      from <- from[, 1L]
      
    } else {
      
      pointVal <- from[, 1L]
      to       <- from[, 3L]
      from     <- from[, 2L]
      
      # no points argument supplied
      if (is.null(points)) {
        
        points <- list(
          val = pointVal,
          pch = 1
        )
        
        # points = TRUE
      } else if (isTRUE(points)) {
        
        points <- list(
          val = pointVal,
          pch = 1
        )
        
        # points = numeric vector
      } else if (is.atomic(points)) {
        
        stop(
          "Point coordinates supplied twice: ",
          "via 3-column matrix and via 'points'."
        )
        
        # points = list(...)
      } else if (is.list(points)) {
        
        if (!is.null(points$val)) {
          
          stop(
            "Point coordinates supplied twice: ",
            "via 3-column matrix and via 'points$val'."
          )
          
        }
        
        points$val <- pointVal
        
      }
    }
  }
  
  # --- defaults ------------------------------------------------------
  
  if (is.null(pos))
    pos <- seq_along(from)
  
  # --- checks --------------------------------------------------------
  
  if (length(from) != length(to))
    stop("'from' and 'to' must have equal length.")
  
  if (length(pos) != length(from))
    stop("'pos' must have the same length as 'from'.")
  
  # --- arrows --------------------------------------------------------
  
  tmp <- bedrock::extractArgs(
    dots = list(...),
    defaults = list(
      angle  = 90,
      code   = 3,
      length = 0.05
    ),
    returnRest = TRUE
  )
  
  arrArgs <- tmp$args
  dots    <- tmp$rest
  
  if (horiz) {
    
    do.call(
      arrows,
      c(
        list(
          x0 = from,
          x1 = to,
          y0 = pos
        ),
        arrArgs,
        dots
      )
    )
    
  } else {
    
    do.call(
      arrows,
      c(
        list(
          x0 = pos,
          y0 = from,
          y1 = to
        ),
        arrArgs,
        dots
      )
    )
    
  }
  

  # --- points --------------------------------------------------------
  
  if (!is.null(points)) {
    
    # points = TRUE
    if (isTRUE(points)) {
      
      points <- list(
        val = (from + to) / 2,
        pch = 1
      )
      
      # points = numeric vector
    } else if (is.atomic(points)) {
      
      points <- list(
        val = points,
        pch = 1
      )
      
    }
    
    # defaults
    if (is.null(points$val))
      points$val <- (from + to) / 2
    
    if (is.null(points$pch))
      points$pch <- 1
    
    val <- points$val
    
    # remove non-graphical helper field
    points$val <- NULL
    
    callIf(
      graphics::points,
      points,
      defaults = list(
        x = if (horiz) val else pos,
        y = if (horiz) pos else val
      )
    )
  }
  
  
  invisible(list(
    from = from,
    to = to,
    pos = pos,
    points = points
  ))
}

