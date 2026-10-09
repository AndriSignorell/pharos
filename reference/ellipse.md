# Ellipse Geometry

Create an elliptic geometry.

## Usage

``` r
ellipse(x = 0, y = 0, radiusX = 1, radiusY = radiusX, nPoints = 100)
```

## Arguments

- x, y:

  centre coordinates.

- radiusX, radiusY:

  horizontal and vertical radius.

- nPoints:

  number of points used to approximate the ellipse.

## Value

An object inheriting from class `"ellipseGeometry"`.

## Details

Use [`rotate()`](rotate.md) to rotate the resulting geometry.

## See also

Other geometry.structures: [`arc()`](arc.md), [`band()`](band.md),
[`bezier()`](bezier.md), [`circle()`](circle.md),
[`polygonX()`](polygonX.md), [`regPolygon()`](regPolygon.md),
[`ring()`](ring.md)

## Examples

``` r
canvas(xlim = c(-2, 2))

e <- ellipse(radiusX = 1.8, radiusY = 0.8)
polygonX(e, col = "lightblue")

# the same ellipse, rotated by 45 degrees
polygonX(rotate(e, theta = pi/4), border = "red")

```
