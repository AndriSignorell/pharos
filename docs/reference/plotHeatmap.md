# Heatmap for Categorical Data

Visualizes a contingency table using a heatmap representation. Cell
values are mapped to colors based on counts or proportions, optionally
with text labels overlaid.

## Usage

``` r
plotHeatmap(
  x,
  main = NULL,
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL,
  scale = c("count", "prop", "row", "col"),
  col = .useTheme,
  border = NA,
  naCol = "gray90",
  text = FALSE,
  zlim = NULL,
  box = .useTheme,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  a contingency table, matrix, or a pair of categorical vectors
  coercible via [`table`](https://rdrr.io/r/base/table.html).

- main:

  main title of the plot. `NULL` (default) derives a title from the
  expression passed as `x` (via `deparse(match.call()$x)`), the same
  "substitute magic" convention used by
  [`plotXY`](https://andrisignorell.github.io/lyra/reference/plotXY.md)/[`plotBox`](https://andrisignorell.github.io/lyra/reference/plotBox.md)/
  [`plotAssoc`](https://andrisignorell.github.io/lyra/reference/plotAssoc.md)
  for their default titles - there's no formula pair here, just the
  single table argument, so the default is simply that expression's text
  (e.g. `plotHeatmap(tab)` titles itself `"tab"`). `""`, `NA`, or
  `FALSE` suppress the title entirely and compact the top margin; any
  other string is used as given (resolved internally via
  `.resolveTitle()`).

- xlab:

  label for the x-axis.

- ylab:

  label for the y-axis.

- xlim, ylim:

  numeric vectors of length 2 specifying axis limits.

- scale:

  character specifying how values are computed:

  `"count"`

  :   absolute frequencies

  `"prop"`

  :   joint proportions \\P(X, Y)\\

  `"row"`

  :   row-wise proportions \\P(Y \mid X)\\

  `"col"`

  :   column-wise proportions \\P(X \mid Y)\\

- col:

  optional vector of colors. Default is a hardcoded sequential
  white-to-navy ramp (`pal("Blues", n = 100)`) - deliberately not
  theme-driven: cell values here are sequential (one direction, no sign
  change), unlike the active theme's categorical `palette` or diverging
  `twin` pair, neither of which fits a heat scale.

- border:

  color of tile borders. Defaults to `NA`.

- naCol:

  color used for missing values.

- text:

  logical; if `TRUE`, cell values are printed on top of the tiles using
  [`fm()`](https://andrisignorell.github.io/lyra/reference/fm.md)
  formatting.

- zlim:

  numeric vector of length 2 specifying the range used for color
  scaling. If `NULL`, the range of the data is used.

- box:

  Controls drawing of the outer frame around the tile grid, drawn via
  [`rect()`](https://rdrr.io/r/graphics/rect.html) at the exact cell
  boundaries rather than [`box()`](https://rdrr.io/r/graphics/box.html)
  (the initial plot suppresses the standard box via
  `frame.plot = FALSE`, since cell bounds differ from the default plot
  region). `.useTheme` (default) resolves border color/width from
  `getTheme()$box`. `TRUE`/`FALSE`, or a named list overriding
  [`rect()`](https://rdrr.io/r/graphics/rect.html) arguments for this
  call only.

- stamp:

  Controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, or an explicit string, as
  for `.withGraphicsState()` (internal).

- ...:

  further graphical parameters passed to
  [`par`](https://rdrr.io/r/graphics/par.html) via the internal
  framework.

## Value

Invisibly returns the matrix used for plotting.

## Details

The heatmap represents values in a contingency table using color
intensity. Depending on `scale`, the plot shows either absolute counts
or different types of proportions. This plot complements association and
spine plots by focusing on overall structure rather than conditional
distributions or statistical inference.

## See also

[`plotAssoc`](https://andrisignorell.github.io/lyra/reference/plotAssoc.md),
[`image`](https://rdrr.io/r/graphics/image.html),
[`getTheme`](https://andrisignorell.github.io/lyra/reference/getTheme.md)

Other plot.bivariate:
[`plotAssoc()`](https://andrisignorell.github.io/lyra/reference/plotAssoc.md),
[`plotBag()`](https://andrisignorell.github.io/lyra/reference/plotBag.md),
[`plotCor()`](https://andrisignorell.github.io/lyra/reference/plotCor.md),
[`plotDens2D()`](https://andrisignorell.github.io/lyra/reference/plotDens2D.md),
[`plotHexbin()`](https://andrisignorell.github.io/lyra/reference/plotHexbin.md),
[`plotMosaic()`](https://andrisignorell.github.io/lyra/reference/plotMosaic.md),
[`plotXY()`](https://andrisignorell.github.io/lyra/reference/plotXY.md)

## Examples

``` r
if (FALSE) { # \dontrun{
tab <- table(UCBAdmissions)

plotHeatmap(tab,
            scale = "prop",
            text = TRUE)
} # }
```
