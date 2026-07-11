# Frequency Distribution Plot

Creates a univariate graphical summary combining a histogram (or
probability mass plot for discrete data), a kernel density curve, a
boxplot, and an empirical cumulative distribution function in a single
multi-panel figure. Optional components include a rug, and fitted
theoretical distribution curves for both the histogram and the ECDF
panel.

## Usage

``` r
plotFdist(
  x,
  main = NULL,
  xlab = "",
  xlim = NULL,
  na.rm = FALSE,
  heights = NULL,
  hist = TRUE,
  dens = TRUE,
  rug = FALSE,
  curve = FALSE,
  boxplot = TRUE,
  ecdf = TRUE,
  curveEcdf = FALSE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  numeric vector whose distribution is to be plotted.

- main:

  main title. `NULL` (default) derives the title from
  `deparse(substitute(x))`. `""`, `NA`, or `FALSE` suppress the title
  and compact the top margin.

- xlab:

  label for the x-axis. The variable name is typically placed in `main`,
  so this defaults to `""`.

- xlim:

  range of the x-axis. `NULL` (default) uses a pretty range of
  `range(x, na.rm = TRUE)`.

- na.rm:

  logical; should `NA`s be removed before plotting? The density function
  requires complete cases, so `TRUE` is recommended when `x` contains
  missing values. Default `FALSE`.

- heights:

  numeric vector of relative panel heights for
  [`layout`](https://rdrr.io/r/graphics/layout.html): three values for
  histogram/boxplot/ecdf, two for histogram/boxplot or histogram/ecdf
  only. `NULL` (default) chooses automatically.

- hist:

  controls the histogram panel. `TRUE` (default) uses package defaults;
  `FALSE`/`NA` suppresses the panel (not recommended: also disables
  automatic `xlim` detection); a list overrides specific arguments
  forwarded to [`hist`](https://rdrr.io/r/graphics/hist.html). The
  element `type` selects the plot style: `"hist"` (standard histogram,
  chosen automatically for continuous or high-cardinality data) or
  `"mass"` (vertical bars per unique value, for discrete/low-cardinality
  data).

- dens:

  controls the kernel density curve. `TRUE` (default) draws a curve via
  [`density`](https://rdrr.io/r/stats/density.html); a list overrides
  specific arguments (e.g. `list(bw = 0.1, col = "red")`).

- rug:

  controls a rug plot. `FALSE` (default) suppresses it; `TRUE` or a list
  draw a rug via [`rug`](https://rdrr.io/r/graphics/rug.html).

- curve:

  controls a fitted theoretical distribution curve on the histogram.
  `FALSE` (default) suppresses it; `TRUE` or `NULL` draws a normal curve
  with `mean(x)`/`sd(x)`; a list may include `expr` as a character
  string or expression for any distribution (e.g.
  `list(expr = "dt(x, df=2)", col = "darkgreen")`).

- boxplot:

  controls the boxplot panel. `TRUE` (default) draws a horizontal
  boxplot with a mean marker and CI band; `FALSE`/ `NA` suppresses the
  panel. A list overrides arguments forwarded to
  [`boxplot`](https://rdrr.io/r/graphics/boxplot.html); two extra
  elements control the mean display: `pch.mean` (default `3`) and
  `col.meanci` (default `getTheme()$grid$col`). Set either to `NA` to
  suppress that element.

- ecdf:

  controls the ECDF panel. `TRUE` (default) calls
  [`plotECDF`](https://andrisignorell.github.io/lyra/reference/plotECDF.md);
  a list overrides specific arguments.

- curveEcdf:

  controls a fitted theoretical CDF curve on the ECDF panel, analogous
  to `curve`. `FALSE` (default) suppresses it.

- stamp:

  Controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for
  [`stamp()`](https://andrisignorell.github.io/lyra/reference/stamp.md).

- ...:

  further graphical parameters passed to
  [`par`](https://rdrr.io/r/graphics/par.html) via the internal
  framework.

## Details

Each plot component is controlled via a single argument accepting
[`callIf`](https://rdrr.io/pkg/bedrock/man/callIf.html) semantics:

- `TRUE`: draw with package defaults

- `FALSE`, `NULL`, or `NA`: suppress entirely

- a named list: draw with the given overrides merged into the defaults

Performance: for very large vectors (n \> 1e7) the density curve, ECDF,
and semi-transparent boxplot outliers will still take noticeable time.
For exploratory work on very large data, consider sampling first:
`plotFdist(x[sample(length(x), 5000)])`.

## See also

[`hist`](https://rdrr.io/r/graphics/hist.html),
[`boxplot`](https://rdrr.io/r/graphics/boxplot.html),
[`plotECDF`](https://andrisignorell.github.io/lyra/reference/plotECDF.md),
[`density`](https://rdrr.io/r/stats/density.html),
[`rug`](https://rdrr.io/r/graphics/rug.html),
[`layout`](https://rdrr.io/r/graphics/layout.html),
[`getTheme`](https://andrisignorell.github.io/lyra/reference/getTheme.md)

Other plot.univariate:
[`plotArea()`](https://andrisignorell.github.io/lyra/reference/plotArea.md),
[`plotBar()`](https://andrisignorell.github.io/lyra/reference/plotBar.md),
[`plotBox()`](https://andrisignorell.github.io/lyra/reference/plotBox.md),
[`plotCatDist()`](https://andrisignorell.github.io/lyra/reference/plotCatDist.md),
[`plotDens()`](https://andrisignorell.github.io/lyra/reference/plotDens.md),
[`plotDensBox()`](https://andrisignorell.github.io/lyra/reference/plotDensBox.md),
[`plotDot()`](https://andrisignorell.github.io/lyra/reference/plotDot.md),
[`plotECDF()`](https://andrisignorell.github.io/lyra/reference/plotECDF.md),
[`plotLines()`](https://andrisignorell.github.io/lyra/reference/plotLines.md),
[`plotQQ()`](https://andrisignorell.github.io/lyra/reference/plotQQ.md),
[`plotViolin()`](https://andrisignorell.github.io/lyra/reference/plotViolin.md)

## Examples

``` r
plotFdist(faithful$eruptions, na.rm = TRUE)


