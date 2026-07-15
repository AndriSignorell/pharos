# Convert Line Coordinates To User Coordinates

Functions like `mtext` or `axis` use the `line` argument to set the
distance from plot. Sometimes it's useful to have the distance in user
coordinates. `lineToUser()` does this nontrivial conversion.

## Usage

``` r
lineToUser(line, side)
```

## Arguments

- line:

  the number of lines

- side:

  the side of the plot

## Value

the user coordinates for the given lines

## Details

For the `lineToUser` function to work, there must be an open plot.

## See also

[`mtext`](https://rdrr.io/r/graphics/mtext.html)

Other graphics.layout:
[`abcCoords()`](https://andrisignorell.github.io/aurora/reference/abcCoords.md),
[`axTicks`](https://andrisignorell.github.io/aurora/reference/axTicks.md),
[`axisBreak()`](https://andrisignorell.github.io/aurora/reference/axisBreak.md),
[`isValidPlotRegion()`](https://andrisignorell.github.io/aurora/reference/isValidPlotRegion.md),
[`mar()`](https://andrisignorell.github.io/aurora/reference/mar.md),
[`plotFacet()`](https://andrisignorell.github.io/aurora/reference/plotFacet.md),
[`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md)

## Examples

``` r

plot(1:10)

lineToUser(line=2, side=4)
#> [1] 11.07646

```
