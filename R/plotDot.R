
#' Dot Plot with Optional Confidence Intervals
#'
#' Draws a dot plot for numeric values with optional confidence intervals.
#' The function accepts vectors, matrices, or 3-dimensional arrays. Internally
#' the data are normalized to an array of dimension
#' \code{items × (est, low, high) × groups}.
#'
#' If lower and upper bounds are supplied, horizontal confidence intervals are
#' drawn with capped ends. Items are arranged vertically and may optionally be
#' grouped.
#'
#' @param x Numeric data. Can be
#'   \itemize{
#'     \item a numeric vector (estimates only),
#'     \item a matrix with 1 column (estimates) or 3 columns (estimate, lower,
#'       upper),
#'     \item a 3D array of dimension
#'       \code{items × (est, low, high) × groups}.
#'   }
#' @param items Optional labels for the items (rows).
#'   Defaults to \code{dimnames(x)[[1]]} if available.
#' @param groups Optional group labels. Defaults to
#'   \code{dimnames(x)[[3]]} if present.
#' @param main Main title of the plot.
#' @param xlim Limits for the horizontal axis.
#' @param gap Vertical spacing between groups.
#' @param axes Logical; if \code{TRUE} axes are drawn.
#' @param xax Optional specification of the x-axis. Passed to
#'   (the internal function) \code{.drawAxis}.
#' @param box Logical; if \code{TRUE} a box is drawn around the plotting region.
#' @param grid Logical; if \code{TRUE} horizontal grid lines are drawn.
#' @param pch Plotting symbol specification for the points. May be a single
#'   value or a list of graphical parameters passed to
#'   \code{\link[graphics]{points}}.
#' @param ... Additional graphical parameters passed to \code{\link{par}} via
#'   \code{.applyParFromDots()}.
#'
#' @details
#' Graphical defaults may also be controlled globally through
#' \code{options(DescToolsX.theme = list(...))}. Values supplied as arguments
#' take precedence over theme settings.
#'
#' @return Invisibly returns a list with the vertical layout positions used in
#' the plot:
#' \itemize{
#'   \item \code{ypos} positions of items,
#'   \item \code{group_y} positions of group labels,
#'   \item \code{sep_y} positions of group separator lines.
#' }
#'
#' 
#' @examples
#' # simple dot plot
#' plotDot(c(12, 18, 28, 40, 65), items = LETTERS[1:5])
#'
#' # dot plot with confidence intervals
#' est  <- c(12, 18, 28, 40, 65)
#' low  <- est - 3
#' high <- est + 3
#'
#' plotDot(cbind(est, low, high), items = LETTERS[1:5])
#' 
#' dat <- structure(c(12, 18, 28, 40, 65, 9.2, 14.9, 24.3, 35.3, 62.4, 
#'                    16.8, 20.6, 32, 42.4, 67.8, 20, 15, 22, 32, 55, 15.3, 10.2, 18, 
#'                    28.1, 52.8, 23.2, 17, 25.1, 36.6, 58, 16, 24, 36, 54, 70, 13.4, 
#'                    21.5, 31.9, 50.8, 65.7, 19.4, 27.8, 39.5, 56.6, 74.5, 10, 14, 
#'                    21, 35, 50, 6.5, 9.8, 16, 31.9, 45.7, 14, 18.4, 23.3, 39.2, 53.2
#'                    ), dim = c(5L, 3L, 4L)) 
#' 
#' plotDot(
#'   dat, main="Plot Dot VADeaths", cex.axis=0.8,
#'   items = c("50-54","55-59","60-64","65-69","70-74"),
#'   groups = c("Rural Male","Rural Female","Urban Male","Urban Female"),
#'   xlim = c(0,80),
#'   pch = list(pch=c(16, 21), col= c("green","blue"), 
#'              cex=c(1,2), bg="white")
#' )
#' 
#' ypos <- plotDot(c(12,18,28,40,65), # groups="", 
#'                 items=LETTERS[1:5], pch=list(cex=1.5), main="Title")
#'                 
#' points(c(12,18,28,40,65) + runif(n = 5)*15, y=unlist(ypos$ypos), 
#'        cex=1.5, pch=15)


