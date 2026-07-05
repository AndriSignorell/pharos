
# utils-plot.R -------------------------------------------------------------
#
# Internal plotting infrastructure for aurora. These helpers implement the
# shared setup path used by all high-level plot*() functions: graphics state
# management, theme-aware par() handling, margin calculation, and resolution
# of callIf-style toggle specs. All functions are internal (@noRd) unless
# stated otherwise.


# R/fcol.R
fcol <- .pal_data$discrete$Helsana


#' Get a DescToolsX Option
#'
#' Thin wrapper around [getOption()] that prepends the suite-wide
#' `"DescToolsX."` prefix. All options across the package suite (bedrock,
#' aurora, lumen, alloy, hermes) live in this single namespace, e.g.
#' `options(DescToolsX.plot.minPin = c(1, 1))`.
#'
#' @param name character string, the option name *without* the
#'   `"DescToolsX."` prefix (e.g. `"plot.minPin"`).
#' @param default value returned if the option is not set. Defaults to
#'   `NULL`.
#'
#' @return The option value, or `default` if unset.
#'
#' @noRd
.getOption <- function(name, default = NULL) {
  getOption(paste0("DescToolsX.", name), default)
}



## ---- Grid / Box: consistent, theme-driven, explicit formal ---------------

#' Draw a Theme-Aware Grid
#'
#' Resolves a callIf-style `grid` spec against the current theme and, unless
#' suppressed, draws a grid via [graphics::grid()]. This is the single
#' choke point for grid rendering in all plot functions, guaranteeing
#' consistent precedence: function defaults < theme settings < user spec.
#'
#' @param grid a callIf-style spec: the sentinel `.useTheme` (use the theme's
#'   `grid` entry as on/off toggle), `TRUE` (draw with defaults), `FALSE` /
#'   `NULL` / `NA` (suppress), or a named list of arguments passed on to
#'   [graphics::grid()] (e.g. `list(nx = NA, ny = 5)`).
#' @param defaults named list of call-site defaults for [graphics::grid()],
#'   applied with lower precedence than the theme's grid parameters.
#'
#' @return Invisibly `NULL`; called for its side effect (drawing).
#'
#' @details Theme entries whose names start with `"group."` are stripped
#'   before merging, as they parameterize grouped-plot variants and are not
#'   valid [graphics::grid()] arguments.
#'
#' @noRd
.drawGrid <- function(grid, defaults = list()) {

  th <- getTheme()$grid

  spec <- if (identical(grid, .useTheme)) !isFALSE(th) else grid

  if (isFALSE(spec) || is.null(spec) ||
      (length(spec) == 1L && !is.list(spec) && is.na(spec)))
    return(invisible())

  themeDefaults <- if (is.list(th)) th[!startsWith(names(th), "group.")] else list()

  bedrock::callIf(graphics::grid, spec, defaults = .modifyListSafe(themeDefaults, defaults))
}


#' Draw a Theme-Aware Box
#'
#' Counterpart to `.drawGrid()` for [graphics::box()]. Resolves a
#' callIf-style `box` spec against the current theme and draws the plot
#' box unless suppressed.
#'
#' @param box a callIf-style spec: `.useTheme` (theme decides), `TRUE`
#'   (draw with defaults), `FALSE` / `NULL` / `NA` (suppress), or a named
#'   list of arguments for [graphics::box()] (e.g. `list(which = "figure")`).
#' @param defaults named list of call-site defaults for [graphics::box()],
#'   applied with lower precedence than the theme's box parameters.
#'
#' @return Invisibly `NULL`; called for its side effect (drawing).
#'
#' @noRd
.drawBox <- function(box, defaults = list()) {

  th <- getTheme()$box

  spec <- if (identical(box, .useTheme)) !isFALSE(th) else box

  if (isFALSE(spec) || is.null(spec) ||
      (length(spec) == 1L && !is.list(spec) && is.na(spec)))
    return(invisible())

  themeDefaults <- if (is.list(th)) th else list()

  bedrock::callIf(graphics::box, spec, defaults = .modifyListSafe(themeDefaults, defaults))
}


## ---- Graphics state wrapper: stamp is theme-driven ------------------------

