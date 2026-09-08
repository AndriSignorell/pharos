# Density and Boxplot Combination (Grouped)

Combines density plots and horizontal boxplots for a numeric variable,
optionally grouped by a categorical variable. The density plot shows the
distribution shape, while the boxplot summarizes key statistics such as
median, spread, and outliers.

## Usage

``` r
plotDensBox(x, ...)

# Default S3 method
plotDensBox(
  x,
  g = NULL,
  main = "",
  xlab = "",
  ylab = "",
  xlim = NULL,
  layout_heights = c(2, 1.4),
  col = NULL,
  grid = TRUE,
  densArgs = TRUE,
  boxArgs = TRUE,
  stamp = NULL,
  ...
)

# S3 method for class 'formula'
plotDensBox(
  formula,
  data,
  subset,
  na.action = na.omit,
  main = "",
  xlab = "",
  ylab = "",
  xlim = NULL,
  layout_heights = c(2, 1.4),
  col = NULL,
  grid = TRUE,
  densArgs = TRUE,
  boxArgs = TRUE,
  stamp = NULL,
  ...
)
```

## Arguments

- x:

  numeric vector, or a formula of the form `x ~ g`.

- ...:

  further graphical parameters passed to
  [`graphics::par()`](https://rdrr.io/r/graphics/par.html) via the
  internal framework.

- g:

  optional grouping variable (ignored if a formula is used).

- main:

  main title of the plot.

- xlab:

  label for the x-axis.

- ylab:

  label for the y-axis.

- xlim:

  numeric vector of length 2 specifying the x-axis limits.

- layout_heights:

  numeric vector of length 2 specifying the relative heights of the
  density plot (top) and boxplot (bottom).

- col:

  vector of colors. If `NULL`, a palette is generated.

- grid:

  controls drawing of the background grid. Can be:

  - `TRUE`: draw grid with default settings

  - `FALSE`, `NULL`, `NA`: suppress grid

  - a named list: arguments passed to
    [`graphics::grid()`](https://rdrr.io/r/graphics/grid.html)

- densArgs:

  controls density estimation via
  [`stats::density()`](https://rdrr.io/r/stats/density.html). Can be:

  - `TRUE`: use default density settings

  - `FALSE`, `NULL`, `NA`: suppress densities

  - a named list: additional arguments passed to
    [`stats::density()`](https://rdrr.io/r/stats/density.html)

- boxArgs:

  controls drawing of boxplots via
  [`graphics::boxplot()`](https://rdrr.io/r/graphics/boxplot.html). Can
  be:

  - `TRUE`: use default boxplot settings

  - `FALSE`, `NULL`, `NA`: suppress boxplots

  - a named list: additional arguments passed to
    [`graphics::boxplot()`](https://rdrr.io/r/graphics/boxplot.html)

- stamp:

  optional annotation passed to the plotting framework.

- formula:

  A formula of the form `y ~ group`.

- data:

  an optional data frame containing variables in the formula.

- subset:

  optional expression indicating which observations to use.

- na.action:

  a function specifying how missing values are handled.

## Value

Invisibly returns `NULL`.

## Details

The function arranges two plots vertically using
[`layout()`](https://rdrr.io/r/graphics/layout.html): a density plot on
top and a horizontal boxplot below. When a grouping variable is
provided, densities and boxplots are drawn for each group.

Optional plot components are controlled using
[`bedrock::callIf()`](https://andrisignorell.github.io/bedrock/reference/callIf.html)
semantics:

- `TRUE`: draw with defaults

- `FALSE`: suppress component

- named list: customize component arguments

## See also

[`stats::density()`](https://rdrr.io/r/stats/density.html),
[`graphics::boxplot()`](https://rdrr.io/r/graphics/boxplot.html),
[`bedrock::callIf()`](https://andrisignorell.github.io/bedrock/reference/callIf.html)

Other plot.univariate: [`plotArea()`](plotArea.md),
[`plotBar()`](plotBar.md), [`plotBox()`](plotBox.md),
[`plotCatDist()`](plotCatDist.md), [`plotDens()`](plotDens.md),
[`plotDot()`](plotDot.md), [`plotECDF()`](plotECDF.md),
[`plotFdist()`](plotFdist.md), [`plotLines()`](plotLines.md),
[`plotQQ()`](plotQQ.md), [`plotViolin()`](plotViolin.md)

## Examples

``` r
if (FALSE) { # \dontrun{
set.seed(1)
x <- rnorm(100)
g <- sample(c("A", "B"), 100, TRUE)

plotDensBox(x)
plotDensBox(x, g)

plotDensBox(
  x,
  densArgs = list(adjust = 2),
  boxArgs  = list(notch = TRUE)
)

plotDensBox(
  x,
  boxArgs = FALSE
)

plotDensBox(x ~ g)
} # }
```
