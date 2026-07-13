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
  quantiles = NULL
)

# S3 method for class 'formula'
plotViolin(
  formula,
  data = NULL,
  subset,
  na.action = na.omit,
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
  quantiles = NULL
)
```

## Arguments

- x:

  numeric vector, list of numeric vectors, or first group.

- ...:

  additional data vectors (unnamed) or graphical parameters passed to
  [`par()`](https://rdrr.io/r/graphics/par.html).

- main, xlab, ylab:

  plot labels.

- xlim, ylim:

  axis limits.

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
  matching the default behavior of
  [`ggplot2::geom_violin()`](https://ggplot2.tidyverse.org/reference/geom_violin.html).
  If `FALSE`, [`density()`](https://rdrr.io/r/stats/density.html) is
  called with its own defaults, which extend the tails up to `cut * bw`
  beyond `range(x)` and may produce violins that reach into implausible
  values (e.g. scores above 100 or below 0).

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

- formula:

  A formula of the form y ~ group.

- data:

  optional data frame.

- subset:

  optional subset expression.

- na.action:

  function to handle missing values.

## Value

Invisibly returns `NULL`.

## Details

The violin shape is constructed from a kernel density estimate of each
group, scaled to a fixed maximum width. Optionally, boxplots and
quantile lines can be added.

Graphical elements such as the boxplot overlay and grid are controlled
via a flexible interface using `TRUE`, `FALSE`, `NA`, or `list(...)` and
are evaluated using
[`bedrock::callIf()`](https://rdrr.io/pkg/bedrock/man/callIf.html).

## Data Handling

The function accepts:

- a numeric vector

- multiple vectors via `...`

- a list of numeric vectors

Groups are handled similarly to
[`boxplot()`](https://rdrr.io/r/graphics/boxplot.html).

## See also

[`boxplot`](https://rdrr.io/r/graphics/boxplot.html),
[`density`](https://rdrr.io/r/stats/density.html)

Other plot.univariate:
[`plotArea()`](https://andrisignorell.github.io/aurora/reference/plotArea.md),
[`plotBar()`](https://andrisignorell.github.io/aurora/reference/plotBar.md),
[`plotBox()`](https://andrisignorell.github.io/aurora/reference/plotBox.md),
[`plotCatDist()`](https://andrisignorell.github.io/aurora/reference/plotCatDist.md),
[`plotDens()`](https://andrisignorell.github.io/aurora/reference/plotDens.md),
[`plotDensBox()`](https://andrisignorell.github.io/aurora/reference/plotDensBox.md),
[`plotDot()`](https://andrisignorell.github.io/aurora/reference/plotDot.md),
[`plotECDF()`](https://andrisignorell.github.io/aurora/reference/plotECDF.md),
[`plotFdist()`](https://andrisignorell.github.io/aurora/reference/plotFdist.md),
[`plotLines()`](https://andrisignorell.github.io/aurora/reference/plotLines.md),
[`plotQQ()`](https://andrisignorell.github.io/aurora/reference/plotQQ.md)

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

```
