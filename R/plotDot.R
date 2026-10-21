
#' Dot Plot for Estimates and Confidence Intervals
#'
#' Displays numeric estimates as points on a horizontal scale. Optional
#' confidence limits are shown as horizontal lines with capped endpoints.
#' Several series of estimates can be arranged in labelled groups.
#'
#' @param x numeric estimates or confidence interval data. Supported formats
#'   are a numeric vector, a numeric matrix, a three-dimensional numeric array,
#'   or a `"CI"` object created with [as.CI()]
#' @param items optional character vector containing the item labels; defaults
#'   to the row names or first dimension names of `x`
#' @param groups optional character vector containing the group labels;
#'   defaults to the column names or third dimension names of `x`
#' @param main main title. `NULL` (default) draws none. `""`, `NA` or
#'   `FALSE` also suppress it; the top margin is compacted whenever no
#'   title is drawn.
#' @param xlim numeric vector containing the limits of the horizontal axis;
#'   by default, the range of all estimates and confidence limits
#' @param gap non-negative number, the vertical space between groups in
#'   item rows
#' @param axes logical; whether the horizontal and item axes are drawn
#' @param xax optional specification for the horizontal axis, interpreted by
#'   the internal axis renderer
#' @param box specification controlling the plot box. The default
#'   `.useTheme` uses the active theme. A logical value, `NA`, or
#'   a named list of graphical parameters can also be supplied
#' @param grid specification controlling the horizontal item and group grid
#'   lines. The default `.useTheme` follows the active theme. A logical
#'   value, `NA`, or a named list of graphical parameters can also be
#'   supplied
#' @param pch specification for the estimate points. The default
#'   `.useTheme` uses the point settings of the active theme. A plotting
#'   symbol or a named list containing parameters such as `pch`,
#'   `col`, `bg`, and `cex` can also be supplied
#' @param cex character expansion factor for the points. `.useTheme`
#'   (default) resolves to `getTheme()$points$cex`.
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/
#'   `NULL`, a string, or a named list for [stamp()].
#' @param ... additional graphical parameters passed to
#'   [graphics::par()]. A `mar` that sets the left side switches off the
#'   automatic widening of the left margin for the labels.
#'
#' @details
#' A numeric vector represents one estimate for each item; a
#' one-dimensional table or array, such as the result of [tapply()] with
#' one grouping factor, is treated the same way.
#'
#' A numeric matrix represents estimates only: rows define the items and
#' columns define the groups. Consequently, a matrix with three columns is
#' interpreted as three groups and not automatically as estimates with lower
#' and upper confidence limits.
#'
#' Use [as.CI()] to declare explicitly that a matrix, data frame,
#' list, or result from [tapply()] contains confidence interval
#' data:
#'
#' \preformatted{
#' plotDot(as.CI(x))
#' }
#'
#' A `"CI"` object contains the columns `est`, `lci`, and
#' `uci`. Additional columns can define the item and group structure.
#' If two additional columns are present, the first defines the items and the
#' second defines the groups.
#'
#' Confidence interval data can alternatively be supplied as a
#' three-dimensional numeric array with dimensions
#' `items × 3 × groups`. The second dimension must contain, in this
#' order, the estimate, lower confidence limit, and upper confidence limit.
#'
#' Values supplied directly as arguments take precedence over the
#' corresponding settings of the active theme. Vectors in `pch` (e.g.
#' `pch = list(col = c("red", "blue"))`) are recycled over the groups, in
#' the order in which the groups are drawn from top to bottom.
#'
#' @return invisibly, a list containing:
#' \describe{
#'   \item{`ypos`}{vertical positions of the items within each group, a
#'     list in the order of the groups}
#'   \item{`group_y`}{vertical positions of the group labels}
#'   \item{`sep_y`}{vertical positions of the group separators}
#' }
#'
#' @examples
#' # estimates for a single series
#' est <- c(A = 12, B = 18, C = 28, D = 40, E = 65)
#'
#' plotDot(
#'   est,
#'   main = "Estimates"
#' )
#'
#' # matrix columns represent groups of estimates
#' groupedEst <- cbind(
#'   Control = c(A = 12, B = 18, C = 28),
#'   Treatment = c(A = 16, B = 24, C = 35)
#' )
#'
#' plotDot(
#'   groupedEst,
#'   main = "Grouped estimates"
#' )
#'
#' # confidence intervals stored in a matrix
#' ci <- cbind(
#'   est = est,
#'   lci = est - c(2, 3, 4, 5, 6),
#'   uci = est + c(2, 3, 4, 5, 6)
#' )
#'
#' plotDot(
#'   as.CI(ci),
#'   main = "Estimates with confidence intervals"
#' )
#'
#' # grouped confidence intervals stored in a data frame
#' groupedCI <- data.frame(
#'   item = rep(c("A", "B", "C"), 2),
#'   group = rep(c("Control", "Treatment"), each = 3),
#'   estimate = c(12, 18, 28, 16, 24, 35),
#'   lower = c(10, 15, 24, 13, 20, 30),
#'   upper = c(14, 21, 32, 19, 28, 40)
#' )
#'
#' plotDot(
#'   as.CI(
#'     groupedCI,
#'     estimate = "estimate",
#'     lower = "lower",
#'     upper = "upper"
#'   ),
#'   main = "Grouped confidence intervals"
#' )
#'
#' # returned positions can be used to add graphical elements
#' pos <- plotDot(est)
#'
#' points(
#'   est + 3,
#'   y = unlist(pos$ypos),
#'   pch = 4
#' )
#'
#' @seealso [as.CI()], [isCI()],
#'   [graphics::dotchart()]
#'
#' @family plot.univariate  
#' @concept dotchart
#' @concept confidence-interval
#'
#' @export
plotDot <- function(
    # DATA
    x,

    # LABELS
    main = NULL,

    # AXES
    xlim = NULL,
    xax  = NULL,
    axes = TRUE,

    # STRUCTURE
    items  = NULL,
    groups = NULL,
    gap    = 1,

    # STYLE
    pch  = .useTheme,
    cex  = .useTheme,
    grid = .useTheme,
    box  = .useTheme,

    # FRAMEWORK
    stamp = .useTheme,

    ...
) {
  UseMethod("plotDot")
}



