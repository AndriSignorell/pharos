# Mix Colors

Mix two sets of colors in RGB space.

## Usage

``` r
mixCol(col1, col2, weights = 0.5)
```

## Arguments

- col1:

  first vector of colors.

- col2:

  second vector of colors.

- weights:

  numeric value between 0 and 1 specifying the contribution of `col2`. A
  value of 0 returns `col1`, while 1 returns `col2`.

## Value

Character vector of hexadecimal colors.

## Details

Colors are mixed linearly in RGB space: \$\$ x\_{mix} = (1 - weights)
x_1 + weights x_2 \$\$

All arguments are recycled as necessary.

## See also

Other color.manipulation: [`addOpacity()`](addOpacity.md),
[`colToOpaque()`](colToOpaque.md), [`darken()`](darken.md),
[`fade()`](fade.md), [`lighten()`](lighten.md)

## Examples

``` r
mixCol("red", "blue")
#> [1] "#7F007F"
mixCol("red", "blue", weights = 0.2)
#> [1] "#CC0033"

# the shorter vector is recycled
mixCol(c("red", "yellow"), "blue")
#> [1] "#7F007F" "#7F7F7F"

# from red to blue
w <- seq(0, 1, 0.1)
barplot(rep(1, 11), col = sapply(w, mixCol, col1 = "red", col2 = "blue"),
        names.arg = w, yaxt = "n", xlab = "weights")

```
