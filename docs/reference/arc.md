# Arc Geometry

Create one or more circular or elliptic arcs.

## Usage

``` r
arc(
  x = 0,
  y = 0,
  radiusX = 1,
  radiusY = radiusX,
  startAngle = 0,
  endAngle = 2 * pi,
  numPoints = 100
)
```

## Arguments

- x, y:

  coordinates of the arc centre

- radiusX, radiusY:

  horizontal and vertical radius

- startAngle, endAngle:

  start and end angle in radians

- numPoints:

  number of points used to approximate the arc

## Value

An object inheriting from class `"arcGeometry"`.

## See also

Other geometry.structures:
[`band()`](https://andrisignorell.github.io/aurora/reference/band.md),
[`bezier()`](https://andrisignorell.github.io/aurora/reference/bezier.md),
[`circle()`](https://andrisignorell.github.io/aurora/reference/circle.md),
[`ellipse()`](https://andrisignorell.github.io/aurora/reference/ellipse.md),
[`polygon()`](https://andrisignorell.github.io/aurora/reference/polygon.md),
[`regPolygon()`](https://andrisignorell.github.io/aurora/reference/regPolygon.md),
[`ring()`](https://andrisignorell.github.io/aurora/reference/ring.md)
