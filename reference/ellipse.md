# Ellipse Geometry

Create an elliptic geometry.

## Usage

``` r
ellipse(x = 0, y = 0, radiusX = 1, radiusY = radiusX, numPoints = 100)
```

## Arguments

- x, y:

  centre coordinates.

- radiusX, radiusY:

  horizontal and vertical radius.

- numPoints:

  number of points used to approximate the ellipse.

## Value

An object inheriting from class `"ellipseGeometry"`.

## Details

Use [`rotate()`](rotate.md) to rotate the resulting geometry.

## See also

Other geometry.structures: [`arc()`](arc.md), [`band()`](band.md),
[`bezier()`](bezier.md), [`circle()`](circle.md),
[`polygon()`](polygon.md), [`regPolygon()`](regPolygon.md),
[`ring()`](ring.md)
