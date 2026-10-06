# Graphics Framework Helpers

The internal machinery every plot function in the suite is built on:
state management, parameter resolution, title handling and the two
element dispatchers. They are exported so that plot functions living in
other packages of the suite - a `plot.FitMod()` in alloy, a
`plot.Desc.*` method anywhere outside pharos - can follow the same
contract instead of reimplementing it.

They are not part of the user-facing API. Nothing here is meant to be
called from an analysis script, and the signatures may change with the
framework.

|  |  |
|----|----|
| Helper | Purpose |
| `.withGraphicsState()` | save/restore [`par()`](https://rdrr.io/r/graphics/par.html), draw the stamp on success |
| `.applyParFromDots()` | apply graphical parameters from `...` over defaults |
| `.resolveTitle()` | three-state `main` contract (§9.4) |
| `.marTop()` | top margin implied by the resolved title |
| `.marginLines()` | left margin implied by the drawn tick labels |
| `.drawGrid()` | grid dispatcher, understands `.useTheme` |
| `.drawBox()` | box dispatcher, understands `.useTheme` |
| `.useTheme` | sentinel telling "resolve against the active theme" (§9.3) |

Resolves a callIf-style `grid` spec against the current theme and,
unless suppressed, draws a grid via
[`graphics::grid()`](https://rdrr.io/r/graphics/grid.html). This is the
single choke point for grid rendering in all plot functions,
guaranteeing consistent precedence: function defaults \< theme settings
\< user spec.

Counterpart to `.drawGrid()` for
[`graphics::box()`](https://rdrr.io/r/graphics/box.html). Resolves a
callIf-style `box` spec against the current theme and draws the plot box
unless suppressed.

Runs `expr` (typically the body of a high-level plot function) while
guaranteeing that all commonly modified
[`par()`](https://rdrr.io/r/graphics/par.html) settings are restored
afterwards, and optionally places a stamp annotation and resets the
layout once the expression has completed successfully.

Central dispatcher that translates the three sources of graphical
parameters into [`par()`](https://rdrr.io/r/graphics/par.html) calls, in
strictly increasing precedence:

Returns the top margin in lines: compact (room for the axis only) when
no title will be drawn, generous otherwise. Centralizes the two values
as theme defaults instead of magic numbers at 40 call sites.

Normalizes the user-facing `main` argument: `NULL` means "use the
function's default title", while `FALSE`, `""` and `NA` all mean
"suppress the title" and map to `""`.

Like `.neededMargin()`, but takes the label orientation (`las`) into
account: with perpendicular labels (`las` 2/3) the label *width* governs
the required space regardless of the axis side. Adds a 15% safety factor
to absorb rounding and font metric differences across devices.

## Usage

``` r
.useTheme

.drawGrid(grid, defaults = list())

.drawBox(box, defaults = list())

.withGraphicsState(expr, stamp = .useTheme, resetLayout = FALSE)

.applyParFromDots(..., exclude = "cex", defaults = list())

.marTop(main)

.resolveTitle(main, default = "")

.marginLines(
  labels,
  side = 4,
  las = par("las"),
  cex = par("cex"),
  pad = 0,
  axisLine = 0
)
```

## Arguments

- grid:

  a callIf-style spec: the sentinel `.useTheme` (use the theme's `grid`
  entry as on/off toggle), `TRUE` (draw with defaults), `FALSE` / `NULL`
  / `NA` (suppress), or a named list of arguments passed on to
  [`graphics::grid()`](https://rdrr.io/r/graphics/grid.html) (e.g.
  `list(nx = NA, ny = 5)`).

- defaults:

  named list of function-level default parameters (tier 2).

- box:

  a callIf-style spec: `.useTheme` (theme decides), `TRUE` (draw with
  defaults), `FALSE` / `NULL` / `NA` (suppress), or a named list of
  arguments for [`graphics::box()`](https://rdrr.io/r/graphics/box.html)
  (e.g. `list(which = "figure")`).

- expr:

  the plot expression, evaluated in the caller's frame via
  `eval.parent(substitute(expr))` so that promises and local variables
  resolve as if the code ran inline.

- stamp:

  controls the stamp annotation drawn after a *successful* plot: the
  sentinel `.useTheme` (default; let the theme decide),
  `TRUE`/`FALSE`/`NULL`/`NA` as an on/off toggle, a bare string or an
  expression (used as the stamp text itself), or a list of arguments for
  [`stamp()`](stamp.md) (e.g. `list(text = "...", las = 2)`).

- resetLayout:

  logical; if `TRUE`, the layout is reset to a single panel
  (`layout(matrix(1))`) after successful completion. Use this in plot
  functions that set up multi-panel layouts internally.

- ...:

  user-supplied graphical parameters (the dots of the calling plot
  function).

- exclude:

  character vector of parameter names that must never reach
  [`par()`](https://rdrr.io/r/graphics/par.html) from the defaults/dots
  tiers. Defaults to `"cex"`: `cex` scales the line height and thus the
  margins, see the "cex policy" in design_rules.md. The theme tier is
  deliberately exempt – theme `cex` is global scaling, a different
  concern from the gated function-argument `cex` (symbol size).

- main:

  the `main` argument as passed by the user.

- default:

  the function's default title, returned when `main = NULL`.

- labels:

  character vector of labels to accommodate; `NULL` or empty yields `0`.

- side:

  integer, the axis side (1 = bottom, 2 = left, 3 = top, 4 = right).

- las:

  label orientation as in
  [`par()`](https://rdrr.io/r/graphics/par.html); 2/3 = perpendicular to
  the axis.

- cex:

  character expansion used for measuring; defaults to `par("cex")`.

- pad:

  additional padding in lines.

- axisLine:

  offset of the axis labels from the plot region, in lines.

## Value

Invisibly `NULL`; called for its side effect (drawing).

Invisibly `NULL`; called for its side effect (drawing).

Invisibly `NULL`; called for its side effects.

Invisibly `NULL`; called for its side effect on
[`par()`](https://rdrr.io/r/graphics/par.html).

A single numeric: `2.1` (no title) or `4.1` (title present).

A character string: `default`, `""`, or `main` itself.

A single numeric: the required margin size in lines (ceiling).

## Details

Theme entries whose names start with `"group."` are stripped before
merging, as they parameterize grouped-plot variants and are not valid
[`graphics::grid()`](https://rdrr.io/r/graphics/grid.html) arguments.

This is the outermost wrapper of the shared plot setup path: every
`plot*()` function routes its drawing code through here, so state
restoration and stamping never have to be handled at individual call
sites.

Deliberately *not* saved/restored: `oma`/`omi`. Restoring these resets
the multi-figure state and thereby destroys user-defined `mfrow`/
[`layout()`](https://rdrr.io/r/graphics/layout.html) arrangements
between panels (each `par(omi = ...)` call restarts the page).
Exception: with `resetLayout = TRUE` the calling function has set up its
own layout and thus owns the page; `oma` is then restored after the
layout reset.

Deliberately *not* saved/restored: `oma`/`omi`. Restoring these resets
the multi-figure state and thereby destroys user-defined `mfrow`/
[`layout()`](https://rdrr.io/r/graphics/layout.html) arrangements
between panels (each `par(omi = ...)` call restarts the page).

Warnings inside `expr` are raised immediately (`warn = 1`) so they
appear in the context of the failing plot call rather than being
deferred to the end of the top-level call.

The success flag `ok` ensures that neither the stamp nor the layout
reset fires when `expr` throws: a half-drawn plot is not stamped, and
the (possibly user-owned) layout is left untouched for inspection.

1.  **Theme `par`** (`getTheme()$par`) – global styling, lowest tier.

2.  **Function defaults** (`defaults`), each individually overridable
    via the corresponding `DescToolsX.plot.<name>` option (see
    `.resolvePar()`).

3.  **User dots** (`...`) – explicit arguments at the call site, highest
    tier.

Only names that are settable
[`par()`](https://rdrr.io/r/graphics/par.html) parameters are applied;
anything else in `...` is silently ignored here (it is typically
consumed by the plot primitives instead).

`mar` and `oma` receive partial-update semantics: a *named* vector
(`c(top = 6)`) patches only the given sides (names must be from
`bottom`, `left`, `top`, `right`); an unnamed vector is recycled to
length 4, with `NA` entries keeping the current value
(`mar = c(NA, 8, NA, NA)` widens only the left margin).

## Why these are exported

Section 9.7 of the design rules gives the unavailability of these
helpers outside `pharos` as the reason `plot.Desc.*` methods live in
`pharos` rather than next to the classes they plot. That reason no
longer holds. The placement of the existing methods is unchanged - the
export only removes the constraint, it does not itself relocate
anything.

## Contract for callers outside pharos

The rules in sections 9.1-9.5 apply unchanged: no direct
[`par()`](https://rdrr.io/r/graphics/par.html) call outside
`.applyParFromDots()`, `stamp` passed to `.withGraphicsState()` rather
than drawn by hand, no `oma`/`omi` in any save/restore list, and no
internal `mfrow`.
