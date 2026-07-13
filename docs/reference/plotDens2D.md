# Two-Dimensional Kernel Density Plot

Computes a two-dimensional kernel density estimate and visualises it
using contour, image, or perspective plots.

## Usage

``` r
plotDens2D(
  x,
  y,
  main = NULL,
  xlab = NULL,
  ylab = NULL,
  xlim = NULL,
  ylim = NULL,
  type = c("contour", "image", "persp"),
  col = rev(pal("red-black", n = 100)),
  grid = .useTheme,
  box = .useTheme,
  ...
)
```

## Arguments

- x:

  numeric vector of x-coordinates.

- y:

  numeric vector of y-coordinates. Must have the same length as `x`.

- main:

  optional main title of the plot.

- xlab, ylab:

  axis labels.

- xlim, ylim:

  numeric vectors of length two specifying axis limits.

- type:

  character string specifying the plot type. One of `"contour"`,
  `"image"`, or `"persp"`.

- col:

  color specification used for `type = "image"`. Defaults to a reversed
  `"red-black"` sequential ramp
  ([`pal()`](https://andrisignorell.github.io/aurora/reference/pal.md)),
  running from black (low density) to red (high density) - hardcoded
  rather than theme-driven, since this is a continuous, unidirectional
  gradient, unlike the active theme's categorical `palette` or diverging
  `twin` pair, neither of which fits a density surface.

- grid:

  controls drawing of the background grid. `.useTheme` (default) follows
  the active theme (`getTheme()$grid`). `TRUE`/`FALSE`/`NA`, or a named
  list, as for [`grid`](https://rdrr.io/r/graphics/grid.html).

- box:

  controls drawing of the plot box. `.useTheme` (default) resolves to
  `getTheme()$box`. `TRUE`/`FALSE`/`NA`, or a named list, as for
  [`box`](https://rdrr.io/r/graphics/box.html).

- ...:

  additional graphical parameters passed to underlying plotting
  functions.

## Value

Invisibly returns the result of the selected plotting call. Typically a
list containing grid coordinates and estimated density values.

## Details

The function estimates a bivariate density surface using a Gaussian
kernel with bandwidths determined via a normal reference rule. The
density is evaluated on a regular grid and visualised using one of three
base graphics representations:

- `"contour"`: contour lines of equal density

- `"image"`: raster representation of the density surface

- `"persp"`: three-dimensional perspective plot

The choice of representation affects interpretability: contour and image
plots emphasise structure in the data distribution, while perspective
plots highlight global shape but may distort local density.

Bandwidth selection follows a rule-of-thumb approach based on spread
(interquartile range and variance), which provides a reasonable default
for unimodal distributions but may oversmooth multimodal structures.

Missing or non-finite values are not allowed and will result in an
error.

## See also

Other plot.bivariate:
[`plotAssoc()`](https://andrisignorell.github.io/aurora/reference/plotAssoc.md),
[`plotBag()`](https://andrisignorell.github.io/aurora/reference/plotBag.md),
[`plotCor()`](https://andrisignorell.github.io/aurora/reference/plotCor.md),
[`plotHeatmap()`](https://andrisignorell.github.io/aurora/reference/plotHeatmap.md),
[`plotHexbin()`](https://andrisignorell.github.io/aurora/reference/plotHexbin.md),
[`plotMosaic()`](https://andrisignorell.github.io/aurora/reference/plotMosaic.md),
[`plotXY()`](https://andrisignorell.github.io/aurora/reference/plotXY.md)

## Examples

``` r
set.seed(1)
x <- rnorm(200)
y <- x + rnorm(200)

plotDens2D(x, y)


plotDens2D(x, y, type = "image")

```
