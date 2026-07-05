# Draw Polygonal Geometries

Generic function for drawing polygon-based geometry objects. This
function extends graphics::polygon() with support for geometry objects
such as circle(), ellipse(), regPolygon() and ring() and further remains
fully compatible with its original interface. \#' For ordinary
coordinate vectors the call is forwarded to
[`polygon`](https://rdrr.io/r/graphics/polygon.html). Geometry objects
such as
[`circle`](https://andrisignorell.github.io/aurora/reference/circle.md),
[`ellipse`](https://andrisignorell.github.io/aurora/reference/ellipse.md),
[`regPolygon`](https://andrisignorell.github.io/aurora/reference/regPolygon.md)
and [`ring`](https://andrisignorell.github.io/aurora/reference/ring.md)
are dispatched to specialised methods.

## Usage

``` r
polygon(x, ...)

# Default S3 method
polygon(
  x,
  y = NULL,
  density = NULL,
  angle = 45,
  border = NULL,
  col = NA,
  lty = par("lty"),
  ...,
  fillOddEven = FALSE
)

# S3 method for class 'ringGeometry'
polygon(x, rule = "evenodd", ...)

# S3 method for class 'polygonGeometry'
polygon(x, ...)
```

## Arguments

- x:

  An object to be drawn.

- ...:

  Further arguments passed to the corresponding method.

- y:

  Numeric vector of y-coordinates.

- density:

  Density of shading lines.

- angle:

  Angle of shading lines in degrees.

- border:

  Border colour.

- col:

  Fill colour.

- lty:

  Line type.

- fillOddEven:

  Logical; should the odd-even rule be used for filling?

- rule:

  Character string specifying the filling rule passed to
  [`polypath`](https://rdrr.io/r/graphics/polypath.html). One of
  `"evenodd"` or `"winding"`.

## Value

Invisibly returns `x`.

## See also

[`arc`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`circle`](https://andrisignorell.github.io/aurora/reference/circle.md),
[`ellipse`](https://andrisignorell.github.io/aurora/reference/ellipse.md),
[`regPolygon`](https://andrisignorell.github.io/aurora/reference/regPolygon.md),
[`ring`](https://andrisignorell.github.io/aurora/reference/ring.md),
[`polygon`](https://rdrr.io/r/graphics/polygon.html)

Other geometry:
[`arc()`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`band()`](https://andrisignorell.github.io/aurora/reference/band.md),
[`bezier()`](https://andrisignorell.github.io/aurora/reference/bezier.md),
[`canvas()`](https://andrisignorell.github.io/aurora/reference/canvas.md),
[`polarGrid()`](https://andrisignorell.github.io/aurora/reference/polarGrid.md),
[`rotate()`](https://andrisignorell.github.io/aurora/reference/rotate.md),
[`shade()`](https://andrisignorell.github.io/aurora/reference/shade.md),
[`transformXY()`](https://andrisignorell.github.io/aurora/reference/transformXY.md)

## Examples

``` r
canvas()

polygon(
  circle(radius = 1),
  col = "lightblue"
)

polygon(
  regPolygon(
    radius = 0.7,
    numVertices = 5
  ),
  border = "red"
)

```
