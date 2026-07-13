# Get or set plot margins conveniently

Convenience wrapper around [`par`](https://rdrr.io/r/graphics/par.html)
for getting and setting plot margins (`mar`) or outer margins (`oma`).
Individual sides can be modified without affecting the others.

## Usage

``` r
mar(bottom = NULL, left = NULL, top = NULL, right = NULL, outer = FALSE)
```

## Arguments

- bottom, left, top, right:

  numeric scalars specifying the margin size (in lines) for each side.
  If `NULL`, the current value is retained.

- outer:

  logical; if `TRUE`, outer margins (`oma`) are used instead of inner
  margins (`mar`).

## Value

If no arguments are provided, returns the current margin vector (numeric
of length 4). Otherwise, sets the margins and returns the new values
invisibly.

## Details

This function simplifies partial updates of `par("mar")` or
`par("oma")`. It avoids the need to manually query and reconstruct the
full margin vector.

For restoring graphical parameters, the recommended base R approach is:


    op <- par(no.readonly = TRUE)
    on.exit(par(op))

## See also

Other graphics.layout:
[`abcCoords()`](https://andrisignorell.github.io/aurora/reference/abcCoords.md),
[`axTicks`](https://andrisignorell.github.io/aurora/reference/axTicks.md),
[`axisBreak()`](https://andrisignorell.github.io/aurora/reference/axisBreak.md),
[`isValidPlotRegion()`](https://andrisignorell.github.io/aurora/reference/isValidPlotRegion.md),
[`lineToUser()`](https://andrisignorell.github.io/aurora/reference/lineToUser.md),
[`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md)

## Examples

``` r
# Get current margins
mar()
#> [1] 5.1 4.1 4.1 2.1

# Set bottom margin only
mar(bottom = 2)

# Set multiple margins
mar(bottom = 2, left = 2)

# Modify outer margins
mar(top = 1, outer = TRUE)
```
