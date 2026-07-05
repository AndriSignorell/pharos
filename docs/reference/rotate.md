# Rotate a Geometric Structure

Rotate a geometric structure by an angle theta around a centerpoint xy.

## Usage

``` r
rotate(x, y = NULL, mx = NULL, my = NULL, theta = pi/3, asp = 1)
```

## Arguments

- x, y:

  vectors containing the coordinates of the vertices of the polygon ,
  which has to be rotated. The coordinates can be passed in a plotting
  structure (a list with x and y components), a two-column matrix, ....
  See [`xy.coords`](https://rdrr.io/r/grDevices/xy.coords.html).

- mx, my:

  xy-coordinates of the center of the rotation. If left to NULL, the
  centroid of the structure will be used.

- theta:

  angle of the rotation

- asp:

  the aspect ratio for the rotation. Helpful for rotate structures along
  an ellipse.

## Value

The function invisibly returns a list of the coordinates for the rotated
shape(s).

## See also

[`polygon`](https://andrisignorell.github.io/aurora/reference/polygon.md),
[`regPolygon`](https://andrisignorell.github.io/aurora/reference/regPolygon.md),
[`ellipse`](https://andrisignorell.github.io/aurora/reference/ellipse.md),
[`arc`](https://andrisignorell.github.io/aurora/reference/arc.md)

Other geometry:
[`arc()`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`band()`](https://andrisignorell.github.io/aurora/reference/band.md),
[`bezier()`](https://andrisignorell.github.io/aurora/reference/bezier.md),
[`canvas()`](https://andrisignorell.github.io/aurora/reference/canvas.md),
[`polarGrid()`](https://andrisignorell.github.io/aurora/reference/polarGrid.md),
[`polygon()`](https://andrisignorell.github.io/aurora/reference/polygon.md),
[`shade()`](https://andrisignorell.github.io/aurora/reference/shade.md),
[`transformXY()`](https://andrisignorell.github.io/aurora/reference/transformXY.md)

## Examples

``` r
op <- par(no.readonly = TRUE)
# let's have a triangle
canvas(main="Rotation")
x <- regPolygon(numVertices=3)

# and rotate
sapply( (0:3) * pi/6, function(theta) {
  xy <- rotate( x=x, theta=theta )
  polygon(xy, col=addAlpha("blue", 0.2))
} )
#> [[1]]
#> NULL
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> NULL
#> 
#> [[4]]
#> NULL
#> 

abline(v=0, h=0)


par(op)
```
