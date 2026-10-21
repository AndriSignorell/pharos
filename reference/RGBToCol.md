# Convert RGB Colors to the Nearest Named R Color

Finds, for each color, the perceptually closest of the named R colors
([`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html)).

## Usage

``` r
rgbToCol(col, method = c("ciede2000", "cie76"))
```

## Arguments

- col:

  colors: an RGB matrix with one color per column and channels on a
  scale from 0 to 255, as returned by [`colToRgb()`](colToRGB.md), or a
  vector of R colors (hexadecimal or named). An alpha channel is
  ignored.

- method:

  color difference formula, `"ciede2000"` (default) or `"cie76"`, see
  Details.

## Value

Character vector of named R colors, one per color in `col`; `NA` for a
missing color.

## Details

The colors are converted from sRGB to the CIELAB color space with
[`grDevices::convertColor()`](https://rdrr.io/r/grDevices/convertColor.html)
(reference white D65), where distances approximate perceived differences
far better than in RGB or HSV. Two color difference formulas are
available:

- `"ciede2000"`:

  CIEDE2000, the current CIE recommendation. It corrects the
  shortcomings of CIE76 in the blue region and for saturated and
  near-neutral colors.

- `"cie76"`:

  CIE76, the Euclidean distance in CIELAB. Simpler, slightly less
  accurate.

## References

Sharma, G., Wu, W., & Dalal, E. N. (2005). The CIEDE2000
color-difference formula: Implementation notes, supplementary test data,
and mathematical observations. *Color Research & Application*, 30(1),
21–30. [doi:10.1002/col.20070](https://doi.org/10.1002/col.20070)

## See also

[color-conversion-overview](color-conversion-overview.md)

## Examples

``` r
rgbToCol(matrix(c(162, 42, 42), nrow = 3))
#> [1] "brown"
rgbToCol(c("#A22A2A", "#4169E0"))
#> [1] "brown"     "royalblue"

# CIE76 instead of CIEDE2000
rgbToCol(c("#A22A2A", "#4169E0"), method = "cie76")
#> [1] "brown"     "royalblue"
```
