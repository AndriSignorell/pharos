# Background of a Plot

Paints the background of the plot, using either the figure region, the
plot region or both. It can sometimes be cumbersome to elaborate the
coordinates and base R does not provide a simple function for that.

## Usage

``` r
setBackCol(col = "grey", region = c("plot", "figure"), border = NA)
```

## Arguments

- col:

  the color of the background, if two colors are provided, the first is
  used for the plot region and the second for the figure region.

- region:

  either `"plot"` or `"figure"`

- border:

  color for rectangle border(s). Default is `NA` for no borders.

## See also

[`rect`](https://rdrr.io/r/graphics/rect.html)

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
[`lighten()`](https://andrisignorell.github.io/aurora/reference/lighten.md),
[`mixColors()`](https://andrisignorell.github.io/aurora/reference/mixColors.md),
[`pal()`](https://andrisignorell.github.io/aurora/reference/pal.md),
[`palNames()`](https://andrisignorell.github.io/aurora/reference/palNames.md)

## Examples

``` r

# use two different colors for the figure region and the plot region
plot(x = rnorm(100), col="blue", cex=1.2, pch=16,
     panel.first={setBackCol(c("red", "lightyellow"))
                  grid()})

```
