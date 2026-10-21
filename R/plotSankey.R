
#' Sankey Diagram (Flow Diagram)
#'
#' Draws a Sankey diagram: nodes arranged in stages (columns) and flows
#' between them as ribbons whose width is proportional to their value, as
#' used for money flows, patient pathways or energy balances. The input is
#' a plain list of flows; stages, node order and colors are derived from
#' it.
#'
#' @param x a data frame with one row per flow and three columns: the
#'   origin node, the destination node and the value of the flow (finite,
#'   non-negative). The column names do not matter, only their order. A
#'   node may appear as destination in one stage and as origin in the
#'   next. Node names identify nodes globally: a state that recurs at
#'   different stages (e.g. "Healthy" before and after treatment) needs
#'   distinct names, which `labels` can then display alike.
#' @param stages optional character vector of column headings, one per
#'   stage, e.g. `c("Sources", "Regimes", "Providers")`.
#' @param order optional character vector of node names giving their
#'   order from top to bottom within each stage. Nodes not listed follow
#'   in the order of their first appearance in `x`, which is the default.
#' @param main main title. `NULL` (default) draws none, unless the theme
#'   sets `autoTitle = TRUE` (see [theme]); the title is then the name of
#'   `x`. `""`, `NA` or `FALSE` always suppress it and compact the top
#'   margin; any other string is used as given.
#' @param col node colors. `.useTheme` (default) gives each stage a hue
#'   from the theme palette and its nodes shades of it. A named vector
#'   (`c(Bund = "darkgreen", ...)`) sets the colors of the named nodes,
#'   an unnamed one is recycled over all nodes in stage order.
#' @param flowCol color of the ribbons: `"source"` (default) takes the
#'   color of the origin node, `"target"` that of the destination node;
#'   any other value is used as a color for all ribbons.
#' @param opacity opacity of the ribbons, between 0 and 1.
#' @param nodeWidth width of the nodes as a fraction of the distance
#'   between two stages, between 0 and 1.
#' @param gap minimal vertical space between the nodes of a stage, as a
#'   fraction of the plot height (non-negative). It applies to the stage
#'   that needs the most room; the other stages spread their nodes over
#'   the same height, so all stages with more than one node are flush at
#'   the top and bottom. A stage with a single node is centred.
#' @param border color of a line along the left and right edge of the
#'   nodes, where the ribbons meet them, e.g. `"white"` for a fine
#'   separation; `NA` (default) draws none. The line width follows `lwd`
#'   in `...`. Top and bottom stay open, so the nodes keep exactly the
#'   height of their ribbons.
#' @param labels controls the node labels. `TRUE` (default) draws the
#'   node names, left of the first stage, right of all others. `FALSE`,
#'   `NULL` or `NA` suppress them. A named character vector replaces the
#'   text of the named nodes, e.g.
#'   `c(Healthy.1 = "Healthy", Healthy.2 = "Healthy")`. A named list
#'   overrides arguments of [graphics::text()], e.g.
#'   `list(cex = 0.7, col = "grey30")`.
#' @param values append the node value to the labels: `FALSE` (default)
#'   or `TRUE`, which formats with [fm()]; a list of arguments for [fm()],
#'   e.g. `list(digits = 1, bigMark = "'")`; or a function that turns the
#'   values into strings.
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, a string, or
#'   a named list for [stamp()].
#' @param ... further graphical parameters passed to [par()] via the
#'   internal framework.
#'
#' @details
#' The stage of a node is the length of the longest directed path that
#' leads to it from a node without incoming flows, so the stages follow
#' from the flows alone. Flows that lead back to an earlier node (cycles)
#' are not supported. Zero flows are dropped, and with them nodes that
#' have no other flows.
#'
#' A flow may skip stages. It is then led through an invisible
#' pass-through node in each stage in between, placed below the real
#' nodes, so that it does not run through a node it has nothing to do
#' with.
#'
#' The height of a node is the larger of its total inflow and total
#' outflow; unequal totals are allowed. Within a node, the ribbons are
#' stacked in the order of the nodes they lead to or come from, which
#' avoids crossings at the node itself. The order of the nodes within a
#' stage is not optimised; `order` sets it by hand.
#'
#' The left and right margins are widened for the labels of the first
#' and last stage, unless `mar` in `...` sets those sides.
#'
#' @return Invisibly, a list with the data frames `nodes` (name, stage,
#'   inflow, outflow, value = the larger of both, color and the
#'   coordinates of each node) and `flows` (the positive flows with their
#'   vertical positions at both ends), e.g. for checking balances or
#'   adding annotations.
#'
#' @examples
#' # Financing of the Swiss health care system (simplified, CHF bn):
#' # one row per flow - origin, destination, value
#' flows <- data.frame(
#'   from = c("Confederation", "Confederation", "Cantons", "Cantons",
#'            "Municipalities", "Companies", "Companies",
#'            "Households", "Households", "Households",
#'            "State", "State", "Health insurance", "Health insurance",
#'            "Social insurance", "Social insurance",
#'            "Private insurance", "Private insurance",
#'            "Out-of-pocket", "Out-of-pocket"),
#'   to   = c("State", "Health insurance", "State", "Health insurance",
#'            "State", "Health insurance", "Social insurance",
#'            "Health insurance", "Private insurance", "Out-of-pocket",
#'            "Hospitals", "Nursing homes", "Hospitals", "Physicians",
#'            "Hospitals", "Nursing homes", "Hospitals", "Physicians",
#'            "Physicians", "Dentists"),
#'   value = c(5, 2, 9, 2, 4, 7, 2, 18, 8, 12,
#'             12, 6, 14, 15, 2, 3, 4, 4, 7, 5)
#' )
#'
#' plotSankey(flows, stages = c("Sources", "Financing", "Providers"))
#'
#' # own colors for some nodes, ribbons colored by destination, values
#' plotSankey(flows, col = c(Households = "darkgreen", State = "orange"),
#'            flowCol = "target", values = TRUE, border = "white", lwd = 2)
#'
#' # a flow that skips a stage is led around the nodes in between
#' plotSankey(data.frame(from = c("A", "B", "A"), to = c("B", "C", "C"),
#'                       value = c(5, 5, 3)))
#'
#' # the same state at two stages: distinct names, same label
#' path <- data.frame(from = c("Healthy.1", "Healthy.1", "Ill", "Ill"),
#'                    to   = c("Healthy.2", "Ill", "Healthy.2", "Dead"),
#'                    value = c(70, 30, 20, 10))
#' plotSankey(path, labels = c(Healthy.1 = "Healthy", Healthy.2 = "Healthy"))
#'
#' @family plot.special
#' @concept flow-diagram
#' @concept composition
#'
#' @export
plotSankey <- function(
    # DATA
    x,

    # LABELS
    stages = NULL,
    main   = NULL,

    # STRUCTURE
    order     = NULL,
    nodeWidth = 0.08,
    gap       = 0.03,

    # STYLE
    col     = .useTheme,
    border  = NA,
    flowCol = "source",
    opacity = 0.4,

    # FEATURES
    labels = TRUE,
    values = FALSE,

    # FRAMEWORK
    stamp = .useTheme,

    ...
) {

  mc   <- match.call()
  main <- .resolveTitle(main, default = deparse1(mc$x))

  # --- arguments -----------------------------------------------------------

  .isNum1 <- function(v) is.numeric(v) && length(v) == 1L && is.finite(v)

  if (!.isNum1(nodeWidth) || nodeWidth <= 0 || nodeWidth >= 1)
    stop("'nodeWidth' must be a single number between 0 and 1", call. = FALSE)
  if (!.isNum1(gap) || gap < 0)
    stop("'gap' must be a single non-negative number", call. = FALSE)
  if (!.isNum1(opacity) || opacity < 0 || opacity > 1)
    stop("'opacity' must be a single number between 0 and 1", call. = FALSE)

  # --- flows ---------------------------------------------------------------

  if (!is.data.frame(x) || ncol(x) < 3L)
    stop("'x' must be a data frame with the columns origin, destination ",
         "and value", call. = FALSE)

  fl <- data.frame(from  = as.character(x[[1L]]),
                   to    = as.character(x[[2L]]),
                   value = x[[3L]],
                   stringsAsFactors = FALSE)

  if (!is.numeric(fl$value) || any(!is.finite(fl$value)) || any(fl$value < 0))
    stop("the values (third column of 'x') must be finite, non-negative ",
         "numbers", call. = FALSE)
  if (anyNA(fl$from) || anyNA(fl$to) ||
      any(!nzchar(fl$from)) || any(!nzchar(fl$to)))
    stop("origin and destination must be non-empty node names",
         call. = FALSE)

  # zero flows draw nothing; nodes that only have zero flows disappear
  fl <- fl[fl$value > 0, , drop = FALSE]
  if (nrow(fl) == 0L)
    stop("'x' contains no positive flow", call. = FALSE)

  # --- nodes: stage, order, size --------------------------------------------

  nodes <- data.frame(name = unique(c(rbind(fl$from, fl$to))),
                      stringsAsFactors = FALSE)
  nodes$stage <- .sankeyStages(nodes$name, fl)

  if (!is.null(order)) {
    bad <- setdiff(order, nodes$name)
    if (length(bad))
      stop(gettextf("unknown node(s) in 'order': %s",
                    toString(dQuote(bad, FALSE))), call. = FALSE)
  }
  rank  <- match(nodes$name, c(order, setdiff(nodes$name, order)))
  nodes <- nodes[order(nodes$stage, rank), , drop = FALSE]

  nodes$inflow  <- as.vector(tapply(fl$value, factor(fl$to,   nodes$name),
                                    sum, default = 0))
  nodes$outflow <- as.vector(tapply(fl$value, factor(fl$from, nodes$name),
                                    sum, default = 0))
  nodes$value   <- pmax(nodes$inflow, nodes$outflow)
  nodes$real    <- TRUE

  nStage <- max(nodes$stage)

  if (!is.null(stages) && length(stages) != nStage)
    stop(gettextf("'stages' must hold %d headings, one per stage", nStage),
         call. = FALSE)

  nodes$col <- .sankeyNodeCol(nodes, col)

  # --- flows across several stages ------------------------------------------
  # A flow that skips a stage would run straight through the nodes of the
  # stages in between and look like a connection with them. It is split
  # instead into one segment per stage, led through an invisible
  # pass-through node that takes its place in each stage in between, below
  # the real nodes.

  stageOf <- setNames(nodes$stage, nodes$name)
  fl$id   <- seq_len(nrow(fl))
  seg     <- vector("list", nrow(fl))
  pass    <- list()

  for (k in seq_len(nrow(fl))) {
    s0 <- stageOf[[fl$from[k]]]
    s1 <- stageOf[[fl$to[k]]]
    via <- if (s1 - s0 > 1L) sprintf("\001%d.%d", k, (s0 + 1L):(s1 - 1L))
    if (length(via))
      pass[[k]] <- data.frame(name = via, stage = (s0 + 1L):(s1 - 1L),
                              value = fl$value[k], stringsAsFactors = FALSE)
    path <- c(fl$from[k], via, fl$to[k])
    seg[[k]] <- data.frame(from = head(path, -1L), to = path[-1L],
                           value = fl$value[k], id = k,
                           stringsAsFactors = FALSE)
  }
  seg <- do.call(rbind, seg)

  if (length(pass)) {
    pass <- do.call(rbind, pass)
    pass$inflow <- pass$outflow <- pass$value
    pass$real   <- FALSE
    pass$col    <- NA_character_
    nodes <- rbind(nodes, pass[, names(nodes)])
    nodes <- nodes[order(nodes$stage, !nodes$real), , drop = FALSE]
  }
  rownames(nodes) <- NULL

  # --- vertical layout ------------------------------------------------------
  # One common scale for all stages, so that the same value has the same
  # height everywhere. It is set by the stage that needs the most room;
  # every other stage spans the same height, the space left over going
  # into its gaps, so all stages share the same top and bottom edge. A
  # stage with a single node is centred instead.

  nPerStage <- tabulate(nodes$stage)
  if (gap * (max(nPerStage) - 1L) >= 1)
    stop("'gap' leaves no room for the nodes; choose a smaller one",
         call. = FALSE)

  perStage <- split(nodes$value, nodes$stage)
  scale <- min(vapply(perStage, function(v)
    (1 - gap * (length(v) - 1)) / sum(v), numeric(1)))

  nodes$y1 <- nodes$y0 <- NA_real_
  for (s in seq_len(nStage)) {
    i <- which(nodes$stage == s)
    h <- nodes$value[i] * scale
    if (length(i) == 1L) {
      nodes$y1[i] <- (1 + h) / 2
    } else {
      g <- (1 - sum(h)) / (length(i) - 1)
      nodes$y1[i] <- 1 - c(0, cumsum(h + g)[-length(i)])
    }
    nodes$y0[i] <- nodes$y1[i] - h
  }

  # horizontal layout: stage s spans [s - 1, s - 1 + w]
  w <- nodeWidth
  nodes$x0 <- nodes$stage - 1
  nodes$x1 <- nodes$x0 + w

  # --- ribbon ends ------------------------------------------------------------
  # Outgoing ribbons are stacked from the top of a node in the order of
  # their destinations, incoming ones in the order of their origins.

  pos <- setNames(seq_len(nrow(nodes)), nodes$name)
  seg$iFrom <- pos[seg$from]
  seg$iTo   <- pos[seg$to]
  seg$h     <- seg$value * scale

  seg$yFrom1 <- seg$yTo1 <- NA_real_

  for (i in seq_len(nrow(nodes))) {
    out <- which(seg$iFrom == i)
    out <- out[order(seg$iTo[out])]
    seg$yFrom1[out] <- nodes$y1[i] - c(0, cumsum(seg$h[out])[-length(out)])

    inc <- which(seg$iTo == i)
    inc <- inc[order(seg$iFrom[inc])]
    seg$yTo1[inc] <- nodes$y1[i] - c(0, cumsum(seg$h[inc])[-length(inc)])
  }
  seg$yFrom0 <- seg$yFrom1 - seg$h
  seg$yTo0   <- seg$yTo1   - seg$h

  # a segment leaving a pass-through node starts at its left edge, so the
  # ribbon runs on across the node's width without a break
  seg$x0 <- ifelse(nodes$real[seg$iFrom], nodes$x1[seg$iFrom],
                   nodes$x0[seg$iFrom])
  seg$x1 <- nodes$x0[seg$iTo]

  # ribbon colors refer to the real origin and destination of the flow
  ribbonCol <- switch(
    if (is.character(flowCol) && length(flowCol) == 1L &&
        flowCol %in% c("source", "target")) flowCol else "fixed",
    source = nodes$col[pos[fl$from]],
    target = nodes$col[pos[fl$to]],
    fixed  = rep_len(flowCol, nrow(fl)))
  ribbonCol <- grDevices::adjustcolor(ribbonCol, alpha.f = opacity)

  # --- labels ---------------------------------------------------------------

  real <- nodes[nodes$real, , drop = FALSE]

  # a named character vector gives the displayed text per node
  labText <- real$name
  if (is.character(labels)) {
    if (is.null(names(labels)))
      stop("a character 'labels' must be named by the nodes it relabels, ",
           "e.g. c(Healthy.1 = \"Healthy\")", call. = FALSE)
    bad <- setdiff(names(labels), real$name)
    if (length(bad))
      stop(gettextf("unknown node(s) in 'labels': %s",
                    toString(dQuote(bad, FALSE))), call. = FALSE)
    hit <- match(names(labels), real$name)
    labText[hit] <- labels
    labels <- TRUE
  }

  if (!isFALSE(values)) {
    v <- if (isTRUE(values)) fm(real$value)
    else if (is.function(values)) values(real$value)
    else if (is.list(values)) do.call(fm, c(list(real$value), values))
    else stop("'values' must be TRUE, FALSE, a list of arguments for fm() ",
              "or a function", call. = FALSE)
    labText <- sprintf("%s (%s)", labText, trimws(v))
  }

  drawLabels <- !(isFALSE(labels) || is.null(labels) ||
                    (length(labels) == 1L && !is.list(labels) && is.na(labels)))
  labCex <- if (is.list(labels) && !is.null(labels$cex)) labels$cex else 0.8

  .withGraphicsState({

    .applyParFromDots(...,
                      defaults = list(
                        mar = c(bottom = 1, left = 1, right = 1,
                                top = .marTop(main) + if (is.null(stages)) 0 else 1)
                      ))

    # room for the labels of the outer stages
    if (drawLabels) {
      userMar <- .userMarSides(list(...))
      lineIn  <- par("csi") * par("mex")
      widthLines <- function(s)
        max(strwidth(labText[real$stage == s], units = "inches",
                     cex = labCex)) / lineIn + 0.8
      mar <- par("mar")
      if (!"left" %in% userMar)
        mar[2L] <- max(mar[2L], widthLines(1))
      if (!"right" %in% userMar)
        mar[4L] <- max(mar[4L], widthLines(nStage))
      par(mar = mar)
      .checkMargins()
    }

    plot.new()
    plot.window(xlim = c(0, nStage - 1 + w), ylim = c(0, 1),
                xaxs = "i", yaxs = "i")

    # ribbons first, nodes on top
    for (k in seq_len(nrow(seg)))
      .sankeyRibbon(seg$x0[k], seg$yFrom0[k], seg$yFrom1[k],
                    seg$x1[k], seg$yTo0[k],   seg$yTo1[k],
                    col = ribbonCol[seg$id[k]])

    rect(real$x0, real$y0, real$x1, real$y1,
         col = real$col, border = NA)

    # separating lines on the vertical edges only: a full outline would
    # also cover the top and bottom and so shorten the nodes against their
    # ribbons. lend = "butt" keeps the lines within the node height.
    if (!all(is.na(border)))
      segments(c(real$x0, real$x1), c(real$y0, real$y0),
               c(real$x0, real$x1), c(real$y1, real$y1),
               col = border, lend = "butt")

    # labels: left of the first stage, right of all others
    if (drawLabels) {
      first <- real$stage == 1L
      bedrock::callIf(
        text, labels,
        defaults = list(
          x      = ifelse(first, real$x0 - 0.02, real$x1 + 0.02),
          y      = (real$y0 + real$y1) / 2,
          labels = labText,
          adj    = NULL,
          pos    = ifelse(first, 2, 4),
          offset = 0.2,
          cex    = labCex,
          col    = "grey20",
          xpd    = NA),
        forbidden = c("x", "y"))
    }

    # stage headings above the nodes
    if (!is.null(stages)) {
      mid <- seq_len(nStage) - 1 + w / 2
      mtext(stages, side = 3, line = 0.4, at = mid, font = 2, cex = 0.85)
    }

    if (nzchar(main))
      title(main = main, line = if (is.null(stages)) 1 else 2.2)

  }, stamp = stamp)

  # flows with the positions at their real origin and destination
  first <- !duplicated(seg$id)
  last  <- !duplicated(seg$id, fromLast = TRUE)
  fl$yFrom0 <- seg$yFrom0[first][order(seg$id[first])]
  fl$yFrom1 <- seg$yFrom1[first][order(seg$id[first])]
  fl$yTo0   <- seg$yTo0[last][order(seg$id[last])]
  fl$yTo1   <- seg$yTo1[last][order(seg$id[last])]

  rownames(real) <- real$name
  invisible(list(
    nodes = real[, c("name", "stage", "inflow", "outflow", "value", "col",
                     "x0", "x1", "y0", "y1")],
    flows = fl[, c("from", "to", "value", "yFrom0", "yFrom1", "yTo0", "yTo1")]
  ))
}


