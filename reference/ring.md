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
  nPoints = 100
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

- nPoints:

  number of points used for each boundary.

## Value

An object inheriting from class `"ringGeometry"` or a
`"geometryCollection"`.

## See also

Other geometry.structures: [`arc()`](arc.md), [`band()`](band.md),
[`bezier()`](bezier.md), [`circle()`](circle.md),
[`ellipse()`](ellipse.md), [`polygonX()`](polygonX.md),
[`regPolygon()`](regPolygon.md)
