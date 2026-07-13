
#' Plot Proportions with Confidence Intervals
#'
#' Displays a horizontal bar with nested confidence interval bands from
#' \code{min(ciLevels)} to \code{max(ciLevels)} to visualise the uncertainty
#' of a proportion. Bands are drawn in a semi-transparent grey so that the
#' accumulated overlap creates a natural density gradient - darker in the
#' centre, lighter at the edges.
#'
#' @param x A two-column integer matrix where each row represents a group and
#'   the two columns contain counts for the two categories. A numeric vector
#'   of length 2 is also accepted and will be coerced to a one-row matrix.
#'
#' @param main main title of the plot. \code{NULL} (default) derives a title
#'   from \code{deparse(substitute(x))}. \code{""}, \code{NA}, or \code{FALSE}
#'   suppress the title and compact the top margin. Any other string is used
#'   as given.
#' @param labels character vector of length 2 with labels for the two
#'   categories, displayed at the top of the plot. Default \code{c("", "")}.
#' @param xlab label for the x-axis. Default \code{""}.
#'
#' @param xlim numeric vector of length 2 for the x-axis limits.
#'   Default \code{c(0, 1)}.
#'
#' @param col character vector of length 2 specifying fill colours for the
#'   stacked bar. \code{.useTheme} (default) resolves to
#'   \code{getTheme()$twin} - the active theme's two-color pair. Note this
#'   is purely "first label gets the first color"; unlike
#'   \code{\link{plotCor}}/\code{\link{plotWeb}}, there is no positive/
#'   negative sign convention here, since proportions of two arbitrary
#'   categories (e.g. "yes"/"no") have no inherent sign.
#' @param ci.col colour for the confidence interval bands. Default is a
#'   semi-transparent grey (\code{addOpacity("grey80", 0.12)}). Deliberately
#'   not theme-driven (like the sequential scales in
#'   \code{\link{plotDens2D}}/\code{\link{plotHeatmap}}): this is a
#'   structural mechanism (many overlapping translucent bands building a
#'   gradient via overdraw), not a categorical or diverging color choice.
#' @param border border colour for the confidence interval bands and the
#'   stacked bar. Default \code{NA} (no border).
#' @param ciLevels numeric vector of confidence levels for the nested bands.
#'   Default \code{seq(0.99, 0.80, by = -0.01)} (20 bands, 99\% down to
#'   80\% in 1\% steps). Draw order does not affect the result, since all
#'   bands share the same translucent color and no border.
#' @param grid controls drawing of the background grid (vertical lines at
#'   the proportion ticks only - there is no meaningful horizontal grid
#'   for the categorical group axis). \code{.useTheme} (default) follows
#'   the active theme (\code{getTheme()$grid}). \code{TRUE}/\code{FALSE}/
#'   \code{NA}, or a named list, as for \code{\link[graphics]{grid}}.
#' @param box controls drawing of the plot box. Default \code{FALSE} (no
#'   frame, consistent with this chart's minimal "Few"-style appearance).
#'   \code{TRUE}/\code{NA}, or a named list, as for
#'   \code{\link[graphics]{box}}.
#'
#' @param legend controls the legend explaining the CI band range.
#'   \code{TRUE} (default) draws it. \code{FALSE}/\code{NA} suppresses it.
#'   A named list overrides arguments forwarded to
#'   \code{\link[graphics]{legend}}.
#'
#' @param stamp controls the corner stamp. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$stamp}. \code{TRUE}/\code{FALSE}/
#'   \code{NULL}, a string, or a named list for \code{\link{stamp}()}.
#' @param ... further arguments passed to \code{\link[graphics]{par}} via
#'   the internal framework, and to \code{\link[graphics]{barplot}}.
#'
#' @return Invisibly returns \code{NULL}. Called for its side effect of
#'   producing a plot.
#'
#' @details
#' Each row of \code{x} is displayed as a horizontal stacked bar showing the
#' proportion of the first category. Confidence intervals are calculated
#' using \code{prop.test()} and drawn as nested bands per \code{ciLevels},
#' all in the same semi-transparent colour. The repeated overdraw naturally
#' darkens the centre of the interval where all bands overlap. A vertical
#' segment marks the observed proportion.
#'
#' @importFrom graphics barplot rect segments mtext legend grid
#' @importFrom grDevices gray.colors
#'
#' @examples
#' m <- matrix(c(22, 111, 33, 120, 80, 100), nrow = 3, byrow = TRUE)
#' plotPropCI(m, labels = c("yes", "no"), main = "Response by Group")
#'
#' # single row - vector input is accepted
#' plotPropCI(m[1, ], labels = c("yes", "no"))
#'
#' @seealso \code{\link[stats]{prop.test}}, [theme]
#'

