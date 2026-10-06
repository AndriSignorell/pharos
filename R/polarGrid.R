
#' Draw a Polar Grid with Optional Labels
#'
#' Adds a polar coordinate grid (circles and radial lines) to an existing plot.
#' Optionally includes labels for radii and angles.
#'
#' @param nRadial numeric or vector controlling radial grid lines:
#'   \describe{
#'     \item{`NULL`}{Uses default "pretty" axis values.}
#'     \item{single numeric}{Number of radial grid lines.}
#'     \item{numeric vector}{Explicit radii at which to draw circles.}
#'     \item{all `NA`}{Suppress radial grid lines.}
#'   }
#' @param nAngular numeric or vector controlling angular grid lines:
#'   \describe{
#'     \item{`NULL`}{Uses 12 equally spaced angles.}
#'     \item{single numeric}{Number of angular divisions.}
#'     \item{numeric vector}{Explicit angles (in radians).}
#'     \item{all `NA`}{Suppress angular grid lines.}
#'   }
#' @param radialLabels optional labels for radial grid lines (excluding zero).
#'   If `NULL`, labels are generated automatically.
#'   Use `NA` to suppress labels.
#' @param angleLabels optional labels for angular grid lines.
#'   If `NULL`, labels are generated automatically (degrees or radians).
#'   Use `NA` to suppress labels.
#' @param labelRadians logical; if `TRUE`, angle labels are shown in radians,
#'   otherwise in degrees.
#' @param col color of grid lines.
#' @param lty line type for grid lines.
#' @param lwd line width for grid lines.
#' @param cex character expansion factor for the labels.
#' @param las integer controlling label orientation (as in [graphics::par()]).
#' @param adj numeric vector specifying text justification.
#' @param dist numeric distance from origin for angular labels.
#'
#' @details
#' This function is intended to be used together with polar plotting functions
#' such as `plotPolar`. It assumes an existing plot with equal aspect ratio.
#'
#' Radial grid lines are drawn as concentric circles, while angular grid lines
#' are drawn as segments from the origin.
#'
#' Label placement and formatting can be customized via `adj`, `las`,
#' and `dist`.
#'
#' @return
#' Invisibly returns `NULL`.
#'
#' @examples
#' plot(0, 0, type = "n", xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)
#' polarGrid()
#'
#' # custom grid
#' plot(0, 0, type = "n", xlim = c(-2, 2), ylim = c(-2, 2), asp = 1)
#' polarGrid(nRadial = 4, nAngular = 8, col = "gray")
#'
#' # suppress labels
#' polarGrid(radialLabels = NA, angleLabels = NA)
#' 
#' 
#' @seealso [grid()]
#' @family graphics.setup
#' @concept geometry
#' @concept annotation
#'
#'
#' @export
polarGrid <- function(nRadial = NULL, nAngular = NULL,
                      radialLabels = NULL, angleLabels = NULL,
                      labelRadians = FALSE,
                      col = "lightgray",
                      lty = "dotted", lwd = par("lwd"),
                      cex = 1, las = 1, adj = NULL, dist = NULL) {
  
  if (is.null(nRadial)) {             # use standard values with pretty axis values
    # at <- seq.int(0, par("xaxp")[2L], length.out = 1L + abs(par("xaxp")[3L]))
    at <- axTicks(1)[axTicks(1)>=0]
  } else if (!all(is.na(nRadial))) {  # use NA for suppress radial gridlines
    if (length(nRadial) > 1) {        # use nRadial as radii
      at <- nRadial
    } else {
      at <- seq.int(0, par("xaxp")[2L], length.out = nRadial + 1)#[-c(1, nRadial + 1)]
    }
  } else {at <- NULL}
  if(!is.null(at))
    lines(circle(radius = at), col = col, lty = lty)
  
  if (is.null(nAngular)) {             # use standard values with pretty axis values
    at.ang <- seq(0, 2*pi, by=2*pi/12)
  } else if (!all(is.na(nAngular))) {  # use NA for suppress radial gridlines
    if (length(nAngular) > 1) {        # use nAngular as angles
      at.ang <- nAngular
    } else {
      at.ang <- seq(0, 2*pi, by=2*pi/nAngular)
    }
  } else {at.ang <- NULL}
  if(!is.null(at.ang)) segments(x0=0, y0=0, x1=max(par("usr"))*cos(at.ang)
                                , y1=max(par("usr"))*sin(at.ang), col = col, lty = lty, lwd = lwd)
  
  # plot radius labels
  if(!is.null(at)){
    if(is.null(radialLabels)) radialLabels <- signif(at[-1], 3)   # standard values
    if(!all(is.na(radialLabels)))
      boxedText(x=at[-1], y=0, labels=radialLabels, border=FALSE, bg="white", cex=cex)
  }

  # plot angle labels
  if(!is.null(at.ang)){
    
    if(is.null(angleLabels))
      if(labelRadians == FALSE){
        angleLabels <- radToDeg(at.ang[-length(at.ang)])   # standard values in degrees
      } else {
        angleLabels <- fm(at.ang[-length(at.ang)], digits=2)   # standard values in radians
      }
    
    if(is.null(dist))
      dist <- par("usr")[2]*1.07
    
    out <- polToCart(r = dist, theta=at.ang)
    
    if(!all(is.na(angleLabels)))
      
      if(is.null(adj)) {
        adj <- ifelse(at.ang %(]% c(pi/2, 3*pi/2), 1, 0)
        adj[at.ang %in% c(pi/2, 3*pi/2)] <- 0.5
      }
    adj <- rep(adj, length_out=length(angleLabels))
    
    if(las == 2){
      sapply(seq_along(angleLabels),
             function(i) text(out$x[i], out$y[i], labels=angleLabels[i], cex=cex,
                              srt=radToDeg(atan(out$y[i]/out$x[i])), adj=adj[i]))
    } else {
      sapply(seq_along(angleLabels),
             function(i) boxedText(x=out$x[i], y=out$y[i], labels=angleLabels[i], cex=cex,
                                   srt=ifelse(las==3, 90, 0), adj=adj[i],
                                   border=NA, col="white"))

    }
  }
  
  invisible()
  
}



