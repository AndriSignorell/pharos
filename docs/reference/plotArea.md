# Stacked Area Plot

Draws one or several stacked area series using cumulative polygons. The
function accepts either a matrix of values or separate `x` and `y`
coordinates. Multiple series are displayed as stacked areas.

## Usage

``` r
plotArea(
  x,
  y,
  prop = FALSE,
  col = NULL,
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL,
  legend = TRUE,
  main = NULL,
  grid = TRUE,
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

- prop:

  logical indicating whether rows should be converted to proportions so
  that stacked areas sum to one.

- col:

  fill colours used for the areas.

- xlab:

  label for the x-axis.

- ylab:

  label for the y-axis.

- xlim:

  limits for the x-axis.

- ylim:

  limits for the y-axis.

- legend:

  logical or list controlling the legend. If `TRUE`, a legend is drawn
  using the column names of the data. If a list is supplied, its
  elements are passed to the internal legend drawing routine.

- main:

  main title of the plot.

- grid:

  logical or list controlling the background grid. If `TRUE`, a default
  grid is drawn.

- ...:

  additional graphical parameters passed to
  [`par`](https://rdrr.io/r/graphics/par.html) via `.applyParFromDots()`
  and to the plotting functions.

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

Other plot.univariate:
[`plotBar()`](https://andrisignorell.github.io/aurora/reference/plotBar.md),
[`plotBox()`](https://andrisignorell.github.io/aurora/reference/plotBox.md),
[`plotCatDist()`](https://andrisignorell.github.io/aurora/reference/plotCatDist.md),
[`plotDens()`](https://andrisignorell.github.io/aurora/reference/plotDens.md),
[`plotDensBox()`](https://andrisignorell.github.io/aurora/reference/plotDensBox.md),
[`plotDot()`](https://andrisignorell.github.io/aurora/reference/plotDot.md),
[`plotECDF()`](https://andrisignorell.github.io/aurora/reference/plotECDF.md),
[`plotFdist()`](https://andrisignorell.github.io/aurora/reference/plotFdist.md),
[`plotLines()`](https://andrisignorell.github.io/aurora/reference/plotLines.md),
[`plotQQ()`](https://andrisignorell.github.io/aurora/reference/plotQQ.md),
[`plotViolin()`](https://andrisignorell.github.io/aurora/reference/plotViolin.md)

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
