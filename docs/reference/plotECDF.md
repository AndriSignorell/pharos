# Empirical Cumulative Distribution Function

Fast plotting of the empirical cumulative distribution function (ECDF),
designed to stay performant even for very large vectors (n ~ 1e6-1e7).

## Usage

``` r
plotECDF(x, ...)

# Default S3 method
plotECDF(
  x,
  main = NULL,
  xlab = NULL,
  ylab = "",
  xlim = NULL,
  breaks = 1000,
  add = FALSE,
  col = .useTheme,
  lwd = 2,
  grid = .useTheme,
  box = .useTheme,
  stamp = .useTheme,
  ...
)

# S3 method for class 'formula'
plotECDF(
  formula,
  data,
  subset,
  na.action = na.omit,
  main = NULL,
  xlab = NULL,
  ylab = "",
  xlim = NULL,
  breaks = 1000,
  col = .useTheme,
  lwd = 2,
  grid = .useTheme,
  box = .useTheme,
  legend = TRUE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  numeric vector of the observations for the ECDF.

- ...:

  further graphical parameters passed to
  [`par`](https://rdrr.io/r/graphics/par.html) via the internal
  framework.

- main:

  main title of the plot. `NULL` (default) derives a title from
  `deparse(substitute(x))`. `""`, `NA`, or `FALSE` suppress the title.

- xlab:

  label for the x-axis. `NULL` (default) derives a label the same way as
  `main`.

- ylab:

  label for the y-axis. The y-axis itself always shows fixed probability
  labels (`.00` to `1.00`); `ylab` adds an axis title above/beside
  those, empty by default.

- xlim:

  numeric vector of length 2; x-axis limits. `NULL` (default) uses
  `range(x)`.

- breaks:

  controls the rendered resolution. A single integer (default `1000`)
  subsamples the ECDF at that many evenly-spaced quantiles whenever
  `length(x)` exceeds it; for `length(x) <= breaks`, full resolution is
  used regardless (no data is ever thinned below its actual size).
  `NULL`, `FALSE`, or `Inf` force full resolution unconditionally,
  regardless of `length(x)`.

- add:

  logical; if `TRUE`, adds to an existing plot instead of starting a new
  one.

- col:

  color of the step line and the min/max marker points. `.useTheme`
  (default) resolves to `getTheme()$twin[1]` - a single accent color,
  consistent with
  [`lines.loess`](https://andrisignorell.github.io/aurora/reference/lines.loess.md)
  and
  [`plotQQ()`](https://andrisignorell.github.io/aurora/reference/plotQQ.md)'s
  confidence band.

- lwd:

  line width.

- grid:

  Controls drawing of the background grid (vertical lines at default
  tick positions, plus a fixed set of horizontal reference lines at the
  probability ticks `0`/`.25`/`.5`/`.75`/`1`

  - the latter always grey regardless of the active theme, a
    deliberately distinct look, not theme-driven). `.useTheme` (default)
    follows the active theme's grid on/off state (`getTheme()$grid`).
    `TRUE`/`FALSE`/`NA`, or a named list, as for
    [`grid`](https://rdrr.io/r/graphics/grid.html).

- box:

  Controls drawing of the plot box. `.useTheme` (default) resolves to
  `getTheme()$box`. `TRUE`/`FALSE`/`NA`, or a named list, as for
  [`box`](https://rdrr.io/r/graphics/box.html).

- stamp:

  Controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, a string, or a named list
  of arguments for
  [`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md).

- formula:

  a formula of the form `y ~ x`.

- data:

  an optional data frame containing variables in the formula.

- subset:

  optional expression indicating which observations to use.

- na.action:

  a function specifying how missing values are handled. Defaults to
  `na.omit`.

- legend:

  Logical or list controlling the legend. If `TRUE`, a legend is drawn
  using the column names of the data. If a list is supplied, its
  elements are passed to the internal legend drawing routine.

## Value

Invisibly returns `NULL`.

## Details

The base
[`plot.ecdf`](https://rdrr.io/r/stats/ecdf.html)/[`ecdf`](https://rdrr.io/r/stats/ecdf.html)
machinery becomes impractically slow well below `n = 1e7`, since it
tracks every single jump. Beyond a few thousand points, individual jumps
are visually indistinguishable anyway, so `plotECDF()` caps the rendered
resolution at `breaks` points by default.

Resolution is achieved via quantile subsampling, not histogram binning:
`breaks` evenly-spaced probability points are mapped back to their
corresponding quantiles
([`quantile`](https://rdrr.io/r/stats/quantile.html), `type = 7`). Each
rendered point therefore lies exactly on the true ECDF - unlike an
equal-width-histogram approximation, this adapts automatically to the
shape of the distribution (no resolution is wasted on near-empty bins in
a skewed or heavy-tailed distribution, nor lost in the tails).

## See also

[`plot.ecdf`](https://rdrr.io/r/stats/ecdf.html),
[`plotFdist`](https://andrisignorell.github.io/aurora/reference/plotFdist.md),
[`getTheme`](https://andrisignorell.github.io/aurora/reference/getTheme.md)

Other plot.univariate:
[`plotArea()`](https://andrisignorell.github.io/aurora/reference/plotArea.md),
[`plotBar()`](https://andrisignorell.github.io/aurora/reference/plotBar.md),
[`plotBox()`](https://andrisignorell.github.io/aurora/reference/plotBox.md),
[`plotCatDist()`](https://andrisignorell.github.io/aurora/reference/plotCatDist.md),
[`plotDens()`](https://andrisignorell.github.io/aurora/reference/plotDens.md),
[`plotDensBox()`](https://andrisignorell.github.io/aurora/reference/plotDensBox.md),
[`plotDot()`](https://andrisignorell.github.io/aurora/reference/plotDot.md),
[`plotFdist()`](https://andrisignorell.github.io/aurora/reference/plotFdist.md),
[`plotLines()`](https://andrisignorell.github.io/aurora/reference/plotLines.md),
[`plotQQ()`](https://andrisignorell.github.io/aurora/reference/plotQQ.md),
[`plotViolin()`](https://andrisignorell.github.io/aurora/reference/plotViolin.md)

## Examples

``` r
plotECDF(faithful$eruptions)


# large vector - automatically thinned to 1000 points, no breaks= needed
x <- rnorm(1e6)
plotECDF(x)


# force full resolution regardless of size
plotECDF(x, breaks = NULL)


# grouped ECDFs via the formula interface
plotECDF(Sepal.Length ~ Species, data = iris)

```
