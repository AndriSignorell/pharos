

#' Plot Method for Categorical-Categorical `Desc` Objects
#'
#' Visualises a (two-dimensional) cross-tabulation, as computed by
#' `DescToolsX::desc()` for a categorical/categorical pair.
#' Four panel types are available, selectable (and combinable) via
#' `which`. Higher-dimensional tables (more than two margins) are not
#' supported; a message is issued and the call returns invisibly.
#'
#' @param x an object of class `"Desc.table"`, as returned by
#'   `DescToolsX::desc()` for a categorical-categorical pair.
#'
#' @param main main title. `NULL` (default) derives a title per panel
#'   from `x$meta$xname` (the deparsed expression originally passed to
#'   `desc()`, e.g. `"table(Pizza$area, Pizza$driver)"`) combined
#'   with a panel-type label for context when multiple panels are shown
#'   (e.g. `"table(Pizza$area, Pizza$driver) (Spineplot)"`). There is
#'   no `y ~ x` pair to draw on here - `x$meta` carries only a
#'   single `xname`, since a table built outside a two-sided formula
#'   has no separately named "x" and "y" variable. `""`, `NA`,
#'   or `FALSE` suppress the title and compact the top margin. Any
#'   other string is used as-is, identically for every selected panel.
#' @param ylab y-axis label. `NULL` (default) leaves the panel's own
#'   default in place (typically empty/unlabeled, since the row dimension
#'   of a table built via e.g. `table(a, b)` usually has no name
#'   carried in `x$meta`). Supplying a value overrides this for every
#'   selected panel.
#'
#' @param which integer vector selecting one or more panels to draw, in the
#'   given order. One or more of:
#'   \describe{
#'     \item{`1`}{Spineplot ([graphics::spineplot()]).
#'       Default.}
#'     \item{`2`}{Mosaic plot (via [plotMosaic()]).}
#'     \item{`3`}{Mosaic plot (swapped axis).}
#'     \item{`4`}{Association plot (Cohen-Friendly plot) via
#'       [plotAssoc()].}
#'     \item{`5`}{Heatmap of cell proportions (via
#'       [plotHeatmap()], `scale = "prop"`).}
#'   }
#'   Selecting multiple panels does not change the plotting layout (no
#'   implicit `mfrow`) - as with other `plot.Desc.*` methods,
#'   arranging multiple panels on one device is left to the caller (e.g.
#'   `par(mfrow = c(2, 1))` beforehand).
#' @param verbose integer; currently computed from
#'   `x$meta$verbose`/`getOption("DescTools.verbose")` for
#'   consistency with other `plot.Desc.*` methods, but not yet
#'   consulted to pick a default `which`.
#'
#' @param col color specification. `.useTheme` (default) resolves a
#'   panel-appropriate default rather than one shared color, since fill
#'   ramps, diverging palettes, and sequential heat scales are different
#'   things:
#'   \describe{
#'     \item{panel 1}{a grey ramp from `"grey30"` to `"grey90"`,
#'       sized to the number of rows of `tab` - the panel draws
#'       `spineplot(t(tab))`, so the stacked (filled) dimension is the
#'       row dimension of `tab`, not its columns (not theme-driven by
#'       design, to keep the unordered category fill neutral).}
#'     \item{panel 2}{a grey ramp from `"grey30"` to `"grey90"`,
#'       sized to the number of columns of `tab` (the fill dimension
#'       of the untransposed mosaic), passed to [plotMosaic()].}
#'     \item{panel 3}{a grey ramp from `"grey30"` to `"grey90"`,
#'       sized to the number of rows of `tab` - with
#'       `swap = TRUE` the fill dimension is the row dimension,
#'       passed to [plotMosaic()].}
#'     \item{panel 4}{left at [plotAssoc()]'s own default
#'       (`pal("red-white-blue-3", n = 100)`), a diverging palette - cell
#'       colors there encode the sign and strength of Pearson residuals, so
#'       a categorical or grey-ramp default would not be meaningful. Supplying
#'       `col` overrides this with the diverging palette of the user's
#'       choice.}
#'     \item{panel 5}{left at [plotHeatmap()]'s own default
#'       (`pal("Blues", n = 100)`), a sequential ramp - cell colors
#'       there encode magnitude only. Supplying `col` overrides this.}
#'   }
#'   Supplying `col` explicitly overrides the default uniformly for
#'   every selected panel.
#' @param box controls the plot frame. `.useTheme` (default) follows
#'   the active theme (`getTheme()$box`); `FALSE`/`NA`
#'   suppress it; a named list overrides frame-drawing arguments.
#'   \describe{
#'     \item{panel 1}{has no effect - `spineplot()` always draws its
#'       native frame unconditionally, with no toggle to override it.}
#'     \item{panels 2/3}{[plotMosaic()] always draws its own
#'       frame; this argument has no effect.}
#'     \item{panel 4}{[plotAssoc()] has no frame/box concept of
#'       its own (it draws dashed reference lines instead); this argument
#'       has no effect.}
#'     \item{panel 5}{forwarded as-is to [plotHeatmap()]'s own
#'       `box` argument, which draws the outer frame via
#'       `rect()` at the exact tile boundaries rather than
#'       [graphics::box()].}
#'   }
#'
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`, drawn once after all selected
#'   panels. Panels 2-5 delegate to [plotMosaic()]/
#'   [plotAssoc()]/[plotHeatmap()], whose own
#'   `stamp` argument is set to `NA` internally to avoid a
#'   duplicate. `TRUE`/`FALSE`/`NULL`, a string, or a
#'   named list for [stamp()].
#'
#' @param ... further graphical parameters, passed to [par()] via
#'   the internal framework and to the underlying panel-drawing functions
#'   (`spineplot()`, [plotMosaic()], [plotAssoc()],
#'   or [plotHeatmap()], depending on the selected panel).
#'
#' @details
#' The left margin is sized automatically from the longest of: the y-axis
#' label, and - for panels 1/2 - the row names of `tab` drawn as
#' axis tick labels, so neither is ever clipped regardless of `which`.
#'
#' Only two-dimensional tables are supported. If `x` carries a table
#' with more than two margins, a message is issued and the function returns
#' invisibly without drawing anything.
#'
#' @return Invisibly returns `x`.
#'
#' @seealso `DescToolsX::desc`, [plotAssoc()],
#'   [plotHeatmap()], [plotMosaic()],
#'   [graphics::spineplot()]
#'
#' @family plot.s3  
#' @concept frequency-table
#'
#' @rdname plot.Desc.table
#' @exportS3Method
#' @rawNamespace export(plot.Desc.table)
# Both tags above are required, not redundant: @exportS3Method alone
# registers S3 dispatch (plot(obj)) but does NOT export the bare symbol,
# so unqualified calls like plot.Desc.table(x, ...) from other packages
# (e.g. DescToolsX's plot.Desc.qq) fail with "could not find function" -
# even with @importFrom pharos plot.Desc.table on the calling side.
# @rawNamespace forces the missing export() NAMESPACE line. See
# design_rules.md, "Exporting S3 Methods Callable From Other Packages".

plot.Desc.table <- function(x,
                            
                            # LABELS
                            main = NULL,
                            ylab = NULL,
                            
                            # STRUCTURE
                            which   = 1,
                            verbose = NULL,
                            
                            # STYLE
                            col = .useTheme,
                            box = .useTheme,
                            
                            # FRAMEWORK
                            stamp = .useTheme,
                            
                            ...) {
  
  verbose <- verbose %||% x$meta$verbose %||%
    getOption("DescTools.verbose", default = 2L)
  
  tab <- x$tab
  
  if (length(dim(tab)) > 2L) {
    message("Sorry, plot not implemented for higher dimensional tables.")
    return(invisible(x))
  }
  
  ncolTab <- ncol(tab)
  
  # x$meta carries a single 'xname' (the deparsed expression originally
  # passed to desc(), e.g. "table(Pizza$area, Pizza$driver)") - there is
  # no y ~ x formula pair at this level, so no yname exists to invent a
  # "y ~ x" title from. The default title is simply xname itself, with a
  # panel-type suffix appended for context when multiple panels are shown.
  xName <- x$meta$xname %||% deparse(substitute(x))
  
  .panelDefault <- function(label) sprintf("%s (%s)", xName, label)
  
  # Panels 1/2 (spineplot()/plotMosaic()) draw the row names of tab as
  # axis tick labels - account for those when sizing the left margin (the
  # same reasoning as plot.Desc.qn's tickLabels), or they get clipped.
  # Unlike the previous, incorrect fixed 4.1: that value happened to work
  # for short row names and silently broke for longer ones (e.g. 3+ rows
  # with long category names), giving the false impression that
  # spineplot() ignores par(mar) - it doesn't; the margin request just
  # wasn't sized from the actual labels being drawn.
  lmar <- max(4.1, .marginLines(c(ylab %||% "", rownames(tab)), 
                                side = 2, las = 1, pad = 1))
  
  .withGraphicsState({
    
    .applyParFromDots(
      ...,
      defaults = list(
        mar = c(bottom = 5, left = lmar, top = .marTop(main), right = 3.1)
      )
    )
    
    .main <- function(default) .resolveTitle(main, default = default)
    
    # Colors resolved per panel type, not forced through one shared 'col':
    # panels 1-3 use a grey ramp (unordered category fill kept neutral,
    # not theme-driven by design); panels 4/5 keep their own diverging /
    # sequential defaults from plotAssoc()/plotHeatmap() unless 'col' is
    # supplied explicitly. 'col' stays one user-facing argument;
    # resolveCol() picks the right default per panel.
    #
    # The ramp length must match the *stacked/filled* dimension, which
    # differs by panel: panel 1 draws spineplot(t(tab)) and panel 3 passes
    # swap = TRUE to plotMosaic() - both fill by the ROWS of tab. Panel 2
    # passes tab untransposed, filling by the columns. Sizing everything
    # from ncolTab (as previously) made the ramp run over the x-axis
    # levels instead of the stack segments in panels 1/3.
    colRowDefault <- colorRampPalette(c("grey30", "grey90"))(nrow(tab))
    colColDefault <- colorRampPalette(c("grey30", "grey90"))(ncolTab)
    
    resolveCol <- function(default) {
      if (identical(col, .useTheme)) default else col
    }
    
    for (w in which) {
      
      switch(as.character(w),
             
             # ── 1: Spineplot ─────────────────────────────────────────────────
             "1" = {
               # ylab left at "" (no override) since there is no separate
               # row-dimension name to derive one from. The frame is left
               # as spineplot() draws it natively (no box() override here
               # by design - see @param box).
               spineplot(t(tab),
                         col  = resolveCol(colRowDefault),
                         xlab = "",
                         ylab = ylab %||% "",
                         main = .main(.panelDefault("Spineplot")),
                         ...)
               
               axis(side = 1, labels = NA, col.ticks = NA)
               axis(side = 4, labels = NA, col.ticks = NA)
             },
             
             # ── 2: Mosaic plot ───────────────────────────────────────────────
             "2" = {
               plotMosaic(tab,
                          col  = resolveCol(colColDefault),
                          xlab = xName,
                          ylab = ylab %||% "",
                          main = .main(.panelDefault("Mosaic plot")),
                          horiz = TRUE,
                          stamp = NA,
                          ...)
             },
             
             # ── 3: Mosaic plot ───────────────────────────────────────────────
             "3" = {
               plotMosaic(tab,
                          col  = resolveCol(colRowDefault),
                          xlab = xName,
                          ylab = ylab %||% "",
                          main = .main(.panelDefault("Mosaic plot")),
                          horiz = FALSE, 
                          swap = TRUE,
                          stamp = NA,
                          ...)
             },
             
             # ── 4: Association plot ──────────────────────────────────────────
             "4" = {
               # plotAssoc() has its own diverging-palette default
               # (pal("red-white-blue-3", n=100)) appropriate for signed
               # residuals - a grey/categorical default would not be
               # meaningful here, so it's only overridden when the caller
               # supplies col explicitly. Its xlab/ylab are TRUE/FALSE/
               # character toggles for the dimnames labels, not plain axis
               # strings - left at their own TRUE default (show dimnames)
               # unless the caller overrides.
               # reorder = FALSE: in the Desc context every panel shows the
               # same category order (rows top-down, columns as in tab);
               # plotAssoc()'s strength-based reordering stays a standalone
               # feature.
               plotAssoc(tab,
                         col  = if (identical(col, .useTheme)) pal("red-white-blue-3", n = 100L) else col,
                         main = .main(.panelDefault("Association plot")),
                         reorder = FALSE,
                         stamp = NA,
                         ...)
             },
             
             # ── 5: Heatmap ────────────────────────────────────────────────────
             "5" = {
               plotHeatmap(tab,
                           scale = "prop",
                           col   = col,
                           ylab  = ylab %||% "",
                           main  = .main(.panelDefault("Heatmap")),
                           box   = box,
                           stamp = NA,
                           ...)
             },
             
             message(sprintf("which=%d not defined for Desc.table", w))
      )
    }
    
  }, stamp = stamp)
  
  invisible(x)
}

