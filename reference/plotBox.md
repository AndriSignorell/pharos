# Grouped Boxplot

Draws boxplots for a numeric variable, optionally grouped by a
categorical variable. Group means and a reference line for the overall
mean can optionally be overlaid.

## Usage

``` r
plotBox(x, ...)

# Default S3 method
plotBox(
  x,
  groups = NULL,
  main = NULL,
  xlab = "",
  ylab = "",
  ylim = NULL,
  col = NULL,
  grid = TRUE,
  means = TRUE,
  stamp = .useTheme,
  ...
)

# S3 method for class 'formula'
plotBox(
  formula,
  data,
  subset,
  na.action = na.omit,
  main = NULL,
  xlab = "",
  ylab = "",
  ...
)
```

## Arguments

- x:

  numeric vector, or a formula of the form `x ~ g`.

- ...:

  graphical parameters. Parameters recognized by the internal graphics
  framework are applied via
  [`par()`](https://rdrr.io/r/graphics/par.html); remaining arguments
  are forwarded to
  [`graphics::boxplot()`](https://rdrr.io/r/graphics/boxplot.html).

- groups:

  optional grouping variable (ignored if a formula is used).

- main:

  main title of the plot. `NULL` (default) derives the title from the
  input: the formula, or `x ~ g` for the default method. `""`, `NA`, or
  `FALSE` suppress the title and compact the top margin.

- xlab:

  label for the x-axis.

- ylab:

  label for the y-axis.

- ylim:

  numeric vector of length 2 specifying the y-axis limits. If `NULL`
  (default), the range of `x` is used.

- col:

  vector of fill colors, recycled over the groups. `NULL` (default) uses
  `"grey90"`.

- grid:

  controls drawing of the background grid. Can be:

  - `TRUE`: draw grid with default settings

  - `FALSE`, `NULL`, or `NA`: suppress grid

  - a named list: arguments passed to
    [`graphics::grid()`](https://rdrr.io/r/graphics/grid.html), e.g.
    `list(col = "red", nx = NA, ny = NULL)` for vertical lines only

- means:

  controls drawing of group means and an overall mean reference line.
  Can be:

  - `TRUE`: draw with default settings

  - `FALSE`, `NULL`, or `NA`: suppress

  - a named list: arguments passed to the internal means function.
    Supported arguments: `col`, `pch`, `cex`, `lcol`, `lty`, `lwd`.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, or an explicit string, as
  for [`.withGraphicsState()`](graphics-framework.md) (internal).

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

Optional plot components are controlled using
[`bedrock::callIf()`](https://andrisignorell.github.io/bedrock/reference/callIf.html)
semantics:

- `TRUE`: draw with defaults

- `FALSE`, `NULL`, or `NA`: suppress component

- named list: customize component arguments

## See also

[`graphics::boxplot()`](https://rdrr.io/r/graphics/boxplot.html),
[`bedrock::callIf()`](https://andrisignorell.github.io/bedrock/reference/callIf.html)

Other plot.univariate: [`plotArea()`](plotArea.md),
[`plotBar()`](plotBar.md), [`plotCatDist()`](plotCatDist.md),
[`plotDens()`](plotDens.md), [`plotDensBox()`](plotDensBox.md),
[`plotDot()`](plotDot.md), [`plotECDF()`](plotECDF.md),
[`plotFreqDist()`](plotFreqDist.md), [`plotLines()`](plotLines.md),
[`plotQQ()`](plotQQ.md), [`plotViolin()`](plotViolin.md)

## Examples

``` r
set.seed(1)
x <- rnorm(100)
g <- sample(c("A", "B"), 100, TRUE)

plotBox(x)

plotBox(x, g)


plotBox(x ~ g)


# data, subset and the cells of two grouping variables
plotBox(len ~ supp, ToothGrowth, subset = dose > 0.5)

plotBox(len ~ supp:dose, ToothGrowth)

```