# custom histogram breaks, density color, boxplot styling
plotFdist(faithful$eruptions,
  hist    = list(breaks = 50),
  dens    = list(col = "olivedrab4"),
  na.rm   = TRUE,
  boxplot = list(col = "olivedrab2", pch.mean = NA, col.meanci = NA))


# no density, no ecdf, add rug instead
plotFdist(faithful$eruptions,
  dens = FALSE, ecdf = FALSE,
  hist = list(xaxt = "s"),
  rug  = TRUE,
  heights = c(3, 2.5), 
  main = "Eruption time")


# overlay a normal density curve
x <- rnorm(1000)
plotFdist(x, curve = TRUE, boxplot = FALSE, ecdf = FALSE)


# compare with a t-distribution curve
plotFdist(x,
  curve   = list(expr = "dt(x, df=2)", col = "darkgreen"),
  boxplot = FALSE, ecdf = FALSE)


# overlay gamma distribution on both histogram and ECDF
ozone <- airquality$Ozone
m <- mean(ozone, na.rm = TRUE)
v <- var(ozone, na.rm = TRUE)
plotFdist(ozone,
  hist       = list(breaks = 15),
  curve      = list(expr = "dgamma(x, shape = m^2/v, scale = v/m)",
                    col = "navajowhite3"),
  curveEcdf = list(expr = "pgamma(x, shape = m^2/v, scale = v/m)",
                    col = "navajowhite3"),
  na.rm = TRUE, main = "Airquality - Ozone")
#> Error in eval(expr, envir = ll, enclos = parent.frame()): object 'm' not found

```