#' @family plot.univariate
#' @concept graphics
#' @concept descriptive-statistics
#' @concept confidence-intervals
#'
#'

#' @export
plotDot <- function(x, 
                    items = NULL,
                    groups = NULL,
                    main=NULL, 
                    xlim = NULL,
                    gap = 1,
                    axes = TRUE,
                    xax = NULL, 
                    box = TRUE,
                    grid = TRUE,
                    pch = NULL, 
                            ...) {
  UseMethod("plotDot")
}



#' @export
plotDot.default <- function(x, 
                    items = NULL,
                    groups = NULL,
                    main=NULL, 
                    xlim = NULL,
                    gap = 1,
                    axes = TRUE,
                    xax = NULL, 
                    box = TRUE,
                    grid = TRUE,
                    pch = NULL, 
                    ...) {

  
  th <- .theme(
    grid = grid,
    pch  = pch, 
    box  = list(col="grey",
                which ="plot") 
  )
  
  
  grid <- th$grid
  pch  <- th$pch
  
  
  x <- .normalizeDotData(x)
  
  nm <- .resolveNames(x, items, groups)
  items  <- nm$items
  groups <- nm$groups
  
  if (dim(x)[3] == 1 && missing(groups))
    groups <- NULL

  ng <- dim(x)[3]
  x <- x[,,rev(seq_len(ng)), drop = FALSE]
  if (!is.null(groups))
    groups <- rev(groups)
  
  
  .withGraphicsState({

    .applyParFromDots(...)
    
    if(length(dim(x)) != 3)
      stop("x must be age x (est,low,high) x group")
    
    nx <- dim(x)[1]
    ng   <- dim(x)[3]
    
    drawGroupHeader <- ng > 1 
    header <- if (drawGroupHeader) 1 else 0
    
    if(is.null(items))
      items <- seq_len(nx)
    
    if(is.null(groups))
      groups <- paste("Group", seq_len(ng))
    
    if(is.null(xlim))
      xlim <- range(x, na.rm = TRUE)
    
    # --------------------------------
    # adjust margin automatically 
    # --------------------------------
    
    # .adjustLeftMarginForLabels(c(groups, items), pad=1)
    .adjustMargin(c(groups, items), side=2, pad=1)
    
    # --------------------------------
    # Y layout
    # --------------------------------
    
    ypos    <- vector("list", ng)
    sep_y   <- numeric(ng)
    group_y <- numeric(ng)
    
    base <- 0
    
    for(g in seq_len(ng)) {
      
      # ypos[[g]]    <- base + seq_len(nx)
      ypos[[g]]    <- base + rev(seq_len(nx))
      sep_y[g]     <- base + nx + header
      group_y[g]   <- base + nx + header
      
      base <- base + nx + gap + header
    }
    
    ymax <- base - gap - header
    
    
    # --------------------------------
    # Plot
    # --------------------------------
    
    plot.new()
    
    plot.window(
      xlim = xlim,
      ylim = c(0, ymax + 1 + header),
      xaxs = "r",
      yaxs = "i"
    )
    
    usr <- par("usr")
    
    
    # --------------------------------
    # Grid
    # --------------------------------

    bedrock::callIf(
      .drawDotGrid,
      grid,
      defaults = list(
        ypos = ypos,
        sep_y = sep_y,
        drawGroupHeader = drawGroupHeader,
        col = th$grid$col,
        lty = th$grid$lty,
        lwd = th$grid$lwd,
        group.col = th$grid$group.col,
        group.lty = th$grid$group.lty,
        group.lwd = th$grid$group.lwd
      )
    )
    
    
    # --------------------------------
    # Axes
    # --------------------------------
    
    if(isTRUE(axes)) {
      
      .drawAxis(1, xax)

      axis(
        2,
        at = unlist(ypos),
        labels = rep(items, ng),
        las = 1
      )
    }
    
    
    # --------------------------------
    # Group labels
    # --------------------------------
    if (drawGroupHeader) {
      
      x_left <- usr[1] - diff(usr[1:2]) * 0.03
      
      for(g in seq_len(ng)) {
        
        text(
          x_left,
          group_y[g],
          groups[g],
          adj = c(1,0.5),
          xpd = NA,
          font = 2,
          cex = par("cex.axis")
        )
      }
    }
    
    # draw box if box != FALSE || NA
    bedrock::callIf(graphics::box, 
            box,
            defaults=th$box)
    
    # place main title if main != FALSE || NA
    if(!(is.null(main) %||% main=="" %||% isNA(main)))
      title(main=main)
    
 
    # add data
    .addDotCI(
      x,
      ypos,
      pch = pch
    )

        
  })
  
  invisible(list(
    ypos = ypos,
    group_y = group_y,
    sep_y = sep_y
  ))
  
}



