
#' Draw a Polar Grid with Optional Labels
#'
#' Adds a polar coordinate grid (circles and radial lines) to an existing plot.
#' Optionally includes labels for radii and angles.
#'
#' @param nr Numeric or vector controlling radial grid lines:
#'   \describe{
#'     \item{\code{NULL}}{Uses default "pretty" axis values.}
#'     \item{single numeric}{Number of radial grid lines.}
#'     \item{numeric vector}{Explicit radii at which to draw circles.}
#'     \item{all \code{NA}}{Suppress radial grid lines.}
#'   }
#' @param ntheta Numeric or vector controlling angular grid lines:
#'   \describe{
#'     \item{\code{NULL}}{Uses 12 equally spaced angles.}
#'     \item{single numeric}{Number of angular divisions.}
#'     \item{numeric vector}{Explicit angles (in radians).}
#'     \item{all \code{NA}}{Suppress angular grid lines.}
#'   }
#' @param col Color of grid lines.
#' @param lty Line type for grid lines.
#' @param lwd Line width for grid lines.
#' @param rlabels Optional labels for radial grid lines (excluding zero).
#'   If \code{NULL}, labels are generated automatically.
#'   Use \code{NA} to suppress labels.
#' @param alabels Optional labels for angular grid lines.
#'   If \code{NULL}, labels are generated automatically (degrees or radians).
#'   Use \code{NA} to suppress labels.
#' @param lblradians Logical; if \code{TRUE}, angle labels are shown in radians,
#'   otherwise in degrees.
#' @param cex.lab Character expansion factor for labels.
#' @param las Integer controlling label orientation (as in \code{\link[graphics]{par}}).
#' @param adj Numeric vector specifying text justification.
#' @param dist Numeric distance from origin for angular labels.
#'
#' @details
#' This function is intended to be used together with polar plotting functions
#' such as \code{plotPolar}. It assumes an existing plot with equal aspect ratio.
#'
#' Radial grid lines are drawn as concentric circles, while angular grid lines
#' are drawn as segments from the origin.
#'
#' Label placement and formatting can be customized via \code{adj}, \code{las},
#' and \code{dist}.
#'
#' @return
#' Invisibly returns \code{NULL}.
#'
#' @examples
#' plot(0, 0, type = "n", xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)
#' polarGrid()
#'
#' # custom grid
#' plot(0, 0, type = "n", xlim = c(-2, 2), ylim = c(-2, 2), asp = 1)
#' polarGrid(nr = 4, ntheta = 8, col = "gray")
#'
#' # suppress labels
#' polarGrid(rlabels = NA, alabels = NA)
#'



#' @family geometry  
#' @concept geometry
#'
#'
#' @export
polarGrid <- function(nr = NULL, ntheta = NULL, 
                      col = "lightgray",
                      lty = "dotted", lwd = par("lwd"), 
                      rlabels = NULL, alabels = NULL,
                      lblradians = FALSE, 
                      cex.lab = 1, las = 1, adj = NULL, dist = NULL) {
  
  if (is.null(nr)) {             # use standard values with pretty axis values
    # at <- seq.int(0, par("xaxp")[2L], length.out = 1L + abs(par("xaxp")[3L]))
    at <- axTicks(1)[axTicks(1)>=0]
  } else if (!all(is.na(nr))) {  # use NA for suppress radial gridlines
    if (length(nr) > 1) {        # use nr as radius
      at <- nr
    } else {
      at <- seq.int(0, par("xaxp")[2L], length.out = nr + 1)#[-c(1, nr + 1)]
    }
  } else {at <- NULL}
  if(!is.null(at))
    lines(circle(radius = at), col = col, lty = lty)
  
  if (is.null(ntheta)) {             # use standard values with pretty axis values
    at.ang <- seq(0, 2*pi, by=2*pi/12)
  } else if (!all(is.na(ntheta))) {  # use NA for suppress radial gridlines
    if (length(ntheta) > 1) {        # use ntheta as angles
      at.ang <- ntheta
    } else {
      at.ang <- seq(0, 2*pi, by=2*pi/ntheta)
    }
  } else {at.ang <- NULL}
  if(!is.null(at.ang)) segments(x0=0, y0=0, x1=max(par("usr"))*cos(at.ang)
                                , y1=max(par("usr"))*sin(at.ang), col = col, lty = lty, lwd = lwd)
  
  # plot radius labels
  if(!is.null(at)){
    if(is.null(rlabels)) rlabels <- signif(at[-1], 3)   # standard values
    if(!all(is.na(rlabels)))
      boxedText(x=at[-1], y=0, labels=rlabels, border=FALSE, bg="white", cex=cex.lab)
  }

  # plot angle labels
  if(!is.null(at.ang)){
    
    if(is.null(alabels))
      if(lblradians == FALSE){
        alabels <- radToDeg(at.ang[-length(at.ang)])   # standard values in degrees
      } else {
        alabels <- fm(at.ang[-length(at.ang)], digits=2)   # standard values in radians
      }
    
    if(is.null(dist))
      dist <- par("usr")[2]*1.07
    
    out <- polToCart(r = dist, theta=at.ang)
    
    if(!all(is.na(alabels)))
      
      if(is.null(adj)) {
        adj <- ifelse(at.ang %(]% c(pi/2, 3*pi/2), 1, 0)
        adj[at.ang %in% c(pi/2, 3*pi/2)] <- 0.5
      }
    adj <- rep(adj, length_out=length(alabels))
    
    if(las == 2){
      sapply(seq_along(alabels),
             function(i) text(out$x[i], out$y[i], labels=alabels[i], cex=cex.lab,
                              srt=radToDeg(atan(out$y[i]/out$x[i])), adj=adj[i]))
    } else {
      sapply(seq_along(alabels),
             function(i) boxedText(x=out$x[i], y=out$y[i], labels=alabels[i], cex=cex.lab,
                                   srt=ifelse(las==3, 90, 0), adj=adj[i],
                                   border=NA, col="white"))

    }
  }
  
  invisible()
  
}



