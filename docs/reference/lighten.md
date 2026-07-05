# Lighten Colors

Lighten colors by mixing them with white.

## Usage

``` r
lighten(col, amount = 0.2)
```

## Arguments

- col:

  Vector of valid R colors.

- amount:

  Numeric value between 0 and 1 specifying the amount of lightening. A
  value of 0 leaves the color unchanged, while 1 returns white.

## Value

Character vector of hexadecimal colors.

## Details

Colors are mixed linearly with white in RGB space: \$\$ x\_{new} = x +
amount \cdot (255 - x) \$\$

## See also

Other color:
[`addAlpha()`](https://andrisignorell.github.io/aurora/reference/addAlpha.md),
[`colToOpaque()`](https://andrisignorell.github.io/aurora/reference/colToOpaque.md),
[`colToRGB()`](https://andrisignorell.github.io/aurora/reference/colToRGB.md),
[`contrastColor()`](https://andrisignorell.github.io/aurora/reference/contrastColor.md),
[`darken()`](https://andrisignorell.github.io/aurora/reference/darken.md),
[`findColor()`](https://andrisignorell.github.io/aurora/reference/findColor.md),
[`grayscale()`](https://andrisignorell.github.io/aurora/reference/grayscale.md),
[`hcol()`](https://andrisignorell.github.io/aurora/reference/hcol.md),
[`hexToRGB()`](https://andrisignorell.github.io/aurora/reference/hexToRGB.md),
[`mixColors()`](https://andrisignorell.github.io/aurora/reference/mixColors.md),
[`pal()`](https://andrisignorell.github.io/aurora/reference/pal.md),
[`palNames()`](https://andrisignorell.github.io/aurora/reference/palNames.md),
[`setBackCol()`](https://andrisignorell.github.io/aurora/reference/setBackCol.md)
