# Ellipse Geometry

Create an elliptic geometry.

## Usage

``` r
ellipse(x = 0, y = 0, radiusX = 1, radiusY = radiusX, numPoints = 100)
```

## Arguments

- x, y:

  Centre coordinates.

- radiusX, radiusY:

  Horizontal and vertical radius.

- numPoints:

  Number of points used to approximate the ellipse.

## Value

An object inheriting from class `"ellipseGeometry"`.

## Details

Use
[`rotate`](https://andrisignorell.github.io/aurora/reference/rotate.md)
to rotate the resulting geometry.
