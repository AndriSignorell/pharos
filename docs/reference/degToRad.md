# Convert Degrees to Radians and Vice Versa

Convert degrees to radians (and back again).

## Usage

``` r
degToRad(deg)

radToDeg(rad)
```

## Arguments

- deg:

  a vector of angles in degrees.

- rad:

  a vector of angles in radians.

## Value

degToRad returns a vector of the same length as `deg` with the angles in
radians.  
radToDeg returns a vector of the same length as `rad` with the angles in
degrees.

## See also

Other graphics.utils:
[`abcCoords()`](https://andrisignorell.github.io/lyra/reference/abcCoords.md),
[`axisBreak()`](https://andrisignorell.github.io/lyra/reference/axisBreak.md),
[`barText()`](https://andrisignorell.github.io/lyra/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/lyra/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/lyra/reference/colLegend.md),
[`errBars()`](https://andrisignorell.github.io/lyra/reference/errBars.md),
[`lineSep()`](https://andrisignorell.github.io/lyra/reference/lineSep.md),
[`lineToUser()`](https://andrisignorell.github.io/lyra/reference/lineToUser.md),
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

degToRad(c(90,180,270))
#> [1] 1.570796 3.141593 4.712389
radToDeg( c(0.5,1,2) * pi)
#> [1]  90 180 360
```
