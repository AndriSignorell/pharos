
#' Coordinates for Named Plot Positions
#'
#' Returns the xy-coordinates and text-adjustment values for named anchor
#' positions such as \code{"topleft"}, \code{"center"}, etc., as used by
#' \code{\link{legend}}.  Useful for placing text or other annotations at
#' consistent, region-aware positions.
#'
#' @details
#' The positioning logic is adapted from \code{\link{legend}}.
#' The inset is computed in character units via \code{\link{strwidth}} and
#' \code{\link{strheight}}, making it robust to device resizing, font
#' changes, and plot-range scaling.
#'
#' Three regions are supported:
#' \describe{
#'   \item{\code{"plot"}}{The inner plot area (\code{par("usr")}).}
#'   \item{\code{"figure"}}{The figure region within the device, accounting
#'     for \code{par("fig")}.}
#'   \item{\code{"device"}}{The full device area.}
#' }
#'
#'
#' @param x       A character string specifying the anchor position.  One
#'   of \code{"bottomright"}, \code{"bottom"}, \code{"bottomleft"},
#'   \code{"left"}, \code{"topleft"}, \code{"top"}, \code{"topright"},
#'   \code{"right"}, or \code{"center"}.  Partial matching is supported.
#' @param region  One of \code{"figure"} (default), \code{"plot"}, or
#'   \code{"device"}.  Determines the coordinate region used.
#' @param cex Character expansion factor. If \code{NULL} (default),
#'   the current \code{par("cex")} is used.
#' @param inset   Inset distance from the boundary, specified in lines of
#'   text (character heights/widths).  May be a scalar (applied to both
#'   x and y) or a length-2 vector (x inset, y inset).  Default \code{0}.
#'
#' @return A list with two components:
#' \describe{
#'   \item{\code{xy}}{A list with elements \code{x} and \code{y} giving
#'     the anchor coordinates in user space.}
#'   \item{\code{adj}}{A numeric vector of length 2, suitable for the
#'     \code{adj} argument of \code{\link{text}}.}
#' }
#'
#' @examples
#' plot(x = rnorm(10), type = "n", xlab = "", ylab = "")
#'
#' # coordinates only
#' abcCoords("bottomleft")
#'
#' # place text at a named position
#' xy <- abcCoords("bottomleft", region = "plot")
#' text(x = xy$xy$x, y = xy$xy$y, labels = "My Label",
#'      adj = xy$adj, xpd = NA)
#'
#' # all nine positions with inset
#' sapply(c("topleft", "top", "topright",
#'          "left",    "center", "right",
#'          "bottomleft", "bottom", "bottomright"),
#'   function(p) {
#'     xy <- abcCoords(p, region = "plot", inset = 1)
#'     text(x = xy$xy$x, y = xy$xy$y,
#'          labels = p, adj = xy$adj, xpd = NA)
#'   })
#'
#' @seealso \code{\link{text}}, \code{\link{legend}}
#'
#' @family graphics.layout
#' @concept annotation
#'
#' @export
abcCoords <- function(x       = "topleft",
                      region  = c("figure", "plot", "device"),
                      cex     = NULL,
                      inset   = 0) {
  
  region <- match.arg(region)
  pos    <- match.arg(x, c("bottomright", "bottom", "bottomleft",
                           "left", "topleft", "top", "topright",
                           "right", "center"))
  
  # resolve cex: use par("cex") when not supplied
  if (is.null(cex))
    cex <- par("cex")
  
  # --- coordinate limits of the requested region ----------------------
  if (region %in% c("figure", "device")) {
    
    ds   <- dev.size("in")
    xlim <- grconvertX(c(0, ds[1L]), from = "in", to = "user")
    ylim <- grconvertY(c(0, ds[2L]), from = "in", to = "user")
    
    if (region == "figure") {
      fig  <- par("fig")
      dx   <- xlim[2L] - xlim[1L]
      dy   <- ylim[2L] - ylim[1L]
      xlim <- xlim[1L] + dx * fig[1L:2L]
      ylim <- ylim[1L] + dy * fig[3L:4L]
    }
    
  } else {
    usr  <- par("usr")
    xlim <- usr[1L:2L]
    ylim <- usr[3L:4L]
  }
  
  # --- inset in user coordinates --------------------------------------
  inset  <- rep(inset, length.out = 2L)
  insetx <- inset[1L] * strwidth ("M", cex = cex, units = "user")
  insety <- inset[2L] * strheight("M", cex = cex, units = "user")
  
  # --- anchor x --------------------------------------------------------
  x1 <- switch(pos,
               bottomright = , topright = , right  = xlim[2L] - insetx,
               bottomleft  = , topleft  = , left   = xlim[1L] + insetx,
               bottom      = , top      = , center = (xlim[1L] + xlim[2L]) / 2
  )
  
  # --- anchor y --------------------------------------------------------
  y1 <- switch(pos,
               bottomright = , bottom = , bottomleft = ylim[1L] + insety,
               topleft     = , top    = , topright   = ylim[2L] - insety,
               left        = , right  = , center     = (ylim[1L] + ylim[2L]) / 2
  )
  
  # --- text adjustment -------------------------------------------------
  adj <- switch(pos,
                topleft     = c(0,   1  ),
                top         = c(0.5, 1  ),
                topright    = c(1,   1  ),
                left        = c(0,   0.5),
                center      = c(0.5, 0.5),
                right       = c(1,   0.5),
                bottomleft  = c(0,   0  ),
                bottom      = c(0.5, 0  ),
                bottomright = c(1,   0  )
  )
  
  list(xy = list(x = x1, y = y1), adj = adj)
}

