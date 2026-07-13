# Add an Alpha Channel to Colors

Add transparency to colors.

## Usage

``` r
addOpacity(col, alpha = 0.5)
```

## Arguments

- col:

  Vector of valid R colors.

- alpha:

  Alpha transparency values between 0 and 1.

## Value

Character vector of hexadecimal colors with alpha channel.

## See also

[`adjustcolor`](https://rdrr.io/r/grDevices/adjustcolor.html),
[`colToOpaque`](https://andrisignorell.github.io/lyra/reference/colToOpaque.md)

Other color:
[`colToOpaque()`](https://andrisignorell.github.io/lyra/reference/colToOpaque.md),
[`colToRGB()`](https://andrisignorell.github.io/lyra/reference/colToRGB.md),
[`contrastColor()`](https://andrisignorell.github.io/lyra/reference/contrastColor.md),
[`darken()`](https://andrisignorell.github.io/lyra/reference/darken.md),
[`findColor()`](https://andrisignorell.github.io/lyra/reference/findColor.md),
[`grayscale()`](https://andrisignorell.github.io/lyra/reference/grayscale.md),
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

addOpacity("yellow", 0.2)
#>      yellow 
#> "#FFFF0033" 
addOpacity(2, 0.5)   # red
#> [1] "#DF536B80"

canvas(3)
polygon(circle(x=c(-1,0,1), y=c(1,-1,1), radius=2), 
        col=addOpacity(2:4, 0.4))


x <- rnorm(15000)
par(mfrow=c(1,2))
plot(x, type="p", col="blue" )
plot(x, type="p", col=addOpacity("blue", .2), 
     main="Better insight with alpha channel" )


par(op)
```
