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
  nPoints = 100
)
```

## Arguments

- x, y:

  coordinates of the arc centre

- radiusX, radiusY:

  horizontal and vertical radius

- startAngle, endAngle:

  start and end angle in radians

- nPoints:

  number of points used to approximate the arc

## Value

An object inheriting from class `"arcGeometry"`.

## See also

Other geometry.structures: [`band()`](band.md), [`bezier()`](bezier.md),
[`circle()`](circle.md), [`ellipse()`](ellipse.md),
[`polygonX()`](polygonX.md), [`regPolygon()`](regPolygon.md),
[`ring()`](ring.md)

## Examples

``` r
canvas(xlim = c(-2, 2))

# a quarter of a circle
lines(arc(radiusX = 1.5, startAngle = 0, endAngle = pi/2), lwd = 2)

# elliptic arcs, vectors of radii yield a collection of arcs
a <- arc(radiusX = c(0.5, 1), radiusY = c(1, 1.8),
         startAngle = pi, endAngle = 3*pi/2)
lines(a, col = "red")

```
