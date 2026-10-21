
#' Helsana Colors
#'
#' Retrieve one or more colors from the helsana palette, optionally faded.
#'
#' @param ... character strings naming the colors to retrieve. Valid names are:
#'   `"blue"`, `"red"`, `"orange"`, `"yellow"`,
#'   `"ecru"`, `"green"`, `"pink"`, `"moss"`,
#'   `"slate"`, `"sand"`, `"brown"`, `"plum"`.
#'   If none are provided, the full palette is returned.
#' @param fade `NULL` (default) returns the colors unchanged. A number in
#'   \eqn{[0, 1]} returns the opaque tint the color has at this opacity on
#'   a white background, see [fade()]: `1` is the color itself, smaller
#'   values are lighter. Recycled over the colors, so
#'   `hcol("blue", fade = c(1, 0.6, 0.3))` gives three tints of one color.
#'
#' @return A named character vector of hex color codes.
#'
#' @examples
#' hcol("blue", "green")
#' hcol()
#'
#' # lighter tints, still opaque
#' hcol("blue", "red", fade = 0.4)
#' hcol("blue", fade = c(1, 0.6, 0.3))
#'
#' @family color.palettes
#' @concept color
#' @concept palette
#'
#' @export
hcol <- function(..., fade = NULL) {

  pal <- .pal_data$discrete$helsana
  nms <- c(...)

  if (is.null(nms)) {
    res <- pal
  } else {
    bad <- setdiff(nms, names(pal))
    if (length(bad))
      stop(gettextf("unknown helsana color(s): %s. Valid names are: %s",
                    toString(dQuote(bad, FALSE)), toString(names(pal))),
           call. = FALSE)
    res <- pal[nms]
  }

  if (!is.null(fade)) {
    if (!is.numeric(fade) || anyNA(fade) || any(fade < 0 | fade > 1))
      stop("'fade' must be a number between 0 and 1", call. = FALSE)

    # one tint per color, or several tints of one color; pharos:: makes
    # clear that the function is meant, not the argument of the same name
    n   <- max(length(res), length(fade))
    nm  <- rep_len(names(res), n)
    res <- setNames(pharos::fade(rep_len(unname(res), n), rep_len(fade, n)),
                    nm)
  }

  res
}
