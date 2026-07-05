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

  Numeric scalars specifying the margin size (in lines) for each side.
  If `NULL`, the current value is retained.

- outer:

  Logical; if `TRUE`, outer margins (`oma`) are used instead of inner
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

Other graphics.utils:
[`abcCoords()`](https://andrisignorell.github.io/aurora/reference/abcCoords.md),
[`axisBreak()`](https://andrisignorell.github.io/aurora/reference/axisBreak.md),
[`barText()`](https://andrisignorell.github.io/aurora/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/aurora/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/aurora/reference/colLegend.md),
[`degToRad()`](https://andrisignorell.github.io/aurora/reference/degToRad.md),
[`errBars()`](https://andrisignorell.github.io/aurora/reference/errBars.md),
[`lineSep()`](https://andrisignorell.github.io/aurora/reference/lineSep.md),
[`lineToUser()`](https://andrisignorell.github.io/aurora/reference/lineToUser.md),
[`lines.lm()`](https://andrisignorell.github.io/aurora/reference/linesLm.md),
[`preview()`](https://andrisignorell.github.io/aurora/reference/preview.md),
[`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md),
[`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md),
[`textLegend()`](https://andrisignorell.github.io/aurora/reference/textLegend.md),
[`titleRect()`](https://andrisignorell.github.io/aurora/reference/titleRect.md),
[`unit()`](https://andrisignorell.github.io/aurora/reference/unit.md)

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
