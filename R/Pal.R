# ── Palette definitions ───────────────────────────────────────────────────────
# All palettes are stored as vectors of base colors.
# pal() handles sampling / interpolation to always return exactly n colors.
#
# continuous: designed for interpolation (gradient palettes)
# discrete:   designed for categorical use, but can be interpolated if needed

.pal_data <- list(
  
  continuous = list(
    "red-black"          = c("red", "yellow", "green", "blue", "black"),
    "red-black-green"    = c("red", "black", "green"),
    "steelblue-white"    = c("steelblue", "white"),
    "red-white-green"    = c("red", "white", "green"),
    "red-white-blue-1"   = c("red", "white", "blue"),
    
    "red-white-blue-2"   = c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7",
                       "#FFFFFF", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC",
                       "#053061"),
    
    "red-white-blue-3"   = c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"),
    
    "red-white-blue-4"   = c("#9A0941", "white", "#8296C4"),
    
    "red-green-1"        = c("#E3001B", "#E63808", "#EA5901", "#EC6700", "#F18400",
                       "#F59E00", "#FBB800", "#FDC300", "#FFD900", "#CBC639",
                       "#96AC62", "#76936C")
  ),
  
  discrete = list(
    # ── Institutional ──────────────────────────────────────────────────────
    "helsana"   = c(blue="#8296C4", red="#9A0941", orange="#F08100", yellow="#FED037",
                 ecru="#CAB790", green="#B3BA12", pink="#D35186", moss="#8FAE8C",  
                 slate="#5F6F9A", sand="#E6E2D3", brown="#6E5A3C", plum="#5B2A45"),
    
    "helsana-1" = c("#000000", "#8296C4", "#9A0941", "#F08100", "#FED037",
                 "#CAB790", "#B3BA12", "#D35186", "#CCCCCC", "#666666"),
    
    "helsana-2" = c("#9a0941", "#62aedf", "#9181c6", "#e55086", "#f2f2f2",
                 "#b6ca2f", "#fec600", "#bea786"),
    
    "tibco"     = c("#005B00", "#009D45", "#FD0161", "#3C78B1", "#9CCD24",
                 "#F4C607", "#FE8201", "#608A8A", "#B2713C"),
    
    # ── ColorBrewer-inspired ───────────────────────────────────────────────
    "spring" = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00",
                 "#FFFF33", "#A65628", "#F781BF", "#999999"),
    "soap"   = c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854",
                 "#FFD92F", "#E5C494", "#B3B3B3"),
    "maiden" = c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3",
                 "#FDB462", "#B3DE69", "#FCCDE5", "#D9D9D9", "#BC80BD",
                 "#CCEBC5"),
    "dark"   = c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E",
                 "#E6AB02", "#A6761D", "#666666"),
    "accent" = c("#7FC97F", "#BEAED4", "#FDC086", "#FFFF99", "#386CB0",
                 "#F0027F", "#BF5B17", "#666666"),
    "pastel" = c("#FBB4AE", "#B3CDE3", "#CCEBC5", "#DECBE4", "#FED9A6",
                 "#FFFFCC", "#E5D8BD", "#FDDAEC", "#F2F2F2"),
    "fragile" = c("#B3E2CD", "#FDCDAC", "#CBD5E8", "#F4CAE4", "#E6F5C9",
                 "#FFF2AE", "#F1E2CC", "#CCCCCC"),
    
    # ── big / long / night / dawn / noon / light ───────────────────────────
    "big"  = c("#800000", "#C00000", "#FF0000", "#FFC0C0",
             "#008000", "#00C000", "#00FF00", "#C0FFC0",
             "#000080", "#0000C0", "#0000FF", "#C0C0FF",
             "#808000", "#C0C000", "#FFFF00", "#FFFFC0",
             "#008080", "#00C0C0", "#00FFFF", "#C0FFFF",
             "#800080", "#C000C0", "#FF00FF", "#FFC0FF",
             "#C39004", "#FF8000", "#FFA858", "#FFDCA8"),
    
    # ── Wes Anderson ──────────────────────────────────────────────────────
    "grand-budapest"   = c("#F1BB7B", "#FD6467", "#5B1A18", "#D67236"),
    "moonrise-1"       = c("#F3DF6C", "#CEAB07", "#D5D5D3", "#24281A"),
    "royal-1"          = c("#899DA4", "#C93312", "#FAEFD1", "#DC863B"),
    "moonrise-2"       = c("#798E87", "#C27D38", "#CCC591", "#29211F"),
    "cavalcanti"       = c("#D8B70A", "#02401B", "#A2A475", "#81A88D", "#972D15"),
    "royal-2"          = c("#9A8822", "#F5CDB4", "#F8AFA8", "#FDDDA0", "#74A089"),
    "grand-budapest-2" = c("#E6A0C4", "#C6CDF7", "#D8A499", "#7294D4"),
    "moonrise-3"       = c("#85D4E3", "#F4B5BD", "#9C964A", "#CDC08C", "#FAD77B"),
    "chevalier"        = c("#446455", "#FDD262", "#D3DDDC", "#C7B19C"),
    "zissou"           = c("#3B9AB2", "#78B7C5", "#EBCC2A", "#E1AF00", "#F21A00"),
    "fantastic-fox"    = c("#DD8D29", "#E2D200", "#46ACC8", "#E58601", "#B40F20"),
    "darjeeling"       = c("#FF0000", "#00A08A", "#F2AD00", "#F98400", "#5BBCD6"),
    "rushmore"         = c("#E1BD6D", "#EABE94", "#0B775E", "#35274A", "#F2300F"),
    "bottle-rocket"    = c("#A42820", "#5F5647", "#9B110E", "#3F5151", "#4E2A1E",
                       "#550307", "#0C1707"),
    "darjeeling-2"     = c("#ECCBAE", "#046C9A", "#D69C4E", "#ABDDDE", "#000000"),
    "tequila"          = c("#642580", "#853b88", "#ab4189", "#c52966", "#d34376",
                       "#d55586", "#ba3723", "#cc6101", "#c6904a", "#eebd00",
                       "#f7d501", "#060c18", "#00323b", "#00484f")
  )
)

