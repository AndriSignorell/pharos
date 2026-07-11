# Darken Colors

Darken colors by mixing them with black.

## Usage

``` r
darken(col, amount = 0.2)
```

## Arguments

- col:

  Vector of valid R colors.

- amount:

  Numeric value between 0 and 1 specifying the amount of darkening. A
  value of 0 leaves the color unchanged, while 1 returns black.

## Value

Character vector of hexadecimal colors.

## Details

Colors are mixed linearly with black in RGB space: \$\$ x\_{new} = x
\\cdot (1 - amount) \$\$

## See also

Other color:
[`addAlpha()`](https://andrisignorell.github.io/lyra/reference/addAlpha.md),
[`colToOpaque()`](https://andrisignorell.github.io/lyra/reference/colToOpaque.md),
[`colToRGB()`](https://andrisignorell.github.io/lyra/reference/colToRGB.md),
[`contrastColor()`](https://andrisignorell.github.io/lyra/reference/contrastColor.md),
[`findColor()`](https://andrisignorell.github.io/lyra/reference/findColor.md),
[`grayscale()`](https://andrisignorell.github.io/lyra/reference/grayscale.md),
[`hcol()`](https://andrisignorell.github.io/lyra/reference/hcol.md),
[`hexToRGB()`](https://andrisignorell.github.io/lyra/reference/hexToRGB.md),
[`lighten()`](https://andrisignorell.github.io/lyra/reference/lighten.md),
[`mixColors()`](https://andrisignorell.github.io/lyra/reference/mixColors.md),
[`pal()`](https://andrisignorell.github.io/lyra/reference/pal.md),
[`palNames()`](https://andrisignorell.github.io/lyra/reference/palNames.md),
[`setBackCol()`](https://andrisignorell.github.io/lyra/reference/setBackCol.md)
