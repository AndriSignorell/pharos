# Circular Chord Diagram

Draws a circular chord diagram from a matrix, showing flows between rows
and columns using sectors and ribbons. The plot is rendered using base
graphics and supports flexible styling via object-based arguments.

## Usage

``` r
plotCirc(
  x,
  sector = TRUE,
  ribbon = TRUE,
  labels = TRUE,
  gap = 5,
  main = NULL,
  ...
)
```

## Arguments

- x:

  A numeric matrix. Rows and columns define the connections between
  sectors.

- sector:

  Sector styling. Can be:

  - a logical (`TRUE`/`FALSE`) to enable/disable sectors,

  - a vector of colors,

  - or a list with elements `col` and `border`.

  Colors are recycled to match the number of sectors
  (`nrow(x) + ncol(x)`).

- ribbon:

  Ribbon styling. Can be:

  - a logical (`TRUE`/`FALSE`) to enable/disable ribbons,

  - a vector of colors,

  - or a list with elements `col` and `border`.

  Colors are recycled to match the number of row categories (`nrow(x)`).

- labels:

  Label styling. Can be:

  - a logical (`TRUE`/`FALSE`) to enable/disable labels,

  - a character vector of labels,

  - or a list with parameters passed to internal label drawing.

- gap:

  Numeric. Gap between sectors in degrees.

- main:

  Character. Main title of the plot.

- ...:

  Additional graphical parameters passed to internal plotting functions.

## Value

Invisibly returns a list with label positions:

- x:

  x-coordinates of labels

- y:

  y-coordinates of labels

## Details

The function constructs a circular layout where:

- Columns of `x` are placed on one half of the circle

- Rows of `x` are placed on the opposite half

- Ribbon widths are proportional to matrix entries

Sector sizes correspond to marginal sums of the matrix.

Internally, angles are computed in radians and mapped to Cartesian
coordinates.

## See also

Other plot.special:
[`plotBinaryTree()`](https://andrisignorell.github.io/lyra/reference/binaryTree.md),
[`plotMiss()`](https://andrisignorell.github.io/lyra/reference/plotMiss.md),
[`plotPolar()`](https://andrisignorell.github.io/lyra/reference/plotPolar.md),
[`plotPropCI()`](https://andrisignorell.github.io/lyra/reference/plotPropCI.md),
[`plotTernary()`](https://andrisignorell.github.io/lyra/reference/plotTernary.md),
[`plotTimeSeries()`](https://andrisignorell.github.io/lyra/reference/plotTimeSeries.md),
[`plotTreemap()`](https://andrisignorell.github.io/lyra/reference/plotTreemap.md),
[`plotWeb()`](https://andrisignorell.github.io/lyra/reference/plotWeb.md)

## Examples

``` r
set.seed(1)
x <- matrix(sample(1:10, 36, replace = TRUE), nrow = 6)
rownames(x) <- LETTERS[1:6]
colnames(x) <- LETTERS[1:6]

plotCirc(x)


# Custom colors
plotCirc(
  x,
  sector = list(col = rainbow(12), border = "grey50"),
  ribbon = list(col = rainbow(6), border = NA)
)
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character
#> Warning: supplied color is neither numeric nor character


# Custom labels
plotCirc(
  x,
  labels = list(cex = 0.8, col = "blue", las = 2)
)

```
