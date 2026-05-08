# ── Palette definitions ───────────────────────────────────────────────────────
# All palettes are stored as vectors of base colors.
# pal() handles sampling / interpolation to always return exactly n colors.
#
# continuous: designed for interpolation (gradient palettes)
# discrete:   designed for categorical use, but can be interpolated if needed

.pal_data <- list(
  
  continuous = list(
    RedToBlack     = c("red", "yellow", "green", "blue", "black"),
    RedBlackGreen  = c("red", "black", "green"),
    SteelblueWhite = c("steelblue", "white"),
    RedWhiteGreen  = c("red", "white", "green"),
    RedWhiteBlue0  = c("red", "white", "blue"),
    RedWhiteBlue1  = c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7",
                       "#FFFFFF", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC",
                       "#053061"),
    RedWhiteBlue2  = c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"),
    RedWhiteBlue3  = c("#9A0941", "white", "#8296C4"),
    RedGreen1      = c("#E3001B", "#E63808", "#EA5901", "#EC6700", "#F18400",
                       "#F59E00", "#FBB800", "#FDC300", "#FFD900", "#CBC639",
                       "#96AC62", "#76936C")
  ),
  
  discrete = list(
    # ── Institutional ──────────────────────────────────────────────────────
    Helsana  = c("#9A0941", "#F08100", "#FED037", "#CAB790", "#D35186",
                 "#8296C4", "#B3BA12", "#CCCCCC", "#666666", "#FFFFFF"),
    Helsana1 = c("#000000", "#8296C4", "#9A0941", "#F08100", "#FED037",
                 "#CAB790", "#B3BA12", "#D35186", "#CCCCCC", "#666666"),
    Helsana2 = c("#9a0941", "#62aedf", "#9181c6", "#e55086", "#f2f2f2",
                 "#b6ca2f", "#fec600", "#bea786"),
    Tibco    = c("#005B00", "#009D45", "#FD0161", "#3C78B1", "#9CCD24",
                 "#F4C607", "#FE8201", "#608A8A", "#B2713C"),
    
    # ── ColorBrewer-inspired ───────────────────────────────────────────────
    Spring   = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00",
                 "#FFFF33", "#A65628", "#F781BF", "#999999"),
    Soap     = c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854",
                 "#FFD92F", "#E5C494", "#B3B3B3"),
    Maiden   = c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072", "#80B1D3",
                 "#FDB462", "#B3DE69", "#FCCDE5", "#D9D9D9", "#BC80BD",
                 "#CCEBC5"),
    Dark     = c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E",
                 "#E6AB02", "#A6761D", "#666666"),
    Accent   = c("#7FC97F", "#BEAED4", "#FDC086", "#FFFF99", "#386CB0",
                 "#F0027F", "#BF5B17", "#666666"),
    Pastel   = c("#FBB4AE", "#B3CDE3", "#CCEBC5", "#DECBE4", "#FED9A6",
                 "#FFFFCC", "#E5D8BD", "#FDDAEC", "#F2F2F2"),
    Fragile  = c("#B3E2CD", "#FDCDAC", "#CBD5E8", "#F4CAE4", "#E6F5C9",
                 "#FFF2AE", "#F1E2CC", "#CCCCCC"),
    
    # ── Big / Long / Night / Dawn / Noon / Light ───────────────────────────
    Big  = c("#800000", "#C00000", "#FF0000", "#FFC0C0",
             "#008000", "#00C000", "#00FF00", "#C0FFC0",
             "#000080", "#0000C0", "#0000FF", "#C0C0FF",
             "#808000", "#C0C000", "#FFFF00", "#FFFFC0",
             "#008080", "#00C0C0", "#00FFFF", "#C0FFFF",
             "#800080", "#C000C0", "#FF00FF", "#FFC0FF",
             "#C39004", "#FF8000", "#FFA858", "#FFDCA8"),
    
    # ── Wes Anderson ──────────────────────────────────────────────────────
    GrandBudapest  = c("#F1BB7B", "#FD6467", "#5B1A18", "#D67236"),
    Moonrise1      = c("#F3DF6C", "#CEAB07", "#D5D5D3", "#24281A"),
    Royal1         = c("#899DA4", "#C93312", "#FAEFD1", "#DC863B"),
    Moonrise2      = c("#798E87", "#C27D38", "#CCC591", "#29211F"),
    Cavalcanti     = c("#D8B70A", "#02401B", "#A2A475", "#81A88D", "#972D15"),
    Royal2         = c("#9A8822", "#F5CDB4", "#F8AFA8", "#FDDDA0", "#74A089"),
    GrandBudapest2 = c("#E6A0C4", "#C6CDF7", "#D8A499", "#7294D4"),
    Moonrise3      = c("#85D4E3", "#F4B5BD", "#9C964A", "#CDC08C", "#FAD77B"),
    Chevalier      = c("#446455", "#FDD262", "#D3DDDC", "#C7B19C"),
    Zissou         = c("#3B9AB2", "#78B7C5", "#EBCC2A", "#E1AF00", "#F21A00"),
    FantasticFox   = c("#DD8D29", "#E2D200", "#46ACC8", "#E58601", "#B40F20"),
    Darjeeling     = c("#FF0000", "#00A08A", "#F2AD00", "#F98400", "#5BBCD6"),
    Rushmore       = c("#E1BD6D", "#EABE94", "#0B775E", "#35274A", "#F2300F"),
    BottleRocket   = c("#A42820", "#5F5647", "#9B110E", "#3F5151", "#4E2A1E",
                       "#550307", "#0C1707"),
    Darjeeling2    = c("#ECCBAE", "#046C9A", "#D69C4E", "#ABDDDE", "#000000"),
    Tequila        = c("#642580", "#853b88", "#ab4189", "#c52966", "#d34376",
                       "#d55586", "#ba3723", "#cc6101", "#c6904a", "#eebd00",
                       "#f7d501", "#060c18", "#00323b", "#00484f")
  )
)

