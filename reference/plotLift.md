# Lift Chart

Draws the cumulative lift curve, the cumulative gain curve, or the
per-group lift bars of a binary classifier, together with the baseline
of a random model. The chart answers the operational question directly:
how much better is acting on the top-scored share of the cases than
acting on a random share of the same size.

## Usage

``` r
plotLift(
  x,
  type = c("cumulative", "gain", "decile"),
  main = NULL,
  xlab = NULL,
  ylab = NULL,
  ylim = NULL,
  col = .useTheme,
  lwd = 2,
  grid = .useTheme,
  box = .useTheme,
  baseline = TRUE,
  perfect = FALSE,
  legend = TRUE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  an object of class `"Lift"`, as returned by `alloy::lift()`.

- type:

  the curve to draw. One of `"cumulative"` (cumulative lift over depth,
  the default), `"gain"` (share of all positives captured, over depth),
  or `"decile"` (per-group lift as bars).

- main:

  main title of the plot. `NULL` (default) derives a title from
  `deparse(substitute(x))`. `""`, `NA`, or `FALSE` suppress the title
  entirely (and compact the top margin accordingly); any other string is
  used as given.

- xlab:

  label for the x-axis. `NULL` (default) derives a label from `type`.

- ylab:

  label for the y-axis. `NULL` (default) derives a label from `type`.

- ylim:

  numeric vector of length 2; y-axis limits. `NULL` (default) spans the
  curve together with the baseline.

- col:

  color of the curve or the bars. `.useTheme` (default) resolves to
  `getTheme()$twin[1]` - a single accent color, consistent with
  [`plotECDF()`](plotECDF.md).

- lwd:

  line width of the curve. Has no effect for `type = "decile"`.

- grid:

  controls drawing of the background grid. Can be:

  - `.useTheme` (default): follow the active theme (`getTheme()$grid`)

  - `TRUE`: draw grid with theme settings

  - `FALSE`, `NULL`, or `NA`: suppress grid

  - a named list: arguments passed to
    [`graphics::grid()`](https://rdrr.io/r/graphics/grid.html),
    overriding the theme defaults for this call only

- box:

  controls drawing of the plot box. `.useTheme` (default) resolves to
  `getTheme()$box`. `TRUE`/`FALSE`/`NA`, or a named list, as for `grid`.

- baseline:

  controls the reference line of a random model - a horizontal line at 1
  for `type = "cumulative"` and `"decile"`, the diagonal for
  `type = "gain"`. Can be:

  - `TRUE` (default): draw with default settings

  - `FALSE`, `NULL`, or `NA`: suppress

  - a named list: arguments passed to
    [`graphics::lines()`](https://rdrr.io/r/graphics/lines.html) (or
    [`graphics::abline()`](https://rdrr.io/r/graphics/abline.html) for
    `type = "decile"`), e.g. `list(col = "black", lty = "dotted")`

- perfect:

  controls the curve of a perfect ranking - the theoretical maximum
  attainable at each depth, given the base rate. `FALSE` by default,
  since it compresses the interesting part of the y-axis; `TRUE` or a
  named list to draw it, as for `baseline`. Has no effect for
  `type = "decile"`.

- legend:

  controls drawing of the legend. Can be:

  - `TRUE` (default): draw with default settings

  - `FALSE`, `NULL`, or `NA`: suppress

  - a named list: arguments passed to
    [`graphics::legend()`](https://rdrr.io/r/graphics/legend.html), e.g.
    `list(x = "bottomleft")`

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  of arguments for [`stamp()`](stamp.md).

- ...:

  further graphical parameters passed to
  [`par()`](https://rdrr.io/r/graphics/par.html) via the internal
  framework.

## Value

Invisibly returns `x`.

## Details

Reading the cumulative curve at depth 0.2 gives the factor by which
contacting the top-scored fifth of the cases beats contacting a random
fifth. The gain variant answers the complementary question - what share
of all positives that fifth captures.

The curve necessarily converges to 1 (cumulative lift) or to the
diagonal endpoint (gain) at depth 1, where all cases are selected and
the model no longer discriminates. Only the left part of the curve
carries decision value: a model that separates well over the first two
deciles and poorly afterwards is preferable for a small campaign to one
with the reverse profile and identical AUC.

Optional plot components (`grid`, `box`, `baseline`, `perfect`,
`legend`) follow
[`bedrock::callIf()`](https://andrisignorell.github.io/bedrock/reference/callIf.html)
semantics:

- `TRUE`: draw with defaults

- `FALSE`, `NULL`, or `NA`: suppress component

- named list: customize component arguments

`col`, `grid`, `box`, and `stamp` default to `.useTheme`, deferring to
the package's active theme (see [theme](theme.md)) rather than a
hardcoded value.

The number of groups is a property of the lift table, not of the plot -
set it via the `nBins` argument of `alloy::lift()`.

## See also

`alloy::lift()`, `alloy::roc()`, [`plotECDF()`](plotECDF.md),
[`bedrock::callIf()`](https://andrisignorell.github.io/bedrock/reference/callIf.html),
[theme](theme.md)

Other plot.special: [`plotBinaryTree()`](binaryTree.md),
[`plotCirc()`](plotCirc.md), [`plotMiss()`](plotMiss.md),
[`plotPolar()`](plotPolar.md), [`plotPropCI()`](plotPropCI.md),
[`plotTernary()`](plotTernary.md),
[`plotTimeSeries()`](plotTimeSeries.md),
[`plotTreemap()`](plotTreemap.md), [`plotWeb()`](plotWeb.md)

## Examples

``` r
if (FALSE) { # \dontrun{
fitLogit <- alloy::fitMod(admit ~ gre + gpa + rank, Admit, fitfn = "logit")
lft <- alloy::lift(fitLogit)

plotLift(lft)
plotLift(lft, type = "gain")

# Per-group bars, coarser grouping set at computation time
plotLift(alloy::lift(fitLogit, nBins = 5), type = "decile")

# Add the perfect-ranking reference, suppress the legend
plotLift(lft, perfect = TRUE, legend = FALSE)

# No title, compact top margin
plotLift(lft, main = "")
} # }
```