#' Evaluate a Plot Expression With Protected Graphics State
#'
#' Runs `expr` (typically the body of a high-level plot function) while
#' guaranteeing that all commonly modified [par()] settings are restored
#' afterwards, and optionally places a stamp annotation and resets the
#' layout once the expression has completed successfully.
#'
#' This is the outermost wrapper of the shared plot setup path: every
#' `plot*()` function routes its drawing code through here, so state
#' restoration and stamping never have to be handled at individual call
#' sites.
#'
#' @param expr the plot expression, evaluated in the caller's frame via
#'   `eval.parent(substitute(expr))` so that promises and local variables
#'   resolve as if the code ran inline.
#' @param stamp controls the stamp annotation drawn after a *successful*
#'   plot: the sentinel `.useTheme` (default; let the theme decide),
#'   `TRUE`/`FALSE`/`NULL`/`NA` as an on/off toggle, a bare string or an
#'   expression (used as the stamp text itself), or a list of arguments
#'   for [aurora::stamp()] (e.g. `list(text = "...", las = 2)`).
#' @param resetLayout logical; if `TRUE`, the layout is reset to a single
#'   panel (`layout(matrix(1))`) after successful completion. Use this in
#'   plot functions that set up multi-panel layouts internally.
#'
#' @return Invisibly `NULL`; called for its side effects.
#'
#' @details
#' Deliberately *not* saved/restored: `oma`/`omi`. Restoring these resets
#' the multi-figure state and thereby destroys user-defined `mfrow`/
#' `layout()` arrangements between panels (each `par(omi = ...)` call
#' restarts the page).
#'
#' Warnings inside `expr` are raised immediately (`warn = 1`) so they
#' appear in the context of the failing plot call rather than being
#' deferred to the end of the top-level call.
#'
#' The success flag `ok` ensures that neither the stamp nor the layout
#' reset fires when `expr` throws: a half-drawn plot is not stamped, and
#' the (possibly user-owned) layout is left untouched for inspection.
#'
#' @noRd
.withGraphicsState <- function(expr, stamp = .useTheme, resetLayout = FALSE) {

  keep <- c(
    "mar","mai","cex","cex.axis","cex.lab","cex.main","cex.sub",
    "las","tck","mgp","xaxs","yaxs","xaxt","yaxt",
    "col","col.axis","col.lab","col.main","col.sub",
    "lwd","lty","pch","bg","fg","xpd", "plt"
    #,"oma", "omi"
  )

  op <- par(keep)

  withr::defer(par(op))
  withr::local_options(warn = 1)

  # 'stamp' may be .useTheme/TRUE/FALSE/NULL/NA (toggle), a bare string or
  # an expression (= the stamp text itself), or a list of arguments for
  # stamp() (e.g. list(text = "...", las = 2)).
  stampArgs <- if (is.list(stamp)) stamp else list(text = stamp)

  ok <- FALSE

  on.exit({
    if (ok)
      # 'stamp' here refers to the exported aurora::stamp() function, not
      # the local formal argument 'stamp' of this call - R's function
      # lookup skips non-functions in call position, so the name resolves
      # correctly despite the clash.
      tryCatch(do.call(aurora::stamp, stampArgs), error = function(e) NULL)

    if (ok && resetLayout)
      tryCatch(layout(matrix(1)), error = function(e) NULL)

  }, add = TRUE)

  eval.parent(substitute(expr))

  ok <- TRUE
  invisible(NULL)
}




## ---- .applyParFromDots: theme par as lowest precedence tier ---------------

