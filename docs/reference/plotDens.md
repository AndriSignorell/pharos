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

  Additional data vectors (unnamed, default method) or graphical
  parameters passed to [`par()`](https://rdrr.io/r/graphics/par.html).

- formula:

  A formula of the form `y ~ group`, `y ~ x` (`x` numeric, conditional
  density), or `y ~ x | group`.

- data:

  Optional data frame.

- subset:

  Optional subset expression.

- na.action:

  Function to handle missing values.

- main, xlab, ylab:

  Plot labels.

- xlim, ylim:

  Axis limits.

- add:

  Logical; if `TRUE`, adds to an existing plot.

- bw:

  Bandwidth passed to [`density`](https://rdrr.io/r/stats/density.html)
  or `cdplot`.

- type:

  Character string specifying the plot type. One of `"density"`,
  `"conditional"`, or `NULL` (default, determined by
  `resolveFormula()`'s design classification).

- col:

  Line color(s).

- lwd:

  Line width(s).

- lty:

  Line type(s).

- fill:

  For `type = "density"`: `FALSE` (default, no fill), `TRUE`
  (translucent fill derived from each group's `col` via
  `adjustcolor(col, alpha.f = 0.3)`), or one or more explicit fill
  colors recycled over groups. For `type = "conditional"` on a single,
  unstratified, binary curve: `TRUE` for cdplot-style grey shading, or a
  vector of 2 colors for the regions below/above the boundary curve.

- grid:

  Logical, `NA`, or list controlling background grid.

- stamp:

  Controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, or an explicit string, as
  for `.withGraphicsState()` (internal).

## Value

Invisibly returns `NULL`.

## Details

The function defers entirely to
[`resolveFormula()`](https://rdrr.io/pkg/bedrock/man/resolveFormula.html)'s
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
[`bedrock::callIf()`](https://rdrr.io/pkg/bedrock/man/callIf.html) and
`.theme()`.

## See also

[`density`](https://rdrr.io/r/stats/density.html),
[`cdplot`](https://rdrr.io/r/graphics/cdplot.html),
[`resolveFormula`](https://rdrr.io/pkg/bedrock/man/resolveFormula.html)

Other topic.graphics:
[`plotBubble()`](https://andrisignorell.github.io/lyra/reference/plotBubble.md),
[`plotDens2D()`](https://andrisignorell.github.io/lyra/reference/plotDens2D.md),
[`plotRidge()`](https://andrisignorell.github.io/lyra/reference/plotRidge.md)

Other plot.univariate:
[`plotArea()`](https://andrisignorell.github.io/lyra/reference/plotArea.md),
[`plotBar()`](https://andrisignorell.github.io/lyra/reference/plotBar.md),
[`plotBox()`](https://andrisignorell.github.io/lyra/reference/plotBox.md),
[`plotCatDist()`](https://andrisignorell.github.io/lyra/reference/plotCatDist.md),
[`plotDensBox()`](https://andrisignorell.github.io/lyra/reference/plotDensBox.md),
[`plotDot()`](https://andrisignorell.github.io/lyra/reference/plotDot.md),
[`plotECDF()`](https://andrisignorell.github.io/lyra/reference/plotECDF.md),
[`plotFdist()`](https://andrisignorell.github.io/lyra/reference/plotFdist.md),
[`plotLines()`](https://andrisignorell.github.io/lyra/reference/plotLines.md),
[`plotQQ()`](https://andrisignorell.github.io/lyra/reference/plotQQ.md),
[`plotViolin()`](https://andrisignorell.github.io/lyra/reference/plotViolin.md)

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
