# Bland-Altman Plot

Plots a Bland-Altman agreement analysis.

## Usage

``` r
# S3 method for class 'BlandAltman'
plot(
  x,
  main = "",
  xlab = "Mean",
  ylab = "Difference",
  xlim = NULL,
  ylim = NULL,
  pch = 16,
  col = NULL,
  grid = TRUE,
  meanLine = TRUE,
  limits = TRUE,
  conf.band = FALSE,
  trend = FALSE,
  showText = TRUE,
  stamp = NULL,
  ...
)
```

## Arguments

- x:

  An object of class `"blandAltman"`.

- main:

  Plot title.

- xlab:

  X-axis label.

- ylab:

  Y-axis label.

- xlim:

  X-axis limits.

- ylim:

  Y-axis limits.

- pch:

  Plotting symbol.

- col:

  Point colour.

- grid:

  Logical; draw a background grid.

- meanLine:

  Logical; draw the bias line.

- limits:

  Logical; draw the limits of agreement.

- conf.band:

  Logical; draw confidence bands.

- trend:

  Logical; draw a regression line of differences versus means.

- showText:

  Logical; annotate bias and limits.

- stamp:

  Optional plot stamp.

- ...:

  Further arguments passed to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html).

## Value

Invisibly returns `x`.

## Details

Objects of class `"blandAltman"` are typically created with
[`DescToolsX::blandAltmanData()`](https://rdrr.io/pkg/DescToolsX/man/blandAltmanData.html).

## See also

Other plot.s3:
[`plot.Desc.qn()`](https://andrisignorell.github.io/lyra/reference/plot.Desc.qn.md),
[`plot.Desc.table()`](https://andrisignorell.github.io/lyra/reference/plot.Desc.table.md),
[`plot.Lc()`](https://andrisignorell.github.io/lyra/reference/plot.Lc.md)