# ============================================================
# plotDot for CI objects
# ============================================================

# internal representation expected by plotDot.default:
#
# dim = c(
#   n_items,
#   3,          # est, lci, uci
#   n_groups
# )
#
# dimnames[[1]] = item labels
# dimnames[[3]] = group labels
#
# ============================================================

#' @export
plotDot.CI <- function(x, ...) {
  
  grp <- setdiff(
    names(x),
    c("est", "lci", "uci")
  )
  
  # ----------------------------------------------------------
  # no grouping variables
  # ----------------------------------------------------------
  
  if (length(grp) == 0) {
    
    arr <- array(
      NA_real_,
      dim = c(nrow(x), 3, 1),
      dimnames = list(
        rownames(x),
        c("est", "lci", "uci"),
        NULL
      )
    )
    
    arr[,1,1] <- x$est
    arr[,2,1] <- x$lci
    arr[,3,1] <- x$uci
    
    return(
      plotDot.default(arr, ...)
    )
  }
  
  # ----------------------------------------------------------
  # one grouping variable
  # ----------------------------------------------------------
  
  if (length(grp) == 1) {
    
    items <- rownames(x)
    
    if (is.null(items))
      stop(
        "For CI objects with one grouping variable, ",
        "rownames must define the items."
      )
    
    groups <- unique(as.character(x[[grp]]))
    
    arr <- array(
      NA_real_,
      dim = c(
        length(unique(items)),
        3,
        length(groups)
      ),
      dimnames = list(
        unique(items),
        c("est", "lci", "uci"),
        groups
      )
    )
    
    for (i in seq_len(nrow(x))) {
      
      ii <- match(
        rownames(x)[i],
        dimnames(arr)[[1]]
      )
      
      jj <- match(
        as.character(x[[grp]][i]),
        groups
      )
      
      arr[ii,1,jj] <- x$est[i]
      arr[ii,2,jj] <- x$lci[i]
      arr[ii,3,jj] <- x$uci[i]
    }
    
    return(
      plotDot.default(arr, ...)
    )
  }
  
  # ----------------------------------------------------------
  # two grouping variables
  # ----------------------------------------------------------
  
  if (length(grp) == 2) {
    
    items  <- unique(as.character(x[[grp[1]]]))
    groups <- unique(as.character(x[[grp[2]]]))
    
    arr <- array(
      NA_real_,
      dim = c(
        length(items),
        3,
        length(groups)
      ),
      dimnames = list(
        items,
        c("est", "lci", "uci"),
        groups
      )
    )
    
    for (i in seq_len(nrow(x))) {
      
      ii <- match(
        as.character(x[[grp[1]]][i]),
        items
      )
      
      jj <- match(
        as.character(x[[grp[2]]][i]),
        groups
      )
      
      arr[ii,1,jj] <- x$est[i]
      arr[ii,2,jj] <- x$lci[i]
      arr[ii,3,jj] <- x$uci[i]
    }
    
    return(
      plotDot.default(arr, ...)
    )
  }
  
  stop(
    "Currently only up to two grouping variables are supported."
  )
}


# == internal helper functions ==============================================


