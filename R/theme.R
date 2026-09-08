
## ============================================================================
## Theme system for pharos
## ============================================================================
## Central default values for graphical and formatting parameters, controlled
## package-wide via getOption("pharos.theme"). Plotting functions consume the
## theme via .theme()/.useThemeValue()/.drawGrid()/.drawBox()/
## .withGraphicsState() and can override it locally via explicit arguments
## (precedence: explicit argument > function-specific default > active theme).
##
## See ?getTheme for the full user-facing documentation of this system.


## ---- Master default theme --------------------------------------------------

.themeDefaults <- list(
  
  # Axis labels, line weight, etc. - runs as its own par() pass WITHOUT the
  # cex exclude-guard (see .applyParFromDots). This cex means global
  # scaling, not the gated function-argument cex (symbol size), which must
  # never go through par().
  par = list(
    col.axis = "grey40",
    las      = 1,
    cex      = 1.1
  ),
  
  # Main grid + subordinate group grid (group.* prefix convention, filtered
  # out by .drawGrid() via startsWith(..., "group.") before being passed on
  # to graphics::grid())
  grid = list(
    col       = "grey80",
    lwd       = 1,
    lty       = "dotted",
    group.col = "grey50",
    group.lwd = 1,
    group.lty = "dotted"
  ),
  
  box = list(
    col = "grey50",
    lwd = 1,
    lty = "solid"
  ),
  
  points = list(
    pch = 21,
    col = "grey50",
    bg  = addOpacity("grey"),   # alpha baked into the theme default, not recomputed per call
    cex = 1.1
  ),
  
  # Two colors: a fixed, named choice. More than two: palette lookup.
  # If a context needs two colors but 'twin' doesn't fit, the calling
  # function must define that explicitly itself (no implicit fallback
  # to palette(n=2)).
  twin    = pal("helsana")[c(2, 1)],
  palette = "helsana",
  
  bar = list(
    col    = "grey80",
    border = NA
  ),
  
  legend = list(
    bg      = addOpacity("white"),
    box.col = "grey50"
  ),
  
  
  # Format codes for fm(), nested rather than four top-level keys
  sty = list(
    abs  =  structure(list(digits = 0, bigMark = "",
              label = "Number format for counts"), 
              class = "Style"),
    perc = structure(list(digits = 1, fmt = "%",
              label = "Percentage number format"),
              class = "Style"),
    num  = structure(list(digits = 3, bigMark = "",
              label = "Number format for numeric values"), 
              class = "Style"),
    pval = structure(list(fmt="p", pThreshold=1e-3,
              label = "Number format for p-values"),
              class = "Style")
  ),
  
  # Stored unevaluated - eval() happens lazily at actual plot time, never
  # at package load or theme-set time, or username/date would freeze.
  stamp = expression(
    gettextf("%s / %s", Sys.getenv("USERNAME"), format(Sys.Date(), "%Y-%m-%d"))
  )
)


## ---- Public session API -----------------------------------------------

