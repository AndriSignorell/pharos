# Apply Geometric Transformations to Coordinates

Applies scaling, rotation, and translation to a set of 2D coordinates.
The transformations are applied in the following order:

1.  Scaling

2.  Rotation (see
    [`rotate`](https://andrisignorell.github.io/aurora/reference/rotate.md))

3.  Translation

## Usage

``` r
transformXY(
  x,
  y = NULL,
  translate = c(0, 0),
  scale = c(1, 1),
  theta = 0,
  asp = 1
)
```

## Arguments

- x:

  numeric vector of x coordinates, or an object coercible by
  [`xy.coords`](https://rdrr.io/r/grDevices/xy.coords.html).

- y:

  numeric vector of y coordinates. Ignored if `x` already contains both
  coordinates.

- translate:

  numeric vector of length 1 or 2 specifying translation in x and y
  direction. Recycled if necessary. Default is `c(0, 0)`.

- scale:

  numeric vector of length 1 or 2 specifying scaling factors for x
  and y. Recycled if necessary. Default is `c(1, 1)`.

- theta:

  rotation angle in radians. Default is `0`.

- asp:

  aspect ratio adjustment passed to
  [`rotate`](https://andrisignorell.github.io/aurora/reference/rotate.md).
  Default is `1`.

## Value

A list with components `x` and `y`, as returned by
[`xy.coords`](https://rdrr.io/r/grDevices/xy.coords.html).

## Details

This function is a convenience wrapper combining basic affine
transformations. Internally, it uses
[`rotate`](https://andrisignorell.github.io/aurora/reference/rotate.md)
for rotation.

## See also

Other geometry.transformation:
[`rotate()`](https://andrisignorell.github.io/aurora/reference/rotate.md)

## Examples

``` r
x <- c(0, 1, 1, 0)
y <- c(0, 0, 1, 1)

# scale, rotate and translate a square
transformXY(x, y,
            scale = 2,
            theta = pi / 4,
            translate = c(1, 1))
#> $x
#> [1] 2.0000000 3.4142136 2.0000000 0.5857864
#> 
#> $y
#> [1] 0.5857864 2.0000000 3.4142136 2.0000000
#> 
#> $xlab
#> NULL
#> 
#> $ylab
#> NULL
#> 

# matrix input
m <- cbind(x, y)
transformXY(m, scale = 0.5, theta = pi/6)
#> $x
#> [1]  0.15849365  0.59150635  0.34150635 -0.09150635
#> 
#> $y
#> [1] -0.09150635  0.15849365  0.59150635  0.34150635
#> 
#> $xlab
#> NULL
#> 
#> $ylab
#> NULL
#> 

```
