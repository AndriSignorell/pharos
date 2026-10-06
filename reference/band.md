# Band Geometry

Create a polygonal band from upper and lower boundaries.

## Usage

``` r
band(x, y)
```

## Arguments

- x:

  A vector or matrix of x coordinates.

- y:

  A vector or matrix of y coordinates.

  If either `x` or `y` is supplied as a two-column matrix, the second
  column is interpreted as the lower boundary and reversed
  automatically.

## Value

An object inheriting from class `"bandGeometry"`.

## Details

Typically used to represent confidence or prediction bands.

## See also

[graphics::polygon](https://rdrr.io/r/graphics/polygon.html)

Other geometry.structures: [`arc()`](arc.md), [`bezier()`](bezier.md),
[`circle()`](circle.md), [`ellipse()`](ellipse.md),
[`polygonX()`](polygonX.md), [`regPolygon()`](regPolygon.md),
[`ring()`](ring.md)

## Examples

``` r
set.seed(18)

x <- rnorm(15)
y <- x + rnorm(15)

new <- seq(-3, 3, 0.5)

pred <- predict(
  lm(y ~ x),
  newdata = data.frame(x = new),
  interval = "confidence"
)

plot(y ~ x)

polygonX(
  band(
    x = new,
    y = pred[,2:3]
  ),
  col = addOpacity("grey80", 0.5),
  border = NA
)



```