#' Apply Graphics Parameters From Theme, Defaults, and User Dots
#'
#' Central dispatcher that translates the three sources of graphical
#' parameters into [par()] calls, in strictly increasing precedence:
#'
#' 1. **Theme `par`** (`getTheme()$par`) -- global styling, lowest tier.
#' 2. **Function defaults** (`defaults`), each individually overridable
#'    via the corresponding `DescToolsX.plot.<name>` option (see
#'    `.resolvePar()`).
#' 3. **User dots** (`...`) -- explicit arguments at the call site,
#'    highest tier.
#'
#' Only names that are settable `par()` parameters are applied; anything
#' else in `...` is silently ignored here (it is typically consumed by
#' the plot primitives instead).
#'
#' @param ... user-supplied graphical parameters (the dots of the calling
#'   plot function).
#' @param exclude character vector of parameter names that must never
#'   reach `par()` from the defaults/dots tiers. Defaults to `"cex"`:
#'   `cex` scales the line height and thus the margins, see the "cex
#'   policy" in design_rules.md. The theme tier is deliberately exempt --
#'   theme `cex` is global scaling, a different concern from the gated
#'   function-argument `cex` (symbol size).
#' @param defaults named list of function-level default parameters
#'   (tier 2).
#'
#' @return Invisibly `NULL`; called for its side effect on `par()`.
#'
#' @details
#' `mar` and `oma` receive partial-update semantics: a *named* vector
#' (`c(top = 6)`) patches only the given sides (names must be from
#' `bottom`, `left`, `top`, `right`); an unnamed vector is recycled to
#' length 4, with `NA` entries keeping the current value
#' (`mar = c(NA, 8, NA, NA)` widens only the left margin).
#'
#' @noRd
.applyParFromDots <- function(..., exclude = "cex", defaults = list()) {

  patch_fourpar <- function(new_val, old_val, pname) {

    if (!is.null(names(new_val))) {
      idx <- match(names(new_val), c("bottom","left","top","right"))
      if (any(is.na(idx)))
        stop(sprintf("%s names must be bottom, left, top, right", pname))
      old_val[idx] <- new_val
      return(old_val)
    }

    new_val <- rep_len(new_val, 4)
    idx_na <- is.na(new_val)
    new_val[idx_na] <- old_val[idx_na]
    new_val
  }

  apply_set <- function(args, useExclude = TRUE) {

    args <- args[!is.na(names(args))]
    args <- args[names(args) %in% names(par(no.readonly = TRUE))]

    if (useExclude && !is.null(exclude))
      args <- args[!names(args) %in% exclude]

    if (!length(args)) return(invisible())

    p <- par(no.readonly = TRUE)

    if ("mar" %in% names(args)) args$mar <- patch_fourpar(args$mar, p$mar, "mar")
    if ("oma" %in% names(args)) args$oma <- patch_fourpar(args$oma, p$oma, "oma")

    do.call(par, args)
    invisible()
  }

  # Tier 1 (lowest precedence, runs first): theme par. Deliberately
  # without 'exclude' - see @param exclude above.
  apply_set(getTheme()$par, useExclude = FALSE)

  # Tier 2: function defaults, possibly overridden by a set option
  if (length(defaults)) {
    defaults <- Map(function(nm, val) .resolvePar(nm, default = val),
                    names(defaults), defaults)
    apply_set(defaults)
  }

  # Tier 3 (highest precedence, runs last): user dots
  apply_set(list(...))

  invisible()
}



#' Top Margin Depending on the Presence of a Main Title
#'
#' Returns the top margin in lines: compact (room for the axis only) when
#' no title will be drawn, generous otherwise. Centralizes the two values
#' as theme defaults instead of magic numbers at 40 call sites.
#'
#' @param main the `main` argument as passed to the plot function.
#'   `FALSE`, `""` and `NA` are treated as "no title" (consistent with
#'   `.resolveTitle()`); note that `NULL` means "default title", not
#'   "no title".
#'
#' @return A single numeric: `2.1` (no title) or `4.1` (title present).
#'
#' @noRd
.marTop <- function(main) {
  noTitle <- isFALSE(main) || identical(main, "") || isTRUE(is.na(main))
  if (noTitle) 2.1 else 4.1
}


#' Resolve a Plot Parameter Against Its Option
#'
#' Implements the per-parameter precedence used by `.applyParFromDots()`
#' tier 2: an explicit `value` wins, otherwise a set option
#' `DescToolsX.plot.<name>` wins, otherwise the hard-coded `default`
#' is used.
#'
#' @param name character string, the parameter name (also the option
#'   suffix, e.g. `"lwd"` resolves against `DescToolsX.plot.lwd`).
#' @param value the explicitly supplied value, or `NULL` if not given.
#' @param default fallback value if neither `value` nor the option is set.
#'
#' @return The resolved parameter value.
#'
#' @noRd
.resolvePar <- function(name, value = NULL, default = NULL) {

  if (!is.null(value)) {
    return(value)
  }

  opt <- .getOption(paste0("DescToolsX.plot.", name))
  if (!is.null(opt)) {
    return(opt)
  }

  default
}



#' Resolve a Main Title Specification
#'
#' Normalizes the user-facing `main` argument: `NULL` means "use the
#' function's default title", while `FALSE`, `""` and `NA` all mean
#' "suppress the title" and map to `""`.
#'
#' @param main the `main` argument as passed by the user.
#' @param default the function's default title, returned when
#'   `main = NULL`.
#'
#' @return A character string: `default`, `""`, or `main` itself.
#'
#' @noRd
.resolveTitle <- function(main, default = "") {

  if (is.null(main))
    return(default)

  noTitle <- isFALSE(main) || identical(main, "") || isTRUE(is.na(main))

  if (noTitle) "" else main
}



