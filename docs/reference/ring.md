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

  Centre coordinates.

- innerRadius:

  Radius of the inner boundary.

- outerRadius:

  Radius of the outer boundary.

- startAngle, endAngle:

  Start and end angle in radians.

- numPoints:

  Number of points used for each boundary.

## Value

An object inheriting from class `"ringGeometry"` or a
`"geometryCollection"`.