#' @family plot.special  
#' @concept confidence-interval  
#' @concept proportion
#'
#'
#' @export
plotPropCI <- function(
    
  # DATA
  x,
  
  # LABELS
  main   = NULL,
  labels = c("", ""),
  xlab   = "",
  
  # AXES
  xlim = c(0, 1),
  
  # STYLE
  col      = .useTheme,
  ci.col   = addOpacity("grey80", 0.12),
  border   = NA,
  ciLevels = seq(0.99, 0.80, by = -0.01),
  grid     = .useTheme,
  box      = FALSE,
  
  # FEATURES
  legend = TRUE,
  
  # FRAMEWORK
  stamp = .useTheme,
  
  ...
) {
  
  mc           <- match.call()
  defaultTitle <- deparse(mc$x)
  
  if (identical(col, .useTheme))
    col <- getTheme()$twin
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    main <- .resolveTitle(main, default = defaultTitle)
    
    # --- coerce vector to one-row matrix ----------------------------------------
    if (is.numeric(x) && !is.matrix(x))
      x <- matrix(x, nrow = 1L, dimnames = list(NULL, names(x)))
    
    # --- pad missing second column with 0 (e.g. all-TRUE or all-FALSE) ----------
    if (is.matrix(x) && ncol(x) == 1L) {
      other <- if (isTRUE(colnames(x) == "TRUE")) "FALSE" else "TRUE"
      x <- cbind(x, matrix(0L, nrow = nrow(x), dimnames = list(NULL, other)))
      x <- x[, c("FALSE", "TRUE"), drop = FALSE]
    }
    
    # --- input checks -----------------------------------------------------------
    if (!is.matrix(x) || !is.numeric(x))
      stop("'x' must be a numeric matrix or numeric vector of length 2.")
    if (ncol(x) != 2L)
      stop("'x' must have exactly 2 columns.")
    if (any(x < 0))
      stop("'x' must contain non-negative counts.")
    if (length(labels) != 2L)
      stop("'labels' must be a character vector of length 2.")
    if (length(col) != 2L)
      stop("'col' must be a vector of length 2.")
    
    # --- layout constants -------------------------------------------------------
    bar.width <- 1
    bar.space <- 0.8
    
    ylim <- if (nrow(x) == 1L)
      c(-1, 4)
    else
      c(-0.5, nrow(x) * 1.8 + 0.5)
    
    # --- proportions and base barplot -------------------------------------------
    pp <- proportions(x, margin = 1L)
    
    b <- barplot(
      t(pp),
      horiz  = TRUE,
      col    = col,
      beside = FALSE,
      xlim   = xlim,
      ylim   = ylim,
      main   = main,
      xlab   = xlab,
      space  = bar.space,
      ...
    )
    
    # --- confidence interval bands (outermost to innermost) ---------------------
    # Same translucent color/no border on every band, so draw order has no
    # visible effect - overlap accumulation is order-independent here.
    for (lvl in ciLevels) {
      ci <- t(vapply(
        seq_len(nrow(x)),
        function(i) suppressWarnings(
          .binomCI_raw(x[i, 1L], n = sum(x[i, ]), conf.level = lvl)
        ),
        numeric(3L)
      ))
      
      rect(
        xleft   = ci[, "lci"],
        ybottom = b - bar.width / 2,
        xright  = ci[, "uci"],
        ytop    = b + bar.width / 2,
        col     = ci.col,
        border  = border
      )
    }
    
    # --- observed proportion marker ---------------------------------------------
    segments(
      x0  = pp[, 1L],
      y0  = b - bar.width / 2,
      y1  = b + bar.width / 2,
      lwd = 2
    )
    
    # --- category labels at top -------------------------------------------------
    lpos <- if (nrow(x) == 1L) -3 else 0
    
    mtext(paste0(" ", labels[1L]), side = 3, at = 0,
          adj = 0, line = lpos, cex = 1.2)
    mtext(paste0(labels[2L], " "), side = 3, at = 1,
          adj = 1, line = lpos, cex = 1.2)
    
    # --- grid and box -------------------------------------------------------
    .drawGrid(grid, defaults = list(ny = NA))
    .drawBox(box)
    
    # --- legend --------------------------------------------------------
    bedrock::callIf(
      graphics::legend,
      legend,
      defaults = .legendDefaults(list(
        x      = "bottomleft",
        legend = sprintf("%s%% \u2013 %s%% CI",
                         round(min(ciLevels) * 100),
                         round(max(ciLevels) * 100)),
        fill   = ci.col,
        bty    = "n",
        inset  = c(-0.045, -0.24),
        xpd    = NA
      ))
    )
    
  }, stamp = stamp)
  
  invisible(NULL)
}


# == internal helper functions =====================================================

# needed here to avoid reverse dependency with binomCI defined in lumen
.binomCI_raw <- function(x, n, conf.level = 0.95) {
  setNamesX(c(est = x/n, prop.test(x, n, conf.level = conf.level, correct = FALSE)$conf.int),
            names = c("est", "lci", "uci"))
}
