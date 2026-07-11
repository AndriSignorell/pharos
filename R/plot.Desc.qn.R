
#' Plot Method for Numeric-Categorical \code{Desc} Objects
#'
#' Visualises the relationship between a numeric variable and a categorical
#' variable, as computed by \code{\link[DescToolsX]{desc}(y ~ x)} (or \code{x ~ y}) for
#' a numeric/categorical pair. Five panel types are available, selectable
#' (and combinable) via \code{which}.
#'
#' @param x An object of class \code{"Desc.qn"}, as returned by
#'   \code{\link[DescToolsX]{desc}()} for a numeric-categorical pair.
#'
#' @param main Main title. \code{NULL} (default) derives a title per panel
#'   from the variable names and the panel type (e.g.
#'   \code{"area ~ delivery_min (Spineplot)"}). \code{""}, \code{NA}, or
#'   \code{FALSE} suppress the title and compact the top margin. Any other
#'   string is used as-is, identically for every selected panel.
#' @param ylab y-axis label. \code{NULL} (default) derives a label specific
#'   to each panel (e.g. \code{"P(y)"} for the conditional density,
#'   \code{"Density"} for the grouped density plot). Supplying a value
#'   overrides this for every selected panel.
#'
#' @param which integer vector selecting one or more panels to draw, in the
#'   given order. One or more of:
#'   \describe{
#'     \item{\code{1}}{Conditional density plot (\code{\link[graphics]{cdplot}}).}
#'     \item{\code{2}}{Spineplot (\code{\link[graphics]{spineplot}}).
#'       Default.}
#'     \item{\code{3}}{Overlapping kernel density curves, one per group
#'       (via \code{\link{plotDens}}).}
#'     \item{\code{4}}{Boxplot of the numeric variable by group (via
#'       \code{\link{plotBox}}).}
#'     \item{\code{5}}{Prevalence (with Wilson confidence intervals) across
#'       quantile bins of the numeric variable. Only available when the
#'       categorical variable is binary (\code{k == 2}); a message is
#'       issued and the panel skipped otherwise.}
#'   }
#'   Selecting multiple panels does not change the plotting layout (no
#'   implicit \code{mfrow}) - arranging multiple panels on one device is
#'   left to the caller (e.g. \code{par(mfrow = c(2, 1))} beforehand).
#' @param verbose integer; currently computed from
#'   \code{x$meta$verbose}/\code{getOption("DescTools.verbose")} for
#'   consistency with other \code{plot.Desc.*} methods, but not yet
#'   consulted to pick a default \code{which}.
#'
#' @param col color specification. \code{.useTheme} (default) resolves a
#'   panel-appropriate default rather than one shared color, since fill
#'   ramps, categorical sets, and single accents are different things:
#'   \describe{
#'     \item{panels 1/2}{a grey ramp from \code{"grey30"} to \code{"grey90"},
#'       sized to the number of categorical levels (not theme-driven by
#'       design, to keep the unordered category fill neutral - see
#'       \code{\link{plotMosaic}} for the same rationale).}
#'     \item{panels 3/4}{\code{pal(getTheme()$palette)}, the active theme's
#'       qualitative palette, sized to the number of levels.}
#'     \item{panel 5}{\code{getTheme()$twin[1]}, the active theme's primary
#'       accent color.}
#'   }
#'   Supplying \code{col} explicitly overrides the default uniformly for
#'   every selected panel.
#' @param box Controls the plot frame for panels 4 and 5.
#'   \code{.useTheme} (default) follows the active theme
#'   (\code{getTheme()$box}); \code{FALSE}/\code{NA} suppress it; a named
#'   list overrides \code{\link[graphics]{box}()} arguments. Panels 1/2
#'   (\code{cdplot()}/\code{spineplot()}) have no effect from this
#'   argument - they always draw their native frame unconditionally, with
#'   no toggle to override it. Panel 4 (\code{\link{plotBox}}) always
#'   draws its own frame regardless of this argument. Panel 3
#'   (\code{\link{plotDens}}) never draws a frame, regardless of this
#'   argument.
#' @param legend Controls the legend for panel 3 (grouped density curves).
#'   \code{TRUE} (default) draws a legend with the group levels.
#'   \code{FALSE}/\code{NA} suppresses it. A named list overrides arguments
#'   forwarded to \code{\link[graphics]{legend}}. Has no effect on the
#'   other panels.
#'
#' @param stamp Controls the corner stamp. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$stamp}, drawn once after all selected
#'   panels (panels 3/4 delegate to \code{\link{plotDens}}/
#'   \code{\link{plotBox}}, whose own stamp is suppressed internally to
#'   avoid a duplicate). \code{TRUE}/\code{FALSE}/\code{NULL}, a string, or
#'   a named list for \code{\link{stamp}()}.
#'
#' @param ... further graphical parameters, passed to \code{\link{par}} via
#'   the internal framework and to the underlying panel-drawing functions
#'   (\code{cdplot()}, \code{spineplot()}, \code{\link{plotDens}},
#'   \code{\link{plotBox}}, or \code{\link[graphics]{plot}}, depending on
#'   the selected panel).
#'
#' @details
#' The left margin is sized automatically from the longest of: the
#' (possibly panel-specific) y-axis labels, and - for panels 1/2 - the
#' categorical level names drawn as axis tick labels, so neither is ever
#' clipped regardless of \code{which}.
#'
#' @return Invisibly returns \code{x}.
#'
#' @seealso \code{\link[DescToolsX]{desc}}, \code{\link{plotDens}}, \code{\link{plotBox}},
#'   \code{\link[graphics]{cdplot}}, \code{\link[graphics]{spineplot}},
#'   \code{\link{getTheme}}
#'
#' @family plot.s3  
#' @concept distribution-summary
#'
#' @rdname plot.Desc.qn
#' @exportS3Method
#' @rawNamespace export(plot.Desc.qn)
# Both tags above are required, not redundant - see plot.Desc.table for
# the full explanation, or design_rules.md, "Exporting S3 Methods
# Callable From Other Packages 
plot.Desc.qn <- function(x,
                         
                         # LABELS
                         main = NULL,
                         ylab = NULL,
                         
                         # STRUCTURE
                         which   = 2,
                         verbose = NULL,
                         
                         # STYLE
                         col = .useTheme,
                         box = .useTheme,
                         
                         # FEATURES
                         legend = TRUE,
                         
                         # FRAMEWORK
                         stamp = .useTheme,
                         
                         ...) {
  
  verbose <- verbose %||% x$meta$verbose %||%
    getOption("DescTools.verbose", default = 2L)
  
  isBinary <- x$res$k == 2L
  
  xOk  <- x$res$xOk
  yOk  <- x$res$yOk
  lvls <- x$res$lvls
  xLab <- x$meta$xname %||% "x"
  yLab <- x$meta$yname %||% "y"
  
  # --- per-panel y-axis label, known upfront from 'which' alone -------------
  # case 4 (boxplot(xOk ~ yOk)): the y-axis shows xOk, so its label is xLab,
  # not yLab - boxplot's grouping variable (yOk) is on the x-axis instead.
  .ylabFor <- function(w) {
    switch(as.character(w),
           "1" = "",
           "2" = "",
           "3" = "Density",
           "4" = xLab,
           "5" = sprintf("P(\"%s\")", lvls[2L]),
           yLab
    )
  }
  
  # If the user supplied ylab explicitly, it applies to every panel as-is;
  # otherwise each panel derives its own label via .ylabFor().
  resolveYlab <- function(w) ylab %||% .ylabFor(w)
  
  ylabs <- vapply(which, resolveYlab, character(1))
  
  # cases 1/2 (cdplot/spineplot) additionally draw the y-level names
  # (e.g. "Brent"/"Camden"/"Westminster") as axis tick labels - account
  # for those when sizing the left margin, or they get clipped.
  tickLabels <- if (any(which %in% c(1, 2))) as.character(lvls) else character(0)
  lmar <- max(4.1, .marginLines(tickLabels, side = 2, las = 1, pad = 1))
  
  # default title: variable names via the same "substitute magic" convention
  # used elsewhere (e.g. plotXY's "y ~ x"), combined with a panel-type label
  # for context when called interactively.
  .panelDefault <- function(label) sprintf("%s ~ %s (%s)", yLab, xLab, label)
  
  .withGraphicsState({
    
    .applyParFromDots(
      ...,
      defaults = list(mar = c(bottom = 5, left = lmar, top = .marTop(main), right = 3.1))
    )
    
    .main <- function(default) .resolveTitle(main, default = default)
    
    # Colors resolved per panel type, not forced through one shared 'col':
    # a fill ramp (1/2), a categorical set (3/4), and a single accent (5)
    # are different things, not interchangeable. 'col' stays one
    # user-facing argument; resolveCol() picks the right default per panel.
    colSpineDefault <- colorRampPalette(c("grey30", "grey90"))(length(lvls))
    colCatDefault   <- pal(getTheme()$palette, n = length(lvls))
    colPtDefault    <- getTheme()$twin[1]
    
    resolveCol <- function(default) {
      if (identical(col, .useTheme)) default else col
    }
    
    
    for (w in which) {
      
      switch(as.character(w),
             
             # ── 1: Conditional density plot ─────────────────────────────────
             "1" = {
               cdplot(yOk ~ xOk,
                      col  = resolveCol(colSpineDefault),
                      xlab = xLab,
                      ylab = resolveYlab(1),
                      main = .main(.panelDefault("Conditional density")),
                      ...)
               
               axis(side = 1, labels = NA, col.ticks = NA)
               axis(side = 4, labels = NA, col.ticks = NA)
             },
             
             # ── 2: Spineplot ─────────────────────────────────────────────────
             "2" = {
               spineplot(yOk ~ xOk,
                         col  = resolveCol(colSpineDefault),
                         xlab = xLab,
                         ylab = resolveYlab(2),
                         main = .main(.panelDefault("Spineplot")),
                         ...)
               
               axis(side = 1, labels = NA, col.ticks = NA)
               axis(side = 4, labels = NA, col.ticks = NA)
             },
             
             # ── 3: Overlapping density per group ────────────────────────────
             "3" = {
               colHere <- resolveCol(colCatDefault)
               split_x <- split(xOk, yOk)
               
               # plotDens() predates the .useTheme sentinel rollout - it
               # still resolves grid color/style via its own .theme() call
               # (which does follow getTheme()), but doesn't understand the
               # .useTheme sentinel object itself, so a plain TRUE is passed
               # here rather than the sentinel. It also has no legend or box
               # parameter; both are added manually below. A box cannot be
               # retrofitted after the call - plotDens() restores its own
               # par() state on exit, so a .drawBox() here would draw into
               # the wrong (already-restored) graphics state.
               lyra::plotDens(
                 split_x,
                 main = .main(.panelDefault("Density by group")),
                 xlab = xLab,
                 ylab = resolveYlab(3),
                 col  = colHere,
                 grid = TRUE,
                 stamp = NA, 
                 ...
               )
               
               bedrock::callIf(
                 graphics::legend,
                 legend,
                 defaults = .legendDefaults(list(
                   x      = "topright",
                   legend = names(split_x),
                   col    = colHere,
                   lty    = 1L
                 ))
               )
             },
             
             
             # ── 4: Boxplot ───────────────────────────────────────────────────
             "4" = {
               # plotBox() always draws its frame (box() is unconditional,
               # no toggle exists) - boxHere has no effect here.
               lyra::plotBox(
                 x    = xOk,
                 g    = yOk,
                 main = .main(.panelDefault("Boxplot")),
                 xlab = yLab,
                 ylab = resolveYlab(4),
                 col  = resolveCol(colCatDefault),
                 grid = TRUE,
                 stamp = NA, 
                 ...
               )
             },
             
             
             # ── 5: Prevalence + Wilson-CI along x (binary only) ─────────────
             "5" = {
               if (!isBinary) {
                 message("which=5 (prevalence plot) is only available for binary y")
                 next
               }
               
               colHere <- resolveCol(colPtDefault)
               
               pt <- x$res$prevTable
               
               xCut <- cut(xOk,
                           breaks         = c(-Inf, x$res$breaks, Inf),
                           include.lowest = TRUE)
               xPos <- as.numeric(tapply(xOk, xCut, median))
               
               prevTotal <- sum(yOk == lvls[2L]) / length(yOk)
               
               plot(xPos, pt$prev,
                    ylim = c(0, 1),
                    pch  = 19,
                    col  = colHere,
                    xlab = xLab,
                    ylab = resolveYlab(5),
                    main = .main(.panelDefault("Prevalence by x-quantile")),
                    ...)
               
               .drawGrid(.useTheme)
               
               arrows(xPos, pt$lci, xPos, pt$uci,
                      angle  = 90,
                      code   = 3,
                      length = 0.05,
                      col    = colHere)
               
               abline(h   = prevTotal,
                      lty = 2,
                      col = "gray50")
               
               text(x      = min(xPos),
                    y      = prevTotal,
                    labels = sprintf("overall: %s",
                                     fm(prevTotal, fmt = "per.sty")),
                    adj    = c(0, -0.5),
                    col    = "gray50",
                    cex    = 0.8)
               
               .drawBox(box)
             },
             
             message(sprintf("which=%d not defined for Desc.qn", w))
      )
    }
    
  }, stamp = stamp)
  
  invisible(x)
}

