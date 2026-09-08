# Grouped Density Plot

Draws kernel density estimates for one or more groups. Supports both
classical density plots and conditional density plots.

## Usage

``` r
plotDens(x, ...)

# S3 method for class 'formula'
plotDens(
  formula,
  data,
  subset,
  na.action = na.omit,
  ...,
  main = NULL,
  xlab = "",
  ylab = NULL,
  xlim = NULL,
  ylim = NULL,
  add = FALSE,
  bw = "nrd0",
  type = NULL,
  col = NULL,
  lwd = 2,
  lty = 1,
  fill = FALSE,
  grid = NA,
  stamp = TRUE
)
```

## Arguments

- x:

  A numeric vector or list of numeric vectors.

- ...:

  additional data vectors (unnamed, default method) or graphical
  parameters passed to [`par()`](https://rdrr.io/r/graphics/par.html).

- formula:

  A formula of the form `y ~ group`, `y ~ x` (`x` numeric, conditional
  density), or `y ~ x | group`.

- data:

  optional data frame.

- subset:

  optional subset expression.

- na.action:

  function to handle missing values.

- main, xlab, ylab:

  plot labels.

- xlim, ylim:

  axis limits.

- add:

  logical; if `TRUE`, adds to an existing plot.

- bw:

  bandwidth passed to
  [`stats::density()`](https://rdrr.io/r/stats/density.html) or
  `cdplot`.

- type:

  character string specifying the plot type. One of `"density"`,
  `"conditional"`, or `NULL` (default, determined by
  `resolveFormula()`'s design classification).

- col:

  line color(s).

- lwd:

  line width(s).

- lty:

  line type(s).

- fill:

  for `type = "density"`: `FALSE` (default, no fill), `TRUE`
  (translucent fill derived from each group's `col` via
  `adjustcolor(col, alpha.f = 0.3)`), or one or more explicit fill
  colors recycled over groups. For `type = "conditional"` on a single,
  unstratified, binary curve: `TRUE` for cdplot-style grey shading, or a
  vector of 2 colors for the regions below/above the boundary curve.

- grid:

  logical, `NA`, or list controlling background grid.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, or an explicit string, as
  for [`.withGraphicsState()`](graphics-framework.md) (internal).

## Value

Invisibly returns `NULL`.

## Details

The function defers entirely to
[`bedrock::resolveFormula()`](https://andrisignorell.github.io/bedrock/reference/resolveFormula.html)'s
design classification to pick a mode when `type = NULL`:

- `y ~ g` (`g` categorical) → density, one curve per group.

- `y ~ x` (`x` numeric) → conditional density \\P(Y \| X)\\, a single
  curve - equivalent to `cdplot(x, factor(y))`.

- `y ~ x | g` → conditional density, one curve per level of `g`.

`type` can be set explicitly to override the default for a given design
(e.g. to force an error rather than silently doing the wrong thing if a
formula's shape is ambiguous).

Graphical elements such as grids are controlled via the unified plot
design system using
[`bedrock::callIf()`](https://andrisignorell.github.io/bedrock/reference/callIf.html)
and `.theme()`.

## See also

[`stats::density()`](https://rdrr.io/r/stats/density.html),
[`graphics::cdplot()`](https://rdrr.io/r/graphics/cdplot.html),
[`bedrock::resolveFormula()`](https://andrisignorell.github.io/bedrock/reference/resolveFormula.html)

Other plot.univariate: [`plotArea()`](plotArea.md),
[`plotBar()`](plotBar.md), [`plotBox()`](plotBox.md),
[`plotCatDist()`](plotCatDist.md), [`plotDensBox()`](plotDensBox.md),
[`plotDot()`](plotDot.md), [`plotECDF()`](plotECDF.md),
[`plotFdist()`](plotFdist.md), [`plotLines()`](plotLines.md),
[`plotQQ()`](plotQQ.md), [`plotViolin()`](plotViolin.md)

## Examples

``` r
set.seed(1)
x <- rnorm(100)
g <- rep(c("A", "B"), each = 50)

# standard density (k = 2 groups)
plotDens(x ~ g)


# conditional density, single curve - auto-detected, no type= needed
y <- rbinom(100, 1, plogis(x))
plotDens(y ~ x)


# same, with cdplot-style fill
plotDens(y ~ x, fill = c("red", "blue"))


# conditional density, stratified by group
plotDens(y ~ x | g)

```
