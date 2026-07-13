# Get or Set Unit Attribute

Retrieves or assigns a unit attribute to an R object.

## Usage

``` r
unit(x)

unit(x) <- value
```

## Arguments

- x:

  an R object.

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

Other format:
[`convUnit()`](https://andrisignorell.github.io/aurora/reference/convUnit.md),
[`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md),
[`fmCI()`](https://andrisignorell.github.io/aurora/reference/fmCI.md),
[`print.Unit()`](https://andrisignorell.github.io/aurora/reference/print.Unit.md),
[`style()`](https://andrisignorell.github.io/aurora/reference/style.md)

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