#' @export
plotDot.default <- function(
    # DATA
    x,

    # LABELS
    main = NULL,

    # AXES
    xlim = NULL,
    xax  = NULL,
    axes = TRUE,

    # STRUCTURE
    items  = NULL,
    groups = NULL,
    gap    = 1,

    # STYLE
    pch  = .useTheme,
    cex  = .useTheme,
    grid = .useTheme,
    box  = .useTheme,

    # FRAMEWORK
    stamp = .useTheme,

    ...
) {
  
  
  gridSpec <- .resolveToggle(grid, getTheme()$grid)
  main     <- .resolveTitle(main)

  if (!is.numeric(gap) || length(gap) != 1L || is.na(gap) || gap < 0)
    stop("'gap' must be a single non-negative number", call. = FALSE)

  if (identical(pch, .useTheme)) {
    pt  <- getTheme()$points
    pch <- list(pch = pt$pch, col = pt$col, bg = pt$bg, cex = pt$cex)
  }

  # cex is the size of the points and ends up in the point specification:
  # an explicit value wins, the theme fills in where a pch list has none
  if (!is.list(pch))
    pch <- list(pch = pch)
  if (!identical(cex, .useTheme))
    pch$cex <- cex
  else if (is.null(pch$cex))
    pch$cex <- getTheme()$points$cex


  x <- .normalizeDotData(x)

  nm     <- .resolveNames(x, items, groups)
  items  <- nm$items
  groups <- nm$groups

  nx <- dim(x)[1]
  ng <- dim(x)[3]

  # a group header only makes sense for several groups
  drawGroupHeader <- ng > 1
  header <- if (drawGroupHeader) 1 else 0

  if (is.null(xlim))
    xlim <- range(x, na.rm = TRUE)

  if (!all(is.finite(xlim)))
    stop("'x' contains no finite values, so 'xlim' cannot be derived",
         call. = FALSE)


  # --------------------------------
  # Y layout
  # --------------------------------
  # The first group is drawn on top, its first item first. The groups are
  # laid out from the bottom up, so the loop runs backwards; x, groups and
  # ypos keep the original group order, and so do per-group vectors in
  # 'pch' and the returned positions.

  ypos    <- vector("list", ng)
  sep_y   <- numeric(ng)
  group_y <- numeric(ng)

  base <- 0

  for (g in rev(seq_len(ng))) {

    ypos[[g]]  <- base + rev(seq_len(nx))
    sep_y[g]   <- base + nx + header
    group_y[g] <- base + nx + header

    base <- base + nx + gap + header
  }

  ymax <- base - gap - header


  .withGraphicsState({

    .applyParFromDots(...,
                      defaults = list(
                        mar = c(top = .marTop(main))
                      ))

    # --------------------------------
    # Left margin for the labels
    # --------------------------------
    # Item labels and the (bold) group headers stand left of the plot;
    # widened only, never narrowed, and not at all when the caller has
    # set the left margin himself.

    if (isTRUE(axes) && !"left" %in% .userMarSides(list(...)))
      .adjustMargin(c(if (drawGroupHeader) groups, items), side = 2, pad = 1)


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
    # NOTE: only the on/off toggle is theme-driven; the line style
    # (orange/grey40, dotted/dashed) is plotDot's own distinctive default,
    # taken from .drawDotGrid()'s own formals unless overridden via a
    # named list passed as 'grid'.

    bedrock::callIf(
      .drawDotGrid,
      gridSpec,
      defaults = list(
        ypos = ypos,
        sep_y = sep_y,
        drawGroupHeader = drawGroupHeader
      )
    )


    # --------------------------------
    # Axes
    # --------------------------------

    if (isTRUE(axes)) {

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

      text(
        x_left,
        group_y,
        groups,
        adj = c(1, 0.5),
        xpd = NA,
        font = 2,
        cex = par("cex.axis")
      )
    }

    # --- box ---
    .drawBox(box, defaults = list(which = "plot"))

    if (nzchar(main))
      title(main = main)


    # --- data ---
    .addDotCI(
      x,
      ypos,
      pch = pch
    )


  }, stamp = stamp)

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

  # pch, col, bg and cex are recycled over the groups, one value per group;
  # any further element (e.g. lwd) goes to points() unchanged. Passing the
  # list itself to points() would recycle a color vector over the items.
  perGroup <- function(v, default) rep_len(v %||% default, ng)

  sym  <- perGroup(pch$pch, 16)
  col  <- perGroup(pch$col, par("fg"))
  bg   <- perGroup(pch$bg,  NA)
  size <- perGroup(pch$cex, 1)

  extra <- pch[setdiff(names(pch), c("pch", "col", "bg", "cex"))]

  for (g in seq_len(ng)) {

    est  <- x[, 1, g]
    low  <- x[, 2, g]
    high <- x[, 3, g]

    y <- as.numeric(ypos[[g]])

    # CI lines, only where both limits exist (arrows() warns on NA and on
    # zero length)
    ok <- !is.na(low) & !is.na(high) & low != high
    if (any(ok))
      graphics::arrows(
        low[ok], y[ok], high[ok], y[ok],
        col    = col[g],
        lwd    = lwd,
        code   = 3,
        angle  = 90,
        length = 0.05
      )

    do.call(graphics::points,
            c(list(x = est, y = y,
                   pch = sym[g], col = col[g], bg = bg[g], cex = size[g]),
              extra))
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

  # a one-dimensional table or array, e.g. tapply(x, g, mean), carries its
  # names in dimnames and is no vector for is.vector()
  if (is.numeric(x) && length(dim(x)) == 1L)
    x <- setNames(as.vector(x), dimnames(x)[[1]])
  
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
  
  stop("'x' must be a numeric vector, matrix, three-dimensional array ",
       "or a \"CI\" object, see ?plotDot", call. = FALSE)
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

