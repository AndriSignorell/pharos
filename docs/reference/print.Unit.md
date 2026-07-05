# Print Object with Unit

S3 method for printing objects with a `"Unit"` class. Displays the value
along with its associated unit.

## Usage

``` r
# S3 method for class 'Unit'
print(x, ...)
```

## Arguments

- x:

  An object with class `"Unit"`.

- ...:

  Additional arguments passed to
  [`print()`](https://rdrr.io/r/base/print.html).

## Value

Invisibly returns `x`.

## Examples

``` r
x <- 10
unit(x) <- "m"
class(x) <- "Unit"
print(x)
#> 10 [ m ]
```