# derived subsets of big
.pal_data$discrete$long  <- .pal_data$discrete$big[c(12,16,25,24,
                                                     2,11,6,15,18,26,23,
                                                     3,10,7,14,19,27,22,
                                                     4,8,20,28)]
.pal_data$discrete$night <- .pal_data$discrete$big[seq(1, 28, by = 4)]
.pal_data$discrete$dawn  <- .pal_data$discrete$big[seq(2, 28, by = 4)]
.pal_data$discrete$noon  <- .pal_data$discrete$big[seq(3, 28, by = 4)]
.pal_data$discrete$light <- .pal_data$discrete$big[seq(4, 28, by = 4)]


# ── Public helpers ────────────────────────────────────────────────────────────

#' List Available Palette Names
#'
#' Returns the names of all palettes available in [pal()],
#' optionally filtered by type.
#'
#' @param type character, one of `"all"` (default), `"continuous"`,
#'   or `"discrete"`.
#'
#' @return a character vector of palette names.
#'
#' @seealso [pal()]
#' @examples
#' palNames()
#' palNames("continuous")
#' palNames("discrete")
#'


#' @family color.palettes
#' @concept color  
#' @concept palette
#'
#'
#' @export
palNames <- function(type = c("all", "continuous", "discrete")) {
  type <- match.arg(type)
  switch(type,
         all        = c(names(.pal_data$continuous), names(.pal_data$discrete)),
         continuous = names(.pal_data$continuous),
         discrete   = names(.pal_data$discrete)
  )
}


# ── Pal ───────────────────────────────────────────────────────────────────────

