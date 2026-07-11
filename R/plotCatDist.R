
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



#' @family plot.univariate  
#' @concept frequency-table
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
    
    n <- length(x)
    
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
    p <- tab / n # sum(tab)
    
    if (ecdf) {
      p <- cumsum(p)
    }
    
    # reverse for plotting (top = largest)
    tab <- rev(tab)
    p   <- unname(rev(p))
    
    y <- seq_along(tab)
    
    # ── Layout & margins ─────────────────────────────────────────
    # Trigger plot.new() hooks (e.g. .Rprofile setHook) before reading par("cex")
    frame()
    ocex <- par("cex")
    
    if (type == "both") {
      lab_lines <- max(strwidth(names(tab), units = "inches", cex = ocex)) /
        (par("cin")[2] * ocex) + 1.8
      par(mfrow = c(1, 2),
          oma   = c(0, lab_lines, 0, 1),
          mar   = c(5.1, 0, 3.1, 2),
          cex   = ocex)
    }
    
    # ── Plot frequency ───────────────────────────────────────────
    if (type %in% c("both", "freq")) {
      
      b <- barplot(unname(tab), horiz = TRUE, 
                   border = border,
                   col = col, space = 0.2,
                   panel.first = grid(nx = NULL, ny = NA),
                   xlab = "frequency")
      
      mtext(names(tab), side = 2, at = b, line = 1, las = 1,
            cex = par("cex.axis")*ocex)
    }
    
    # ── Plot proportions ─────────────────────────────────────────
    if (type %in% c("both", "perc")) {
      
      col_ecdf <- grDevices::adjustcolor(col, alpha.f = 0.5)
      
      if (!ecdf) {
        bp <- barplot(rev(cumsum(rev(p))), horiz = TRUE,
                      border = border, col = col_ecdf,
                      xlim = c(0, 1), space = 0.2,
                      panel.first = grid(nx = NULL, ny = NA),
                      xlab = "proportion")
        barplot(p, horiz = TRUE, border = border, col = col,
                space = 0.2, add = TRUE)
      } else {
        bp <- barplot(p, horiz = TRUE,
                      border = border, col = col,
                      xlim = c(0, 1), space = 0.2,
                      panel.first = grid(nx = NULL, ny = NA),
                      xlab = "cumulative proportion")
      }
      
      if (type != "both")
        mtext(names(tab), side = 2, at = bp, line = 1, las = 1,
              cex = par("cex.axis"))
    }
    
    # ── Title ────────────────────────────────────────────────────
    if (!is.null(main))
      title(main = main, outer = (type == "both"), line = if (type == "both") -1.5 else NA)
    
    # ── Truncation note ──────────────────────────────────────────
    if (trunc_fg) {
      text(x = 1, y = 1, labels = " ...[list output truncated]",
      cex = 0.6, adj = c(1, 0.5))
      
    }
    
  }, resetLayout = TRUE)
  
  invisible(list(freq = tab, prop = p))
}
