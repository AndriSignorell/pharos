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

  Coordinates of the arc centre.

- radiusX, radiusY:

  Horizontal and vertical radius.

- startAngle, endAngle:

  Start and end angle in radians.

- numPoints:

  Number of points used to approximate the arc.

## Value

An object inheriting from class `"arcGeometry"`.

## See also

Other geometry:
[`band()`](https://andrisignorell.github.io/lyra/reference/band.md),
[`bezier()`](https://andrisignorell.github.io/lyra/reference/bezier.md),
[`canvas()`](https://andrisignorell.github.io/lyra/reference/canvas.md),
[`polarGrid()`](https://andrisignorell.github.io/lyra/reference/polarGrid.md),
[`polygon()`](https://andrisignorell.github.io/lyra/reference/polygon.md),
[`rotate()`](https://andrisignorell.github.io/lyra/reference/rotate.md),
[`shade()`](https://andrisignorell.github.io/lyra/reference/shade.md),
[`transformXY()`](https://andrisignorell.github.io/lyra/reference/transformXY.md)
