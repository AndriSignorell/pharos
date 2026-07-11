# Convert Hex Colors to Named R Colors

Convert hexadecimal colors to the nearest named R colors.

## Usage

``` r
hexToCol(hex, method = c("rgb", "hsv"), metric = c("euclidean", "manhattan"))
```

## Arguments

- hex:

  Character vector of hexadecimal colors.

- method:

  Color space used for matching.

- metric:

  Distance metric.

## Value

Character vector of named R colors.

## See also

Other color.conversion:
[`colToHSV()`](https://andrisignorell.github.io/lyra/reference/colToHSV.md),
[`colToHex()`](https://andrisignorell.github.io/lyra/reference/colToHex.md),
[`longToRGB()`](https://andrisignorell.github.io/lyra/reference/longToRGB.md),
[`rgbToCol()`](https://andrisignorell.github.io/lyra/reference/rgbToCol.md),
[`rgbToHex()`](https://andrisignorell.github.io/lyra/reference/rgbToHex.md),
[`rgbToLong()`](https://andrisignorell.github.io/lyra/reference/rgbToLong.md)
