# Convert Hex Colors to Named R Colors

Convert hexadecimal colors to the nearest named R colors.

## Usage

``` r
hexToCol(col, method = c("ciede2000", "cie76"))
```

## Arguments

- col:

  character vector of hexadecimal colors.

- method:

  color difference formula, `"ciede2000"` (default) or `"cie76"`, see
  Details.

## Value

Character vector of named R colors.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
hexToCol(c("#A22A2A", "#4169E0"))
#> [1] "brown"     "royalblue"
hexToCol("#4169E0", method = "cie76")
#> [1] "royalblue"
```
