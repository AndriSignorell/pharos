# Convert R Colors to RGB

Convert any valid R color specification to an RGB matrix.

## Usage

``` r
colToRGB(col, alpha = FALSE)
```

## Arguments

- col:

  Vector of valid R colors.

- alpha:

  Logical indicating whether the alpha channel should be included.

## Value

Integer matrix with rows corresponding to RGB (and optionally alpha)
channels.

## See also

[`col2rgb`](https://rdrr.io/r/grDevices/col2rgb.html)

Other color:
[`addOpacity()`](https://andrisignorell.github.io/lyra/reference/addOpacity.md),
[`colToOpaque()`](https://andrisignorell.github.io/lyra/reference/colToOpaque.md),
[`contrastColor()`](https://andrisignorell.github.io/lyra/reference/contrastColor.md),
[`darken()`](https://andrisignorell.github.io/lyra/reference/darken.md),
[`findColor()`](https://andrisignorell.github.io/lyra/reference/findColor.md),
[`grayscale()`](https://andrisignorell.github.io/lyra/reference/grayscale.md),
[`hcol()`](https://andrisignorell.github.io/lyra/reference/hcol.md),
[`hexToRGB()`](https://andrisignorell.github.io/lyra/reference/hexToRGB.md),
[`lighten()`](https://andrisignorell.github.io/lyra/reference/lighten.md),
[`mixColors()`](https://andrisignorell.github.io/lyra/reference/mixColors.md),
[`pal()`](https://andrisignorell.github.io/lyra/reference/pal.md),
[`palNames()`](https://andrisignorell.github.io/lyra/reference/palNames.md),
[`setBackCol()`](https://andrisignorell.github.io/lyra/reference/setBackCol.md)

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