#' Is the Current Panel the Last One on the Page?
#'
#' Determines whether the panel about to be drawn is the final one of an
#' `mfrow`/`mfcol` arrangement, a [layout()] configuration, or a
#' [split.screen()] / manual `fig` setup. Used e.g. to decide when to
#' place page-level annotations (stamp, outer legends) that must be drawn
#' exactly once per page.
#'
#' @param tol numeric tolerance for the `fig` coordinate comparison used
#'   in the `split.screen`/manual-`fig` fallback.
#'
#' @return A single logical.
#'
#' @details
#' Three cases, in order:
#' * `par("page")` is `TRUE` -- the *next* plot starts a new page, i.e.
#'   the current panel is the first of a page, not the last: `FALSE`.
#' * A complete `par("mfg")` (length 4) is available -- last panel iff
#'   the current row/column equals the grid dimensions.
#' * Fallback for `split.screen()` or manually set `fig` parameters:
#'   the panel is considered last if its figure region touches the right
#'   edge (`fig[2] == 1`) and the bottom edge (`fig[3] == 0`), within
#'   `tol`.
#'
#' @noRd
.isLastPanel <- function(tol = 1e-7) {

  if (par("page"))
    return(FALSE)

  mfg <- par("mfg")

  if(length(mfg) == 4)
    return(mfg[1] == mfg[3] && mfg[2] == mfg[4])

  # needed for split.screen or manually set fig parameters
  fig <- par("fig")
  abs(fig[2] - 1) < tol && abs(fig[3] - 0) < tol
}



#' Margin Lines Needed to Accommodate Axis Labels
#'
#' Estimates how many margin lines are required so that a set of labels
#' fits on the given side, including the axis line offset and padding.
#' Works in inches internally and converts to lines via the current line
#' height (`csi * mex`), so the result is valid for the active device and
#' character size.
#'
#' Requires an open device with a valid coordinate system, since
#' [strwidth()]/[strheight()] are used for measurement.
#'
#' @param labels character vector of labels to accommodate.
#' @param side integer, the axis side (1 = bottom, 2 = left, 3 = top,
#'   4 = right). Sides 2/4 use label *widths*, sides 1/3 label *heights*.
#' @param cex character expansion used for measuring; defaults to
#'   `par("cex.axis")`.
#' @param pad additional padding in lines.
#' @param axis.line offset of the axis labels from the plot region, in
#'   lines (corresponds to the second element of `mgp`).
#'
#' @return A single numeric: the required margin size in lines (ceiling),
#'   or `0` if `labels` is empty.
#'
#' @seealso `.marginLines()` for the las-aware variant,
#'   `.adjustMargin()` which applies the result to `par("mar")`.
#'
#' @noRd
.neededMargin <- function(labels,
                          side = 2,
                          cex = par("cex.axis"),
                          pad = 0.5,
                          axis.line = 1) {

  if(length(labels) == 0)
    return(0)

  w <- max(strwidth(labels, units = "inches", cex = cex))
  h <- max(strheight(labels, units = "inches", cex = cex))

  size <- if(side %in% c(2,4)) w else h

  lineHeight <- par("csi") * par("mex")

  lines <- size / lineHeight

  ceiling(lines + axis.line + pad)
}


#' Margin Lines Needed for Labels, Respecting Label Orientation
#'
#' Like `.neededMargin()`, but takes the label orientation (`las`) into
#' account: with perpendicular labels (`las` 2/3) the label *width*
#' governs the required space regardless of the axis side. Adds a 15%
#' safety factor to absorb rounding and font metric differences across
#' devices.
#'
#' @param labels character vector of labels to accommodate; `NULL` or
#'   empty yields `0`.
#' @param side integer, the axis side (1 = bottom, 2 = left, 3 = top,
#'   4 = right).
#' @param las label orientation as in [par()]; 2/3 = perpendicular to
#'   the axis.
#' @param cex character expansion used for measuring; defaults to
#'   `par("cex")`.
#' @param pad additional padding in lines.
#' @param axis.line offset of the axis labels from the plot region, in
#'   lines.
#'
#' @return A single numeric: the required margin size in lines (ceiling).
#'
#' @noRd
.marginLines <- function(labels,
                         side = 4,
                         las = par("las"),
                         cex = par("cex"),
                         pad = 0,
                         axis.line = 0) {

  if(is.null(labels) || !length(labels))
    return(0)

  w <- max(strwidth(labels, units = "inches", cex = cex))
  h <- max(strheight(labels, units = "inches", cex = cex))

  size <- if(las %in% c(2, 3)) {
    w
  } else {
    if(side %in% c(2, 4)) w else h
  }

  lineHeight <- par("csi") * par("mex")

  ceiling(
    1.15 * (size / lineHeight + axis.line + pad)
  )

}



