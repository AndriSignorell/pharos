# Plot Missing Data

Takes a data frame and displays the location of missing data. The
missings can be clustered and be displayed together.

## Usage

``` r
plotMiss(
  x,
  col = "deeppink4",
  bg = fade("navajowhite3", 0.3),
  clust = FALSE,
  main = NULL,
  ...
)
```

## Arguments

- x:

  a data.frame to be analysed.

- col:

  the colour of the missings.

- bg:

  the background colour of the plot.

- clust:

  logical, defining if the missings should be clustered. Default is
  `FALSE`.

- main:

  the main title.

- ...:

  the dots are passed to
  [`plot`](https://rdrr.io/r/graphics/plot.default.html).

## Value

if clust is set to TRUE, the new order will be returned invisibly.

## Details

A graphical display of the position of the missings can be help to
detect dependencies or patterns within the missings.

## Note

Following an idea of Henk Harmsen <henk@carbonmetrics.com>

## See also

[`hclust`](https://rdrr.io/r/stats/hclust.html),
[`countCompCases`](https://rdrr.io/pkg/bedrock/man/countCompCases.html)

Other plot.special:
[`plotBinaryTree()`](https://andrisignorell.github.io/lyra/reference/binaryTree.md),
[`plotCirc()`](https://andrisignorell.github.io/lyra/reference/plotCirc.md),
[`plotPolar()`](https://andrisignorell.github.io/lyra/reference/plotPolar.md),
[`plotPropCI()`](https://andrisignorell.github.io/lyra/reference/plotPropCI.md),
[`plotTernary()`](https://andrisignorell.github.io/lyra/reference/plotTernary.md),
[`plotTimeSeries()`](https://andrisignorell.github.io/lyra/reference/plotTimeSeries.md),
[`plotTreemap()`](https://andrisignorell.github.io/lyra/reference/plotTreemap.md),
[`plotWeb()`](https://andrisignorell.github.io/lyra/reference/plotWeb.md)

## Examples

``` r

plotMiss(airquality, main="Missing data (in orignal order)")

plotMiss(airquality, main="Missing data (clustered)", clust=TRUE)

```
