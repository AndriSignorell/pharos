# Bubble Plot

Draws a bubble plot where the position is given by `x` and `y`, and the
size of each bubble increases with `area`.

## Usage

``` r
plotBubble(x, ...)

# Default S3 method
plotBubble(
  x,
  y,
  area,
  main = "",
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL,
  add = FALSE,
  col = NA,
  border = NULL,
  cex = 1,
  grid = NA,
  na.rm = FALSE,
  stamp = .useTheme,
  ...
)

# S3 method for class 'formula'
plotBubble(
  formula,
  data = NULL,
  subset,
  na.action = na.omit,
  main = "",
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL,
  add = FALSE,
  col = NA,
  border = NULL,
  cex = 1,
  grid = NA,
  ...
)
```

## Arguments

- x:

  numeric vector of x positions.

- ...:

  additional graphical parameters passed to
  [`par()`](https://rdrr.io/r/graphics/par.html).

- y:

  numeric vector of y positions.

- area:

  non-negative numeric vector controlling the bubble sizes.

- main, xlab, ylab:

  plot labels.

- xlim, ylim:

  axis limits.

- add:

  logical; if `TRUE`, adds to an existing plot.

- col:

  fill color(s) of the bubbles.

- border:

  border color(s) of the bubbles.

- cex:

  scaling factor applied to the bubble radii.

- grid:

  logical, `NA`, or list controlling background grid.

- na.rm:

  logical. Observations with a missing `x`, `y` or `area` cannot be
  drawn and are always omitted; with `na.rm = FALSE` (default) a warning
  reports how many. Missing colors are not missing data, `NA` draws
  transparent.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for [`stamp()`](stamp.md).

- formula:

  A formula of the form `y ~ x | area`.

- data:

  optional data frame.

- subset:

  optional subset expression, evaluated in `data`.

- na.action:

  function to handle missing values, defaults to
  [`na.omit()`](https://rdrr.io/r/stats/na.fail.html).

## Value

Invisibly, a data frame with one row per drawn bubble and the columns
`x`, `y`, `area`, `col`, `border`, and the radii `rx`, `ry` in user
coordinates, sorted by decreasing area.

## Details

The function supports both a default interface and a formula interface
of the form `y ~ x | area`.

The bubble radii are scaled relative to the largest area: the largest
bubble gets a radius of `0.35 * cex` inches, the others \\r = 0.35 \cdot
cex \cdot (area / \max(area))^{0.4}\\. The exponent 0.4 (instead of 0.5
for strictly area-proportional circles) dampens the size differences, so
that small bubbles remain visible. Radii are converted to user
coordinates separately for both axes, so the bubbles are drawn as
circles regardless of the aspect ratio.

Bubbles are drawn in order of decreasing area, so small bubbles are not
hidden behind large ones.

Graphical elements such as grids are controlled via the unified plot
design system using
[`bedrock::callIf()`](https://andrisignorell.github.io/bedrock/reference/callIf.html)
and `.theme()`.

## See also

[`symbols()`](https://rdrr.io/r/graphics/symbols.html)

Other plot.bivariate: [`plotAssoc()`](plotAssoc.md),
[`plotBag()`](plotBag.md), [`plotCor()`](plotCor.md),
[`plotDens2D()`](plotDens2D.md), [`plotHeatmap()`](plotHeatmap.md),
[`plotHexbin()`](plotHexbin.md), [`plotMosaic()`](plotMosaic.md),
[`plotXY()`](plotXY.md)

## Examples

``` r
set.seed(1)
x <- rnorm(100)
y <- rnorm(100)
a <- runif(100, 1, 10)

plotBubble(x, y, a)


df <- data.frame(x = x, y = y, a = a)
plotBubble(y ~ x | a, data = df)


US <- data.frame(state.x77, State=state.name,
                   Region=state.region, Abb=state.abb)
plotBubble(Income ~ Population | Area ,
           data=US,
           grid=TRUE, col=addOpacity(pal("helsana")[US$Region]), cex=1.2 )

text(Income ~ Population, US, labels=US$Abb, cex=0.8)

```