# == internal helper functions ==============================================

# Stage of every node: 1 for nodes without incoming flows, otherwise one
# more than the highest stage among its origins, i.e. the length of the
# longest directed path from a source node (not the shortest). A cycle
# has no such order and is an error.
.sankeyStages <- function(nodes, fl) {

  stage <- setNames(rep(NA_integer_, length(nodes)), nodes)
  stage[!nodes %in% fl$to] <- 1L

  for (iter in seq_along(nodes)) {
    todo <- names(stage)[is.na(stage)]
    if (!length(todo))
      break
    for (n in todo) {
      orig <- stage[fl$from[fl$to == n]]
      if (!anyNA(orig))
        stage[n] <- max(orig) + 1L
    }
  }

  if (anyNA(stage))
    stop("the flows contain a cycle; this implementation supports only ",
         "flows that lead onwards, not back to an earlier node", call. = FALSE)

  unname(stage)
}


# Node colors. The theme default gives every stage a hue of the theme
# palette and spreads its nodes over shades of it (dark to light); named
# colors in 'col' replace single nodes, unnamed ones are recycled.
.sankeyNodeCol <- function(nodes, col) {

  if (!identical(col, .useTheme) && is.null(names(col)))
    return(rep_len(col, nrow(nodes)))

  res <- character(nrow(nodes))
  hue <- pal(getTheme()$palette)
  for (s in unique(nodes$stage)) {
    i    <- which(nodes$stage == s)
    base <- hue[(s - 1L) %% length(hue) + 1L]
    res[i] <- if (length(i) == 1L) base else
      grDevices::colorRampPalette(c(darken(base, 0.35),
                                    lighten(base, 0.35)))(length(i))
  }

  if (!identical(col, .useTheme)) {
    bad <- setdiff(names(col), nodes$name)
    if (length(bad))
      stop(gettextf("unknown node(s) in 'col': %s",
                    toString(dQuote(bad, FALSE))), call. = FALSE)
    res[match(names(col), nodes$name)] <- col
  }

  res
}


# One ribbon from (x0, [a0, a1]) to (x1, [b0, b1]): the edges follow a
# smooth S-curve (cubic smoothstep), so ribbons leave and enter the nodes
# horizontally.
.sankeyRibbon <- function(x0, a0, a1, x1, b0, b1, col, n = 50) {

  t <- seq(0, 1, length.out = n)
  s <- 3 * t^2 - 2 * t^3
  xx <- x0 + (x1 - x0) * t

  polygon(c(xx, rev(xx)),
          c(a1 + (b1 - a1) * s, rev(a0 + (b0 - a0) * s)),
          col = col, border = NA)
}
