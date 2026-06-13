

#' Plot Proportions with Confidence Intervals
#'
#' Displays a horizontal bar with nested confidence interval bands from 80%
#' to 99% (in 1% steps) to visualise the uncertainty of a proportion. Bands
#' are drawn in a semi-transparent grey so that the accumulated overlap
#' creates a natural density gradient — darker in the centre, lighter at the
#' edges.
#'
#' @param x A two-column integer matrix where each row represents a group and
#'   the two columns contain counts for the two categories. A numeric vector
#'   of length 2 is also accepted and will be coerced to a one-row matrix.
#' @param main Character string giving the plot title. Default is `""`.
#' @param labels Character vector of length 2 with labels for the two
#'   categories, displayed at the top of the plot. Default is `c("", "")`.
#' @param col Character vector of length 2 specifying fill colours for the
#'   stacked bar. Defaults to `c(hblue, hred)` from \pkg{DescToolsX}.
#' @param ci.col Colour for the confidence interval bands. Default is a
#'   semi-transparent grey (`adjustcolor("grey50", alpha.f = 0.5)`). With
#'   20 overlapping bands the accumulated opacity creates a density gradient.
#' @param xlab Label for the x-axis. Default is `""`.
#' @param xlim Numeric vector of length 2 for the x-axis limits. 
#'   Default is `c(0, 1)`.
#' @param legend Logical; if `TRUE` a legend is drawn. Default is `TRUE`.
#' @param ... Further arguments passed to \code{\link[graphics]{barplot}}.
#' 
#' @return Invisibly returns `NULL`. Called for its side effect of producing
#'   a plot.
#'
#' @details
#' Each row of `x` is displayed as a horizontal stacked bar showing the
#' proportion of the first category. Confidence intervals are calculated
#' using \code{prop.test()} and drawn as 20 nested bands from
#' 80% to 99% in 1% steps, all in the same semi-transparent colour. The
#' repeated overdraw naturally darkens the centre of the interval where all
#' bands overlap. A vertical segment marks the observed proportion.
#'
#' @importFrom graphics barplot rect segments mtext legend grid
#' @importFrom grDevices gray.colors
#'
#' @examples
#' m <- matrix(c(22, 111, 33, 120, 80, 100), nrow = 3, byrow = TRUE)
#' hblue <- "steelblue"
#' hred  <- "firebrick"
#' plotPropCI(m, labels = c("yes", "no"), main = "Response by Group")
#'
#' # single row — vector input is accepted
#' plotPropCI(m[1, ], labels = c("yes", "no"))
#'

#' @family plot.univariate
#' @concept graphics
#' @concept confidence-intervals
#' @concept descriptive-statistics
#'
#'
#' @export
plotPropCI <- function(
    x,
    labels = NULL,     # level labels (z.B. TRUE/FALSE)
    main = NULL,
    xlab = "",
    col    = NULL,
    ci.col = addAlpha("grey80", 0.12),
    xlim = c(0, 1),
    legend = TRUE,
    ...
) {
  
  if(is.null(col))
    col <- c("steelblue", "firebrick")
  
  border <- NA
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # --- coerce vector to one-row matrix ----------------------------------------
    if (is.numeric(x) && !is.matrix(x))
      x <- matrix(x, nrow = 1L, dimnames = list(NULL, names(x)))
    
    # --- pad missing second column with 0 (e.g. all-TRUE or all-FALSE) ----------
    if (is.matrix(x) && ncol(x) == 1L) {
      other <- if (colnames(x) == "TRUE") "FALSE" else "TRUE"
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
      space  = bar.space
    )
    
    # --- confidence interval bands (outermost to innermost) ---------------------
    # 20 bands from 99% down to 80%, all in the same semi-transparent colour.
    # Accumulated overdraw darkens the centre naturally.
    ci.levels <- seq(0.99, 0.80, by = -0.01)
    
    for (lvl in ci.levels) {
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
      x0 = pp[, 1L],
      y0 = b - bar.width / 2,
      y1 = b + bar.width / 2,
      lwd=2
      
    )
    
    # --- category labels at top -------------------------------------------------
    lpos <- if (nrow(x) == 1L) -3 else 0
    
    mtext(paste0(" ", labels[1L]), side = 3, at = 0, 
          adj = 0, line = lpos, cex=1.2)
    mtext(paste0(labels[2L], " "), side = 3, at = 1, 
          adj = 1, line = lpos, cex=1.2)
    
    # --- grid and legend --------------------------------------------------------
    grid(nx = NULL, ny = NA)
    # abline(v=c(0, 1))
    
    if(legend) {
      legend(
        x      = "bottomleft",
        legend = "80% \u2013 99% CI",
        fill   = ci.col,
        bty    = "n",
        inset  = c(-0.045, -0.24),
        xpd    = NA
      )
    }
    
    
  })
  
  invisible(ci)
}



# == internal helper functions =====================================================


# needed here to avoid reverse dependency with binomCI defined in lumen

.binomCI_raw <- function(x, n, conf.level=0.95){
  setNamesX(c(est=x/n, prop.test(x, n, conf.level = conf.level, correct=FALSE)$conf.int),
            names=c("est", "lci", "uci"))
}


