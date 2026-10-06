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
  cband = FALSE,
  trend = FALSE,
  showText = TRUE,
  stamp = NULL,
  ...
)
```

## Arguments

- x:

  an object of class `"blandAltman"`.

- main:

  plot title.

- xlab:

  X-axis label.

- ylab:

  Y-axis label.

- xlim:

  X-axis limits.

- ylim:

  Y-axis limits.

- pch:

  plotting symbol.

- col:

  point colour.

- grid:

  logical; draw a background grid.

- meanLine:

  logical; draw the bias line.

- limits:

  logical; draw the limits of agreement.

- cband:

  logical; draw confidence bands.

- trend:

  logical; draw a regression line of differences versus means.

- showText:

  logical; annotate bias and limits.

- stamp:

  optional plot stamp.

- ...:

  further arguments passed to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html).

## Value

Invisibly returns `x`.

## Details

Objects of class `"blandAltman"` are typically created with
`DescToolsX::blandAltmanData()`.

## See also

Other plot.s3: [`plot.Desc.qn()`](plot.Desc.qn.md),
[`plot.Desc.table()`](plot.Desc.table.md), [`plot.Lc()`](plot.lc.md)
