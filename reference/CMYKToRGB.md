# Convert CMYK to RGB

Convert CMYK colors to RGB.

## Usage

``` r
cmykToRgb(col, maxColorValue = 1)
```

## Arguments

- col:

  numeric CMYK matrix (columns C, M, Y, K).

- maxColorValue:

  maximum channel value.

## Value

Numeric RGB matrix.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
cmyk <- cmyToCmyk(rgbToCmy(c("#FF6347", "#4169E1"), maxColorValue = 255))
cmykToRgb(cmyk)
#>             R         G         B
#> [1,] 1.000000 0.3882353 0.2784314
#> [2,] 0.254902 0.4117647 0.8823529

# back to hexadecimal colors
rgbToHex(t(cmykToRgb(cmyk) * 255))
#> [1] "#FF6347" "#4169E1"
```