.addDotCI <- function(x, ypos, pch = list(pch = 16), lwd = 1) {
  
  if (!is.list(ypos))
    stop("ypos must be list of y-vectors")
  
  ng <- dim(x)[3]
  
  # ensure pch is a list
  if (!is.list(pch))
    pch <- list(pch = pch)
  
  for (g in seq_len(ng)) {
    
    est  <- x[,1,g]
    low  <- x[,2,g]
    high <- x[,3,g]
    
    y <- as.numeric(ypos[[g]])
    
    # CI lines
    graphics::arrows(
      low, y, high, y,
      col   = pch$col %||% par("fg"),
      lwd   = lwd,
      code  = 3,
      angle = 90,
      length = 0.05
    )
    
    # points
    bedrock::callIf(
      graphics::points,
      pch,
      defaults = list(
        x   = est,
        y   = y,
        pch = rep_len(pch$pch %||% 16, ng)[g],
        col = rep_len(pch$col %||% par("fg"), ng)[g],
        bg  = rep_len(pch$bg  %||% NA, ng)[g],
        cex = rep_len(pch$cex %||% 1, ng)[g]
      ),
      forbidden = c("x", "y")
    )
    
  }
  
  invisible(NULL)
}


.resolveNames <- function(x, items=NULL, groups=NULL) {
  
  dn <- dimnames(x)
  
  if (is.null(items)) {
    items <- if (!is.null(dn[[1]])) dn[[1]] else seq_len(dim(x)[1])
  }
  
  if (is.null(groups)) {
    groups <- if (!is.null(dn[[3]])) dn[[3]] else seq_len(dim(x)[3])
  }
  
  list(items=items, groups=groups)
}



.normalizeDotData <- function(x) {
  
  if (is.array(x) && length(dim(x)) == 3)
    return(x)
  
  # ----------------------------
  # vector -> estimate only
  # ----------------------------
  
  if (is.vector(x)) {
    
    out <- array(NA_real_, dim = c(length(x), 3, 1))
    out[,1,1] <- x
    
    dimnames(out)[[1]] <- names(x)
    
    return(out)
  }
  
  # ----------------------------
  # tapply-like list array
  # ----------------------------
  
  if (is.list(x) && !is.null(dim(x))) {
    
    dm <- dim(x)
    dn <- dimnames(x)
    
    out <- array(
      NA_real_,
      dim = c(dm[1], 3, dm[2])
    )
    
    for (j in seq_len(dm[2])) {
      for (i in seq_len(dm[1])) {
        out[i,,j] <- x[[i + (j - 1) * dm[1]]]
      }
    }
    
    dimnames(out)[[1]] <- dn[[1]]
    dimnames(out)[[3]] <- dn[[2]]
    
    return(out)
  }
  
  # ----------------------------
  # matrix
  # ----------------------------
  
  if (is.matrix(x)) {
    
    n  <- nrow(x)
    ng <- ncol(x)
    
    rn <- rownames(x)
    cn <- colnames(x)
    
    # estimate only
    if (ng == 1) {
      
      out <- array(
        NA_real_,
        dim = c(n, 3, 1)
      )
      
      out[,1,1] <- x[,1]
      
      dimnames(out)[[1]] <- rn
      
      return(out)
    }
    
    # matrix interpreted as:
    # rows = items
    # cols = groups
    # estimates only
    
    out <- array(
      NA_real_,
      dim = c(n, 3, ng)
    )
    
    for (i in seq_len(ng))
      out[,1,i] <- x[,i]
    
    dimnames(out)[[1]] <- rn
    dimnames(out)[[3]] <- cn
    
    return(out)
  }
  
  stop("Unsupported data structure")
}


.drawDotGrid <- function(
    ypos, sep_y, drawGroupHeader,
    col = "orange", lty = 3, lwd=1,
    group.col = "grey40", group.lty = 2, group.lwd=1
) {
  
  ng <- length(ypos)
  
  for (g in seq_len(ng)) {
    
    graphics::abline(h = ypos[[g]], col = col, lty = lty)
    
    if (drawGroupHeader)
      graphics::abline(h = sep_y[g], col = group.col, lty = group.lty)
  }
  
  invisible(NULL)
}
