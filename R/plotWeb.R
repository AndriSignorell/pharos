
#' Plot a Web of Connected Points
#'
#' Displays a symmetric matrix (typically a correlation matrix) as a
#' network diagram: variables are placed equidistantly around a circle,
#' and connecting lines between each pair are drawn with width proportional
#' to the absolute value of the matrix entry and color indicating its sign.
#'
#' The function uses the lower triangular matrix of \code{m}; when
#' overriding \code{lwd} or \code{col} manually, values must be supplied in
#' the same order as \code{m[lower.tri(m)]}.
#'
#' @param m a symmetric numeric matrix (e.g. a correlation matrix).
#'
#' @param main main title of the plot. \code{NULL} (default) produces no
#'   title.
#'
#' @param dist distance of node labels from the outer circle. Default
#'   \code{0.5}.
#'
#' @param col two colors for the connecting lines: the first is used for
#'   negative values, the second for positive values. \code{.useTheme}
#'   (default) resolves to \code{getTheme()$twin} - consistent with the
#'   sign-based coloring in \code{\link{plotCor}}.
#' @param lty line type for the connecting lines. \code{NULL} (default)
#'   inherits from \code{par("lty")}.
#' @param lwd line widths for the connecting lines. \code{NULL} (default)
#'   scales widths linearly between 0.5 and 10 in proportion to the absolute
#'   matrix values.
#'
#' @param labels controls node labels around the circle. \code{TRUE}
#'   (default) draws labels using \code{colnames(m)} with default styling.
#'   \code{FALSE}/\code{NA}/\code{NULL} suppresses labels. A named list
#'   overrides individual settings:
#'   \describe{
#'     \item{\code{labels}}{character vector of label texts; defaults to
#'       \code{colnames(m)}}
#'     \item{\code{las}}{orientation: \code{1} horizontal (default),
#'       \code{2} radial, \code{3} vertical}
#'     \item{\code{adj}}{label adjustment (0/0.5/1); \code{NULL} (default)
#'       chooses automatically based on position around the circle}
#'     \item{\code{cex}}{character expansion; default \code{1.0}}
#'   }
#'
#' @param points controls the node point symbols. The default
#'   (\code{list(pch=21, cex=2, col="black", bg="darkgrey")}) draws
#'   prominent filled circles, larger than the generic data-point default,
#'   since nodes represent variables rather than observations.
#'   \code{FALSE}/\code{NA}/\code{NULL} suppresses the points. A named list
#'   overrides individual elements (\code{pch}, \code{cex}, \code{col},
#'   \code{bg}).
#'
#' @param legend controls the legend. \code{TRUE} (default) draws a legend
#'   showing the line widths and colors for the minimum/maximum positive
#'   and negative values. \code{FALSE}/\code{NA} suppresses it. A named
#'   list overrides arguments forwarded to \code{\link[graphics]{legend}}.
#'
#' @param stamp controls the corner stamp. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$stamp}. \code{TRUE}/\code{FALSE}/
#'   \code{NULL}, a string, or a named list for \code{\link{stamp}()}.
#' @param \dots further graphical parameters passed to
#'   \code{\link[graphics]{par}} and to the internal \code{canvas()} call.
#'
#' @return Invisibly returns a list of \code{x}/\code{y} coordinates of the
#'   node points, useful for adding further annotations to the plot.
#'
#' @seealso \code{\link{plotCor}}, [theme]
#'
#' @examples
#' m <- cor(swiss)
#' plotWeb(m, main = "Swiss correlation")
#'
#' # custom labels (abbreviations)
#' plotWeb(m, labels = list(labels = abbreviate(colnames(m), 4), cex = 0.9))
#'
#' # show only significant correlations
#' p <- outer(
#'   (vars <- colnames(mtcars)), vars,
#'   Vectorize(function(v1, v2)
#'     cor.test(mtcars[[v1]], mtcars[[v2]])$p.value)
#' )
#' dimnames(p) <- list(vars, vars)
#' m2 <- cor(mtcars)
#' m2[p > 0.05] <- NA
#' plotWeb(m2, labels = list(las = 2))
#'

