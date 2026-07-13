# Convert Colors to Grayscale

Convert colors to grayscale using luminance weighting.

## Usage

``` r
grayscale(col)
```

## Arguments

- col:

  Vector of valid R colors.

## Value

Character vector of grayscale colors.

## Details

Grayscale conversion uses the standard luminance approximation: \$\$0.3
R + 0.59 G + 0.11 B\$\$

## See also

Other color:
[`addOpacity()`](https://andrisignorell.github.io/lyra/reference/addOpacity.md),
[`colToOpaque()`](https://andrisignorell.github.io/lyra/reference/colToOpaque.md),
[`colToRGB()`](https://andrisignorell.github.io/lyra/reference/colToRGB.md),
[`contrastColor()`](https://andrisignorell.github.io/lyra/reference/contrastColor.md),
[`darken()`](https://andrisignorell.github.io/lyra/reference/darken.md),
[`findColor()`](https://andrisignorell.github.io/lyra/reference/findColor.md),
[`hcol()`](https://andrisignorell.github.io/lyra/reference/hcol.md),
[`hexToRGB()`](https://andrisignorell.github.io/lyra/reference/hexToRGB.md),
[`lighten()`](https://andrisignorell.github.io/lyra/reference/lighten.md),
[`mixColors()`](https://andrisignorell.github.io/lyra/reference/mixColors.md),
[`pal()`](https://andrisignorell.github.io/lyra/reference/pal.md),
[`palNames()`](https://andrisignorell.github.io/lyra/reference/palNames.md),
[`setBackCol()`](https://andrisignorell.github.io/lyra/reference/setBackCol.md)

## Examples

``` r
op <- par(no.readonly = TRUE)
par(mfcol=c(2,2))

tmp <- 1:3
names(tmp) <- c('red','green','blue')

barplot(tmp, col=c('red','green','blue'))
barplot(tmp, col=grayscale(c('red','green','blue')))

barplot(tmp, col=c('red','#008100','#3636ff'))
barplot(tmp, col=grayscale(c('red','#008100','#3636ff')))


par(op)
```
