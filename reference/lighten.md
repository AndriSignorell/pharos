# Lighten Colors

Lighten colors by mixing them with white.

## Usage

``` r
lighten(col, amount = 0.2)
```

## Arguments

- col:

  vector of valid R colors.

- amount:

  numeric value between 0 and 1 specifying the amount of lightening. A
  value of 0 leaves the color unchanged, while 1 returns white.

## Value

Character vector of hexadecimal colors.

## Details

Colors are mixed linearly with white in RGB space: \$\$ x\_{new} = x +
amount \cdot (255 - x) \$\$

## See also

Other color.manipulation: [`addOpacity()`](addOpacity.md),
[`colToOpaque()`](colToOpaque.md), [`darken()`](darken.md),
[`fade()`](fade.md), [`mixCol()`](mixCol.md)

## Examples

``` r
lighten("tomato")
#> [1] "#FF826B"
lighten(c("tomato", "royalblue"), amount = 0.5)
#> [1] "#FFB1A3" "#A0B4F0"

# increasing amounts
amount <- seq(0, 1, 0.2)
barplot(rep(1, 6), col = sapply(amount, lighten, col = "tomato"),
        names.arg = amount, yaxt = "n", xlab = "amount")

```
