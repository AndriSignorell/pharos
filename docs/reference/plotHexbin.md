# Hexagonal Binning Plot

Displays a two-dimensional density estimate using hexagonal bins.
Observations are aggregated into hexagons and coloured according to the
number of observations falling into each cell.

## Usage

``` r
plotHexbin(
  x,
  y,
  bins = 30,
  col = NULL,
  border = NA,
  grid = FALSE,
  xlim = NULL,
  ylim = NULL,
  main = NULL,
  xlab = "",
  ylab = "",
  ...
)
```

## Arguments

- x:

  numeric vector of x-values.

- y:

  numeric vector of y-values.

- bins:

  number of hexagons across the x-axis.

- col:

  colours used for the count scale. If `NULL`, a default sequential
  palette is used.

- border:

  border colour of the hexagons.

- grid:

  logical or list controlling the background grid.

- xlim:

  limits for the x-axis.

- ylim:

  limits for the y-axis.

- main:

  main title.

- xlab:

  label for the x-axis.

- ylab:

  label for the y-axis.

- ...:

  additional graphical parameters passed to `.applyParFromDots()`.

## Value

Invisibly returns a list containing the computed `hexbin` object and the
original `x` and `y`.

## See also

Other plot.bivariate:
[`plotAssoc()`](https://andrisignorell.github.io/aurora/reference/plotAssoc.md),
[`plotBag()`](https://andrisignorell.github.io/aurora/reference/plotBag.md),
[`plotCor()`](https://andrisignorell.github.io/aurora/reference/plotCor.md),
[`plotDens2D()`](https://andrisignorell.github.io/aurora/reference/plotDens2D.md),
[`plotHeatmap()`](https://andrisignorell.github.io/aurora/reference/plotHeatmap.md),
[`plotMosaic()`](https://andrisignorell.github.io/aurora/reference/plotMosaic.md),
[`plotXY()`](https://andrisignorell.github.io/aurora/reference/plotXY.md)
