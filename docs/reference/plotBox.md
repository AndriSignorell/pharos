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
  g = NULL,
  main = NULL,
  xlab = "",
  ylab = "",
  ylim = NULL,
  col = NULL,
  grid = TRUE,
  means = TRUE,
  stamp = TRUE,
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
  ylim = NULL,
  col = NULL,
  grid = TRUE,
  stamp = TRUE,
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
  are forwarded to [`boxplot`](https://rdrr.io/r/graphics/boxplot.html).

- g:

  optional grouping variable (ignored if a formula is used).

- main:

  main title of the plot.

- xlab:

  label for the x-axis.

- ylab:

  label for the y-axis.

- ylim:

  numeric vector of length 2 specifying the y-axis limits. If `NULL`
  (default), the range of `x` is used.

- col:

  vector of colors. If `NULL`, a palette is generated automatically.

- grid:

  controls drawing of the background grid. Can be:

  - `TRUE`: draw grid with default settings

  - `FALSE`, `NULL`, or `NA`: suppress grid

  - a named list: arguments passed to
    [`grid`](https://rdrr.io/r/graphics/grid.html), e.g.
    `list(col = "red", nx = NA, ny = NULL)` for vertical lines only

- means:

  controls drawing of group means and an overall mean reference line.
  Can be:

  - `TRUE`: draw with default settings

  - `FALSE`, `NULL`, or `NA`: suppress

  - a named list: arguments passed to the internal means function.
    Supported arguments: `col`, `pch`, `cex`, `lcol`, `lty`, `lwd`.

- stamp:

  Controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, or an explicit string, as
  for `.withGraphicsState()` (internal).

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

Optional plot components are controlled using
[`callIf`](https://rdrr.io/pkg/bedrock/man/callIf.html) semantics:

- `TRUE`: draw with defaults

- `FALSE`, `NULL`, or `NA`: suppress component

- named list: customize component arguments

## See also

[`boxplot`](https://rdrr.io/r/graphics/boxplot.html),
[`callIf`](https://rdrr.io/pkg/bedrock/man/callIf.html)

Other plot.univariate:
[`plotArea()`](https://andrisignorell.github.io/lyra/reference/plotArea.md),
[`plotBar()`](https://andrisignorell.github.io/lyra/reference/plotBar.md),
[`plotCatDist()`](https://andrisignorell.github.io/lyra/reference/plotCatDist.md),
[`plotDens()`](https://andrisignorell.github.io/lyra/reference/plotDens.md),
[`plotDensBox()`](https://andrisignorell.github.io/lyra/reference/plotDensBox.md),
[`plotDot()`](https://andrisignorell.github.io/lyra/reference/plotDot.md),
[`plotECDF()`](https://andrisignorell.github.io/lyra/reference/plotECDF.md),
[`plotFdist()`](https://andrisignorell.github.io/lyra/reference/plotFdist.md),
[`plotLines()`](https://andrisignorell.github.io/lyra/reference/plotLines.md),
[`plotQQ()`](https://andrisignorell.github.io/lyra/reference/plotQQ.md),
[`plotViolin()`](https://andrisignorell.github.io/lyra/reference/plotViolin.md)

## Examples

``` r
if (FALSE) { # \dontrun{
set.seed(1)
x <- rnorm(100)
g <- sample(c("A", "B"), 100, TRUE)

plotBox(x)
plotBox(x, g)

plotBox(x ~ g)
} # }
```
