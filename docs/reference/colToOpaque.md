# Equivalent Opaque Color for Transparent Color

Determine the equivalent opaque RGB color for a given partially
transparent RGB color against a background of any color.

## Usage

``` r
colToOpaque(col, alpha = NULL, bg = NULL)
```

## Arguments

- col:

  the color as hex value (use converters below if it's not available).
  `col` and `alpha` are recycled.

- alpha:

  the alpha channel, if left to NULL the alpha channels of the colors
  are used

- bg:

  the background color to be used to calculate against (default is
  "white")

## Value

An named vector with the hexcodes of the opaque colors.

## Details

Reducing the opacity against a white background is a good way to find
usable lighter and less saturated tints of a base color. For doing so,
we sometimes need to get the equivalent opaque color for the transparent
color.

## See also

[`decToHex`](https://rdrr.io/pkg/bedrock/man/numeric-conversions.html),

Other color:
[`addOpacity()`](https://andrisignorell.github.io/lyra/reference/addOpacity.md),
[`colToRGB()`](https://andrisignorell.github.io/lyra/reference/colToRGB.md),
[`contrastColor()`](https://andrisignorell.github.io/lyra/reference/contrastColor.md),
[`darken()`](https://andrisignorell.github.io/lyra/reference/darken.md),
[`findColor()`](https://andrisignorell.github.io/lyra/reference/findColor.md),
[`grayscale()`](https://andrisignorell.github.io/lyra/reference/grayscale.md),
[`hcol()`](https://andrisignorell.github.io/lyra/reference/hcol.md),
[`hexToRGB()`](https://andrisignorell.github.io/lyra/reference/hexToRGB.md),
[`lighten()`](https://andrisignorell.github.io/lyra/reference/lighten.md),
[`mixColors()`](https://andrisignorell.github.io/lyra/reference/mixColors.md),
[`pal()`](https://andrisignorell.github.io/lyra/reference/pal.md),
[`palNames()`](https://andrisignorell.github.io/lyra/reference/palNames.md),
[`setBackCol()`](https://andrisignorell.github.io/lyra/reference/setBackCol.md)

## Examples

``` r

cols <- c(addOpacity("limegreen", 0.4), 
          colToOpaque(colToHex("limegreen"), 0.4), 
          "limegreen")
barplot(c(1, 1.2, 1.3), col=cols, panel.first=abline(h=0.4, lwd=10, col="grey35"))

```
