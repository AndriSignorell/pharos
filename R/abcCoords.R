
#' Coordinates for Named Plot Positions
#'
#' Returns the xy-coordinates and text-adjustment values for named anchor
#' positions such as `"topleft"`, `"center"`, etc., as used by
#' [legend()].  Useful for placing text or other annotations at
#' consistent, region-aware positions.
#'
#' @details
#' The positioning logic is adapted from [legend()].
#' The inset is computed in character units via [strwidth()] and
#' [strheight()], making it robust to device resizing, font
#' changes, and plot-range scaling.
#'
#' Three regions are supported:
#' \describe{
#'   \item{`"plot"`}{The inner plot area (`par("usr")`).  The
#'     default, and the region [legend()] positions in.}
#'   \item{`"figure"`}{The figure region within the device, accounting
#'     for `par("fig")`.}
#'   \item{`"device"`}{The full device area.}
#' }
#'
#' Coordinates for `"figure"` and `"device"` lie outside
#' `par("usr")` and are therefore clipped away by [text()]
#' and friends unless the drawing call sets `xpd = NA`.  The returned
#' values are in user space either way; only the clipping has to be turned
#' off by the caller.
#'
#'
#' @param x       A character string specifying the anchor position.  One
#'   of `"bottomright"`, `"bottom"`, `"bottomleft"`,
#'   `"left"`, `"topleft"`, `"top"`, `"topright"`,
#'   `"right"`, or `"center"`.  Partial matching is supported.
#' @param region  one of `"plot"` (default), `"figure"`, or
#'   `"device"`.  Determines the coordinate region used.  See Details
#'   for the clipping that comes with the latter two.
#' @param cex character expansion factor. If `NULL` (default),
#'   the current `par("cex")` is used.
#' @param inset   inset distance from the boundary, specified in lines of
#'   text (character heights/widths).  May be a scalar (applied to both
#'   x and y) or a length-2 vector (x inset, y inset).  Default `0`.
#'
#' @return A list with two components:
#' \describe{
#'   \item{`xy`}{A list with elements `x` and `y` giving
#'     the anchor coordinates in user space.}
#'   \item{`adj`}{A numeric vector of length 2, suitable for the
#'     `adj` argument of [text()].}
#' }
#'
#' @examples
#' plot(x = rnorm(10), type = "n", xlab = "", ylab = "")
#'
#' # coordinates only
#' abcCoords("bottomleft")
#'
#' # place text at a named position
#' xy <- abcCoords("bottomleft")
#' text(x = xy$xy$x, y = xy$xy$y, labels = "My Label", adj = xy$adj)
#'
#' # all nine positions with inset
#' sapply(c("topleft", "top", "topright",
#'          "left",    "center", "right",
#'          "bottomleft", "bottom", "bottomright"),
#'   function(p) {
#'     xy <- abcCoords(p, inset = 1)
#'     text(x = xy$xy$x, y = xy$xy$y,
#'          labels = p, adj = xy$adj)
#'   })
#'
#' # the margins need xpd = NA, whatever the coordinates say
#' xy <- abcCoords("bottomright", region = "figure", inset = 0.5)
#' text(x = xy$xy$x, y = xy$xy$y, labels = "source: ...",
#'      adj = xy$adj, cex = 0.7, xpd = NA)
#'
#' @seealso [text()], [legend()]
#'
#' @family graphics.layout
#' @concept annotation
#' @concept label
#' @concept geometry
#'
#' @export
abcCoords <- function(x       = "topleft",
                      region  = c("plot", "figure", "device"),
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

