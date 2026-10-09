# Convert CMY to CMYK

Convert CMY colors to CMYK.

## Usage

``` r
cmyToCmyk(col)
```

## Arguments

- col:

  numeric CMY matrix.

## Value

Numeric CMYK matrix.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
cmy <- rgbToCmy(c("#FF6347", "#4169E1"), maxColorValue = 255)
cmyToCmyk(cmy)
#>              C         M         Y         K
#> [1,] 0.0000000 0.6117647 0.7215686 0.0000000
#> [2,] 0.7111111 0.5333333 0.0000000 0.1176471
```
