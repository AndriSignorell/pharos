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

[`lighten`](https://andrisignorell.github.io/lyra/reference/lighten.md),
[`darken`](https://andrisignorell.github.io/lyra/reference/darken.md)

Other color:
[`addAlpha()`](https://andrisignorell.github.io/lyra/reference/addAlpha.md),
[`colToOpaque()`](https://andrisignorell.github.io/lyra/reference/colToOpaque.md),
[`colToRGB()`](https://andrisignorell.github.io/lyra/reference/colToRGB.md),
[`contrastColor()`](https://andrisignorell.github.io/lyra/reference/contrastColor.md),
[`darken()`](https://andrisignorell.github.io/lyra/reference/darken.md),
[`findColor()`](https://andrisignorell.github.io/lyra/reference/findColor.md),
[`grayscale()`](https://andrisignorell.github.io/lyra/reference/grayscale.md),
[`hcol()`](https://andrisignorell.github.io/lyra/reference/hcol.md),
[`hexToRGB()`](https://andrisignorell.github.io/lyra/reference/hexToRGB.md),
[`lighten()`](https://andrisignorell.github.io/lyra/reference/lighten.md),
[`pal()`](https://andrisignorell.github.io/lyra/reference/pal.md),
[`palNames()`](https://andrisignorell.github.io/lyra/reference/palNames.md),
[`setBackCol()`](https://andrisignorell.github.io/lyra/reference/setBackCol.md)
