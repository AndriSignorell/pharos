
#' Categorical Distribution Plot
#'
#' Visualizes the distribution of a categorical variable using horizontal
#' bar plots of absolute and relative frequencies. Optionally, cumulative
#' proportions (ECDF-style) can be displayed.
#'
#' @param x a factor, character vector, or table of counts.
#'
#' @param type character; one of \code{"both"}, \code{"freq"}, \code{"perc"}.
#'   Controls whether absolute frequencies, relative frequencies, or both
#'   are displayed.
#'
#' @param ecdf logical; if \code{TRUE}, cumulative proportions are shown
#'   instead of simple relative frequencies.
#'
#' @param col fill color for bars.
#' @param border logical; draw borders around bars.
#'
#' @param maxlablen integer; maximum length of category labels before truncation.
#' @param maxcats optional maximum number of categories to display (truncates if exceeded).
#'
#' @param main plot title.
#'
#' @param ... further graphical parameters passed to \code{par()}.
#'
#' @details
#' The function produces horizontal bar plots:
#' \itemize{
#'   \item Absolute frequencies (counts)
#'   \item Relative frequencies (percentages) or cumulative proportions
#' }
#'
#' If \code{type = "both"}, both views are shown side by side.
#'
#' Long labels are truncated, and large category sets can be limited via
#' \code{maxcats}.
#'
#' @return Invisibly returns a list with frequencies and proportions.
#'
#' @examples
#' # Basic usage
#' x <- factor(sample(letters[1:5], 100, TRUE))
#' plotCatDist(x)
#'
#' # Only proportions
#' plotCatDist(x, type = "perc")
#'
#' # With cumulative distribution
#' plotCatDist(x, ecdf = TRUE)
#'
#' # Many categories (truncation)
#' x2 <- factor(sample(letters, 200, TRUE))
#' plotCatDist(x2, maxcats = 10)
#'


#' @family plot.distribution
#' @concept graphics
#' @concept descriptive-statistics
#' @concept factor-handling
#'
#'
#' @export
plotCatDist <- function(
    x,
    type = c("both", "freq", "perc"),
    ecdf = FALSE,
    col = "grey80",
    border = FALSE,
    maxlablen = 25,
    maxcats = NULL,
    main = NULL,
    ...
) {
  
  type <- match.arg(type)
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # ── Input handling ───────────────────────────────────────────
    if (is.factor(x) || is.character(x)) {
      tab <- table(x)
    } else if (is.table(x) || is.numeric(x)) {
      tab <- x
    } else {
      stop("'x' must be factor, character, or table")
    }
    
    tab <- sort(tab, decreasing = TRUE)
    k <- length(tab)
    
    # ── Truncate categories ──────────────────────────────────────
    trunc_fg <- FALSE
    
    if (!is.null(maxcats) && k > maxcats) {
      tab <- tab[seq_len(maxcats)]
      trunc_fg <- TRUE
    }
    
    # ── Labels ───────────────────────────────────────────────────
    labs <- names(tab)
    
    if (max(nchar(labs)) > maxlablen) {
      labs <- strTrunc(labs, maxlablen)
    }
    
    names(tab) <- labs
    
    # ── Proportions ──────────────────────────────────────────────
    p <- tab / sum(tab)
    
    if (ecdf) {
      p <- cumsum(p)
    }
    
    # reverse for plotting (top = largest)
    tab <- rev(tab)
    p   <- rev(p)
    
    y <- seq_along(tab)
    
    # ── Layout ───────────────────────────────────────────────────
    if (type == "both") {
      par(mfrow = c(1, 2))
    }
    
    # ── Plot frequency ───────────────────────────────────────────
    if (type %in% c("both", "freq")) {
      
      plotBar(
        tab,
        horiz = TRUE,
        col = col,
        border = border,
        grid = TRUE,
        yaxt = "n",
        xlab = "frequency"
      )
      
      axis(2, at = y, labels = names(tab), las = 1)
    }
    
    # ── Plot proportions ─────────────────────────────────────────
    if (type %in% c("both", "perc")) {
      
      plotBar(
        p,
        horiz = TRUE,
        col = if (ecdf) col else c(col, fade(col, 0.5)),
        border = border,
        grid = TRUE,
        yaxt = "n",
        xlim = c(0, 1),
        xlab = if (ecdf) "cumulative proportion" else "proportion"
      )
      
      axis(2, at = y, labels = names(tab), las = 1)
    }
    
    # ── Title ────────────────────────────────────────────────────
    bedrock::callIf(
      title,
      if (!is.null(main)) list(main = main, outer = TRUE)
    )
    
    # ── Truncation note ──────────────────────────────────────────
    if (trunc_fg) {
      mtext("... truncated", side = 1, line = 2, cex = 0.8)
    }
    
  })
  
  invisible(list(freq = tab, prop = p))
}