# derived subsets of Big
.pal_data$discrete$Long  <- .pal_data$discrete$Big[c(12,16,25,24,
                                                     2,11,6,15,18,26,23,
                                                     3,10,7,14,19,27,22,
                                                     4,8,20,28)]
.pal_data$discrete$Night <- .pal_data$discrete$Big[seq(1, 28, by = 4)]
.pal_data$discrete$Dawn  <- .pal_data$discrete$Big[seq(2, 28, by = 4)]
.pal_data$discrete$Noon  <- .pal_data$discrete$Big[seq(3, 28, by = 4)]
.pal_data$discrete$Light <- .pal_data$discrete$Big[seq(4, 28, by = 4)]


# ── Public helpers ────────────────────────────────────────────────────────────

#' List Available Palette Names
#'
#' Returns the names of all palettes available in \code{\link{pal}},
#' optionally filtered by type.
#'
#' @param type character, one of \code{"all"} (default), \code{"continuous"},
#'   or \code{"discrete"}.
#'
#' @return a character vector of palette names.
#'
#' @seealso \code{\link{pal}}
#' @examples
#' palNames()
#' palNames("continuous")
#' palNames("discrete")
#'

#' @family topic.colors
#' @concept color-manipulation
#' @concept graphics
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
#' Returns \code{n} colors from a named palette. All palettes always return
#' exactly \code{n} colors regardless of their base size:
#' \itemize{
#'   \item \code{n < length(base)}: evenly spaced sample for maximum contrast
#'   \item \code{n = length(base)}: returned as-is
#'   \item \code{n > length(base)}: interpolated via
#'     \code{\link[grDevices]{colorRampPalette}}
#' }
#'
#' @param name character or integer. Palette name (full match via
#'   \code{\link[base]{match.arg}}) or index into \code{\link{palNames}()}.
#'   If missing, returns the current default palette from
#'   \code{getOption("DescToolsX.palette")}.
#' @param n integer, number of colors to return. Default \code{100}.
#' @param alpha numeric in \eqn{[0, 1]}, opacity. Default \code{1} (opaque).
#'   Applied via \code{\link[grDevices]{adjustcolor}}.
#'
#' @return a character vector of \code{n} hex color codes of class
#'   \code{c("palette", "character")} with a \code{"name"} attribute.
#'
#' @seealso \code{\link{palNames}}, \code{\link[grDevices]{colorRampPalette}},
#'   \code{\link[grDevices]{adjustcolor}}
#'
#' @family color
#' @concept color palette ramp discrete continuous
#'
#' @examples
#' # default palette from options
#' pal()
#'
#' # discrete palette — 3 maximally contrasting colors
#' pal("Dark", n = 3)
#'
#' # continuous gradient — 50 colors
#' pal("RedWhiteBlue1", n = 50)
#'
#' # by index
#' pal(1, n = 10)
#'
#' # with transparency
#' pal("Helsana", n = 5, alpha = 0.5)
#'
#' # show all names
#' palNames()
#'


