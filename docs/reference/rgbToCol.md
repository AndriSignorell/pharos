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

  Color space used for matching.

- metric:

  Distance metric.

## Value

Character vector of named R colors.

## See also

Other color.conversion:
[`colToHSV()`](https://andrisignorell.github.io/aurora/reference/colToHSV.md),
[`colToHex()`](https://andrisignorell.github.io/aurora/reference/colToHex.md),
[`hexToCol()`](https://andrisignorell.github.io/aurora/reference/hexToCol.md),
[`longToRGB()`](https://andrisignorell.github.io/aurora/reference/longToRGB.md),
[`rgbToHex()`](https://andrisignorell.github.io/aurora/reference/rgbToHex.md),
[`rgbToLong()`](https://andrisignorell.github.io/aurora/reference/rgbToLong.md)
