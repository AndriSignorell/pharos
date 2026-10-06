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
  groups = NULL,
  main = NULL,
  xlab = "",
  ylab = "",
  xlim = NULL,
  heights = c(2, 1.4),
  col = NULL,
  grid = TRUE,
  dens = TRUE,
  box = TRUE,
  stamp = .useTheme,
  ...
)

# S3 method for class 'formula'
plotDensBox(
  formula,
  data,
  subset,
  na.action = na.omit,
  main = NULL,
  xlab = "",
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

- groups:

  optional grouping variable (ignored if a formula is used).

- main:

  main title of the plot. `NULL` (default) derives the title from the
  input: the formula, or `x` resp. `x ~ g` for the default method. `""`,
  `NA`, or `FALSE` suppress the title and its outer margin.

- xlab:

  label for the x-axis, drawn below the boxplot. For the formula method,
  an empty label defaults to the response.

- ylab:

  label for the y-axis of the density panel.

- xlim:

  numeric vector of length 2 specifying the x-axis limits. `NULL`
  (default) covers the data and the tails of the densities.

- heights:

  numeric vector of length 2 specifying the relative heights of the
  density plot (top) and boxplot (bottom).

- col:

  vector of colors, recycled over the groups. If `NULL`, a palette is
  generated.

- grid:

  controls drawing of the background grid. Can be:

  - `TRUE`: draw grid with default settings

  - `FALSE`, `NULL`, `NA`: suppress grid

  - a named list: arguments passed to
    [`graphics::grid()`](https://rdrr.io/r/graphics/grid.html)

- dens:

  controls density estimation via
  [`stats::density()`](https://rdrr.io/r/stats/density.html). Can be:

  - `TRUE`: use default density settings

  - `FALSE`, `NULL`, `NA`: suppress densities

  - a named list: additional arguments passed to
    [`stats::density()`](https://rdrr.io/r/stats/density.html)

- box:

  controls drawing of boxplots via
  [`graphics::boxplot()`](https://rdrr.io/r/graphics/boxplot.html). Can
  be:

  - `TRUE`: use default boxplot settings

  - `FALSE`, `NULL`, `NA`: suppress boxplots

  - a named list: additional arguments passed to
    [`graphics::boxplot()`](https://rdrr.io/r/graphics/boxplot.html)

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, a string, or a named list
  for [`stamp()`](stamp.md).

- formula:

  a formula of the form `y ~ group`, or `y ~ a:b` for the cells of
  several grouping variables. `y ~ a + b` is not accepted, see
  [`bedrock::resolveFormula()`](https://andrisignorell.github.io/bedrock/reference/resolveFormula.html).

- data:

  an optional data frame containing the variables in the formula.

- subset:

  an optional expression indicating which observations to use, evaluated
  in `data` (`subset = len > 10`), as in
  [`boxplot()`](https://rdrr.io/r/graphics/boxplot.html).

- na.action:

  a function specifying how missing values are handled, defaults to
  [`na.omit()`](https://rdrr.io/r/stats/na.fail.html).

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
[`plotFreqDist()`](plotFreqDist.md), [`plotLines()`](plotLines.md),
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
  dens = list(adjust = 2),
  box  = list(notch = TRUE)
)

plotDensBox(
  x,
  box = FALSE
)

plotDensBox(x ~ g)

# subset and the cells of two grouping variables
plotDensBox(len ~ supp:dose, ToothGrowth, subset = dose > 0.5)
} # }
```
