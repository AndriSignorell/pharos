# Color Conversion Functions in lyra

lyra provides a family of functions for converting colors between
representations. Read each matrix as **row -\> column**: the cell at row
X, column Y is the function that converts a color from representation X
to representation Y. `-` marks the diagonal (no self-conversion), `.`
marks a combination with no direct function. RGB is the hub between the
two tables below.

## R color, hex, HSV, and RGB

|  |  |  |  |  |
|----|----|----|----|----|
| From \\ To | Col | Hex | HSV | RGB |
| **Col** | \- | [`colToHex()`](https://andrisignorell.github.io/aurora/reference/colToHex.md) | [`colToHSV()`](https://andrisignorell.github.io/aurora/reference/colToHSV.md) | [`colToRGB()`](https://andrisignorell.github.io/aurora/reference/colToRGB.md) |
| **Hex** | [`hexToCol()`](https://andrisignorell.github.io/aurora/reference/hexToCol.md) | \- | . | [`hexToRGB()`](https://andrisignorell.github.io/aurora/reference/hexToRGB.md) |
| **HSV** | . | . | \- | . |
| **RGB** | [`rgbToCol()`](https://andrisignorell.github.io/aurora/reference/rgbToCol.md) | [`rgbToHex()`](https://andrisignorell.github.io/aurora/reference/rgbToHex.md) | . | \- |

*"Col" is any valid R color specification (name, hex string, or palette
index) as accepted by*
[`col2rgb`](https://rdrr.io/r/grDevices/col2rgb.html). No function
starts from HSV: it is only ever a conversion target (via
[`colToHSV`](https://andrisignorell.github.io/aurora/reference/colToHSV.md)),
not a source – see the note below the second table for the reason this
gap is left open.

## RGB, CMY, CMYK, and long integer

|  |  |  |  |  |
|----|----|----|----|----|
| From \\ To | CMY | CMYK | Long | RGB |
| **CMY** | \- | [`cmyToCmyk()`](https://andrisignorell.github.io/aurora/reference/cmyToCmyk.md) | . | . |
| **CMYK** | [`cmykToCmy()`](https://andrisignorell.github.io/aurora/reference/cmykToCmy.md) | \- | . | [`cmykToRgb()`](https://andrisignorell.github.io/aurora/reference/cmykToRgb.md) |
| **Long** | . | . | \- | [`longToRGB()`](https://andrisignorell.github.io/aurora/reference/longToRGB.md) |
| **RGB** | [`rgbToCmy()`](https://andrisignorell.github.io/aurora/reference/rgbToCmy.md) | . | [`rgbToLong()`](https://andrisignorell.github.io/aurora/reference/rgbToLong.md) | \- |

## Not part of either conversion matrix

Two related functions transform a color without changing its
representation, so they don't fit a row/column slot above:

|  |  |
|----|----|
| Function | Purpose |
| [`colToOpaque()`](https://andrisignorell.github.io/aurora/reference/colToOpaque.md) | Computes the equivalent opaque color for a transparent color against a background – Hex stays Hex |
| [`grayScale()`](https://andrisignorell.github.io/aurora/reference/grayScale.md) | Converts colors to grayscale using luminance weighting – Col stays Col |

## Why HSV has no source functions

Base R already provides the HSV -\> Col/Hex direction via
[`hsv()`](https://rdrr.io/r/grDevices/hsv.html), which builds a hex
color string directly from h/s/v values – the same role
[`rgb()`](https://rdrr.io/r/grDevices/rgb.html) plays for RGB triplets.
lyra deliberately doesn't duplicate it; chain
[`hsv()`](https://rdrr.io/r/grDevices/hsv.html) into
[`colToRGB()`](https://andrisignorell.github.io/aurora/reference/colToRGB.md)
or
[`colToHex()`](https://andrisignorell.github.io/aurora/reference/colToHex.md)
instead (see examples).

## See also

[`grDevices::col2rgb()`](https://rdrr.io/r/grDevices/col2rgb.html),
[`grDevices::hsv()`](https://rdrr.io/r/grDevices/hsv.html)

## Examples

``` r
# A "." in the matrix means chaining two functions through a hub
# (usually RGB or Col), not a missing feature.

# CMY -> RGB: no direct function: CMY -> CMYK -> RGB
c(0.2, 0.6, 0.9) |> cmyToCmyk() |> cmykToRgb()
#>     R   G   B
#> C 0.8 0.4 0.1

# Long integer -> R color name: Long -> RGB -> Col
255 |> longToRGB() |> rgbToCol()
#> [1] "red"

# HSV -> RGB: base R's hsv() bridges the gap noted above
hsv(h = 0.6, s = 0.8, v = 0.9) |> colToRGB()
#>       [,1]
#> red     46
#> green  119
#> blue   230
```
