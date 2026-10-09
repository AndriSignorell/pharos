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
\cdot (1 - amount) \$\$

## See also

Other color.manipulation: [`addOpacity()`](addOpacity.md),
[`colToOpaque()`](colToOpaque.md), [`fade()`](fade.md),
[`lighten()`](lighten.md), [`mixCol()`](mixCol.md)

## Examples

``` r
darken("tomato")
#> [1] "#CC4F38"
darken(c("tomato", "royalblue"), amount = 0.5)
#> [1] "#7F3123" "#203470"

# increasing amounts
amount <- seq(0, 1, 0.2)
barplot(rep(1, 6), col = sapply(amount, darken, col = "tomato"),
        names.arg = amount, yaxt = "n", xlab = "amount")

```
