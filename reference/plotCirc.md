# Circular Chord Diagram

Draws a circular chord diagram from a matrix, showing flows between rows
and columns using sectors and ribbons. The plot is rendered using base
graphics and supports flexible styling via object-based arguments.

## Usage

``` r
plotCirc(
  x,
  main = NULL,
  gap = 5,
  sector = TRUE,
  ribbon = TRUE,
  labels = TRUE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  A numeric matrix. Rows and columns define the connections between
  sectors.

- main:

  character. Main title of the plot.

- gap:

  numeric. Gap between sectors in degrees.

- sector:

  sector styling. Can be:

  - a logical (`TRUE`/`FALSE`) to enable/disable sectors,

  - a vector of colors,

  - or a list with elements `col` and `border`.

  Colors are recycled to match the number of sectors
  (`nrow(x) + ncol(x)`). The sectors are filled in the order in which
  they are drawn: the columns of `x` first, then the rows, both in
  reverse order. `TRUE` (default) uses the qualitative palette of the
  active theme (see [theme](theme.md)) and grey borders.

- ribbon:

  ribbon styling. Can be:

  - a logical (`TRUE`/`FALSE`) to enable/disable ribbons,

  - a vector of colors,

  - or a list with elements `col` and `border`.

  Colors are recycled to match the number of row categories (`nrow(x)`).
  With `TRUE` (default) a ribbon takes the color of the row sector it
  starts from, made half transparent, and a grey border.

- labels:

  label styling. Can be:

  - a logical (`TRUE`/`FALSE`) to enable/disable labels,

  - a character vector of labels, for the rows followed by the columns
    of `x`,

  - or a list with parameters passed to internal label drawing
    (`labels`, `cex`, `col`, `las`, `adj`).

  `TRUE` (default) uses the row and column names of `x`.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for [`stamp()`](stamp.md).

- ...:

  additional graphical parameters passed to internal plotting functions.

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

Other plot.special: [`plotBinaryTree()`](binaryTree.md),
[`plotLift()`](plotLift.md), [`plotMiss()`](plotMiss.md),
[`plotPolar()`](plotPolar.md), [`plotPropCI()`](plotPropCI.md),
[`plotTernary()`](plotTernary.md),
[`plotTimeSeries()`](plotTimeSeries.md),
[`plotTreemap()`](plotTreemap.md), [`plotWeb()`](plotWeb.md)

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


# Custom labels
plotCirc(
  x,
  labels = list(cex = 0.8, col = "blue", las = 2)
)

```
