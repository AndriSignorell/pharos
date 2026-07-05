# Line Plot for Multiple Series

Draws one or several line series using
[`matplot`](https://rdrr.io/r/graphics/matplot.html). The function
accepts either a matrix of values or separate `x` and `y` coordinates
and supports optional point symbols, grid lines, and an automatically
positioned legend.

## Usage

``` r
plotLines(
  x,
  y,
  main = NULL,
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL,
  xaxt = NULL,
  yaxt = NULL,
  lty = 1,
  lwd = 2,
  col = .useTheme,
  points = FALSE,
  grid = .useTheme,
  legend = TRUE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  Numeric vector, matrix or data frame. If `y` is missing, `x` is
  interpreted as a matrix of series where rows correspond to x positions
  and columns to individual lines.

- y:

  Optional numeric vector or matrix giving the y-values. If supplied,
  `x` is interpreted as the x-coordinates.

- main:

  Main title of the plot. `NULL` (default) derives a title from the
  input. `""`, `NA`, or `FALSE` suppress the title and compact the top
  margin.

- xlab, ylab:

  Labels for the axes.

- xlim, ylim:

  Limits for the axes.

- xaxt, yaxt:

  Axis specification passed to
  [`axis`](https://rdrr.io/r/graphics/axis.html).

- lty:

  Line type(s).

- lwd:

  Line width(s).

- col:

  Colours for the lines. `.useTheme` (default) resolves to
  `pal(getTheme()$palette)`, the active theme's qualitative palette.

- points:

  Controls drawing of points on the lines. `FALSE` (default) suppresses
  points; `TRUE` draws with theme defaults (`getTheme()$points`); a
  named list overrides individual elements (`pch`, `col`, `bg`, `cex`).

- grid:

  Controls drawing of the background grid. `.useTheme` (default) follows
  the active theme (`getTheme()$grid`). `TRUE`/`FALSE`/`NA`, or a named
  list, as for [`grid`](https://rdrr.io/r/graphics/grid.html).

- legend:

  Controls the legend. `TRUE` (default) draws an inline legend via
  `textLegend` at the last value of each series. `FALSE`/`NA` suppresses
  it. A list overrides legend arguments.

- stamp:

  Controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, a string, or a named list
  for
  [`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md).

- ...:

  Additional graphical parameters passed to
  [`par`](https://rdrr.io/r/graphics/par.html) via `.applyParFromDots()`
  and to the plotting functions.

## Value

Invisibly returns a list containing:

- `x` the x-values used for plotting,

- `y` the y-values (if supplied),

- `legend` the legend specification if drawn.

## Details

If `y` is missing, `x` is interpreted as a matrix and each column is
drawn as a separate line. Row names are used for the x-axis labels if
available. The legend labels default to the column names of the data.

## See also

Other plot.univariate:
[`plotArea()`](https://andrisignorell.github.io/aurora/reference/plotArea.md),
[`plotBar()`](https://andrisignorell.github.io/aurora/reference/plotBar.md),
[`plotBox()`](https://andrisignorell.github.io/aurora/reference/plotBox.md),
[`plotCatDist()`](https://andrisignorell.github.io/aurora/reference/plotCatDist.md),
[`plotDens()`](https://andrisignorell.github.io/aurora/reference/plotDens.md),
[`plotDensBox()`](https://andrisignorell.github.io/aurora/reference/plotDensBox.md),
[`plotDot()`](https://andrisignorell.github.io/aurora/reference/plotDot.md),
[`plotECDF()`](https://andrisignorell.github.io/aurora/reference/plotECDF.md),
[`plotFdist()`](https://andrisignorell.github.io/aurora/reference/plotFdist.md),
[`plotQQ()`](https://andrisignorell.github.io/aurora/reference/plotQQ.md),
[`plotViolin()`](https://andrisignorell.github.io/aurora/reference/plotViolin.md)

## Examples

``` r
m <- matrix(c(3,4,5,1,5,4,2,6,2), nrow = 3,
            dimnames = list(
              dose = c("A","B","C"),
              age  = c("2000","2001","2002")
            ))

plotLines(m, lwd = 2, main = "Dose ~ Age")


# with points
plotLines(m, points = TRUE)


# custom legend
plotLines(m, legend = list(cex = 0.8))

```
