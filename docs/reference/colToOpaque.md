# Equivalent Opaque Color for Transparent Color

Determine the equivalent opaque RGB color for a given partially
transparent RGB color against a background of any color.

## Usage

``` r
colToOpaque(col, opacity = NULL, bg = NULL)
```

## Arguments

- col:

  the color as hex value (use converters below if it's not available).
  `col` and `opacity` are recycled.

- opacity:

  the opacity value, if left to NULL the alpha channels of the colors
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

Other color.manipulation:
[`addOpacity()`](https://andrisignorell.github.io/aurora/reference/addOpacity.md),
[`darken()`](https://andrisignorell.github.io/aurora/reference/darken.md),
[`fade()`](https://andrisignorell.github.io/aurora/reference/fade.md),
[`lighten()`](https://andrisignorell.github.io/aurora/reference/lighten.md),
[`mixColors()`](https://andrisignorell.github.io/aurora/reference/mixColors.md)

## Examples

``` r

cols <- c(addOpacity("limegreen", 0.4), 
          colToOpaque(colToHex("limegreen"), 0.4), 
          "limegreen")
barplot(c(1, 1.2, 1.3), col=cols, panel.first=abline(h=0.4, lwd=10, col="grey35"))

```