#' pharos's Graphics and Formatting Theme
#'
#' `getTheme()`, `setTheme()`, and `resetTheme()` are the
#' user-facing entry points to pharos's theme system: a single, named list
#' of graphical and formatting defaults, consulted by essentially every
#' plotting function in the package (and by [fm()] for
#' numeric/percentage/p-value formatting) whenever the corresponding
#' function argument is left at its default value.
#'
#' @param theme either a named list of theme components to merge into the
#'   active theme (only the given top-level elements are replaced; e.g.
#'   `setTheme(list(palette = "Set2"))` changes only the palette,
#'   leaving `grid`, `box`, `twin`, etc. untouched), or a
#'   single string naming a preset registered in the (currently empty)
#'   preset registry.
#'
#' @return `getTheme()` and `resetTheme()` return the (new)
#'   active theme, a named list; `setTheme()` returns the new active
#'   theme as well, invisibly.
#'
#' @section What the theme is for:
#'
#' Most graphical parameters in pharos's plotting functions (`col`,
#' `grid`, `box`, `pch`, ...) default to a sentinel value,
#' `.useTheme`, rather than to a hardcoded color or number. At call
#' time, that sentinel is resolved against `getTheme()` - so changing
#' the active theme changes the look of *every* plot produced
#' afterwards that didn't explicitly override that argument, without
#' touching a single plotting function's code.
#'
#' This gives three independent ways to control a plot's appearance, in
#' order of precedence (highest first):
#'
#' \enumerate{
#'   \item **Explicit argument**, e.g. `plotXY(x, y, col = "red")`
#'     - always wins, for that one call only.
#'   \item **Function-specific default** - some functions deliberately
#'     hardcode a value that differs from the generic theme baseline
#'     instead of using `.useTheme` (e.g. `plotBar()`'s
#'     `box` defaults to `FALSE` rather than the theme's box
#'     setting, and `plotDot()`'s grid line color/style stays its own
#'     orange/grey dashed look regardless of the active theme). This is a
#'     conscious per-function design choice, not a bug - see the
#'     individual function's documentation for which arguments opt out of
#'     theme-following this way.
#'   \item **Active theme** (`getTheme()`) - the package-wide
#'     fallback used whenever neither of the above applies.
#' }
#'
#' @section Structure of the theme:
#'
#' The theme is a named list with the following top-level components.
#' Nested components (`grid`, `box`, `points`, `bar`,
#' `sty`) are themselves named lists; `setTheme()` replaces them
#' wholesale (it does not merge one level deeper), so to change a single
#' nested value, supply the complete sub-list, e.g.
#' `setTheme(list(grid = list(col = "red", lwd = 1, lty = "dotted")))`.
#'
#' \describe{
#'   \item{`par`}{`col.axis="grey40", las=1, cex=1.1`. Global
#'     `par()` pass applied by every `.applyParFromDots()` call
#'     (axis label color, axis label orientation, global text scaling).}
#'   \item{`grid`}{`col="grey80", lwd=1, lty="dotted"`, plus
#'     `group.*` variants. Background grid lines, via
#'     `.drawGrid()`. The `group.*` entries style a
#'     subordinate/secondary grid (e.g. group separators) where a
#'     function draws one.}
#'   \item{`box`}{`col="grey50", lwd=1, lty="solid"`. The frame
#'     drawn around a plot region, via `.drawBox()`.}
#'   \item{`points`}{`pch=21, col="grey50",
#'     bg=addOpacity("grey"), cex=1.1`. Default point styling for
#'     scatterplot-like functions (e.g. `plotXY()`, `plotDot()`).}
#'   \item{`twin`}{`pal("helsana")[c(6, 1)]`. A fixed pair of
#'     colors for contexts that inherently need exactly two contrasting
#'     colors (e.g. a fit line and a smoother in `plotXY()`, the two
#'     poles of a diverging color ramp in `plotCor()`, a single
#'     accent color via `twin[1]` in
#'     [lines.loess()]/`plotQQ()`'s confidence band). Never
#'     used as a substitute for `palette` when more than two colors
#'     are needed.}
#'   \item{`palette`}{`"helsana"`. Name of the qualitative
#'     (categorical) palette used whenever more than two unordered colors
#'     are needed (e.g. `plotMosaic()`'s fill colors), resolved via
#'     [pal()]. Deliberately not used for sequential or
#'     diverging numeric scales -- see the next item.}
#'   \item{(none -- by design)}{Sequential/diverging numeric color scales
#'     (e.g. `plotDens2D()`'s density heatmap, `plotHeatmap()`'s
#'     cell shading) are deliberately *not* theme-driven; they use a
#'     hardcoded, purpose-built palette via [pal()] instead
#'     (e.g. `pal("red-black")`, `pal("Blues")`). Neither
#'     `palette` (categorical) nor `twin` (a fixed pair) is the
#'     right semantic fit for an ordered, continuous scale -- see
#'     [pal()] for the registry of named continuous palettes.}
#'   \item{`bar`}{`col="grey80", border=NA`. Default bar
#'     fill/border in `plotBar()`.}
#'   \item{`sty`}{`abs="abs.sty", perc="per.sty", num="num.sty",
#'     pval="pval.sty"`. Names of [fm()] format styles (see
#'     [styles()]) used for absolute counts, percentages,
#'     plain numbers, and p-values respectively.}
#'   \item{`stamp`}{`expression(...)` -- unevaluated. The corner
#'     stamp text drawn by every
#'     [stamp()]/`.withGraphicsState()` call. Stored as
#'     an unevaluated `expression()` and `eval()`'d at draw
#'     time (not at theme-load or theme-set time), so it always reflects
#'     the current user and date rather than freezing whatever they were
#'     when the theme was defined or last changed. Default:
#'     `"<username> / <YYYY-MM-DD>"`.}
#' }
#'
#' @section The `.useTheme` sentinel:
#'
#' Internally, a function argument that should follow the active theme
#' (rather than some fixed value) defaults to a dedicated sentinel object,
#' `.useTheme`, not to `TRUE`, `FALSE`, `NA`, or
#' `NULL`. Those four are frequently legitimate, explicit values in
#' their own right (e.g. `grid = NULL` commonly means "suppress the
#' grid" for a given function) - using any of them to also mean "no value
#' was given, defer to the theme" would make that case ambiguous. A
#' dedicated sentinel avoids the ambiguity entirely and keeps the
#' resolution logic a single, explicit equality check
#' (`identical(x, .useTheme)`) rather than an implicit, error-prone
#' guess based on data type.
#'
#' Two small internal helpers resolve it:
#' \itemize{
#'   \item `.useThemeValue(value, ...)` - for a simple value taken
#'     from a nested theme key, e.g.
#'     `col <- .useThemeValue(col, "points", "col")`.
#'   \item `.resolveToggle(spec, themeValue)` - for an on/off-style
#'     argument (such as `grid`/`box`) that may also be a
#'     `TRUE`/`FALSE`/`NA`/`NULL`/list spec in its own
#'     right, used internally by `.drawGrid()`/`.drawBox()`.
#' }
#'
#' Some theme values require more than a simple key lookup to resolve
#' (e.g. building a color ramp from `twin`, or constructing a list of
#' point parameters from `points`); those are resolved with a small
#' inline `identical(x, .useTheme)` check directly in the consuming
#' function rather than forcing them through one of the two generic
#' helpers above. See e.g. `plotCor()`'s `col` argument or
#' `plotDot()`'s `pch` argument for worked examples.
#'
#' @section How plotting functions consume the theme:
#'
#' \describe{
#'   \item{`.applyParFromDots()`}{Applies `getTheme()$par` as the
#'     lowest-precedence `par()` pass, before the function's own
#'     defaults and the user's `...`.}
#'   \item{`.drawGrid(grid, defaults = list())` / `.drawBox(box, defaults = list())`}{
#'     Generic dispatchers wrapping `graphics::grid()`/
#'     `graphics::box()`. Resolve the `.useTheme` sentinel,
#'     merge the theme's style values with any function-specific
#'     `defaults` (e.g. `plotBar()` suppressing the
#'     axis-parallel grid direction via `nx`/`ny`), and dispatch
#'     via [bedrock::callIf()]. **Not** used by every
#'     function that draws a grid or frame: a few (`plotCor()`,
#'     `plotHeatmap()`, `plotDot()`) have grid/box geometry tied
#'     to exact data coordinates (e.g. half-integer cell boundaries) that
#'     doesn't match `graphics::grid()`'s axis-tick-based geometry: 
#'     these resolve theme values directly via `getTheme()$grid`/
#'     `getTheme()$box` but draw with their own clipped
#'     `rect()`/`abline()` calls instead.}
#'   \item{`.withGraphicsState(expr, stamp = .useTheme, ...)`}{Wraps a
#'     plotting function's body, restores `par()` afterwards, and -
#'     after `expr` has run successfully - calls
#'     [stamp()] with the (possibly theme-resolved) corner
#'     stamp text/arguments.}
#' }
#'
#' @section Presets:
#'
#' `setTheme()` also accepts a single preset name (a string) instead
#' of a list, looked up in an internal preset registry
#' (`.themePresets`). No presets are currently registered; the
#' registry exists so named, complete theme variants (e.g. a monochrome or
#' high-contrast theme) can be added later without changing the
#' `setTheme()` interface.
#'
#' @examples
#' # inspect the active theme
#' getTheme()
#'
#' # change only the qualitative palette for the rest of the session
#' setTheme(list(palette = "Set2"))
#'
#' # change the accent color pair used for e.g. lm/loess fit lines
#' setTheme(list(twin = c("firebrick", "navy")))
#'
#' # turn grid lines off package-wide (any .useTheme-driven grid argument
#' # everywhere now resolves to "off", unless a function overrides it)
#' setTheme(list(grid = FALSE))
#'
#' # back to package defaults
#' resetTheme()
#'
#' @seealso [pal()] for the color palette registry,
#'   [fm()] for the formatting styles referenced by `sty`,
#'   [stamp()] for the corner stamp mechanism.
#'
#' @name theme
#' 
#' @family theme  
#' @concept theme
#'
#'
#' @export
getTheme <- function() {
  getOption("pharos.theme", .themeDefaults)
}

