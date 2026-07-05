# Get or Set Unit Attribute

Retrieves or assigns a unit attribute to an R object.

## Usage

``` r
unit(x)

unit(x) <- value
```

## Arguments

- x:

  An R object.

- value:

  A single character string specifying the unit, or `NULL` to remove the
  unit attribute.

## Value

- `unit(x)` returns the unit as a character string or `NULL`.

- `unit(x) <- value` returns `x` with updated unit attribute.

## Details

The unit is stored as a simple character string in the `"unit"`
attribute. This provides a lightweight mechanism for attaching unit
metadata to objects, without enforcing any automatic conversion or
validation.

The setter does not validate whether the unit is physically meaningful.
Validation and conversion should be handled externally (e.g., via a unit
conversion engine such as `ConvUnit7`).

Assigning `NULL` removes the unit attribute.

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
[`mar()`](https://andrisignorell.github.io/aurora/reference/mar.md),
[`preview()`](https://andrisignorell.github.io/aurora/reference/preview.md),
[`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md),
[`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md),
[`textLegend()`](https://andrisignorell.github.io/aurora/reference/textLegend.md),
[`titleRect()`](https://andrisignorell.github.io/aurora/reference/titleRect.md)

## Examples

``` r
x <- 10
unit(x) <- "m"
unit(x)
#> [1] "m"

y <- 5
unit(y) <- "kg"

# remove unit
unit(y) <- NULL
```
