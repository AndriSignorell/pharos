# Mix Colors

Mix two sets of colors in RGB space.

## Usage

``` r
mixColors(col1, col2, weights = 0.5)
```

## Arguments

- col1:

  First vector of colors.

- col2:

  Second vector of colors.

- weights:

  Numeric value between 0 and 1 specifying the contribution of `col2`. A
  value of 0 returns `col1`, while 1 returns `col2`.

## Value

Character vector of hexadecimal colors.

## Details

Colors are mixed linearly in RGB space: \$\$ x\_{mix} = (1 - weights)
x_1 + weights x_2 \$\$

All arguments are recycled as necessary.

## See also

[`lighten`](https://andrisignorell.github.io/aurora/reference/lighten.md),
[`darken`](https://andrisignorell.github.io/aurora/reference/darken.md)

Other color:
[`addOpacity()`](https://andrisignorell.github.io/aurora/reference/addOpacity.md),
[`colToOpaque()`](https://andrisignorell.github.io/aurora/reference/colToOpaque.md),
[`colToRGB()`](https://andrisignorell.github.io/aurora/reference/colToRGB.md),
[`contrastColor()`](https://andrisignorell.github.io/aurora/reference/contrastColor.md),
[`darken()`](https://andrisignorell.github.io/aurora/reference/darken.md),
[`findColor()`](https://andrisignorell.github.io/aurora/reference/findColor.md),
[`grayscale()`](https://andrisignorell.github.io/aurora/reference/grayscale.md),
[`hcol()`](https://andrisignorell.github.io/aurora/reference/hcol.md),
[`hexToRGB()`](https://andrisignorell.github.io/aurora/reference/hexToRGB.md),
[`lighten()`](https://andrisignorell.github.io/aurora/reference/lighten.md),
[`pal()`](https://andrisignorell.github.io/aurora/reference/pal.md),
[`palNames()`](https://andrisignorell.github.io/aurora/reference/palNames.md),
[`setBackCol()`](https://andrisignorell.github.io/aurora/reference/setBackCol.md)