#' Widen a Margin to Fit Labels, If Necessary
#'
#' Convenience wrapper: measures the space required for `labels` via
#' `.marginLines()` and enlarges the corresponding entry of `par("mar")`
#' if -- and only if -- the current margin is too small. Margins are never
#' shrunk. Finishes with a `.checkMargins()` pass to guarantee that the
#' enlarged margins still leave a usable plot region.
#'
#' @param labels character vector of labels to accommodate; `NULL` or
#'   empty is a no-op.
#' @param side integer, the axis side whose margin may be widened
#'   (1 = bottom, 2 = left, 3 = top, 4 = right).
#' @param las label orientation as in [par()].
#' @param cex character expansion used for measuring; defaults to
#'   `par("cex.axis")`.
#' @param pad additional padding in lines.
#' @param axis.line offset of the axis labels from the plot region, in
#'   lines.
#'
#' @return Invisibly `NULL`; called for its side effect on `par("mar")`.
#'
#' @noRd
.adjustMargin <- function(labels,
                          side = 2,
                          las = par("las"),
                          cex = par("cex.axis"),
                          pad = 0.5,
                          axis.line = 1) {

  if(is.null(labels) || !length(labels))
    return(invisible())

  needed <- .marginLines(
    labels    = labels,
    side      = side,
    las       = las,
    cex       = cex,
    pad       = pad,
    axis.line = axis.line
  )

  mar <- par("mar")

  if(needed > mar[side]) {
    mar[side] <- needed
    par(mar = mar)
  }

  .checkMargins()

  invisible()
}



#' Shrink Margins That Would Not Fit the Figure Region
#'
#' Guards against the base graphics error `"figure margins too large"`:
#' if the combined opposite margins (bottom+top, or left+right) meet or
#' exceed the figure size in the respective direction, all margins are
#' scaled down proportionally so that 10% of the figure remains for the
#' plot region.
#'
#' @return Invisibly `NULL`; called for its side effect on `par("mar")`.
#'
#' @details
#' The comparison is done in lines: the figure size (`par("fin")`, in
#' inches) is converted via the current line height (`csi * mex`).
#' Proportional scaling preserves the relative margin layout instead of
#' clipping single sides.
#'
#' Note that on a very small device this still leaves only a sliver of
#' plot region -- a positive but unusable `pin`. Catching that case is
#' the job of the plot region check, not of this function.
#'
#' @noRd
.checkMargins <- function() {

  mar <- par("mar")
  fin <- par("fin")

  lineHeight <- par("csi") * par("mex")

  heightLines <- fin[2] / lineHeight
  widthLines  <- fin[1] / lineHeight

  if(mar[1] + mar[3] >= heightLines ||
     mar[2] + mar[4] >= widthLines) {

    # shrink proportionally
    scale <- 0.9 * min(
      heightLines / (mar[1] + mar[3]),
      widthLines  / (mar[2] + mar[4])
    )

    par(mar = mar * scale)
  }

  invisible()
}



#' Resolve the cex Family From User Dots
#'
#' Derives a complete, consistent set of character expansion factors from
#' the dots of a plot call: an explicit `cex` acts as the base value, and
#' each specific factor (`cex.axis`, `cex.lab`, `cex.main`, `cex.sub`)
#' falls back to that base unless given explicitly. This differs from the
#' base graphics behaviour, where the specific factors default
#' independently of `cex`.
#'
#' @param dots list of the caller's dots (`list(...)`).
#'
#' @return A named list with elements `cex`, `cex.axis`, `cex.lab`,
#'   `cex.main` and `cex.sub`.
#'
#' @noRd
.resolveCex <- function(dots) {

  cex <- dots$cex %||% par("cex")

  list(
    cex      = cex,
    cex.axis = dots$cex.axis %||% cex,
    cex.lab  = dots$cex.lab  %||% cex,
    cex.main = dots$cex.main %||% cex,
    cex.sub  = dots$cex.sub  %||% cex
  )

}