#' @family plot.special  
#' @concept bivariate
#'
#'
#' @export
plotWeb <- function(m,
                    
                    # LABELS
                    main = NULL,
                    
                    # STRUCTURE
                    dist = 0.5,
                    
                    # STYLE
                    col    = hcol("red","blue"),
                    lty    = NULL,
                    lwd    = NULL,
                    labels = TRUE,
                    points = list(pch = 21, cex = 2,
                                  col = "black", bg = "darkgrey"),
                    
                    # FEATURES
                    legend = TRUE,
                    
                    # FRAMEWORK
                    stamp = .useTheme,
                    
                    ...) {
  
  # Resolve twin colors: col[1] = negative, col[2] = positive,
  # consistent with plotCor()'s diverging ramp convention.
  if (identical(col, .useTheme))
    col <- getTheme()$twin
  col <- rep_len(col, 2L)
  
  .withGraphicsState({
    
    .applyParFromDots(
      ...,
      defaults = list(
        mar = c(bottom= 3, left = 3, 
                top = .marTop(main), right = 3)
      )
    )
    
    canvas(4, main = main, ...)
    
    angles <- seq(0, 2 * pi, length = nrow(m) + 1)[-1]
    xy     <- polToCart(r = 3,        theta = angles)
    xylab  <- polToCart(r = 3 + dist, theta = angles)
    
    # --- labels ---
    # 'labels' element in the list overrides colnames(m) as label text;
    # all other elements (las, adj, cex) control appearance.
    labDefaults <- list(
      labels = colnames(m),
      las    = 1L,
      adj    = NULL,
      cex    = 1.0
    )
    
    labSpec <- .resolveSpec(labels, labDefaults)
    
    if (!is.null(labSpec)) {
      
      node.labels <- labSpec$labels
      las         <- labSpec$las
      adj         <- labSpec$adj
      labCex      <- labSpec$cex
      
      if (las == 2L) {
        
        if (is.null(adj))
          adj <- as.integer(angles >= pi / 2 & angles <= 3 * pi / 2)
        adj <- rep_len(adj, length(node.labels))
        
        for (i in seq_along(node.labels))
          text(xylab$x[i], xylab$y[i],
               labels = node.labels[i], cex = labCex,
               srt    = radToDeg(atan(xy$y[i] / xy$x[i])),
               adj    = adj[i])
        
      } else {
        
        if (is.null(adj))
          adj <- if (las == 1L)
            as.integer(angles >= pi / 2 & angles <= 3 * pi / 2)
        else
          as.integer(angles >= 3 * pi / 4 & angles <= 7 * pi / 4)
        adj <- rep_len(adj, length(node.labels))
        
        for (i in seq_along(node.labels))
          text(xylab$x[i], xylab$y[i],
               labels = node.labels[i], cex = labCex,
               srt    = ifelse(las == 3L, 90, 0),
               adj    = adj[i])
      }
    }
    
    # --- edges ---
    idx <- combPairs(seq_len(dim(m)[1]))
    d.m <- data.frame(
      d      = m[lower.tri(m)],
      from.x = xy[[1]][idx[, 2]], to.x = xy[[1]][idx[, 1]],
      from.y = xy[[2]][idx[, 2]], to.y = xy[[2]][idx[, 1]]
    )
    
    d.m$d.sc <- if (is.null(lwd))
      linScale(abs(d.m$d), newLow = 0.5, newHigh = 10)
    else
      rep_len(lwd, nrow(d.m))
    
    # lty is independent of lwd - old code tied them incorrectly
    d.m$lty <- rep_len(lty %||% par("lty"), nrow(d.m))
    d.m$col <- col[((sign(d.m$d) + 1) / 2) + 1]
    
    segments(
      x0  = d.m$from.x, y0 = d.m$from.y,
      x1  = d.m$to.x,   y1 = d.m$to.y,
      col = d.m$col,    lty = d.m$lty,
      lwd = d.m$d.sc,   lend = 1
    )
    
    # --- points (nodes represent variables, not data points - larger default) ---
    ptDefaults <- list(pch = 21, cex = 2, col = "black", bg = "darkgrey")
    
    ptSpec <- if (isFALSE(points) || is.null(points) ||
                  (length(points) == 1L && !is.list(points) &&
                   isTRUE(suppressWarnings(is.na(points))))) {
      NULL
    } else if (isTRUE(points)) {
      ptDefaults
    } else {
      .modifyListSafe(ptDefaults, points)
    }
    
    if (!is.null(ptSpec))
      graphics::points(xy, pch = ptSpec$pch, cex = ptSpec$cex,
                       col = ptSpec$col,     bg  = ptSpec$bg)
    
    # --- legend ---
    i_neg_min <- which.min(d.m$d)
    i_neg_max <- which.max(ifelse(d.m$d <= 0, d.m$d, NA))
    i_pos_min <- which.min(ifelse(d.m$d >  0, d.m$d, NA))
    i_pos_max <- which.max(d.m$d)
    
    # positive entries first (top), negative last (bottom)
    idx_leg <- c(i_pos_max, i_pos_min, i_neg_max, i_neg_min)
    
    bedrock::callIf(
      graphics::legend,
      legend,
      defaults = .legendDefaults(list(
        x      = "bottomright",
        legend = gsub("0.", ".", format(d.m$d[idx_leg], digits = 3),
                      fixed = TRUE),
        lwd    = d.m$d.sc[idx_leg],
        col    = rep(col[c(2, 1)], each = 2L),  # twin[2]=blau für positiv oben
        cex    = 0.8
      ))
    )
    
    invisible(xy)
    
  }, stamp = stamp)
}

