# Convert RGB to Hexadecimal Colors

Convert RGB values to hexadecimal color strings.

## Usage

``` r
rgbToHex(col)
```

## Arguments

- col:

  RGB matrix with one color per column, as returned by
  [`colToRgb()`](colToRGB.md), or a vector with the channel values of a
  single color.

## Value

Character vector of hexadecimal colors, one per color.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
rgbToHex(c(162, 42, 42))
#> [1] "#A22A2A"

# one color per column, as returned by colToRgb()
rgbToHex(colToRgb(c("tomato", "royalblue")))
#> [1] "#FF6347" "#4169E1"
```