#' Get a Color Palette
#'
#' Returns `n` colors from a named palette. All palettes always return
#' exactly `n` colors regardless of their base size:
#' \itemize{
#'   \item `n < length(base)`: evenly spaced sample for maximum contrast
#'   \item `n = length(base)`: returned as-is
#'   \item `n > length(base)`: interpolated via
#'     [grDevices::colorRampPalette()]
#' }
#'
#' @param name character or integer. Palette name (full match via
#'   [base::match.arg()]) or index into [palNames()].
#'   If missing, returns the palette named in the active theme
#'   (`getTheme()$palette`, see [theme]).   
#'   
#' @param n integer, number of colors to return. Default `NA` returns 
#' the colors as contained in the palette.
#' @param opacity numeric in \eqn{[0, 1]}, opacity. Default `1` (opaque).
#'   Applied via [grDevices::adjustcolor()].
#'
#' @return a character vector of `n` hex color codes of class
#'   `c("palette", "character")` with a `"name"` attribute.
#'
#' @seealso [palNames()], [grDevices::colorRampPalette()],
#'   [grDevices::adjustcolor()]
#'
#' @family color.palettes
#' @concept color
#' @concept palette
#'
#' @examples
#' # default palette from options
#' pal()
#'
#' # discrete palette — 3 maximally contrasting colors
#' pal("dark", n = 3)
#'
#' # continuous gradient — 50 colors
#' pal("red-white-blue-2", n = 50)
#'
#' # by index
#' pal(1, n = 10)
#'
#' # with transparency
#' pal("helsana", n = 5, opacity = 0.5)
#'
#' # show all names
#' palNames()
#'


#' @export
pal <- function(name, n = NA, opacity = 1) {
  
  # ── missing: fall back to the active theme's palette ──────────────────────
  if (missing(name))
    name <- getTheme()$palette
  
  all_names <- palNames("all")
  
  # ── numeric index ──────────────────────────────────────────────────────────
  if (is.numeric(name)) {
    idx <- as.integer(name)
    if (idx < 1L || idx > length(all_names))
      stop(gettextf("palette index %d out of range (1-%d)",
                    idx, length(all_names)))
    name <- all_names[idx]
  }
  
  # ── name matching — full match only via match.arg ──────────────────────────
  name <- tryCatch(
    match.arg(name, choices = all_names),
    error = function(e)
      stop(gettextf("palette '%s' not found. Use palNames() to list available palettes.",
                    name))
  )
  
  # ── retrieve base colors ───────────────────────────────────────────────────
  if (name %in% names(.pal_data$continuous)) {
    base <- .pal_data$continuous[[name]]
  } else {
    base <- .pal_data$discrete[[name]]
  }
  
  nb <- length(base)
  
  if (is.na(n)) n <- nb
  
  res <- if (n == nb) {
    base
  } else if (n < nb) {
    idx <- round(seq(1, nb, length.out = n))
    base[idx]
  } else {
    colorRampPalette(base)(n)
  }
  
  if (any(opacity != 1))
    res <- grDevices::adjustcolor(res, alpha.f = opacity)
  
  attr(res, "name") <- name
  class(res)        <- c("Palette", "character")
  
  res
}



#' @param x palette object to be plotted.
#' @param main main title. `NULL` (default) uses the name of the palette,
#'   regardless of the theme's `autoTitle`;
#'   `""`, `NA` or `FALSE` suppress the title and compact the top margin.
#' @param cex character expansion of the labels (index, name, hex code).
#'   It is reduced automatically when the rows get too narrow, and the
#'   labels are left out for very long palettes.
#' @param border color for the border of the swatches.
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, a string, or
#'   a named list for [stamp()].
#' @param ... further graphical parameters, passed to [par()] via the
#'   internal framework.

