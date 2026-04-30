
#' Proportion Plot with Confidence Intervals
#'
#' Visualizes proportions (e.g., success rates) with optional confidence intervals.
#'
#' @param x numeric vector of successes or proportions
#' @param n optional total counts (same length as x). If NULL, x is treated as proportion.
#' @param labels optional character vector of group labels
#'
#' @param main plot title
#' @param xlab x-axis label
#'
#' @param col colors: c(success, failure, CI...)
#' @param xlim x-axis limits (default 0–1)
#' @param glabels group labels, if more than 1 group
#'
#' @param conf.levels numeric vector of confidence levels.
#'   Use \code{NA} to suppress confidence intervals.
#'
#' @param legend logical or list; show legend
#'
#' @param ... passed to \code{par()}
#' 
#' @examples
#' plotPropCI(30, n = 100,
#'            labels = "Success",
#'            main = "Single proportion")
#'            
#' # multiple groups 
#' plotPropCI(c(30, 55, 80),
#'            n = c(100, 120, 150),
#'            labels = c("A", "B", "C"),
#'            main = "Group comparison")
#'            
#' # no confidence intervals
#' plotPropCI(c(0.3, 0.6, 0.8),
#'            labels = c("A", "B", "C"),
#'            conf.levels = NA,
#'            main = "Proportions only")
#' 


#' @export
plotPropCI <- function(
    x,
    n = NULL,
    labels = NULL,     # level labels (z.B. TRUE/FALSE)
    glabels = NULL,    # group labels (nur bei mehreren)
    main = NULL,
    xlab = "",
    col = NULL,
    xlim = c(0, 1),
    conf.levels = c(0.99, 0.95, 0.90),
    legend = TRUE,
    ...
) {
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # ── Input handling ───────────────────────────────────────────
    if (is.null(n)) {
      p <- x
      if (any(p < 0 | p > 1, na.rm = TRUE))
        stop("If 'n' is NULL, 'x' must be proportions in [0,1]")
    } else {
      if (length(x) != length(n))
        stop("'x' and 'n' must have same length")
      p <- x / n
    }
    
    k <- length(p)
    
    # ── defaults ────────────────────────────────────────────────
    if (is.null(glabels))
      glabels <- names(p) %||% paste0("G", seq_len(k))
    
    if (is.null(labels))
      labels <- c("0", "1")   # fallback
    
    # ── reverse order (top first) ───────────────────────────────
    p <- rev(p)
    if (!is.null(n)) {
      x <- rev(x)
      n <- rev(n)
    }
    glabels <- rev(glabels)
    
    # ── Colors ───────────────────────────────────────────────────
    if (is.null(col)) {
      base <- aurora::pal()
      col <- c(base[1:2], rep(c("grey80","grey60","grey40"),
                              length.out = length(conf.levels)))
    } else {
      col <- rep(col, length.out = 2 + length(conf.levels))
    }
    
    # ── Layout ───────────────────────────────────────────────────
    y <- seq_len(k)
    
    if(k==1){
      
      par(mar=c(5.1,2.1,4.1,2.1))
      ylim <- c(0.7, 1.3)
      
    } else {
      ylim <- c(0.5, k + 0.5)
    }
    
    plot(NA,
         xlim = xlim,
         ylim = ylim,
         yaxt = "n",
         ylab = "",
         xlab = xlab,
         main = main,
         bty = "n")
    
    abline(v = seq(0, 1, 0.1), col = "grey90", lty = 3)
    
    # ── Geometry ────────────────────────────────────────────────
    h_bar <- if (k == 1) 0.10 else 0.18   # schlanker für single
    h_ci  <- h_bar * 1.6
    
    for (i in seq_len(k)) {
      
      # baseline
      segments(0, y[i], 1, y[i], col = "grey70")
      
      # Balken: links = 0 / rechts = 1
      rect(0, y[i] - h_bar, 1 - p[i], y[i] + h_bar, col = col[1])
      rect(1 - p[i], y[i] - h_bar, 1, y[i] + h_bar, col = col[2])
      
      # ── CI ────────────────────────────────────────────────────
      if (!all(is.na(conf.levels)) && !is.null(n)) {
        
        for (j in seq_along(conf.levels)) {
          
          if (is.na(conf.levels[j])) next
          
          ci <- .binomCI_raw(x[i], n[i], conf.level = conf.levels[j])[2:3]
          ci <- 1 - rev(ci)
          
          rect(ci[1],
               y[i] - h_ci,
               ci[2],
               y[i] + h_ci,
               col = col[2 + j],
               border = NA)
        }
        
        segments(1 - p[i], y[i] - h_ci * 1.2, 1 - p[i], y[i] + h_ci * 1.2,
                 col = "grey30", lwd = 1)
      }
    }
    
    # ── Level labels (0/1 etc.) ─────────────────────────────────
    text(0.02, max(y) + h_ci * 1.6, labels = labels[1], adj = c(0, 0.5))
    text(0.98, max(y) + h_ci * 1.6, labels = labels[2], adj = c(1, 0.5))
    
    # ── Group labels (links stirnseitig) ────────────────────────
    if( k > 1 ){
      text(x = 0,
           y = y,
           labels = glabels,
           adj = c(1.1, 0.5),
           xpd = NA)
    }    
    
    # ── Legend unterhalb ────────────────────────────────────────
    .callIf(function(...) {
      
      usr <- par("usr")
      
      x0 <- usr[1]                     # exakt linker Rand (Balkenstart)
      y0 <- usr[3] - 0.3 * diff(usr[3:4])  # unterhalb Achse
      
      levs <- conf.levels[!is.na(conf.levels)]
      cols <- col[3:(2 + length(levs))]
      
      dx <- 0.04 * diff(usr[1:2])      # Breite eines Kastens
      gap <- 0.015 * diff(usr[1:2])    # Abstand
      
      for (i in seq_along(levs)) {
        
        xi <- x0 + (i - 1) * (dx + gap + 0.08)  # spacing inkl. Text
        
        # Kasten
        rect(xi, y0,
             xi + dx,
             y0 + 0.04 * diff(usr[3:4]),
             col = cols[i], border = "black", xpd = NA)
        
        # Text
        text(xi + dx + gap,
             y0 + 0.02 * diff(usr[3:4]),
             labels = paste0("CI ", levs[i] * 100, "%"),
             adj = c(0, 0.5), xpd = NA)
      }
      
    }, legend)
    
  })
  
  invisible(p)
}

