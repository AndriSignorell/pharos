# Add an Alpha Channel to Colors

Add transparency to colors.

## Usage

``` r
addOpacity(col, opacity = 0.5)
```

## Arguments

- col:

  vector of valid R colors

- opacity:

  opacity value between 0 and 1

## Value

Character vector of hexadecimal colors with alpha channel.

## See also

[grDevices::adjustcolor](https://rdrr.io/r/grDevices/adjustcolor.html)

Other color.manipulation: [`colToOpaque()`](colToOpaque.md),
[`darken()`](darken.md), [`fade()`](fade.md), [`lighten()`](lighten.md),
[`mixCol()`](mixCol.md)

## Examples

``` r

op <- par(no.readonly = TRUE)

addOpacity("yellow", 0.2)
#>      yellow 
#> "#FFFF0033" 
addOpacity(2, 0.5)   # red
#> [1] "#DF536B80"

canvas(3)
polygonX(circle(x=c(-1,0,1), y=c(1,-1,1), radius=2), 
        col=addOpacity(2:4, 0.4))


x <- rnorm(15000)
par(mfrow=c(1,2))
plot(x, type="p", col="blue" )
plot(x, type="p", col=addOpacity("blue", .2), 
     main="Better insight with alpha channel" )


par(op)
```
