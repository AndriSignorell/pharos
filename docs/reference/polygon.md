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

  an object to be drawn.

- ...:

  further arguments passed to the corresponding method.

- y:

  numeric vector of y-coordinates.

- density:

  density of shading lines.

- angle:

  angle of shading lines in degrees.

- border:

  border colour.

- col:

  fill colour.

- lty:

  line type.

- fillOddEven:

  logical; should the odd-even rule be used for filling?

- rule:

  character string specifying the filling rule passed to
  [`polypath`](https://rdrr.io/r/graphics/polypath.html). One of
  `"evenodd"` or `"winding"`.

## Value

Invisibly returns `x`.

## See also

Other geometry.structures:
[`arc()`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`band()`](https://andrisignorell.github.io/aurora/reference/band.md),
[`bezier()`](https://andrisignorell.github.io/aurora/reference/bezier.md),
[`circle()`](https://andrisignorell.github.io/aurora/reference/circle.md),
[`ellipse()`](https://andrisignorell.github.io/aurora/reference/ellipse.md),
[`regPolygon()`](https://andrisignorell.github.io/aurora/reference/regPolygon.md),
[`ring()`](https://andrisignorell.github.io/aurora/reference/ring.md)

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
