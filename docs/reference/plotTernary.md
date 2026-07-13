# Ternary Plot

Draws a ternary plot for compositional data consisting of three
non-negative components per observation. Each row is interpreted as a
composition and internally rescaled to sum to 1 if necessary.

## Usage

``` r
plotTernary(
  x,
  y = NULL,
  z = NULL,
  ...,
  add = FALSE,
  col = NULL,
  pch = 16,
  cex = 1,
  grid = NA,
  lbl = NULL,
  main = "",
  xlim = c(-1, 1),
  ylim = c(-0.5, 1)
)
```

## Arguments

- x:

  A numeric vector, matrix, or data frame. If `y` and `z` are provided,
  `x`, `y`, and `z` are combined into a matrix. Otherwise, `x` must
  contain exactly three columns.

- y:

  optional numeric vector for the second component.

- z:

  optional numeric vector for the third component.

- ...:

  additional graphical parameters passed to
  [`par()`](https://rdrr.io/r/graphics/par.html).

- add:

  logical; if `TRUE`, adds to an existing plot.

- col:

  point color(s).

- pch:

  plotting symbol.

- cex:

  point size.

- grid:

  logical, `NA`, or list controlling the ternary grid.

- lbl:

  character vector of length 3 specifying axis labels.

- main:

  plot title.

- xlim, ylim:

  plot limits (usually left at defaults).

## Value

Invisibly returns `NULL`.

## Details

A ternary plot represents three-part compositions on an equilateral
triangle. Each observation \\(x_1, x_2, x_3)\\ is mapped to 2D
coordinates using barycentric transformation. If rows do not sum to 1,
they are automatically normalized with a warning.

Graphical elements such as grids are controlled via the unified plot
design system using
[`bedrock::callIf()`](https://rdrr.io/pkg/bedrock/man/callIf.html) and
`.theme()`.

## See also

[`plotDens`](https://andrisignorell.github.io/aurora/reference/plotDens.md),
[`plotRidge`](https://andrisignorell.github.io/aurora/reference/plotRidge.md)

Other plot.special:
[`plotBinaryTree()`](https://andrisignorell.github.io/aurora/reference/binaryTree.md),
[`plotCirc()`](https://andrisignorell.github.io/aurora/reference/plotCirc.md),
[`plotMiss()`](https://andrisignorell.github.io/aurora/reference/plotMiss.md),
[`plotPolar()`](https://andrisignorell.github.io/aurora/reference/plotPolar.md),
[`plotPropCI()`](https://andrisignorell.github.io/aurora/reference/plotPropCI.md),
[`plotTimeSeries()`](https://andrisignorell.github.io/aurora/reference/plotTimeSeries.md),
[`plotTreemap()`](https://andrisignorell.github.io/aurora/reference/plotTreemap.md),
[`plotWeb()`](https://andrisignorell.github.io/aurora/reference/plotWeb.md)

## Examples

``` r
set.seed(1)
x <- runif(100)
y <- runif(100)
z <- runif(100)

plotTernary(x, y, z)
#> Warning: rows are rescaled to sum to 1


# matrix input
M <- cbind(x, y, z)
plotTernary(M, lbl = c("A", "B", "C"))
#> Warning: rows are rescaled to sum to 1

```
