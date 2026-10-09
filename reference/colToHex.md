# Convert R Colors to Hexadecimal Colors

Convert any valid R color specification to hexadecimal colors.

## Usage

``` r
colToHex(col, opacity = 1)
```

## Arguments

- col:

  vector of valid R colors.

- opacity:

  opacity value between 0 and 1.

## Value

Character vector of hexadecimal colors.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
colToHex(c("tomato", "royalblue"))
#> [1] "#FF6347" "#4169E1"
colToHex("tomato", opacity = 0.5)
#> [1] "#FF634780"

# color numbers refer to the current palette
colToHex(1:3)
#> [1] "#000000" "#DF536B" "#61D04F"
```
