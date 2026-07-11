# Plot Method for Categorical-Categorical `Desc` Objects

Visualises a (two-dimensional) cross-tabulation, as computed by
[`desc()`](https://rdrr.io/pkg/DescToolsX/man/desc.html) for a
categorical/categorical pair. Four panel types are available, selectable
(and combinable) via `which`. Higher-dimensional tables (more than two
margins) are not supported; a message is issued and the call returns
invisibly.

## Usage

``` r
# S3 method for class 'Desc.table'
plot(
  x,
  main = NULL,
  ylab = NULL,
  which = 1,
  verbose = NULL,
  col = .useTheme,
  box = .useTheme,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  An object of class `"Desc.table"`, as returned by
  [`desc()`](https://rdrr.io/pkg/DescToolsX/man/desc.html) for a
  categorical-categorical pair.

- main:

  Main title. `NULL` (default) derives a title per panel from
  `x$meta$xname` (the deparsed expression originally passed to `desc()`,
  e.g. `"table(Pizza$area, Pizza$driver)"`) combined with a panel-type
  label for context when multiple panels are shown (e.g.
  `"table(Pizza$area, Pizza$driver) (Spineplot)"`). There is no `y ~ x`
  pair to draw on here - `x$meta` carries only a single `xname`, since a
  table built outside a two-sided formula has no separately named "x"
  and "y" variable. `""`, `NA`, or `FALSE` suppress the title and
  compact the top margin. Any other string is used as-is, identically
  for every selected panel.

- ylab:

  y-axis label. `NULL` (default) leaves the panel's own default in place
  (typically empty/unlabeled, since the row dimension of a table built
  via e.g. `table(a, b)` usually has no name carried in `x$meta`).
  Supplying a value overrides this for every selected panel.

- which:

  integer vector selecting one or more panels to draw, in the given
  order. One or more of:

  `1`

  :   Spineplot
      ([`spineplot`](https://rdrr.io/r/graphics/spineplot.html)).
      Default.

  `2`

  :   Mosaic plot (via
      [`plotMosaic`](https://andrisignorell.github.io/lyra/reference/plotMosaic.md)).

  `3`

  :   Mosaic plot (swapped axis).

  `4`

  :   Association plot (Cohen-Friendly plot) via
      [`plotAssoc`](https://andrisignorell.github.io/lyra/reference/plotAssoc.md).

  `5`

  :   Heatmap of cell proportions (via
      [`plotHeatmap`](https://andrisignorell.github.io/lyra/reference/plotHeatmap.md),
      `scale = "prop"`).

  Selecting multiple panels does not change the plotting layout (no
  implicit `mfrow`) - as with other `plot.Desc.*` methods, arranging
  multiple panels on one device is left to the caller (e.g.
  `par(mfrow = c(2, 1))` beforehand).

- verbose:

  integer; currently computed from
  `x$meta$verbose`/`getOption("DescTools.verbose")` for consistency with
  other `plot.Desc.*` methods, but not yet consulted to pick a default
  `which`.

- col:

  color specification. `.useTheme` (default) resolves a
  panel-appropriate default rather than one shared color, since fill
  ramps, diverging palettes, and sequential heat scales are different
  things:

  panel 1

  :   a grey ramp from `"grey30"` to `"grey90"`, sized to the number of
      columns of `tab` (not theme-driven by design, to keep the
      unordered category fill neutral).

  panel 2

  :   a grey ramp from `"grey30"` to `"grey90"`, sized to the number of
      columns of `tab`, passed to
      [`plotMosaic`](https://andrisignorell.github.io/lyra/reference/plotMosaic.md).

  panel 3

  :   left at
      [`plotAssoc`](https://andrisignorell.github.io/lyra/reference/plotAssoc.md)'s
      own default (`pal("RedWhiteBlue3", n = 100)`), a diverging
      palette - cell colors there encode the sign and strength of
      Pearson residuals, so a categorical or grey-ramp default would not
      be meaningful. Supplying `col` overrides this with the diverging
      palette of the user's choice.

  panel 4

  :   left at
      [`plotHeatmap`](https://andrisignorell.github.io/lyra/reference/plotHeatmap.md)'s
      own default (`pal("Blues", n = 100)`), a sequential ramp - cell
      colors there encode magnitude only. Supplying `col` overrides
      this.

  Supplying `col` explicitly overrides the default uniformly for every
  selected panel.

- box:

  Controls the plot frame. `.useTheme` (default) follows the active
  theme (`getTheme()$box`); `FALSE`/`NA` suppress it; a named list
  overrides frame-drawing arguments.

  panel 1

  :   has no effect -
      [`spineplot()`](https://rdrr.io/r/graphics/spineplot.html) always
      draws its native frame unconditionally, with no toggle to override
      it.

  panel 2

  :   [`plotMosaic`](https://andrisignorell.github.io/lyra/reference/plotMosaic.md)
      always draws its own frame; this argument has no effect.

  panel 3

  :   [`plotAssoc`](https://andrisignorell.github.io/lyra/reference/plotAssoc.md)
      has no frame/box concept of its own (it draws dashed reference
      lines instead); this argument has no effect.

  panel 4

  :   forwarded as-is to
      [`plotHeatmap`](https://andrisignorell.github.io/lyra/reference/plotHeatmap.md)'s
      own `box` argument, which draws the outer frame via
      [`rect()`](https://rdrr.io/r/graphics/rect.html) at the exact tile
      boundaries rather than
      [`box()`](https://rdrr.io/r/graphics/box.html).

- stamp:

  Controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`, drawn once after all selected panels. Panels 2-4
  delegate to
  [`plotMosaic`](https://andrisignorell.github.io/lyra/reference/plotMosaic.md)/
  [`plotAssoc`](https://andrisignorell.github.io/lyra/reference/plotAssoc.md)/[`plotHeatmap`](https://andrisignorell.github.io/lyra/reference/plotHeatmap.md),
  whose own `stamp` argument is set to `NA` internally to avoid a
  duplicate. `TRUE`/`FALSE`/`NULL`, a string, or a named list for
  [`stamp()`](https://andrisignorell.github.io/lyra/reference/stamp.md).

- ...:

  further graphical parameters, passed to
  [`par`](https://rdrr.io/r/graphics/par.html) via the internal
  framework and to the underlying panel-drawing functions
  ([`spineplot()`](https://rdrr.io/r/graphics/spineplot.html),
  [`plotMosaic`](https://andrisignorell.github.io/lyra/reference/plotMosaic.md),
  [`plotAssoc`](https://andrisignorell.github.io/lyra/reference/plotAssoc.md),
  or
  [`plotHeatmap`](https://andrisignorell.github.io/lyra/reference/plotHeatmap.md),
  depending on the selected panel).

## Value

Invisibly returns `x`.

## Details

The left margin is sized automatically from the longest of: the y-axis
label, and - for panels 1/2 - the row names of `tab` drawn as axis tick
labels, so neither is ever clipped regardless of `which`.

Only two-dimensional tables are supported. If `x` carries a table with
more than two margins, a message is issued and the function returns
invisibly without drawing anything.

## See also

[`desc`](https://rdrr.io/pkg/DescToolsX/man/desc.html),
[`plotAssoc`](https://andrisignorell.github.io/lyra/reference/plotAssoc.md),
[`plotHeatmap`](https://andrisignorell.github.io/lyra/reference/plotHeatmap.md),
[`plotMosaic`](https://andrisignorell.github.io/lyra/reference/plotMosaic.md),
[`spineplot`](https://rdrr.io/r/graphics/spineplot.html),
[`getTheme`](https://andrisignorell.github.io/lyra/reference/getTheme.md)

Other plot.s3:
[`plot.BlandAltman()`](https://andrisignorell.github.io/lyra/reference/plot.BlandAltman.md),
[`plot.Desc.qn()`](https://andrisignorell.github.io/lyra/reference/plot.Desc.qn.md),
[`plot.Lc()`](https://andrisignorell.github.io/lyra/reference/plot.Lc.md)