#' @export
pal <- function(name, n = 100L, alpha = 1) {
  
  # ── missing: return default ────────────────────────────────────────────────
  if (missing(name)) {
    res <- getOption("DescToolsX.palette")
    if (!inherits(res, "palette"))
      class(res) <- c("Palette", "character")
    return(res)
  }
  
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
  
  # n = NA: return all base colors as defined
  if (is.na(n)) n <- nb
  
  # ── sample / interpolate to n ──────────────────────────────────────────────
  res <- if (n == nb) {
    base
  } else if (n < nb) {
    # evenly spaced indices for maximum contrast
    idx <- round(seq(1, nb, length.out = n))
    base[idx]
  } else {
    # interpolate
    colorRampPalette(base)(n)
  }
  
  # ── alpha ──────────────────────────────────────────────────────────────────
  if (alpha != 1)
    res <- grDevices::adjustcolor(res, alpha.f = alpha)
  
  # ── class and name attribute ───────────────────────────────────────────────
  attr(res, "name") <- name
  class(res)        <- c("Palette", "character")
  
  res
}


#' @param x palette object to be plotted.
#' @param cex character extension.
#' @param border color for the border.
#' @param ... further params.

#' @rdname pal
#' @method plot Palette
#' @export
plot.Palette <- function(
    
  x,
  
  # STYLE
  cex = 2.5,
  border = "grey70",
  ...
) {
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    oldpar <- par(mar = c(1, 6, 3, 2))
    on.exit(par(oldpar), add = TRUE)
    
    # --- Meta -------------------------------------------------------------
    palname <- attr(x, "name")
    if (is.null(palname) || is.na(palname))
      palname <- "palette"
    
    n <- length(x)
    x <- rev(x)
    
    # --- Layout coords ----------------------------------------------------
    xpos_main  <- 1
    xpos_alpha <- 2 + seq(0, by = 0.8, length.out = 4)
    alphas     <- c(0.8, 0.6, 0.4, 0.2)
    
    ymax <- n + 2
    
    # --- Empty plot -------------------------------------------------------
    plot(NA,
         xlim = c(0.5, max(xpos_alpha) + 0.5),
         ylim = c(0.5, ymax),
         axes = FALSE,
         xlab = "",
         ylab = "",
         main = "")
    

    # --- Main palette -----------------------------------------------------
    points(rep(xpos_main, n), seq_len(n),
           pch = 22,
           cex = cex,
           col = border,
           bg  = x)
    
    # --- Alpha variants ---------------------------------------------------
    for (j in seq_along(alphas)) {
      points(rep(xpos_alpha[j], n), seq_len(n),
             pch = 22,
             cex = cex,
             col = border,
             bg  = grDevices::adjustcolor(x, alpha.f = alphas[j]))
    }
    
    # --- Labels -----------------------------------------------------------
    lab <- if (!is.null(names(x))) paste0(seq_len(n), ": ", names(x)) else seq_len(n)
    
    text(x = xpos_main + 0.4,
         y = seq_len(n),
         labels = lab,
         adj = c(0, 0.5),
         cex = 0.8)
    
    # --- Header -----------------------------------------------------------
    title(main = sprintf('"%s" palette', palname))
    
    text(x = xpos_alpha,
         y = n + 1,
         labels = alphas,
         cex = 0.8)
    
    text(x = mean(xpos_alpha),
         y = n + 1.5,
         labels = "alpha",
         cex = 0.9)
    
    abline(h = n + 0.7, col = "grey80")
    
  })
  
  invisible(NULL)
}