#' @rdname theme
#' @export
setTheme <- function(theme) {
  
  new <- if (is.character(theme) && length(theme) == 1L) {
    
    .themePresets[[theme]] %||%
      stop("unknown theme preset: '", theme, "'. Available: ",
           paste(names(.themePresets), collapse = ", "))
    
  } else if (is.list(theme)) {
    
    utils::modifyList(getTheme(), theme)
    
  } else {
    stop("'theme' must be a named list or a preset name")
  }
  
  options(pharos.theme = new)
  invisible(new)
}

#' @rdname theme
#' @export
resetTheme <- function() {
  options(pharos.theme = .themeDefaults)
  invisible(.themeDefaults)
}


## ---- Preset registry (currently empty, presets to follow as needed) -----

.themePresets <- list()


## ---- Local resolver: reconcile a function's own defaults against the
## active theme ---------------------------------------------------------

#' @noRd
.theme <- function(...) {
  
  fallback <- list(...)
  active   <- getTheme()
  
  if (length(fallback) == 0L) return(active)
  
  out <- fallback
  
  for (nm in names(fallback)) {
    # modifyList(arg) <- list(NULL) rather than out[[nm]] <- NULL: a NULL
    # entry in active[[nm]] would, via plain assignment, delete the key
    # from 'out' instead of setting it to NULL (the same trap callIf()
    # guards against).
    if (!is.null(active[[nm]]))
      out[[nm]] <- utils::modifyList(fallback[[nm]], active[[nm]])
  }
  
  out
}


## ---- Sentinel: "no explicit value given -> let the theme decide" --------

# A dedicated object rather than TRUE/FALSE/NA/NULL as a formal default,
# so it can never collide with a legitimate, documented user value (e.g.
# grid = NULL already means "explicitly suppress" for several functions -
# theme integration must not silently reinterpret that). No dots-sniffing,
# no new ...-argument - plain, explicit formal-argument matching.

#' @rdname graphics-framework
#' @export
.useTheme <- structure(list(), class = "pharos_useTheme")


#' @noRd
.useThemeValue <- function(value, ...) {
  if (!identical(value, .useTheme)) return(value)
  th <- getTheme()
  for (key in list(...)) th <- th[[key]]
  th
}


#' @noRd
.legendDefaults <- function(extra = list()) {
  # Merges theme legend defaults with any function-specific extras.
  # Pass the result as the 'defaults' argument to callIf(graphics::legend, ...).
  th <- getTheme()$legend
  if (is.null(th)) th <- list()
  .modifyListSafe(th, extra)
}


