
#' Plot Method for Categorical-Categorical \code{Desc} Objects
#'
#' Visualises a (two-dimensional) cross-tabulation, as computed by
#' \code{\link[DescToolsX]{desc}()} for a categorical/categorical pair.
#' Four panel types are available, selectable (and combinable) via
#' \code{which}. Higher-dimensional tables (more than two margins) are not
#' supported; a message is issued and the call returns invisibly.
#'
#' @param x An object of class \code{"Desc.table"}, as returned by
#'   \code{\link[DescToolsX]{desc}()} for a categorical-categorical pair.
#'
#' @param main Main title. \code{NULL} (default) derives a title per panel
#'   from \code{x$meta$xname} (the deparsed expression originally passed to
#'   \code{desc()}, e.g. \code{"table(Pizza$area, Pizza$driver)"}) combined
#'   with a panel-type label for context when multiple panels are shown
#'   (e.g. \code{"table(Pizza$area, Pizza$driver) (Spineplot)"}). There is
#'   no \code{y ~ x} pair to draw on here - \code{x$meta} carries only a
#'   single \code{xname}, since a table built outside a two-sided formula
#'   has no separately named "x" and "y" variable. \code{""}, \code{NA},
#'   or \code{FALSE} suppress the title and compact the top margin. Any
#'   other string is used as-is, identically for every selected panel.
#' @param ylab y-axis label. \code{NULL} (default) leaves the panel's own
#'   default in place (typically empty/unlabeled, since the row dimension
#'   of a table built via e.g. \code{table(a, b)} usually has no name
#'   carried in \code{x$meta}). Supplying a value overrides this for every
#'   selected panel.
#'
#' @param which integer vector selecting one or more panels to draw, in the
#'   given order. One or more of:
#'   \describe{
#'     \item{\code{1}}{Spineplot (\code{\link[graphics]{spineplot}}).
#'       Default.}
#'     \item{\code{2}}{Mosaic plot (via \code{\link{plotMosaic}}).}
#'     \item{\code{3}}{Mosaic plot (swapped axis).}
#'     \item{\code{4}}{Association plot (Cohen-Friendly plot) via
#'       \code{\link{plotAssoc}}.}
#'     \item{\code{5}}{Heatmap of cell proportions (via
#'       \code{\link{plotHeatmap}}, \code{scale = "prop"}).}
#'   }
#'   Selecting multiple panels does not change the plotting layout (no
#'   implicit \code{mfrow}) - as with other \code{plot.Desc.*} methods,
#'   arranging multiple panels on one device is left to the caller (e.g.
#'   \code{par(mfrow = c(2, 1))} beforehand).
#' @param verbose integer; currently computed from
#'   \code{x$meta$verbose}/\code{getOption("DescTools.verbose")} for
#'   consistency with other \code{plot.Desc.*} methods, but not yet
#'   consulted to pick a default \code{which}.
#'
#' @param col color specification. \code{.useTheme} (default) resolves a
#'   panel-appropriate default rather than one shared color, since fill
#'   ramps, diverging palettes, and sequential heat scales are different
#'   things:
#'   \describe{
#'     \item{panel 1}{a grey ramp from \code{"grey30"} to \code{"grey90"},
#'       sized to the number of columns of \code{tab} (not theme-driven by
#'       design, to keep the unordered category fill neutral).}
#'     \item{panel 2}{a grey ramp from \code{"grey30"} to \code{"grey90"},
#'       sized to the number of columns of \code{tab}, passed to
#'       \code{\link{plotMosaic}}.}
#'     \item{panel 3}{left at \code{\link{plotAssoc}}'s own default
#'       (\code{pal("RedWhiteBlue3", n = 100)}), a diverging palette - cell
#'       colors there encode the sign and strength of Pearson residuals, so
#'       a categorical or grey-ramp default would not be meaningful. Supplying
#'       \code{col} overrides this with the diverging palette of the user's
#'       choice.}
#'     \item{panel 4}{left at \code{\link{plotHeatmap}}'s own default
#'       (\code{pal("Blues", n = 100)}), a sequential ramp - cell colors
#'       there encode magnitude only. Supplying \code{col} overrides this.}
#'   }
#'   Supplying \code{col} explicitly overrides the default uniformly for
#'   every selected panel.
#' @param box Controls the plot frame. \code{.useTheme} (default) follows
#'   the active theme (\code{getTheme()$box}); \code{FALSE}/\code{NA}
#'   suppress it; a named list overrides frame-drawing arguments.
#'   \describe{
#'     \item{panel 1}{has no effect - \code{spineplot()} always draws its
#'       native frame unconditionally, with no toggle to override it.}
#'     \item{panel 2}{\code{\link{plotMosaic}} always draws its own frame;
#'       this argument has no effect.}
#'     \item{panel 3}{\code{\link{plotAssoc}} has no frame/box concept of
#'       its own (it draws dashed reference lines instead); this argument
#'       has no effect.}
#'     \item{panel 4}{forwarded as-is to \code{\link{plotHeatmap}}'s own
#'       \code{box} argument, which draws the outer frame via
#'       \code{rect()} at the exact tile boundaries rather than
#'       \code{\link[graphics]{box}()}.}
#'   }
#'
#' @param stamp Controls the corner stamp. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$stamp}, drawn once after all selected
#'   panels. Panels 2-4 delegate to \code{\link{plotMosaic}}/
#'   \code{\link{plotAssoc}}/\code{\link{plotHeatmap}}, whose own
#'   \code{stamp} argument is set to \code{NA} internally to avoid a
#'   duplicate. \code{TRUE}/\code{FALSE}/\code{NULL}, a string, or a
#'   named list for \code{\link{stamp}()}.
#'
#' @param ... further graphical parameters, passed to \code{\link{par}} via
#'   the internal framework and to the underlying panel-drawing functions
#'   (\code{spineplot()}, \code{\link{plotMosaic}}, \code{\link{plotAssoc}},
#'   or \code{\link{plotHeatmap}}, depending on the selected panel).
#'
#' @details
#' The left margin is sized automatically from the longest of: the y-axis
#' label, and - for panels 1/2 - the row names of \code{tab} drawn as
#' axis tick labels, so neither is ever clipped regardless of \code{which}.
#'
#' Only two-dimensional tables are supported. If \code{x} carries a table
#' with more than two margins, a message is issued and the function returns
#' invisibly without drawing anything.
#'
#' @return Invisibly returns \code{x}.
#'
#' @seealso \code{\link[DescToolsX]{desc}}, \code{\link{plotAssoc}},
#'   \code{\link{plotHeatmap}}, \code{\link{plotMosaic}},
#'   \code{\link[graphics]{spineplot}}, \code{\link{getTheme}}
#'
#' @family desc
#' @concept data-description
#' @concept descriptive-statistics
#'
#' @rdname plot.Desc.table
#'
#' @exportS3Method
#' @rawNamespace export(plot.Desc.table)
# Both tags above are required, not redundant: @exportS3Method alone
# registers S3 dispatch (plot(obj)) but does NOT export the bare symbol,
# so unqualified calls like plot.Desc.table(x, ...) from other packages
# (e.g. DescToolsX's plot.Desc.qq) fail with "could not find function" -
# even with @importFrom aurora plot.Desc.table on the calling side.
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
    # panels 1/2 share a grey ramp (unordered category fill kept neutral,
    # not theme-driven by design); panels 3/4 keep their own diverging /
    # sequential defaults from plotAssoc()/plotHeatmap() unless 'col' is
    # supplied explicitly. 'col' stays one user-facing argument;
    # resolveCol() picks the right default for panels 1/2.
    colSpineDefault <- colorRampPalette(c("grey30", "grey90"))(ncolTab)

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
                         col  = resolveCol(colSpineDefault),
                         xlab = ylab %||% "",
                         ylab = xName,
                         main = .main(.panelDefault("Spineplot")),
                         ...)

               axis(side = 1, labels = NA, col.ticks = NA)
               axis(side = 4, labels = NA, col.ticks = NA)
             },

             # ── 2: Mosaic plot ───────────────────────────────────────────────
             "2" = {
               plotMosaic(tab,
                          col  = resolveCol(colSpineDefault),
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
                          col  = resolveCol(colSpineDefault),
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
               # (pal("RedWhiteBlue3", n=100)) appropriate for signed
               # residuals - a grey/categorical default would not be
               # meaningful here, so it's only overridden when the caller
               # supplies col explicitly. Its xlab/ylab are TRUE/FALSE/
               # character toggles for the dimnames labels, not plain axis
               # strings - left at their own TRUE default (show dimnames)
               # unless the caller overrides.
               plotAssoc(tab,
                        col  = if (identical(col, .useTheme)) pal("RedWhiteBlue3", n = 100L) else col,
                        main = .main(.panelDefault("Association plot")),
                        stamp = NA,
                        ...)
             },

             # ── 5: Heatmap ────────────────────────────────────────────────────
             "5" = {
               plotHeatmap(tab,
                          scale = "prop",
                          col   = col,
                          xlab  = xName,
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
