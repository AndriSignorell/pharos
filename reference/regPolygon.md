# Regular Polygon Geometry

Create a regular polygon.

## Usage

``` r
regPolygon(x = 0, y = 0, radius = 1, nVertices = 6, startAngle = 0)
```

## Arguments

- x, y:

  centre coordinates.

- radius:

  circumradius.

- nVertices:

  number of vertices.

- startAngle:

  staring angle in radians.

## Value

An object inheriting from class `"regPolygonGeometry"`.

## See also

Other geometry.structures: [`arc()`](arc.md), [`band()`](band.md),
[`bezier()`](bezier.md), [`circle()`](circle.md),
[`ellipse()`](ellipse.md), [`polygonX()`](polygonX.md),
[`ring()`](ring.md)

## Examples

``` r
canvas(xlim = c(-2, 2))

# a hexagon is the default
polygonX(regPolygon(radius = 1.8), col = "lightblue")

# a square, once standing on a vertex and once on an edge
polygonX(regPolygon(radius = 1.2, nVertices = 4), border = "red")
polygonX(regPolygon(radius = 1.2, nVertices = 4, startAngle = pi/4))

# a triangle pointing upwards
polygonX(regPolygon(radius = 0.5, nVertices = 3, startAngle = pi/2),
         col = "royalblue")

```
