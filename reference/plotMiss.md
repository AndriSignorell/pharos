# Plot Missing Data

Takes a data frame and displays the location of missing data. The
missings can be clustered and be displayed together.

## Usage

``` r
plotMiss(
  x,
  main = NULL,
  cluster = FALSE,
  col = "deeppink4",
  bg = fade("navajowhite3", 0.3),
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  a data.frame to be analysed.

- main:

  the main title.

- cluster:

  logical, defining if the missings should be clustered. Default is
  `FALSE`.

- col:

  the colour of the missings.

- bg:

  the background colour of the plot.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for [`stamp()`](stamp.md).

- ...:

  the dots are passed to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html).

## Value

if `cluster` is set to TRUE, the new order will be returned invisibly.

## Details

A graphical display of the position of the missings can be help to
detect dependencies or patterns within the missings.

## Note

Following an idea of Henk Harmsen <henk@carbonmetrics.com>

## See also

[`hclust()`](https://rdrr.io/r/stats/hclust.html),
[`bedrock::countCompCases()`](https://andrisignorell.github.io/bedrock/reference/countCompCases.html)

Other plot.special: [`plotBinaryTree()`](binaryTree.md),
[`plotCirc()`](plotCirc.md), [`plotLift()`](plotLift.md),
[`plotPolar()`](plotPolar.md), [`plotPropCI()`](plotPropCI.md),
[`plotTernary()`](plotTernary.md),
[`plotTimeSeries()`](plotTimeSeries.md),
[`plotTreemap()`](plotTreemap.md), [`plotWeb()`](plotWeb.md)

## Examples

``` r

plotMiss(airquality, main="Missing data (in orignal order)")

plotMiss(airquality, main="Missing data (clustered)", cluster=TRUE)

```
