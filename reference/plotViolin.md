# Violin Plot

Draws violin plots for one or more groups, combining kernel density
estimation with optional boxplot overlays. The function follows a
boxplot-like interface and supports both default and formula methods.

## Usage

``` r
plotViolin(x, ...)

# Default S3 method
plotViolin(
  x,
  ...,
  main = NULL,
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL,
  horizontal = FALSE,
  at = NULL,
  names = NULL,
  add = FALSE,
  bw = "nrd0",
  trim = TRUE,
  col = "grey80",
  border = "black",
  lwd = 1,
  box = TRUE,
  grid = NA,
  quantiles = NULL,
  stamp = .useTheme
)

# S3 method for class 'formula'
plotViolin(
  formula,
  data,
  subset,
  na.action = na.omit,
  ...,
  main = NULL,
  xlab = "",
  ylab = "",
  horizontal = FALSE,
  names = NULL
)
```

## Arguments

- x:

  numeric vector, list of numeric vectors, or first group.

- ...:

  additional data vectors (unnamed) or graphical parameters passed to
  [`par()`](https://rdrr.io/r/graphics/par.html).

- main:

  main title. `NULL` (default) derives the title from the input: the
  names of the data arguments, or the formula. `""`, `NA`, or `FALSE`
  suppress the title and compact the top margin.

- xlab, ylab:

  axis labels. For the formula method, empty labels default to the
  grouping variable and the response.

- xlim, ylim:

  axis limits. `NULL` (default) uses the range of the densities, padded
  by 2%; given limits are used as they are.

- horizontal:

  logical; if `TRUE`, draws horizontal violins.

- at:

  numeric positions of the groups.

- names:

  optional group labels.

- add:

  logical; if `TRUE`, adds to an existing plot.

- bw:

  bandwidth specification passed to
  [`density()`](https://rdrr.io/r/stats/density.html).

- trim:

  logical. If `TRUE` (default), the kernel density estimate of each
  group is restricted to the observed data range (`from = min(x)`,
  `to = max(x)`), so the violin never extends beyond the actual data —
  matching the default behavior of `ggplot2::geom_violin()`. If `FALSE`,
  [`density()`](https://rdrr.io/r/stats/density.html) is called with its
  own defaults, which extend the tails up to `cut * bw` beyond
  `range(x)` and may produce violins that reach into implausible values
  (e.g. scores above 100 or below 0).

- col:

  fill color(s) of the violins.

- border:

  border color(s) of the violins.

- lwd:

  line width for violin borders.

- box:

  logical or list controlling the boxplot overlay (see Details).

- grid:

  logical, `NA`, or list controlling background grid.

- quantiles:

  optional numeric vector of probabilities for drawing quantile lines
  inside each violin.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, a string, or a named list
  for [`stamp()`](stamp.md).

- formula:

  a formula of the form `y ~ group`, or `y ~ a:b` for the cells of
  several grouping variables. `y ~ a + b` is not accepted (unlike
  [`boxplot()`](https://rdrr.io/r/graphics/boxplot.html)), see
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

The violin shape is constructed from a kernel density estimate of each
group, scaled to a fixed maximum width. Optionally, boxplots and
quantile lines can be added.

Graphical elements such as the boxplot overlay and grid are controlled
via a flexible interface using `TRUE`, `FALSE`, `NA`, or `list(...)` and
are evaluated using
[`bedrock::callIf()`](https://andrisignorell.github.io/bedrock/reference/callIf.html).

## Data Handling

The function accepts:

- a numeric vector

- multiple vectors via `...`

- a list of numeric vectors

Groups are handled similarly to
[`boxplot()`](https://rdrr.io/r/graphics/boxplot.html).

## See also

[`boxplot()`](https://rdrr.io/r/graphics/boxplot.html),
[`density()`](https://rdrr.io/r/stats/density.html)

Other plot.univariate: [`plotArea()`](plotArea.md),
[`plotBar()`](plotBar.md), [`plotBox()`](plotBox.md),
[`plotCatDist()`](plotCatDist.md), [`plotDens()`](plotDens.md),
[`plotDensBox()`](plotDensBox.md), [`plotDot()`](plotDot.md),
[`plotECDF()`](plotECDF.md), [`plotFdist()`](plotFdist.md),
[`plotLines()`](plotLines.md), [`plotQQ()`](plotQQ.md)

## Examples

``` r
set.seed(1)
x <- rnorm(100)
y <- rnorm(100, 1)

plotViolin(x, y)


# horizontal violins
plotViolin(x, y, horizontal = TRUE)


# with quantiles
plotViolin(x, y, quantiles = c(0.25, 0.5, 0.75))


# untrimmed: tails extend beyond the observed data range
plotViolin(x, y, trim = FALSE)


# custom styling
plotViolin(x, y,
  col = c("lightblue", "salmon"),
  box = list(col = "white"),
  grid = TRUE
)


# formula interface
df <- data.frame(
  value = rnorm(200),
  group = rep(letters[1:4], each = 50)
)

plotViolin(value ~ group, data = df)


# subset and the cells of two grouping variables
plotViolin(len ~ supp:dose, ToothGrowth, subset = len > 8)

```
