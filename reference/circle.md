# Circle Geometry

Create a circular geometry.

## Usage

``` r
circle(x = 0, y = 0, radius = 1, nPoints = 100)
```

## Arguments

- x, y:

  centre coordinates.

- radius:

  circle radius.

- nPoints:

  number of points used to approximate the circle.

## Value

An object inheriting from class `"circleGeometry"`.

## See also

Other geometry.structures: [`arc()`](arc.md), [`band()`](band.md),
[`bezier()`](bezier.md), [`ellipse()`](ellipse.md),
[`polygonX()`](polygonX.md), [`regPolygon()`](regPolygon.md),
[`ring()`](ring.md)

## Examples

``` r
canvas(xlim = c(-2, 2))

polygonX(circle(radius = 1.5), col = "lightblue")

# several circles at once
polygonX(circle(x = c(-0.6, 0.6), y = 0, radius = 0.4),
         col = c("tomato", "royalblue"))

```
