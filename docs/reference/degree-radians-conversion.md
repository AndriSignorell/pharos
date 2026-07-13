# Convert Degrees to Radians and Vice Versa

Convert degrees to radians (and back again).

## Usage

``` r
degToRad(deg)

radToDeg(rad)
```

## Arguments

- deg:

  a vector of angles in degrees.

- rad:

  a vector of angles in radians.

## Value

degToRad returns a vector of the same length as `deg` with the angles in
radians.  
radToDeg returns a vector of the same length as `rad` with the angles in
degrees.

## See also

Other geometry.conversion:
[`coordinate-conversions`](https://andrisignorell.github.io/aurora/reference/coordinate-conversions.md)

## Examples

``` r

degToRad(c(90,180,270))
#> [1] 1.570796 3.141593 4.712389
radToDeg( c(0.5,1,2) * pi)
#> [1]  90 180 360
```
