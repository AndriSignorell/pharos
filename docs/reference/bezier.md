# Bézier Geometry

Create a Bézier curve from a set of control points.

## Usage

``` r
bezier(x, y = NULL, numPoints = 100)
```

## Arguments

- x, y:

  Numeric vectors of control points. Alternatively, `x` may be a list
  with components `x` and `y`.

- numPoints:

  Number of points used to approximate the curve.

## Value

An object inheriting from class `"bezierGeometry"`.

## References

Farin, G. (1993). *Curves and Surfaces for Computer Aided Geometric
Design*. Academic Press.

## See also

[`arc`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`lines`](https://rdrr.io/r/graphics/lines.html)

Other geometry:
[`arc()`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`band()`](https://andrisignorell.github.io/aurora/reference/band.md),
[`canvas()`](https://andrisignorell.github.io/aurora/reference/canvas.md),
[`polarGrid()`](https://andrisignorell.github.io/aurora/reference/polarGrid.md),
[`polygon()`](https://andrisignorell.github.io/aurora/reference/polygon.md),
[`rotate()`](https://andrisignorell.github.io/aurora/reference/rotate.md),
[`shade()`](https://andrisignorell.github.io/aurora/reference/shade.md),
[`transformXY()`](https://andrisignorell.github.io/aurora/reference/transformXY.md)

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
