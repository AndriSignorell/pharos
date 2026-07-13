# Coordinate Transformations Cartesian/Polar/Spherical

Transform cartesian into polar coordinates, resp. to spherical
coordinates and vice versa.

## Usage

``` r
polToCart(r, theta)

cartToPol(x, y)

cartToSph(x, y, z, up = TRUE)

sphToCart(r, theta, phi, up = TRUE)
```

## Arguments

- r:

  a vector with the radius of the points.

- theta:

  a vector with the angle(s) of the points.

- x, y, z:

  vectors with the xy-coordianates to be transformed.

- up:

  logical. If set to `TRUE` (default) theta is measured from x-y plane,
  else theta is measured from the z-axis.

- phi:

  a vector with the angle(s) of the points.

## Value

`polToCart()` returns a list of x and y coordinates of the points.  
`cartToPol()` returns a list of r for the radius and theta for the
angles of the given points.

## Details

Angles are in radians, not degrees (i.e., a right angle is pi/2). Use
[`degToRad`](https://andrisignorell.github.io/aurora/reference/degree-radians-conversion.md)
to convert, if you don't wanna do it by yourself.  
All parameters are recycled if necessary.

## Note

Based on code by Christian W. Hoffmann

## See also

Other geometry.conversion:
[`degree-radians-conversion`](https://andrisignorell.github.io/aurora/reference/degree-radians-conversion.md)

## Examples

``` r

cartToPol(x=1, y=1)
#> $r
#> [1] 1.414214
#> 
#> $theta
#> [1] 0.7853982
#> 
cartToPol(x=c(1,2,3), y=c(1,1,1))
#> $r
#> [1] 1.414214 2.236068 3.162278
#> 
#> $theta
#> [1] 0.7853982 0.4636476 0.3217506
#> 
cartToPol(x=c(1,2,3), y=1)
#> $r
#> [1] 1.414214 2.236068 3.162278
#> 
#> $theta
#> [1] 0.7853982 0.4636476 0.3217506
#> 


polToCart(r=1, theta=pi/2)
#> $x
#> [1] 6.123032e-17
#> 
#> $y
#> [1] 1
#> 
polToCart(r=c(1,2,3), theta=pi/2)
#> $x
#> [1] 6.123032e-17 1.224606e-16 1.836910e-16
#> 
#> $y
#> [1] 1 2 3
#> 

polToCart(r=c(1,2,3), theta=pi/2)
#> $x
#> [1] 6.123032e-17 1.224606e-16 1.836910e-16
#> 
#> $y
#> [1] 1 2 3
#> 

cartToSph(x=1, y=2, z=3)   # r=3.741657, theta=0.930274, phi=1.107149
#> $r
#> [1] 3.741657
#> 
#> $theta
#> [1] 0.930274
#> 
#> $phi
#> [1] 1.107149
#> 
```
