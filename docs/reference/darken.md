# Darken Colors

Darken colors by mixing them with black.

## Usage

``` r
darken(col, amount = 0.2)
```

## Arguments

- col:

  vector of valid R colors.

- amount:

  numeric value between 0 and 1 specifying the amount of darkening. A
  value of 0 leaves the color unchanged, while 1 returns black.

## Value

Character vector of hexadecimal colors.

## Details

Colors are mixed linearly with black in RGB space: \$\$ x\_{new} = x
\\cdot (1 - amount) \$\$

## See also

Other color.manipulation:
[`addOpacity()`](https://andrisignorell.github.io/aurora/reference/addOpacity.md),
[`colToOpaque()`](https://andrisignorell.github.io/aurora/reference/colToOpaque.md),
[`fade()`](https://andrisignorell.github.io/aurora/reference/fade.md),
[`lighten()`](https://andrisignorell.github.io/aurora/reference/lighten.md),
[`mixColors()`](https://andrisignorell.github.io/aurora/reference/mixColors.md)
