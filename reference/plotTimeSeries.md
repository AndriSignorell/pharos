# Combined Plot of a Time Series and Its ACF and PACF

Combined plot of a time Series and its autocorrelation and partial
autocorrelation

## Usage

``` r
plotTimeSeries(
  x,
  main = NULL,
  ylab = NULL,
  maxLag = 10 * log10(length(x)),
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  univariate time series.

- main:

  an overall title for the plot

- ylab:

  a title for the y axis: see
  [`title()`](https://rdrr.io/r/graphics/title.html).

- maxLag:

  integer. Defines the number of lags to be displayed. The default is 10
  \* log10(length(series)).

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for [`stamp()`](stamp.md).

- ...:

  the dots are passed to the plot command.

## Value

`x`, invisibly. Called for its side effect of drawing the plot.

## Details

plotTimeSeries plots a combination of the time series and its
autocorrelation and partial autocorrelation.

## Note

Rewritten based on ideas of M.Huerzeler

## See also

[`ts()`](https://rdrr.io/r/stats/ts.html)

Other plot.special: [`plotBinaryTree()`](binaryTree.md),
[`plotCirc()`](plotCirc.md), [`plotLift()`](plotLift.md),
[`plotMiss()`](plotMiss.md), [`plotPolar()`](plotPolar.md),
[`plotPropCI()`](plotPropCI.md), [`plotTernary()`](plotTernary.md),
[`plotTreemap()`](plotTreemap.md), [`plotWeb()`](plotWeb.md)

## Examples

``` r

plotTimeSeries(AirPassengers)
```
