# Ring Geometry

Create one or more rings or ring segments.

## Usage

``` r
ring(
  x = 0,
  y = 0,
  innerRadius = 0.5,
  outerRadius = 1,
  startAngle = 0,
  endAngle = 2 * pi,
  numPoints = 100
)
```

## Arguments

- x, y:

  centre coordinates.

- innerRadius:

  radius of the inner boundary.

- outerRadius:

  radius of the outer boundary.

- startAngle, endAngle:

  start and end angle in radians.

- numPoints:

  number of points used for each boundary.

## Value

An object inheriting from class `"ringGeometry"` or a
`"geometryCollection"`.

## See also

Other geometry.structures:
[`arc()`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`band()`](https://andrisignorell.github.io/aurora/reference/band.md),
[`bezier()`](https://andrisignorell.github.io/aurora/reference/bezier.md),
[`circle()`](https://andrisignorell.github.io/aurora/reference/circle.md),
[`ellipse()`](https://andrisignorell.github.io/aurora/reference/ellipse.md),
[`polygon()`](https://andrisignorell.github.io/aurora/reference/polygon.md),
[`regPolygon()`](https://andrisignorell.github.io/aurora/reference/regPolygon.md)
