# Convert Long Integers to RGB

Decode long integers into RGB values.

## Usage

``` r
longToRgb(col)
```

## Arguments

- col:

  integer vector.

## Value

RGB matrix.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
longToRgb(c(255, 65280, 16711680))
#>       [,1] [,2] [,3]
#> red    255    0    0
#> green    0  255    0
#> blue     0    0  255

# there and back again
rgbToHex(longToRgb(rgbToLong(colToRgb("tomato"))))
#> [1] "#FF6347"
```
