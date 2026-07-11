# Plot Proportions with Confidence Intervals

Displays a horizontal bar with nested confidence interval bands from
`min(ciLevels)` to `max(ciLevels)` to visualise the uncertainty of a
proportion. Bands are drawn in a semi-transparent grey so that the
accumulated overlap creates a natural density gradient - darker in the
centre, lighter at the edges.

## Usage

``` r
plotPropCI(
  x,
  main = NULL,
  labels = c("", ""),
  xlab = "",
  xlim = c(0, 1),
  col = .useTheme,
  ci.col = addAlpha("grey80", 0.12),
  border = NA,
  ciLevels = seq(0.99, 0.8, by = -0.01),
  grid = .useTheme,
  box = FALSE,
  legend = TRUE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  A two-column integer matrix where each row represents a group and the
  two columns contain counts for the two categories. A numeric vector of
  length 2 is also accepted and will be coerced to a one-row matrix.

- main:

  Main title of the plot. `NULL` (default) derives a title from
  `deparse(substitute(x))`. `""`, `NA`, or `FALSE` suppress the title
  and compact the top margin. Any other string is used as given.

- labels:

  Character vector of length 2 with labels for the two categories,
  displayed at the top of the plot. Default `c("", "")`.

- xlab:

  Label for the x-axis. Default `""`.

- xlim:

  Numeric vector of length 2 for the x-axis limits. Default `c(0, 1)`.

- col:

  Character vector of length 2 specifying fill colours for the stacked
  bar. `.useTheme` (default) resolves to `getTheme()$twin` - the active
  theme's two-color pair. Note this is purely "first label gets the
  first color"; unlike
  [`plotCor`](https://andrisignorell.github.io/lyra/reference/plotCor.md)/[`plotWeb`](https://andrisignorell.github.io/lyra/reference/plotWeb.md),
  there is no positive/ negative sign convention here, since proportions
  of two arbitrary categories (e.g. "yes"/"no") have no inherent sign.

- ci.col:

  Colour for the confidence interval bands. Default is a
  semi-transparent grey (`addAlpha("grey80", 0.12)`). Deliberately not
  theme-driven (like the sequential scales in
  [`plotDens2D`](https://andrisignorell.github.io/lyra/reference/plotDens2D.md)/[`plotHeatmap`](https://andrisignorell.github.io/lyra/reference/plotHeatmap.md)):
  this is a structural mechanism (many overlapping translucent bands
  building a gradient via overdraw), not a categorical or diverging
  color choice.

- border:

  Border colour for the confidence interval bands and the stacked bar.
  Default `NA` (no border).

- ciLevels:

  Numeric vector of confidence levels for the nested bands. Default
  `seq(0.99, 0.80, by = -0.01)` (20 bands, 99\\ 80\\ bands share the
  same translucent color and no border.

- grid:

  Controls drawing of the background grid (vertical lines at the
  proportion ticks only - there is no meaningful horizontal grid for the
  categorical group axis). `.useTheme` (default) follows the active
  theme (`getTheme()$grid`). `TRUE`/`FALSE`/ `NA`, or a named list, as
  for [`grid`](https://rdrr.io/r/graphics/grid.html).

- box:

  Controls drawing of the plot box. Default `FALSE` (no frame,
  consistent with this chart's minimal "Few"-style appearance).
  `TRUE`/`NA`, or a named list, as for
  [`box`](https://rdrr.io/r/graphics/box.html).

- legend:

  Controls the legend explaining the CI band range. `TRUE` (default)
  draws it. `FALSE`/`NA` suppresses it. A named list overrides arguments
  forwarded to [`legend`](https://rdrr.io/r/graphics/legend.html).

- stamp:

  Controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for
  [`stamp()`](https://andrisignorell.github.io/lyra/reference/stamp.md).

- ...:

  Further arguments passed to
  [`par`](https://rdrr.io/r/graphics/par.html) via the internal
  framework, and to
  [`barplot`](https://rdrr.io/r/graphics/barplot.html).

## Value

Invisibly returns `NULL`. Called for its side effect of producing a
plot.

## Details

Each row of `x` is displayed as a horizontal stacked bar showing the
proportion of the first category. Confidence intervals are calculated
using [`prop.test()`](https://rdrr.io/r/stats/prop.test.html) and drawn
as nested bands per `ciLevels`, all in the same semi-transparent colour.
The repeated overdraw naturally darkens the centre of the interval where
all bands overlap. A vertical segment marks the observed proportion.

## See also

[`prop.test`](https://rdrr.io/r/stats/prop.test.html),
[`getTheme`](https://andrisignorell.github.io/lyra/reference/getTheme.md)

Other plot.special:
[`plotBinaryTree()`](https://andrisignorell.github.io/lyra/reference/binaryTree.md),
[`plotCirc()`](https://andrisignorell.github.io/lyra/reference/plotCirc.md),
[`plotMiss()`](https://andrisignorell.github.io/lyra/reference/plotMiss.md),
[`plotPolar()`](https://andrisignorell.github.io/lyra/reference/plotPolar.md),
[`plotTernary()`](https://andrisignorell.github.io/lyra/reference/plotTernary.md),
[`plotTimeSeries()`](https://andrisignorell.github.io/lyra/reference/plotTimeSeries.md),
[`plotTreemap()`](https://andrisignorell.github.io/lyra/reference/plotTreemap.md),
[`plotWeb()`](https://andrisignorell.github.io/lyra/reference/plotWeb.md)

## Examples

``` r
m <- matrix(c(22, 111, 33, 120, 80, 100), nrow = 3, byrow = TRUE)
plotPropCI(m, labels = c("yes", "no"), main = "Response by Group")


# single row - vector input is accepted
plotPropCI(m[1, ], labels = c("yes", "no"))

```
