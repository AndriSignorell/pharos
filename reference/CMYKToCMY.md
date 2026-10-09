# Convert CMYK to CMY

Convert CMYK colors to CMY.

## Usage

``` r
cmykToCmy(col)
```

## Arguments

- col:

  numeric CMYK matrix.

## Value

Numeric CMY matrix.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
cmy <- rgbToCmy(c("#FF6347", "#4169E1"), maxColorValue = 255)
cmyk <- cmyToCmyk(cmy)

# the way back
cmykToCmy(cmyk)
#>             C         M         Y
#> [1,] 0.000000 0.6117647 0.7215686
#> [2,] 0.745098 0.5882353 0.1176471
```
