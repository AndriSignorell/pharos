# Convert R Colors to RGB

Convert any valid R color specification to an RGB matrix.

## Usage

``` r
colToRGB(col, useAlphaChannel = FALSE)
```

## Arguments

- col:

  vector of valid R colors.

- useAlphaChannel:

  logical indicating whether the alpha channel should be included.

## Value

Integer matrix with rows corresponding to RGB (and optionally alpha)
channels.

## See also

[grDevices::col2rgb](https://rdrr.io/r/grDevices/col2rgb.html),
[color-conversion-overview](https://andrisignorell.github.io/aurora/reference/color-conversion-overview.md)

## Examples

``` r

rgbToCol(matrix(c(162,42,42), nrow=3))
#> [1] "brown"

rgbToLong(matrix(c(162,42,42), nrow=3))
#> [1] 2763426

colToRGB("peachpuff")
#>       [,1]
#> red    255
#> green  218
#> blue   185
colToRGB(c(blu = "royalblue", reddish = "tomato")) # names kept
#>       blu reddish
#> red    65     255
#> green 105      99
#> blue  225      71

colToRGB(1:8)
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> red      0  223   97   34   40  205  245  158
#> green    0   83  208  151  226   11  199  158
#> blue     0  107   79  230  229  188   16  158

```
