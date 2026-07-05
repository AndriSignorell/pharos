# Combined Plot of a Time Series and Its ACF and PACF

Combined plot of a time Series and its autocorrelation and partial
autocorrelation

## Usage

``` r
plotTimeSeries(
  x,
  maxLag = 10 * log10(length(x)),
  ylab = NULL,
  main = NULL,
  ...
)
```

## Arguments

- x:

  univariate time series.

- maxLag:

  integer. Defines the number of lags to be displayed. The default is 10
  \* log10(length(series)).

- ylab:

  a title for the y axis: see
  [`title`](https://rdrr.io/r/graphics/title.html).

- main:

  an overall title for the plot

- ...:

  the dots are passed to the plot command.

## Details

plotTimeSeries plots a combination of the time series and its
autocorrelation and partial autocorrelation.

## Note

Rewritten based on ideas of M.Huerzeler

## See also

[`ts`](https://rdrr.io/r/stats/ts.html)

Other plot.special:
[`plotBinaryTree()`](https://andrisignorell.github.io/aurora/reference/binaryTree.md),
[`plotCirc()`](https://andrisignorell.github.io/aurora/reference/plotCirc.md),
[`plotMiss()`](https://andrisignorell.github.io/aurora/reference/plotMiss.md),
[`plotPolar()`](https://andrisignorell.github.io/aurora/reference/plotPolar.md),
[`plotPropCI()`](https://andrisignorell.github.io/aurora/reference/plotPropCI.md),
[`plotTernary()`](https://andrisignorell.github.io/aurora/reference/plotTernary.md),
[`plotTreemap()`](https://andrisignorell.github.io/aurora/reference/plotTreemap.md),
[`plotWeb()`](https://andrisignorell.github.io/aurora/reference/plotWeb.md)

## Examples

``` r

plotTimeSeries(AirPassengers)
```
