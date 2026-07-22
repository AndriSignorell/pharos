

# ---- Randbedarf für gedrehte Labels abschätzen -----------------------

.axisFmtMar <- function(side, labels, srt, cex = par("cex")) {
  
  # benötigte Ausdehnung (in Zoll) der gedrehten Labels senkrecht zur Achse,
  # umgerechnet in mar-Zeilen (1 Zeile = par("csi") Zoll)
  
  w <- strwidth(labels,  units = "inches", cex = cex)
  h <- strheight(labels, units = "inches", cex = cex)
  
  theta <- srt * pi / 180
  
  # Projektion der Textbox auf die Achsen-Normale:
  # x-Achse (side 1/3): vertikale Ausdehnung zählt
  # y-Achse (side 2/4): horizontale Ausdehnung zählt
  if (side %in% c(1, 3))
    extent <- abs(w * sin(theta)) + abs(h * cos(theta))
  else
    extent <- abs(w * cos(theta)) + abs(h * sin(theta))
  
  # grösstes Label bestimmt den Rand; + kleiner Puffer
  lines_needed <- max(extent) / par("csi") + 0.7
  
  lines_needed
}


# ---- Achse mit optional gedrehten Labels -----------------------------

#' Draw an Axis With Formatted or Rotated Labels
#'
#' A drop-in replacement for [graphics::axis()] that adds two conveniences:
#' tick labels can be formatted through [fm()] via the \code{fmt} argument,
#' and labels can be drawn at an arbitrary angle using \code{srt} (which
#' [graphics::axis()] itself ignores). When rotated labels are requested the
#' function also estimates the margin space they require and, optionally,
#' widens the corresponding plot margin so the labels are not clipped.
#'
#' The \code{fmt} argument is passed straight to [fm()] and therefore accepts
#' the full range of format specifications: a special short code (e.g.
#' \code{"\%"}, \code{"e"}, \code{"eng"}, \code{"p"}), an ISO-8601 date
#' pattern (e.g. \code{"MMM yyyy"}), a \code{Style} object, a bare (named)
#' list treated as a style template (e.g. \code{fmt = list(digits = 1,
#' bigMark = " ")}), or a function of \code{x}. See [fm()] for the details.
#'
#' When \code{srt} is set, the axis line and ticks are drawn without labels
#' via [graphics::axis()], and the labels are added separately with
#' [graphics::text()] using \code{xpd = TRUE} so they may extend into the
#' figure margin. The required margin width is estimated by projecting the
#' rotated label boxes onto the axis normal (see \code{estimateMar}).
#'
#' Note that changing \code{par("mar")} after the plot region has been
#' established does not resize the existing region. When \code{estimateMar}
#' is \code{TRUE} the widened margin therefore mainly ensures enough device
#' space outside the plot region for the (\code{xpd = TRUE}) labels. For a
#' clean layout, set the margin \emph{before} calling [graphics::plot()]; the
#' returned \code{mar} component reports the estimated requirement so a
#' calling routine can reserve the space in advance.
#'
#' @param side integer specifying which side of the plot the axis is drawn on,
#' as in [graphics::axis()]: \code{1} = below, \code{2} = left, \code{3} =
#' above and \code{4} = right.
#' @param at numeric vector of tick positions. If \code{NULL} (default) the
#' positions are determined with [graphics::axTicks()].
#' @param fmt format specification passed to [fm()] to format the tick
#' labels. If \code{NULL} (default) the labels are used as they are (or the
#' bare tick values, coerced to character). See Details.
#' @param labels either a logical or a character vector of labels. If
#' \code{TRUE} (default) the labels are generated from \code{at} (formatted
#' with \code{fmt} if supplied). A character vector is used verbatim.
#' @param srt numeric, the string rotation angle in degrees. If \code{NULL}
#' (default) labels are drawn horizontally through the ordinary
#' [graphics::axis()] mechanism. Any other value triggers the rotated-label
#' path described in Details (a common choice for long category names is
#' \code{srt = 45}).
#' @param adj label justification passed to [graphics::text()]. If \code{NULL}
#' a sensible default is chosen from \code{side} and the rotation: right
#' aligned with the tick for the x-axes (\code{c(1, 0.5)}) and bottom aligned
#' for the y-axes (\code{c(0.5, 0)}).
#' @param estimateMar logical. If \code{TRUE} (default) and \code{srt} is set,
#' the margin on \code{side} is temporarily widened to the estimated space
#' needed by the rotated labels (restored on exit). Set to \code{FALSE} to
#' leave the margins untouched.
#' @param \dots further arguments passed to both [graphics::axis()] (for the
#' line and ticks) and [graphics::text()] (for the labels). Graphical
#' parameters shared by the two (e.g. \code{col}, \code{cex}) therefore affect
#' both.
#' @return invisibly, a list with components \code{at} (the tick positions
#' used) and \code{mar} (the estimated margin requirement in lines for the
#' rotated labels, or \code{NA} when \code{srt} is \code{NULL}).
#' @author Andri Signorell <andri@@signorell.net>
#' @seealso [graphics::axis], [graphics::axTicks], [graphics::text], [fm]
#' @examples
#'
#' # formatted tick labels
#' plot(1:10, runif(10) * 1000, yaxt = "n", xaxt = "n")
#' axisFmt(2, fmt = list(digits = 0, bigMark = " "))
#' axisFmt(1, fmt = list(fmt = "%", digits = 1))
#'
#' # rotated category labels (margin widened automatically)
#' plot(1:5, c(7, 6, 11, 5, 12), xaxt = "n", xlab = "")
#' axisFmt(1, at = 1:5, labels = paste("Category", LETTERS[1:5]), srt = 45)
#'
#' @export
axisFmt <- function(side, at = NULL, fmt = NULL, labels = TRUE,
                    srt = NULL, adj = NULL, estimateMar = TRUE, ...) {
  
  if (is.null(at))
    at <- axTicks(side)
  
  if (isTRUE(labels))
    labels <- if (is.null(fmt)) {
      as.character(at)
    } else if (is.list(fmt) && is.null(attr(fmt, "class"))) {
      # bare list: spread as named fm() arguments (house pattern, cf.
      # .applyFmt() / .drawAxis()) - fm.default() cannot digest a plain
      # list passed via fmt=
      do.call(fm, c(list(x = at), fmt))
    } else {
      fm(at, fmt = fmt)
    }
  
  # --- kein srt: normales Verhalten -----------------------------------
  if (is.null(srt)) {
    axis(side = side, at = at, labels = labels, ...)
    return(invisible(list(at = at, mar = NA_real_)))
  }
  
  # --- Randbedarf prüfen und ggf. verbreitern -------------------------
  need <- .axisFmtMar(side, labels, srt,
                      cex = list(...)$cex %||% par("cex"))
  
  if (isTRUE(estimateMar) && need > par("mar")[side]) {
    op <- par(mar = replace(par("mar"), side, need))
    on.exit(par(op), add = TRUE)
  }
  
  # --- Achse (nur Linie + Ticks) --------------------------------------
  axis(side = side, at = at, labels = FALSE, ...)
  
  usr <- par("usr")
  pos <- switch(side,
                `1` = usr[3] - 0.02 * diff(usr[3:4]),
                `2` = usr[1] - 0.02 * diff(usr[1:2]),
                `3` = usr[4] + 0.02 * diff(usr[3:4]),
                `4` = usr[2] + 0.02 * diff(usr[1:2])
  )
  
  if (is.null(adj))
    adj <- if (side %in% c(1, 3)) c(1, 0.5) else c(0.5, 0)
  
  if (side %in% c(1, 3))
    text(x = at, y = pos, labels = labels, srt = srt, adj = adj,
         xpd = TRUE, ...)
  else
    text(x = pos, y = at, labels = labels, srt = srt, adj = adj,
         xpd = TRUE, ...)
  
  invisible(list(at = at, mar = need))
}
