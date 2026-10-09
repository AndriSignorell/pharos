# Convert RGB to CMY

Convert RGB colors to the CMY color space.

## Usage

``` r
rgbToCmy(col, maxColorValue = 1)
```

## Arguments

- col:

  RGB matrix with one color per row (columns red, green and blue), or a
  vector of hexadecimal colors.

- maxColorValue:

  maximum channel value of `col`. Use 255 for hexadecimal colors.

## Value

Numeric CMY matrix with one color per row.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
# one color per row, channels on a scale from 0 to 1
rgbToCmy(matrix(c(1, 0.39, 0.28), nrow = 1))
#>      C    M    Y
#> [1,] 0 0.61 0.72

# the channels of hexadecimal colors run from 0 to 255
rgbToCmy(c("#FF6347", "#4169E1"), maxColorValue = 255)
#>             C         M         Y
#> [1,] 0.000000 0.6117647 0.7215686
#> [2,] 0.745098 0.5882353 0.1176471
```
