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

Other graphics.utils:
[`abcCoords()`](https://andrisignorell.github.io/lyra/reference/abcCoords.md),
[`axisBreak()`](https://andrisignorell.github.io/lyra/reference/axisBreak.md),
[`barText()`](https://andrisignorell.github.io/lyra/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/lyra/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/lyra/reference/colLegend.md),
[`degToRad()`](https://andrisignorell.github.io/lyra/reference/degToRad.md),
[`errBars()`](https://andrisignorell.github.io/lyra/reference/errBars.md),
[`lineSep()`](https://andrisignorell.github.io/lyra/reference/lineSep.md),
[`lines.lm()`](https://andrisignorell.github.io/lyra/reference/linesLm.md),
[`mar()`](https://andrisignorell.github.io/lyra/reference/mar.md),
[`preview()`](https://andrisignorell.github.io/lyra/reference/preview.md),
[`spreadOut()`](https://andrisignorell.github.io/lyra/reference/spreadOut.md),
[`stamp()`](https://andrisignorell.github.io/lyra/reference/stamp.md),
[`textLegend()`](https://andrisignorell.github.io/lyra/reference/textLegend.md),
[`titleRect()`](https://andrisignorell.github.io/lyra/reference/titleRect.md),
[`unit()`](https://andrisignorell.github.io/lyra/reference/unit.md)

## Examples

``` r

plot(1:10)

lineToUser(line=2, side=4)
#> [1] 11.07646
```
