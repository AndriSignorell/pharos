# Bézier Geometry

Create a Bézier curve from a set of control points.

## Usage

``` r
bezier(x, y = NULL, nPoints = 100)
```

## Arguments

- x, y:

  numeric vectors of control points. Alternatively, `x` may be a list
  with components `x` and `y`.

- nPoints:

  number of points used to approximate the curve.

## Value

An object inheriting from class `"bezierGeometry"`.

## References

Farin, G. (1993). *Curves and Surfaces for Computer Aided Geometric
Design*. Academic Press.

## See also

[graphics::lines](https://rdrr.io/r/graphics/lines.html)

Other geometry.structures: [`arc()`](arc.md), [`band()`](band.md),
[`circle()`](circle.md), [`ellipse()`](ellipse.md),
[`polygonX()`](polygonX.md), [`regPolygon()`](regPolygon.md),
[`ring()`](ring.md)

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
