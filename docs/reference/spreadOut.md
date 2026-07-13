# Spread Out a Vector of Numbers To a Minimum Interval

Spread the numbers of a vector so that there is a minimum interval
between any two numbers (in ascending or descending order). This is
helpful when we want to place textboxes on a plot and ensure, that they
do not mutually overlap.

## Usage

``` r
spreadOut(x, mindist = NULL, cex = 1)
```

## Arguments

- x:

  a numeric vector which may contain `NA`s.

- mindist:

  the minimum interval between any two values. If this is left to `NULL`
  (default) the function will check if a plot is open and then use 90%%
  of [`strheight()`](https://rdrr.io/r/graphics/strwidth.html).

- cex:

  numeric character expansion factor; multiplied by
  [`par`](https://rdrr.io/r/graphics/par.html)`("cex")` yields the final
  character size; the default `NULL` is equivalent to `1`.

## Value

On success, the spread out values. If there are less than two valid
values, the original vector is returned.

## Details

`spreadOut()` starts at or near the middle of the vector and increases
the intervals between the ordered values. `NA`s are preserved.
`spreadOut()` first tries to spread groups of values with intervals less
than `mindist` out neatly away from the mean of the group. If this
doesn't entirely succeed, a second pass that forces values away from the
middle is performed.

`spreadOut()` can also be used to avoid overplotting of axis tick labels
where they may be close together.

## Note

This function is based on `plotrix::spreadOut()` and has been integrated
here with some minor changes.

Based on code by Jim Lemon <jim@bitwrit.com.au>

## See also

[`strheight()`](https://rdrr.io/r/graphics/strwidth.html)

Other graphics.layout:
[`abcCoords()`](https://andrisignorell.github.io/aurora/reference/abcCoords.md),
[`axTicks`](https://andrisignorell.github.io/aurora/reference/axTicks.md),
[`axisBreak()`](https://andrisignorell.github.io/aurora/reference/axisBreak.md),
[`isValidPlotRegion()`](https://andrisignorell.github.io/aurora/reference/isValidPlotRegion.md),
[`lineToUser()`](https://andrisignorell.github.io/aurora/reference/lineToUser.md),
[`mar()`](https://andrisignorell.github.io/aurora/reference/mar.md)

## Examples

``` r

spreadOut(c(1, 3, 3, 3, 3, 5), 0.2)
#> [1] 1.0 2.7 2.9 3.1 3.3 5.0
spreadOut(c(1, 2.5, 2.5, 3.5, 3.5, 5), 0.2)
#> [1] 1.0 2.4 2.6 3.4 3.6 5.0
spreadOut(c(5, 2.5, 2.5, NA, 3.5, 1, 3.5, NA), 0.2)
#> [1] 5.0 2.4 2.6  NA 3.4 1.0 3.6  NA

# this will almost always invoke the brute force second pass
spreadOut(rnorm(10), 0.5)
#>  [1]  0.02423061 -0.97576939  2.02423061 -1.97576939  0.52423061 -2.93977370
#>  [7] -0.47576939  1.02423061 -1.47576939  1.52423061

```
