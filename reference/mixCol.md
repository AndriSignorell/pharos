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
