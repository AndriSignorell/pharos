# Plot a Web of Connected Points

Displays a symmetric matrix (typically a correlation matrix) as a
network diagram: variables are placed equidistantly around a circle, and
connecting lines between each pair are drawn with width proportional to
the absolute value of the matrix entry and color indicating its sign.

## Usage

``` r
plotWeb(
  m,
  main = NULL,
  dist = 0.5,
  col = hcol("red", "blue"),
  lty = NULL,
  lwd = NULL,
  labels = TRUE,
  points = list(pch = 21, cex = 2, col = "black", bg = "darkgrey"),
  legend = TRUE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- m:

  a symmetric numeric matrix (e.g. a correlation matrix).

- main:

  main title of the plot. `NULL` (default) produces no title.

- dist:

  distance of node labels from the outer circle. Default `0.5`.

- col:

  two colors for the connecting lines: the first is used for negative
  values, the second for positive values. `.useTheme` (default) resolves
  to `getTheme()$twin` - consistent with the sign-based coloring in
  [`plotCor`](https://andrisignorell.github.io/aurora/reference/plotCor.md).

- lty:

  line type for the connecting lines. `NULL` (default) inherits from
  `par("lty")`.

- lwd:

  line widths for the connecting lines. `NULL` (default) scales widths
  linearly between 0.5 and 10 in proportion to the absolute matrix
  values.

- labels:

  controls node labels around the circle. `TRUE` (default) draws labels
  using `colnames(m)` with default styling. `FALSE`/`NA`/`NULL`
  suppresses labels. A named list overrides individual settings:

  `labels`

  :   character vector of label texts; defaults to `colnames(m)`

  `las`

  :   orientation: `1` horizontal (default), `2` radial, `3` vertical

  `adj`

  :   label adjustment (0/0.5/1); `NULL` (default) chooses automatically
      based on position around the circle

  `cex`

  :   character expansion; default `1.0`

- points:

  controls the node point symbols. The default
  (`list(pch=21, cex=2, col="black", bg="darkgrey")`) draws prominent
  filled circles, larger than the generic data-point default, since
  nodes represent variables rather than observations.
  `FALSE`/`NA`/`NULL` suppresses the points. A named list overrides
  individual elements (`pch`, `cex`, `col`, `bg`).

- legend:

  controls the legend. `TRUE` (default) draws a legend showing the line
  widths and colors for the minimum/maximum positive and negative
  values. `FALSE`/`NA` suppresses it. A named list overrides arguments
  forwarded to [`legend`](https://rdrr.io/r/graphics/legend.html).

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for
  [`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md).

- ...:

  further graphical parameters passed to
  [`par`](https://rdrr.io/r/graphics/par.html) and to the internal
  [`canvas()`](https://andrisignorell.github.io/aurora/reference/canvas.md)
  call.

## Value

Invisibly returns a list of `x`/`y` coordinates of the node points,
useful for adding further annotations to the plot.

## Details

The function uses the lower triangular matrix of `m`; when overriding
`lwd` or `col` manually, values must be supplied in the same order as
`m[lower.tri(m)]`.

## See also

[`plotCor`](https://andrisignorell.github.io/aurora/reference/plotCor.md),
[`getTheme`](https://andrisignorell.github.io/aurora/reference/getTheme.md)

Other plot.special:
[`plotBinaryTree()`](https://andrisignorell.github.io/aurora/reference/binaryTree.md),
[`plotCirc()`](https://andrisignorell.github.io/aurora/reference/plotCirc.md),
[`plotMiss()`](https://andrisignorell.github.io/aurora/reference/plotMiss.md),
[`plotPolar()`](https://andrisignorell.github.io/aurora/reference/plotPolar.md),
[`plotPropCI()`](https://andrisignorell.github.io/aurora/reference/plotPropCI.md),
[`plotTernary()`](https://andrisignorell.github.io/aurora/reference/plotTernary.md),
[`plotTimeSeries()`](https://andrisignorell.github.io/aurora/reference/plotTimeSeries.md),
[`plotTreemap()`](https://andrisignorell.github.io/aurora/reference/plotTreemap.md)

## Examples

``` r
m <- cor(swiss)
plotWeb(m, main = "Swiss correlation")


# custom labels (abbreviations)
plotWeb(m, labels = list(labels = abbreviate(colnames(m), 4), cex = 0.9))


# show only significant correlations
p <- outer(
  (vars <- colnames(mtcars)), vars,
  Vectorize(function(v1, v2)
    cor.test(mtcars[[v1]], mtcars[[v2]])$p.value)
)
dimnames(p) <- list(vars, vars)
m2 <- cor(mtcars)
m2[p > 0.05] <- NA
plotWeb(m2, labels = list(las = 2))

```
