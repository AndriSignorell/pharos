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
  zlim = NULL,
  scale = c("count", "prop", "row", "col"),
  col = .useTheme,
  border = NA,
  naCol = "gray90",
  box = .useTheme,
  text = FALSE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  a contingency table, matrix, or a pair of categorical vectors
  coercible via [`table()`](https://rdrr.io/r/base/table.html).

- main:

  main title of the plot. `NULL` (default) derives a title from the
  expression passed as `x` (via `deparse(match.call()$x)`), the same
  "substitute magic" convention used by
  [`plotXY()`](plotXY.md)/[`plotBox()`](plotBox.md)/
  [`plotAssoc()`](plotAssoc.md) for their default titles - there's no
  formula pair here, just the single table argument, so the default is
  simply that expression's text (e.g. `plotHeatmap(tab)` titles itself
  `"tab"`). `""`, `NA`, or `FALSE` suppress the title entirely and
  compact the top margin; any other string is used as given (resolved
  internally via [`.resolveTitle()`](graphics-framework.md)).

- xlab:

  label for the x-axis.

- ylab:

  label for the y-axis.

- xlim, ylim:

  numeric vectors of length 2 specifying axis limits.

- zlim:

  numeric vector of length 2 specifying the range used for color
  scaling. If `NULL`, the range of the data is used.

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

- box:

  controls drawing of the outer frame around the tile grid, drawn via
  [`rect()`](https://rdrr.io/r/graphics/rect.html) at the exact cell
  boundaries rather than
  [`graphics::box()`](https://rdrr.io/r/graphics/box.html) (the initial
  plot suppresses the standard box via `frame.plot = FALSE`, since cell
  bounds differ from the default plot region). `.useTheme` (default)
  resolves border color/width from `getTheme()$box`. `TRUE`/`FALSE`, or
  a named list overriding
  [`rect()`](https://rdrr.io/r/graphics/rect.html) arguments for this
  call only.

- text:

  logical; if `TRUE`, cell values are printed on top of the tiles using
  [`fm()`](fm.md) formatting.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, or an explicit string, as
  for [`.withGraphicsState()`](graphics-framework.md) (internal).

- ...:

  further graphical parameters passed to
  [`graphics::par()`](https://rdrr.io/r/graphics/par.html) via the
  internal framework.

## Value

Invisibly returns the matrix used for plotting.

## Details

The heatmap represents values in a contingency table using color
intensity. Depending on `scale`, the plot shows either absolute counts
or different types of proportions. Rows are drawn in reading order: the
first table row appears at the top, matching the printed table and the
other bivariate plots. This plot complements association and spine plots
by focusing on overall structure rather than conditional distributions
or statistical inference.

## See also

[`plotAssoc()`](plotAssoc.md),
[`graphics::image()`](https://rdrr.io/r/graphics/image.html),
[theme](theme.md)

Other plot.bivariate: [`plotAssoc()`](plotAssoc.md),
[`plotBag()`](plotBag.md), [`plotCor()`](plotCor.md),
[`plotDens2D()`](plotDens2D.md), [`plotHexbin()`](plotHexbin.md),
[`plotMosaic()`](plotMosaic.md), [`plotXY()`](plotXY.md)

## Examples

``` r
if (FALSE) { # \dontrun{
tab <- table(UCBAdmissions)

plotHeatmap(tab,
            scale = "prop",
            text = TRUE)
} # }
```
