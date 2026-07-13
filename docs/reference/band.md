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

Other geometry.structures:
[`arc()`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`bezier()`](https://andrisignorell.github.io/aurora/reference/bezier.md),
[`circle()`](https://andrisignorell.github.io/aurora/reference/circle.md),
[`ellipse()`](https://andrisignorell.github.io/aurora/reference/ellipse.md),
[`polygon()`](https://andrisignorell.github.io/aurora/reference/polygon.md),
[`regPolygon()`](https://andrisignorell.github.io/aurora/reference/regPolygon.md),
[`ring()`](https://andrisignorell.github.io/aurora/reference/ring.md)

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

polygon(
  band(
    x = new,
    y = pred[,2:3]
  ),
  col = addOpacity("grey80", 0.5),
  border = NA
)



```
