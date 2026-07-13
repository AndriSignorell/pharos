# Convert Hex Colors to Named R Colors

Convert hexadecimal colors to the nearest named R colors.

## Usage

``` r
hexToCol(hex, method = c("rgb", "hsv"), metric = c("euclidean", "manhattan"))
```

## Arguments

- hex:

  character vector of hexadecimal colors.

- method:

  color space used for matching.

- metric:

  distance metric.

## Value

Character vector of named R colors.

## See also

[color-conversion-overview](https://andrisignorell.github.io/aurora/reference/color-conversion-overview.md)
