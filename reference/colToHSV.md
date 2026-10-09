# Convert R Colors to HSV

Convert any valid R color specification to HSV.

## Usage

``` r
colToHsv(col, useAlphaChannel = FALSE)
```

## Arguments

- col:

  vector of valid R colors.

- useAlphaChannel:

  logical indicating whether the alpha channel should be included.

## Value

Numeric HSV matrix with one column per color. With
`useAlphaChannel = TRUE` the alpha channel is added as fourth row,
scaled to the range from 0 to 1 like the other rows.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
colToHsv(c("tomato", "royalblue"))
#>         [,1]      [,2]
#> h 0.02536232 0.6250000
#> s 0.72156863 0.7111111
#> v 1.00000000 0.8823529

# the alpha channel is added as fourth row, on a scale from 0 to 1
colToHsv("#FF634780", useAlphaChannel = TRUE)
#>             [,1]
#> h     0.02536232
#> s     0.72156863
#> v     1.00000000
#> alpha 0.50196078
```
