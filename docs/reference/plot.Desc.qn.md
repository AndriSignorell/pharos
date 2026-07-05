# Plot Method for Numeric-Categorical `Desc` Objects

Visualises the relationship between a numeric variable and a categorical
variable, as computed by
[`desc`](https://rdrr.io/pkg/DescToolsX/man/desc.html)`(y ~ x)` (or
`x ~ y`) for a numeric/categorical pair. Five panel types are available,
selectable (and combinable) via `which`.

## Usage

``` r
# S3 method for class 'Desc.qn'
plot(
  x,
  main = NULL,
  ylab = NULL,
  which = 2,
  verbose = NULL,
  col = .useTheme,
  box = .useTheme,
  legend = TRUE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  An object of class `"Desc.qn"`, as returned by
  [`desc()`](https://rdrr.io/pkg/DescToolsX/man/desc.html) for a
  numeric-categorical pair.

- main:

  Main title. `NULL` (default) derives a title per panel from the
  variable names and the panel type (e.g.
  `"area ~ delivery_min (Spineplot)"`). `""`, `NA`, or `FALSE` suppress
  the title and compact the top margin. Any other string is used as-is,
  identically for every selected panel.

- ylab:

  y-axis label. `NULL` (default) derives a label specific to each panel
  (e.g. `"P(y)"` for the conditional density, `"Density"` for the
  grouped density plot). Supplying a value overrides this for every
  selected panel.

- which:

  integer vector selecting one or more panels to draw, in the given
  order. One or more of:

  `1`

  :   Conditional density plot
      ([`cdplot`](https://rdrr.io/r/graphics/cdplot.html)).

  `2`

  :   Spineplot
      ([`spineplot`](https://rdrr.io/r/graphics/spineplot.html)).
      Default.

  `3`

  :   Overlapping kernel density curves, one per group (via
      [`plotDens`](https://andrisignorell.github.io/aurora/reference/plotDens.md)).

  `4`

  :   Boxplot of the numeric variable by group (via
      [`plotBox`](https://andrisignorell.github.io/aurora/reference/plotBox.md)).

  `5`

  :   Prevalence (with Wilson confidence intervals) across quantile bins
      of the numeric variable. Only available when the categorical
      variable is binary (`k == 2`); a message is issued and the panel
      skipped otherwise.

  Selecting multiple panels does not change the plotting layout (no
  implicit `mfrow`) - arranging multiple panels on one device is left to
  the caller (e.g. `par(mfrow = c(2, 1))` beforehand).

- verbose:

  integer; currently computed from
  `x$meta$verbose`/`getOption("DescTools.verbose")` for consistency with
  other `plot.Desc.*` methods, but not yet consulted to pick a default
  `which`.

- col:

  color specification. `.useTheme` (default) resolves a
  panel-appropriate default rather than one shared color, since fill
  ramps, categorical sets, and single accents are different things:

  panels 1/2

  :   a grey ramp from `"grey30"` to `"grey90"`, sized to the number of
      categorical levels (not theme-driven by design, to keep the
      unordered category fill neutral - see
      [`plotMosaic`](https://andrisignorell.github.io/aurora/reference/plotMosaic.md)
      for the same rationale).

  panels 3/4

  :   `pal(getTheme()$palette)`, the active theme's qualitative palette,
      sized to the number of levels.

  panel 5

  :   `getTheme()$twin[1]`, the active theme's primary accent color.

  Supplying `col` explicitly overrides the default uniformly for every
  selected panel.

- box:

  Controls the plot frame for panels 4 and 5. `.useTheme` (default)
  follows the active theme (`getTheme()$box`); `FALSE`/`NA` suppress it;
  a named list overrides [`box()`](https://rdrr.io/r/graphics/box.html)
  arguments. Panels 1/2
  ([`cdplot()`](https://rdrr.io/r/graphics/cdplot.html)/[`spineplot()`](https://rdrr.io/r/graphics/spineplot.html))
  have no effect from this argument - they always draw their native
  frame unconditionally, with no toggle to override it. Panel 4
  ([`plotBox`](https://andrisignorell.github.io/aurora/reference/plotBox.md))
  always draws its own frame regardless of this argument. Panel 3
  ([`plotDens`](https://andrisignorell.github.io/aurora/reference/plotDens.md))
  never draws a frame, regardless of this argument.

- legend:

  Controls the legend for panel 3 (grouped density curves). `TRUE`
  (default) draws a legend with the group levels. `FALSE`/`NA`
  suppresses it. A named list overrides arguments forwarded to
  [`legend`](https://rdrr.io/r/graphics/legend.html). Has no effect on
  the other panels.

- stamp:

  Controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`, drawn once after all selected panels (panels 3/4
  delegate to
  [`plotDens`](https://andrisignorell.github.io/aurora/reference/plotDens.md)/
  [`plotBox`](https://andrisignorell.github.io/aurora/reference/plotBox.md),
  whose own stamp is suppressed internally to avoid a duplicate).
  `TRUE`/`FALSE`/`NULL`, a string, or a named list for
  [`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md).

- ...:

  further graphical parameters, passed to
  [`par`](https://rdrr.io/r/graphics/par.html) via the internal
  framework and to the underlying panel-drawing functions
  ([`cdplot()`](https://rdrr.io/r/graphics/cdplot.html),
  [`spineplot()`](https://rdrr.io/r/graphics/spineplot.html),
  [`plotDens`](https://andrisignorell.github.io/aurora/reference/plotDens.md),
  [`plotBox`](https://andrisignorell.github.io/aurora/reference/plotBox.md),
  or [`plot`](https://rdrr.io/r/graphics/plot.default.html), depending
  on the selected panel).

## Value

Invisibly returns `x`.

## Details

The left margin is sized automatically from the longest of: the
(possibly panel-specific) y-axis labels, and - for panels 1/2 - the
categorical level names drawn as axis tick labels, so neither is ever
clipped regardless of `which`.

## See also

[`desc`](https://rdrr.io/pkg/DescToolsX/man/desc.html),
[`plotDens`](https://andrisignorell.github.io/aurora/reference/plotDens.md),
[`plotBox`](https://andrisignorell.github.io/aurora/reference/plotBox.md),
[`cdplot`](https://rdrr.io/r/graphics/cdplot.html),
[`spineplot`](https://rdrr.io/r/graphics/spineplot.html),
[`getTheme`](https://andrisignorell.github.io/aurora/reference/getTheme.md)

Other plot.s3:
[`plot.BlandAltman()`](https://andrisignorell.github.io/aurora/reference/plot.BlandAltman.md),
[`plot.Desc.table()`](https://andrisignorell.github.io/aurora/reference/plot.Desc.table.md),
[`plot.Lc()`](https://andrisignorell.github.io/aurora/reference/plot.Lc.md)
