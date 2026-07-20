# Check if Character Strings Represent Numeric Values

Determines whether elements of a character vector represent valid
numeric values. Unlike
[`as.numeric()`](https://rdrr.io/r/base/numeric.html), this function
performs a regex-based validation and does not produce warnings.

## Usage

``` r
strIsNumeric(x, scientific = FALSE)
```

## Arguments

- x:

  a character vector to be tested

- scientific:

  logical; if `TRUE`, scientific notation (e.g., `"1e3"`) is allowed.
  Defaults to `FALSE`.

## Value

A logical vector of the same length as `x`, indicating whether each
element represents a numeric value.

## Details

The function uses regular expressions via stringi to validate numeric
formats. Valid formats include optional leading sign (`+` or `-`),
optional decimal point, and digits. If `scientific = TRUE`, exponential
notation using `e` or `E` is also supported.

Note that special values such as `"Inf"`, `"-Inf"`, and `"NaN"` are not
considered numeric by this function.

## See also

[`as.numeric`](https://rdrr.io/r/base/numeric.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in pharos.

## Examples

``` r
x <- c("123", "-3.141", "1e3", "foo", "Inf")

strIsNumeric(x)
#> [1]  TRUE  TRUE FALSE FALSE FALSE
strIsNumeric(x, scientific = TRUE)
#> [1]  TRUE  TRUE  TRUE FALSE FALSE
```
