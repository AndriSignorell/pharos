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

[color-conversion-overview](https://andrisignorell.github.io/aurora/reference/color-conversion-overview.md)
