# Stacked Area Plot

Draws one or several stacked area series using cumulative polygons. The
function accepts either a matrix of values or separate `x` and `y`
coordinates. Multiple series are displayed as stacked areas.

## Usage

``` r
plotArea(
  x,
  y,
  main = NULL,
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL,
  prop = FALSE,
  col = NULL,
  grid = .useTheme,
  legend = TRUE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  numeric vector, matrix or data frame. If `y` is missing, `x` is
  interpreted as a matrix of series where rows correspond to x positions
  and columns to individual areas.

- y:

  optional numeric vector or matrix giving the y-values. If supplied,
  `x` is interpreted as the x-coordinates.

- main:

  main title of the plot.

- xlab:

  label for the x-axis.

- ylab:

  label for the y-axis.

- xlim:

  limits for the x-axis.

- ylim:

  limits for the y-axis.

- prop:

  logical indicating whether rows should be converted to proportions so
  that stacked areas sum to one.

- col:

  fill colours used for the areas.

- grid:

  controls the background grid. `.useTheme` (default) follows the active
  theme (`getTheme()$grid`), `TRUE` draws it, `FALSE`, `NULL` or `NA`
  suppress it, and a named list is passed to
  [`graphics::grid()`](https://rdrr.io/r/graphics/grid.html).

- legend:

  logical or list controlling the legend. If `TRUE`, a legend is drawn
  using the column names of the data. If a list is supplied, its
  elements are passed to the internal legend drawing routine.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for [`stamp()`](stamp.md).

- ...:

  additional graphical parameters passed to
  [`graphics::par()`](https://rdrr.io/r/graphics/par.html) via
  [`.applyParFromDots()`](graphics-framework.md) and to the plotting
  functions.

## Value

Invisibly returns a list containing:

- `x` the x-values used for plotting,

- `y` the original y-values,

- `cumulative` the cumulative values used to construct the areas,

- `legend` the legend specification if drawn.

## Details

If `y` is missing, `x` is interpreted as a matrix and each column is
drawn as a separate stacked area.

The cumulative sums are calculated row-wise and displayed as polygons
stacked on top of each other.

If `prop = TRUE`, each row is converted to proportions before plotting,
so the stacked areas sum to one.

Row names are used as x-axis labels when available and `y` is omitted.

## See also

Other plot.univariate: [`plotBar()`](plotBar.md),
[`plotBox()`](plotBox.md), [`plotCatDist()`](plotCatDist.md),
[`plotDens()`](plotDens.md), [`plotDensBox()`](plotDensBox.md),
[`plotDot()`](plotDot.md), [`plotECDF()`](plotECDF.md),
[`plotFreqDist()`](plotFreqDist.md), [`plotLines()`](plotLines.md),
[`plotQQ()`](plotQQ.md), [`plotViolin()`](plotViolin.md)

## Examples

``` r
plotArea(VADeaths)


plotArea(
  WorldPhones,
  col = pal("helsana")
)


plotArea(
  WorldPhones,
  prop = TRUE,
  col = rainbow(ncol(WorldPhones))
)


x <- 1:20
y <- cbind(
  A = runif(20, 1, 5),
  B = runif(20, 1, 3),
  C = runif(20, 1, 4)
)

plotArea(x, y)

```