#' Convert User Coordinates to Outer (NDC-Like) Figure Coordinates
#'
#' Maps positions given in user coordinates (`usr`) to the normalized
#' figure coordinate system spanned by `par("plt")`. Needed when
#' annotations tied to data positions (e.g. axis-aligned outer labels)
#' must be placed with `xpd = NA` or via `mtext(..., outer = )`-style
#' positioning.
#'
#' @param at numeric vector of positions in user coordinates.
#' @param side integer axis side; sides 2/4 map along the y direction,
#'   sides 1/3 along the x direction.
#'
#' @return A numeric vector of the same length as `at`, in normalized
#'   figure coordinates (0 = lower/left figure edge, 1 = upper/right).
#'
#' @noRd
.outerAt <- function(at, side = 2) {

  usr <- par("usr")
  plt <- par("plt")

  if (side %in% c(2,4)) {
    # y direction
    plt[3] + (at - usr[3]) / diff(usr[3:4]) * diff(plt[3:4])
  } else {
    # x direction
    plt[1] + (at - usr[1]) / diff(usr[1:2]) * diff(plt[1:2])
  }

}



#' Resolve a Toggle Spec Against Its Theme Value
#'
#' Minimal resolver for on/off arguments that default to the `.useTheme`
#' sentinel: if the user left the sentinel in place, the theme value
#' decides (anything but explicit `FALSE` counts as on); otherwise the
#' user's spec is returned untouched.
#'
#' @param spec the user-facing argument value (possibly the `.useTheme`
#'   sentinel).
#' @param themeValue the corresponding entry from [getTheme()].
#'
#' @return `spec`, or the theme-derived logical if `spec` was the
#'   sentinel.
#'
#' @noRd
.resolveToggle <- function(spec, themeValue) {
  if (identical(spec, .useTheme)) !isFALSE(themeValue) else spec
}


#' modifyList Variant That Preserves Explicit NULL Values
#'
#' [utils::modifyList()] treats a `NULL` value in `val` as "delete this
#' key" rather than "set it to NULL" -- that silently drops things like
#' `ny = NULL`, which [graphics::grid()] needs explicitly (its own formal
#' default is `ny = nx`, not `ny = NULL`). This variant assigns every
#' entry of `val` verbatim, `NULL`s included. Same fix pattern as
#' `callIf()` / `.theme()` use internally.
#'
#' @param x named list to be updated.
#' @param val named list of replacement values; `NULL` entries are kept
#'   as explicit `NULL`s.
#'
#' @return The updated list.
#'
#' @noRd
.modifyListSafe <- function(x, val) {
  for (nm in names(val)) {
    x[nm] <- list(val[[nm]])
  }
  x
}



#' Resolve a callIf-Style Spec Into an Argument List, Without Calling
#'
#' Resolves a callIf-style spec (`TRUE`/`FALSE`/`NA`/`NULL`/list/
#' `.useTheme`) against a set of defaults *without calling any function*:
#' returns `NULL` if the component is suppressed, or the merged argument
#' list otherwise. Used for tightly coupled multi-panel plots where
#' components must share state (e.g. `xlim`, `ylim`) *before* any drawing
#' happens -- the resolved argument lists can be inspected and harmonized
#' first, then executed.
#'
#' @param spec the callIf-style spec: `FALSE`/`NULL`/scalar `NA` suppress
#'   (returns `NULL`); `TRUE` or the `.useTheme` sentinel accept the
#'   defaults; a named list is merged over the defaults; anything else
#'   falls back to the defaults.
#' @param defaults named list of default arguments.
#' @param forbidden character vector of argument names that users may not
#'   override (stripped from a list spec before merging), e.g. shared
#'   state like `xlim` that the caller controls.
#'
#' @return `NULL` (suppressed) or a named list of arguments.
#'
#' @seealso [bedrock::callIf()] for the resolve-and-call counterpart,
#'   `.modifyListSafe()` for the NULL-preserving merge used here.
#'
#' @noRd
.resolveSpec <- function(spec, defaults, forbidden = character(0)) {
  if (isFALSE(spec) || is.null(spec) ||
      (length(spec) == 1L && !is.list(spec) &&
       isTRUE(suppressWarnings(is.na(spec)))))
    return(NULL)
  if (isTRUE(spec) || identical(spec, .useTheme))
    return(defaults)
  if (is.list(spec)) {
    clean <- spec[!names(spec) %in% forbidden]
    return(.modifyListSafe(defaults, clean))
  }
  defaults
}


