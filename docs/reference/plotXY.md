# Scatterplot with Optional Smooth Lines

Draws a scatterplot of two numeric variables with optional linear and
locally weighted regression lines, and an optional legend.

## Usage

``` r
plotXY(x, ...)

# Default S3 method
plotXY(
  x,
  y,
  main = NULL,
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL,
  col = .useTheme,
  bg = .useTheme,
  pch = .useTheme,
  cex = .useTheme,
  grid = .useTheme,
  box = .useTheme,
  lm = TRUE,
  loess = TRUE,
  legend = TRUE,
  stamp = .useTheme,
  ...
)

# S3 method for class 'formula'
plotXY(
  formula,
  data,
  subset,
  na.action = na.omit,
  main = NULL,
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL,
  col = .useTheme,
  bg = .useTheme,
  pch = .useTheme,
  cex = .useTheme,
  grid = .useTheme,
  lm = TRUE,
  loess = TRUE,
  legend = TRUE,
  box = .useTheme,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  numeric vector of x-values, or a formula of the form `y ~ x`.

- ...:

  further graphical parameters passed to
  [`par()`](https://rdrr.io/r/graphics/par.html) via the internal
  framework.

- y:

  numeric vector of y-values (ignored if a formula is used).

- main:

  main title of the plot. `NULL` (default) derives a title from the
  input - `deparse(y) ~ deparse(x)` for the default method, or the
  formula's `data.name` for the formula method. `""`, `NA`, or `FALSE`
  suppress the title entirely (and compact the top margin accordingly);
  any other string is used as given (resolved internally via
  `.resolveTitle()`).

- xlab:

  label for the x-axis.

- ylab:

  label for the y-axis.

- xlim:

  numeric vector of length 2; x-axis limits. If `NULL` (default), the
  range of `x` is used.

- ylim:

  numeric vector of length 2; y-axis limits. If `NULL` (default), the
  range of `y` is used.

- col:

  color of the points. `.useTheme` (default) resolves to
  `getTheme()$points$col`.

- bg:

  background (fill) color of the points. `.useTheme` (default) resolves
  to `getTheme()$points$bg`.

- pch:

  plotting character. `.useTheme` (default) resolves to
  `getTheme()$points$pch`.

- cex:

  character expansion factor for points. `.useTheme` (default) resolves
  to `getTheme()$points$cex`.

- grid:

  controls drawing of the background grid. Can be:

  - `.useTheme` (default): follow the active theme (`getTheme()$grid`)

  - `TRUE`: draw grid with theme settings

  - `FALSE`, `NULL`, or `NA`: suppress grid

  - a named list: arguments passed to
    [`grid`](https://rdrr.io/r/graphics/grid.html), overriding the theme
    defaults for this call only

- box:

  controls drawing of the plot box. Can be:

  - `.useTheme` (default): follow the active theme (`getTheme()$box`)

  - `TRUE`: draw box with theme settings

  - `FALSE`, `NULL`, or `NA`: suppress box

  - a named list: arguments passed to
    [`box`](https://rdrr.io/r/graphics/box.html), overriding the theme
    defaults for this call only

- lm:

  controls drawing of the linear regression line. Can be:

  - `TRUE`: draw with default settings

  - `FALSE`, `NULL`, or `NA`: suppress

  - a named list: arguments passed to
    [`lines`](https://rdrr.io/r/graphics/lines.html), e.g.
    `list(col = "blue", lwd = 2)`

- loess:

  controls drawing of the locally weighted regression line. Can be:

  - `TRUE`: draw with default settings

  - `FALSE`, `NULL`, or `NA`: suppress

  - a named list: arguments passed to
    [`lines`](https://rdrr.io/r/graphics/lines.html), e.g.
    `list(col = "red", lty = "dashed")`

- legend:

  controls drawing of the legend. Can be:

  - `TRUE`: draw with default settings (position `"topright"`)

  - `FALSE`, `NULL`, or `NA`: suppress

  - a named list: arguments passed to
    [`legend`](https://rdrr.io/r/graphics/legend.html), e.g.
    `list(x = "bottomleft")`

  The legend is only drawn when at least one of `lm` or `loess` is
  active. `lm`/`loess` line colors are taken from the active theme's
  `twin` colors (`getTheme()$twin`).

- stamp:

  Controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for
  [`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md).

- formula:

  a formula of the form `y ~ x`.

- data:

  an optional data frame containing variables in the formula.

- subset:

  optional expression indicating which observations to use.

- na.action:

  a function specifying how missing values are handled. Defaults to
  `na.omit`.

## Value

Invisibly returns `NULL`.

## Details

Optional plot components (`grid`, `box`, `lm`, `loess`, `legend`) follow
[`callIf`](https://rdrr.io/pkg/bedrock/man/callIf.html) semantics:

- `TRUE`: draw with defaults

- `FALSE`, `NULL`, or `NA`: suppress component

- named list: customize component arguments

`col`, `bg`, `pch`, `cex`, `grid`, and `box` default to `.useTheme`,
deferring to the package's active theme (see
[`getTheme`](https://andrisignorell.github.io/aurora/reference/getTheme.md))
rather than a hardcoded value. This means
`setTheme(list(points = list(col = "black")))` changes the point color
for every call to `plotXY()` (and any other function using the same
theme section) that doesn't override `col` explicitly.

## See also

[`plot`](https://rdrr.io/r/graphics/plot.default.html),
[`lm`](https://rdrr.io/r/stats/lm.html),
[`loess`](https://rdrr.io/r/stats/loess.html),
[`callIf`](https://rdrr.io/pkg/bedrock/man/callIf.html),
[`getTheme`](https://andrisignorell.github.io/aurora/reference/getTheme.md),
[`setTheme`](https://andrisignorell.github.io/aurora/reference/getTheme.md)

Other plot.bivariate:
[`plotAssoc()`](https://andrisignorell.github.io/aurora/reference/plotAssoc.md),
[`plotBag()`](https://andrisignorell.github.io/aurora/reference/plotBag.md),
[`plotCor()`](https://andrisignorell.github.io/aurora/reference/plotCor.md),
[`plotDens2D()`](https://andrisignorell.github.io/aurora/reference/plotDens2D.md),
[`plotHeatmap()`](https://andrisignorell.github.io/aurora/reference/plotHeatmap.md),
[`plotHexbin()`](https://andrisignorell.github.io/aurora/reference/plotHexbin.md),
[`plotMosaic()`](https://andrisignorell.github.io/aurora/reference/plotMosaic.md)

## Examples

``` r
if (FALSE) { # \dontrun{
plotXY(temperature ~ delivery_min, bedrock::Pizza,
       main = "Temperature vs. Delivery Time")

# Suppress loess, customize lm line
plotXY(temperature ~ delivery_min, bedrock::Pizza,
       lm    = list(col = "darkred", lwd = 2),
       loess = FALSE)

# No title, compact top margin
plotXY(temperature ~ delivery_min, bedrock::Pizza, main = "")
} # }
```
