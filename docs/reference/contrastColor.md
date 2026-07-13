# Choose Optimal Text Color Based on WCAG Contrast

Computes the optimal text color (default: black or white) for a given
background color based on the WCAG contrast ratio.

## Usage

``` r
contrastColor(col, light = "white", dark = "black")
```

## Arguments

- col:

  Vector of colors. Can be any valid R color specification: color names,
  hexadecimal strings (e.g. `"#RRGGBB"` or `"#RRGGBBAA"`), or palette
  indices.

- light:

  Color used for dark backgrounds (default: `"white"`).

- dark:

  Color used for light backgrounds (default: `"black"`).

## Value

A character vector of the same length as `col`, containing either
`light` or `dark`, depending on which yields the higher contrast ratio.

## Details

This function implements the official relative luminance definition for
sRGB colors (including gamma correction) and selects the text color that
maximizes the contrast ratio according to the Web Content Accessibility
Guidelines (WCAG 2.1).

Compared to simple heuristics (e.g., mean RGB), this approach is
perceptually more accurate and suitable for accessibility-critical
applications.

The relative luminance is computed as:

\$\$L = 0.2126 R + 0.7152 G + 0.0722 B\$\$

where \\R, G, B\\ are linearized sRGB components:

\$\$ c\_{lin} = \begin{cases} \frac{c}{12.92} & c \le 0.04045 \\
\left(\frac{c + 0.055}{1.055}\right)^{2.4} & c \> 0.04045 \end{cases}
\$\$

The contrast ratio between two luminance values \\L1\\ and \\L2\\ is:

\$\$ \frac{\max(L1, L2) + 0.05}{\min(L1, L2) + 0.05} \$\$

The function compares contrast ratios against `light` and `dark` and
returns the better option.

## See also

Other color:
[`addOpacity()`](https://andrisignorell.github.io/lyra/reference/addOpacity.md),
[`colToOpaque()`](https://andrisignorell.github.io/lyra/reference/colToOpaque.md),
[`colToRGB()`](https://andrisignorell.github.io/lyra/reference/colToRGB.md),
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
cols <- c("black", "white", "red", "blue", "yellow", "#777777")
contrastColor(cols)
#> [1] "white" "black" "black" "white" "black" "black"

# custom text colors
contrastColor(cols, light = "#FFFFFF", dark = "#222222")
#> [1] "#FFFFFF" "#222222" "#FFFFFF" "#FFFFFF" "#222222" "#FFFFFF"
```
