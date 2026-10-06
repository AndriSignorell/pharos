# Polar Plot for Radial Data

Creates a polar coordinate plot for one or multiple radial series.

## Usage

``` r
plotPolar(
  r,
  theta = NULL,
  main = NULL,
  rlim = NULL,
  type = "p",
  add = FALSE,
  col = NULL,
  border = NULL,
  stamp = .useTheme,
  ...
)
```

## Arguments

- r:

  numeric vector or matrix of radial values. Each row represents one
  series.

- theta:

  optional numeric vector or matrix of angles (in radians). Must match
  the dimensions of `r`. If `NULL`, equally spaced angles are used.

- main:

  optional plot title.

- rlim:

  numeric limit for radial axis. If `NULL`, determined automatically.

- type:

  character vector specifying plot type for each series:

  "p"

  :   points

  "l"

  :   polygon (connected and optionally filled)

  "h"

  :   radial segments ("histogram"-style)

- add:

  logical; if `TRUE`, adds to an existing plot.

- col:

  color for points/lines.

- border:

  color for border in case of type `polygon`.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for [`stamp()`](stamp.md).

- ...:

  additional graphical parameters passed to base plotting functions.

## Value

Invisibly returns `NULL`.

## Details

The function supports plotting multiple radial series simultaneously.
Each row of `r` is treated as a separate series.

Angles are interpreted in radians. If `theta` is not provided, points
are distributed evenly over \\\[0, 2\pi)\\.

Graphical parameters such as `lwd`, `lty`, `pch`, `cex`, `fill`, and
`mar` can be passed via `...`.

## See also

Other plot.special: [`plotBinaryTree()`](binaryTree.md),
[`plotCirc()`](plotCirc.md), [`plotLift()`](plotLift.md),
[`plotMiss()`](plotMiss.md), [`plotPropCI()`](plotPropCI.md),
[`plotTernary()`](plotTernary.md),
[`plotTimeSeries()`](plotTimeSeries.md),
[`plotTreemap()`](plotTreemap.md), [`plotWeb()`](plotWeb.md)

## Examples

``` r
r <- matrix(runif(20), nrow = 2)
plotPolar(r, type = c("l", "p"), col = c("blue", "red"))
#> Warning: 'x' is NULL so the result will be NULL


# with custom angles
theta <- seq(0, 2*pi, length.out = 10)
plotPolar(r[1,], theta = theta, type = "h")
#> Warning: 'x' is NULL so the result will be NULL
#> Warning: 'x' is NULL so the result will be NULL

```
