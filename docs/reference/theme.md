# pharos's Graphics and Formatting Theme

`getTheme()`, `setTheme()`, and `resetTheme()` are the user-facing entry
points to pharos's theme system: a single, named list of graphical and
formatting defaults, consulted by essentially every plotting function in
the package (and by
[`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md) for
numeric/percentage/p-value formatting) whenever the corresponding
function argument is left at its default value.

## Usage

``` r
getTheme()

setTheme(theme)

resetTheme()
```

## Arguments

- theme:

  either a named list of theme components to merge into the active theme
  (only the given top-level elements are replaced; e.g.
  `setTheme(list(palette = "Set2"))` changes only the palette, leaving
  `grid`, `box`, `twin`, etc. untouched), or a single string naming a
  preset registered in the (currently empty) preset registry.

## Value

`getTheme()` and `resetTheme()` return the (new) active theme, a named
list; `setTheme()` returns the new active theme as well, invisibly.

## What the theme is for

Most graphical parameters in pharos's plotting functions (`col`, `grid`,
`box`, `pch`, ...) default to a sentinel value, `.useTheme`, rather than
to a hardcoded color or number. At call time, that sentinel is resolved
against `getTheme()` - so changing the active theme changes the look of
*every* plot produced afterwards that didn't explicitly override that
argument, without touching a single plotting function's code.

This gives three independent ways to control a plot's appearance, in
order of precedence (highest first):

1.  **Explicit argument**, e.g. `plotXY(x, y, col = "red")` - always
    wins, for that one call only.

2.  **Function-specific default** - some functions deliberately hardcode
    a value that differs from the generic theme baseline instead of
    using `.useTheme` (e.g.
    [`plotBar()`](https://andrisignorell.github.io/aurora/reference/plotBar.md)'s
    `box` defaults to `FALSE` rather than the theme's box setting, and
    [`plotDot()`](https://andrisignorell.github.io/aurora/reference/plotDot.md)'s
    grid line color/style stays its own orange/grey dashed look
    regardless of the active theme). This is a conscious per-function
    design choice, not a bug - see the individual function's
    documentation for which arguments opt out of theme-following this
    way.

3.  **Active theme** (`getTheme()`) - the package-wide fallback used
    whenever neither of the above applies.

## Structure of the theme

The theme is a named list with the following top-level components.
Nested components (`grid`, `box`, `points`, `bar`, `sty`) are themselves
named lists; `setTheme()` replaces them wholesale (it does not merge one
level deeper), so to change a single nested value, supply the complete
sub-list, e.g.
`setTheme(list(grid = list(col = "red", lwd = 1, lty = "dotted")))`.

- `par`:

  `col.axis="grey40", las=1, cex=1.1`. Global
  [`par()`](https://rdrr.io/r/graphics/par.html) pass applied by every
  `.applyParFromDots()` call (axis label color, axis label orientation,
  global text scaling).

- `grid`:

  `col="grey80", lwd=1, lty="dotted"`, plus `group.*` variants.
  Background grid lines, via `.drawGrid()`. The `group.*` entries style
  a subordinate/secondary grid (e.g. group separators) where a function
  draws one.

- `box`:

  `col="grey50", lwd=1, lty="solid"`. The frame drawn around a plot
  region, via `.drawBox()`.

- `points`:

  `pch=21, col="grey50", bg=addOpacity("grey"), cex=1.1`. Default point
  styling for scatterplot-like functions (e.g.
  [`plotXY()`](https://andrisignorell.github.io/aurora/reference/plotXY.md),
  [`plotDot()`](https://andrisignorell.github.io/aurora/reference/plotDot.md)).

- `twin`:

  `pal("helsana")[c(6, 1)]`. A fixed pair of colors for contexts that
  inherently need exactly two contrasting colors (e.g. a fit line and a
  smoother in
  [`plotXY()`](https://andrisignorell.github.io/aurora/reference/plotXY.md),
  the two poles of a diverging color ramp in
  [`plotCor()`](https://andrisignorell.github.io/aurora/reference/plotCor.md),
  a single accent color via `twin[1]` in
  [`lines.loess`](https://andrisignorell.github.io/aurora/reference/lines.loess.md)/[`plotQQ()`](https://andrisignorell.github.io/aurora/reference/plotQQ.md)'s
  confidence band). Never used as a substitute for `palette` when more
  than two colors are needed.

- `palette`:

  `"helsana"`. Name of the qualitative (categorical) palette used
  whenever more than two unordered colors are needed (e.g.
  [`plotMosaic()`](https://andrisignorell.github.io/aurora/reference/plotMosaic.md)'s
  fill colors), resolved via
  [`pal()`](https://andrisignorell.github.io/aurora/reference/pal.md).
  Deliberately not used for sequential or diverging numeric scales – see
  the next item.

- (none – by design):

  Sequential/diverging numeric color scales (e.g.
  [`plotDens2D()`](https://andrisignorell.github.io/aurora/reference/plotDens2D.md)'s
  density heatmap,
  [`plotHeatmap()`](https://andrisignorell.github.io/aurora/reference/plotHeatmap.md)'s
  cell shading) are deliberately *not* theme-driven; they use a
  hardcoded, purpose-built palette via
  [`pal()`](https://andrisignorell.github.io/aurora/reference/pal.md)
  instead (e.g. `pal("red-black")`, `pal("Blues")`). Neither `palette`
  (categorical) nor `twin` (a fixed pair) is the right semantic fit for
  an ordered, continuous scale – see
  [`pal`](https://andrisignorell.github.io/aurora/reference/pal.md) for
  the registry of named continuous palettes.

- `bar`:

  `col="grey80", border=NA`. Default bar fill/border in
  [`plotBar()`](https://andrisignorell.github.io/aurora/reference/plotBar.md).

- `sty`:

  `abs="abs.sty", perc="per.sty", num="num.sty", pval="pval.sty"`. Names
  of [`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md)
  format styles (see
  [`styles()`](https://andrisignorell.github.io/aurora/reference/style.md))
  used for absolute counts, percentages, plain numbers, and p-values
  respectively.

- `stamp`:

  `expression(...)` – unevaluated. The corner stamp text drawn by every
  [`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md)/`.withGraphicsState()`
  call. Stored as an unevaluated
  [`expression()`](https://rdrr.io/r/base/expression.html) and
  [`eval()`](https://rdrr.io/r/base/eval.html)'d at draw time (not at
  theme-load or theme-set time), so it always reflects the current user
  and date rather than freezing whatever they were when the theme was
  defined or last changed. Default: `"<username> / <YYYY-MM-DD>"`.

## The `.useTheme` sentinel

Internally, a function argument that should follow the active theme
(rather than some fixed value) defaults to a dedicated sentinel object,
`.useTheme`, not to `TRUE`, `FALSE`, `NA`, or `NULL`. Those four are
frequently legitimate, explicit values in their own right (e.g.
`grid = NULL` commonly means "suppress the grid" for a given function) -
using any of them to also mean "no value was given, defer to the theme"
would make that case ambiguous. A dedicated sentinel avoids the
ambiguity entirely and keeps the resolution logic a single, explicit
equality check (`identical(x, .useTheme)`) rather than an implicit,
error-prone guess based on data type.

Two small internal helpers resolve it:

- `.useThemeValue(value, ...)` - for a simple value taken from a nested
  theme key, e.g. `col <- .useThemeValue(col, "points", "col")`.

- `.resolveToggle(spec, themeValue)` - for an on/off-style argument
  (such as `grid`/`box`) that may also be a
  `TRUE`/`FALSE`/`NA`/`NULL`/list spec in its own right, used internally
  by `.drawGrid()`/`.drawBox()`.

Some theme values require more than a simple key lookup to resolve (e.g.
building a color ramp from `twin`, or constructing a list of point
parameters from `points`); those are resolved with a small inline
`identical(x, .useTheme)` check directly in the consuming function
rather than forcing them through one of the two generic helpers above.
See e.g.
[`plotCor()`](https://andrisignorell.github.io/aurora/reference/plotCor.md)'s
`col` argument or
[`plotDot()`](https://andrisignorell.github.io/aurora/reference/plotDot.md)'s
`pch` argument for worked examples.

## How plotting functions consume the theme

- `.applyParFromDots()`:

  Applies `getTheme()$par` as the lowest-precedence
  [`par()`](https://rdrr.io/r/graphics/par.html) pass, before the
  function's own defaults and the user's `...`.

- `.drawGrid(grid, defaults = list())` /
  `.drawBox(box, defaults = list())`:

  Generic dispatchers wrapping
  [`graphics::grid()`](https://rdrr.io/r/graphics/grid.html)/
  [`graphics::box()`](https://rdrr.io/r/graphics/box.html). Resolve the
  `.useTheme` sentinel, merge the theme's style values with any
  function-specific `defaults` (e.g.
  [`plotBar()`](https://andrisignorell.github.io/aurora/reference/plotBar.md)
  suppressing the axis-parallel grid direction via `nx`/`ny`), and
  dispatch via [`callIf`](https://rdrr.io/pkg/bedrock/man/callIf.html).
  **Not** used by every function that draws a grid or frame: a few
  ([`plotCor()`](https://andrisignorell.github.io/aurora/reference/plotCor.md),
  [`plotHeatmap()`](https://andrisignorell.github.io/aurora/reference/plotHeatmap.md),
  [`plotDot()`](https://andrisignorell.github.io/aurora/reference/plotDot.md))
  have grid/box geometry tied to exact data coordinates (e.g.
  half-integer cell boundaries) that doesn't match
  [`graphics::grid()`](https://rdrr.io/r/graphics/grid.html)'s
  axis-tick-based geometry: these resolve theme values directly via
  `getTheme()$grid`/ `getTheme()$box` but draw with their own clipped
  [`rect()`](https://rdrr.io/r/graphics/rect.html)/[`abline()`](https://rdrr.io/r/graphics/abline.html)
  calls instead.

- `.withGraphicsState(expr, stamp = .useTheme, ...)`:

  Wraps a plotting function's body, restores
  [`par()`](https://rdrr.io/r/graphics/par.html) afterwards, and - after
  `expr` has run successfully - calls
  [`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md)
  with the (possibly theme-resolved) corner stamp text/arguments.

## Presets

`setTheme()` also accepts a single preset name (a string) instead of a
list, looked up in an internal preset registry (`.themePresets`). No
presets are currently registered; the registry exists so named, complete
theme variants (e.g. a monochrome or high-contrast theme) can be added
later without changing the `setTheme()` interface.

## See also

[`pal`](https://andrisignorell.github.io/aurora/reference/pal.md) for
the color palette registry,
[`fm`](https://andrisignorell.github.io/aurora/reference/fm.md) for the
formatting styles referenced by `sty`,
[`stamp`](https://andrisignorell.github.io/aurora/reference/stamp.md)
for the corner stamp mechanism.

## Examples

``` r
# inspect the active theme
getTheme()
#> $par
#> $par$col.axis
#> [1] "grey40"
#> 
#> $par$las
#> [1] 1
#> 
#> $par$cex
#> [1] 1.1
#> 
#> 
#> $grid
#> $grid$col
#> [1] "grey80"
#> 
#> $grid$lwd
#> [1] 1
#> 
#> $grid$lty
#> [1] "dotted"
#> 
#> $grid$group.col
#> [1] "grey50"
#> 
#> $grid$group.lwd
#> [1] 1
#> 
#> $grid$group.lty
#> [1] "dotted"
#> 
#> 
#> $box
#> $box$col
#> [1] "grey50"
#> 
#> $box$lwd
#> [1] 1
#> 
#> $box$lty
#> [1] "solid"
#> 
#> 
#> $points
#> $points$pch
#> [1] 21
#> 
#> $points$col
#> [1] "grey50"
#> 
#> $points$bg
#>        grey 
#> "#BEBEBE80" 
#> 
#> $points$cex
#> [1] 1.1
#> 
#> 
#> $twin
#>       red      blue 
#> "#9A0941" "#8296C4" 
#> 
#> $palette
#> [1] "helsana"
#> 
#> $bar
#> $bar$col
#> [1] "grey80"
#> 
#> $bar$border
#> [1] NA
#> 
#> 
#> $legend
#> $legend$bg
#>       white 
#> "#FFFFFF80" 
#> 
#> $legend$box.col
#> [1] "grey50"
#> 
#> 
#> $sty
#> $sty$abs
#> Definition:    digits=0, bigMark="", label="Number format for counts"
#> Example:       314159
#> 
#> $sty$perc
#> Definition:    digits=1, fmt="%", label="Percentage number format"
#> Example:       31415926.5%
#> 
#> $sty$num
#> Definition:    digits=3, bigMark="", label="Number format for numeric values"
#> Example:       314159.265
#> 
#> $sty$pval
#> Definition:    fmt="p", pThreshold=0.001, label="Number format for p-values"
#> Example:       NA
#> 
#> 
#> $stamp
#> expression(gettextf("%s / %s", Sys.getenv("USERNAME"), format(Sys.Date(), 
#>     "%Y-%m-%d")))
#> 

# change only the qualitative palette for the rest of the session
setTheme(list(palette = "Set2"))

# change the accent color pair used for e.g. lm/loess fit lines
setTheme(list(twin = c("firebrick", "navy")))

# turn grid lines off package-wide (any .useTheme-driven grid argument
# everywhere now resolves to "off", unless a function overrides it)
setTheme(list(grid = FALSE))

# back to package defaults
resetTheme()
```
