
#' Categorical Distribution Plot
#'
#' Visualizes the distribution of a categorical variable using horizontal
#' bar plots of absolute and relative frequencies. Optionally, cumulative
#' proportions (ECDF-style) can be displayed.
#'
#' @param x a factor or character vector, a one-dimensional table of counts,
#'   or a numeric vector of precomputed frequencies. Unnamed numeric frequency
#'   vectors are labelled by their positions.
#'
#' @param type character; one of `"both"`, `"freq"`, `"perc"`.
#'   Controls whether absolute frequencies, relative frequencies, or both
#'   are displayed.
#'
#' @param ecdf logical; if `TRUE`, cumulative proportions are shown
#'   instead of simple relative frequencies.
#'
#' @param col fill color for bars.
#' @param border logical; draw borders around bars.
#'
#' @param maxLabLen integer; maximum length of category labels before truncation.
#' @param maxCats optional maximum number of categories to display (truncates if exceeded).
#'
#' @param main plot title.
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/
#'   `NULL`, a string, or a named list for [stamp()].
#' @param ... further graphical parameters passed to `par()`.
#'
#' @details
#' The function produces horizontal bar plots:
#' \itemize{
#'   \item Absolute frequencies (counts)
#'   \item Relative frequencies (percentages) or cumulative proportions
#' }
#'
#' If `type = "both"`, both views are shown side by side.
#'
#' Long labels are truncated, and large category sets can be limited via
#' `maxCats`.
#'
#' Raw categorical data and their pre-tabulated form are treated identically.
#' When categories are truncated via `maxCats`, proportions remain based
#' on the total frequency before truncation.
#'
#' @return Invisibly returns a list with frequencies and proportions.
#'
#' @examples
#' # Basic usage
#' x <- factor(sample(letters[1:5], 100, TRUE))
#' plotCatDist(x)
#' plotCatDist(table(x))
#'
#' # Only proportions
#' plotCatDist(x, type = "perc")
#'
#' # With cumulative distribution
#' plotCatDist(x, ecdf = TRUE)
#'
#' # Many categories (truncation)
#' x2 <- factor(sample(letters, 200, TRUE))
#' plotCatDist(x2, maxCats = 10)
#'



#' @family plot.univariate  
#' @concept frequency-table
#'
#'
#' @export
plotCatDist <- function(
    # DATA
    x,

    # LABELS
    main = NULL,

    # STRUCTURE
    type      = c("both", "freq", "perc"),
    ecdf      = FALSE,
    maxCats   = NULL,
    maxLabLen = 25,

    # STYLE
    col    = "grey80",
    border = FALSE,

    # FRAMEWORK
    stamp = .useTheme,

    ...
) {
  
  type <- match.arg(type)
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # ── Input handling ───────────────────────────────────────────
    if (is.factor(x) || is.character(x)) {
      tab <- table(x)
    } else if (is.table(x)) {
      if (length(dim(x)) != 1L)
        stop("'x' must be a one-dimensional table")
      tab <- x
    } else if (is.numeric(x)) {
      tab <- x
    } else {
      stop("'x' must be a factor or character vector, a one-dimensional ",
           "table, or a numeric frequency vector")
    }

    if (anyNA(tab) || any(!is.finite(tab)) || any(tab < 0))
      stop("frequencies must be finite, non-missing, and non-negative")

    total <- sum(tab)

    if (total <= 0)
      stop("the total frequency must be positive")
    
    tab <- sort(tab, decreasing = TRUE)
    k <- length(tab)
    
    # ── Truncate categories ──────────────────────────────────────
    trunc_fg <- FALSE
    
    if (!is.null(maxCats) && k > maxCats) {
      tab <- tab[seq_len(maxCats)]
      trunc_fg <- TRUE
    }
    
    # ── Labels ───────────────────────────────────────────────────
    labs <- names(tab)

    if (is.null(labs))
      labs <- as.character(seq_along(tab))
    
    if (max(nchar(labs)) > maxLabLen) {
      labs <- strTrunc(labs, maxLabLen)
    }
    
    names(tab) <- labs
    
    # ── Proportions ──────────────────────────────────────────────
    p <- tab / total
    
    if (ecdf) {
      p <- cumsum(p)
    }
    
    # reverse for plotting (top = largest)
    tab <- rev(tab)
    p   <- unname(rev(p))
    
    y <- seq_along(tab)
    
    # ── Layout & margins ─────────────────────────────────────────
    # Preserve the current character expansion across the two-panel layout.
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
    
  }, stamp = stamp, resetLayout = TRUE)
  
  invisible(list(freq = tab, prop = p))
}
