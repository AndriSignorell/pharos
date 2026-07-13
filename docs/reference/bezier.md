# Bézier Geometry

Create a Bézier curve from a set of control points.

## Usage

``` r
bezier(x, y = NULL, numPoints = 100)
```

## Arguments

- x, y:

  numeric vectors of control points. Alternatively, `x` may be a list
  with components `x` and `y`.

- numPoints:

  number of points used to approximate the curve.

## Value

An object inheriting from class `"bezierGeometry"`.

## References

Farin, G. (1993). *Curves and Surfaces for Computer Aided Geometric
Design*. Academic Press.

## See also

[graphics::lines](https://rdrr.io/r/graphics/lines.html)

Other geometry.structures:
[`arc()`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`band()`](https://andrisignorell.github.io/aurora/reference/band.md),
[`circle()`](https://andrisignorell.github.io/aurora/reference/circle.md),
[`ellipse()`](https://andrisignorell.github.io/aurora/reference/ellipse.md),
[`polygon()`](https://andrisignorell.github.io/aurora/reference/polygon.md),
[`regPolygon()`](https://andrisignorell.github.io/aurora/reference/regPolygon.md),
[`ring()`](https://andrisignorell.github.io/aurora/reference/ring.md)

## Examples

``` r
canvas(xlim = c(0, 1))

lines(
  bezier(
    x = c(0, 0.5, 1),
    y = c(0, 1, 0)
  ),
  col = "red",
  lwd = 2
)

```
