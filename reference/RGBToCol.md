# Convert RGB Colors to the Nearest Named R Color

Match RGB colors to the nearest named R color.

## Usage

``` r
rgbToCol(col, method = c("rgb", "hsv"), metric = c("euclidean", "manhattan"))
```

## Arguments

- col:

  RGB matrix or hexadecimal colors.

- method:

  color space used for matching.

- metric:

  distance metric.

## Value

Character vector of named R colors.

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
rgbToCol(matrix(c(162, 42, 42), nrow = 3))
#> [1] "brown"
rgbToCol(c("#A22A2A", "#4169E0"))
#> [1] "brown"     "royalblue"

# nearest color in HSV space
rgbToCol(c("#A22A2A", "#4169E0"), method = "hsv", metric = "manhattan")
#> [1] "brown"     "royalblue"
```