#' @rdname pal
#' @method plot Palette
#' @export
plot.Palette <- function(

  x,

  # LABELS
  main = NULL,

  # STYLE
  cex = 0.85,
  border = "grey70",

  # FRAMEWORK
  stamp = .useTheme,

  ...
) {

  # --- Meta ---------------------------------------------------------------
  palname <- attr(x, "name")
  if (is.null(palname) || is.na(palname))
    palname <- "palette"

  # the palette name is shown nowhere else, so this title is always on
  main <- .resolveTitle(main, default = sprintf('"%s" palette', palname),
                        always = TRUE)

  cols <- as.vector(unclass(x))
  nms  <- names(x)
  n    <- length(cols)

  if (n == 0L)
    stop("the palette contains no colors", call. = FALSE)

  # 6-digit hex code for every color, whatever form it is stored in
  # ("red", "#8296C4", "#8296C480")
  hex    <- grDevices::rgb(t(grDevices::col2rgb(cols)), maxColorValue = 255)
  alphas <- c(1, 0.8, 0.6, 0.4, 0.2)

  # the header (opacity values and their caption) sits in the top margin,
  # so its distance to the swatches does not depend on the number of rows
  marTop <- 2.6 + if (nzchar(main)) 1.8 else 0

  .withGraphicsState({

    .applyParFromDots(...,
                      defaults = list(
                        mar = c(bottom = 1, left = 1, top = marTop, right = 1)
                      ))

    # --- Coordinate system ------------------------------------------------
    # x in inches (so text widths measured with strwidth(units = "inches")
    # can be used directly), y in rows: the first color on top. A row is
    # at most 0.38 in high; a short palette then stays below the header
    # instead of being spread over the whole device.
    plot.new()
    pin   <- par("pin")
    rowIn <- min(pin[2] / n, 0.38)
    plot.window(xlim = c(0, pin[1]), ylim = c(n + 0.5 - pin[2] / rowIn, n + 0.5),
                xaxs = "i", yaxs = "i")

    # text no taller than 3/4 of a row, left out when it would be unreadable
    cexT     <- min(cex, 0.75 * rowIn / par("csi"))
    showText <- cexT >= 0.45

    .textWidth <- function(s, family = "")
      if (showText) max(strwidth(s, units = "inches", cex = cexT,
                                 family = family)) else 0

    # --- Column layout (inches) -------------------------------------------
    gap <- 0.18                       # between text columns
    sp  <- 0.10                       # between swatches
    sw  <- 0.42                       # swatch width

    wIdx  <- .textWidth(as.character(n))
    wName <- if (is.null(nms)) 0 else .textWidth(nms)
    wHex  <- .textWidth(hex, family = "mono")

    textW <- if (showText)
      wIdx + gap + (if (wName > 0) wName + gap else 0) + wHex + 2 * gap
    else 0

    # the opaque column is set apart from the transparent ones by an extra
    # gap; swatches narrow down when the device is too small
    swatchW <- function(sw) 5 * sw + 5 * sp
    if (textW + swatchW(sw) > pin[1])
      sw <- max(0.12, (pin[1] - textW - 5 * sp) / 5)

    total <- textW + swatchW(sw)
    x0    <- max(0, (pin[1] - total) / 2)

    xIdx  <- x0 + wIdx                               # right aligned
    xName <- xIdx + gap
    xHex  <- xName + if (wName > 0) wName + gap else 0
    xSw   <- x0 + textW + c(0, sw + 2 * sp + (0:3) * (sw + sp))

    # --- Swatches ---------------------------------------------------------
    # Separate framed swatches while there is room for them; a long
    # (typically interpolated) palette is drawn as a continuous band
    # instead, where gaps and frames would only add noise.
    y      <- n - seq_len(n) + 1
    banded <- rowIn < 0.12
    hU     <- if (banded) 1 else 0.72

    for (j in seq_along(alphas)) {
      rect(xSw[j], y - hU / 2, xSw[j] + sw, y + hU / 2,
           col    = grDevices::adjustcolor(cols, alpha.f = alphas[j]),
           border = if (banded) NA else border)
      if (banded)
        rect(xSw[j], 0.5, xSw[j] + sw, n + 0.5, border = border)
    }

    # --- Labels -----------------------------------------------------------
    if (showText) {

      text(xIdx, y, seq_len(n), adj = c(1, 0.5), cex = cexT, col = "grey50")

      if (!is.null(nms))
        text(xName, y, nms, adj = c(0, 0.5), cex = cexT)

      text(xHex, y, hex, adj = c(0, 0.5), cex = cexT,
           family = "mono", col = "grey40")
    }

    # --- Header -----------------------------------------------------------
    mid <- xSw + sw / 2

    mtext(format(alphas), side = 3, line = 0.3, at = mid,
          cex = 0.75, col = "grey40")
    mtext("opacity", side = 3, line = 1.3, at = mean(range(mid)), cex = 0.8)

    if (showText) {
      if (!is.null(nms))
        mtext("name", side = 3, line = 0.3, at = xName, adj = 0,
              cex = 0.75, col = "grey40")
      mtext("hex", side = 3, line = 0.3, at = xHex, adj = 0,
            cex = 0.75, col = "grey40")
    }

    if (nzchar(main))
      title(main = main, line = 2.8)

  }, stamp = stamp)

  invisible(x)
}
