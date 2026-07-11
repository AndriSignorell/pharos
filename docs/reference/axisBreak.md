# Place a Break Mark on an Axis

Places a break mark on an axis on an existing plot.

## Usage

``` r
axisBreak(
  axis = 1,
  breakpos = NULL,
  pos = NA,
  bgcol = "white",
  breakcol = "black",
  style = "slash",
  brw = 0.02
)
```

## Arguments

- axis:

  which axis to break.

- breakpos:

  where to place the break in user units.

- pos:

  position of the axis (see
  [axis](https://rdrr.io/r/graphics/axis.html)).

- bgcol:

  the color of the plot background.

- breakcol:

  the color of the "break" marker.

- style:

  Either `gap`, `slash` or `zigzag`.

- brw:

  break width relative to plot width.

## Details

The `pos` argument is not needed unless the user has specified a
different position from the default for the axis to be broken.

## Note

There is some controversy about the propriety of using discontinuous
coordinates for plotting, and thus axis breaks. Discontinuous
coordinates allow widely separated groups of values or outliers to
appear without devoting too much of the plot to empty space.  
The major objection seems to be that the reader will be misled by
assuming continuous coordinates. The `gap` style that clearly separates
the two sections of the plot is probably best for avoiding this.

## See also

Other graphics.utils:
[`abcCoords()`](https://andrisignorell.github.io/lyra/reference/abcCoords.md),
[`barText()`](https://andrisignorell.github.io/lyra/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/lyra/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/lyra/reference/colLegend.md),
[`degToRad()`](https://andrisignorell.github.io/lyra/reference/degToRad.md),
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

## Author

Jim Lemon and Ben Bolker

## Examples

``` r

plot(3:10, main="Axis break test")

# put a break at the default axis and position
axisBreak()
axisBreak(2, 2.9, style="zigzag")

```
