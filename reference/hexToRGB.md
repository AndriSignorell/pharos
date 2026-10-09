# Convert Hex Colors to RGB

Convert hexadecimal color strings to an RGB matrix.

## Usage

``` r
hexToRgb(col)
```

## Arguments

- col:

  character vector of hexadecimal colors.

## Value

Integer matrix with RGB rows.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
hexToRgb(c("#A52A2A", "#FFDAB9"))
#>       A52A2A FFDAB9
#> red      165    255
#> green     42    218
#> blue      42    185

# an alpha channel is kept
hexToRgb("#A52A2A80")
#>       A52A2A80
#> red        165
#> green       42
#> blue        42
#> alpha      128
```
