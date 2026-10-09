# Convert RGB to Long Integers

Encode RGB colors as long integers.

## Usage

``` r
rgbToLong(col)
```

## Arguments

- col:

  RGB matrix.

## Value

Integer vector.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
rgbToLong(colToRgb(c("red", "green", "blue")))
#> [1]      255    65280 16711680
```
