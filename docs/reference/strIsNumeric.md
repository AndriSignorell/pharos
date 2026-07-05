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

  A character vector to be tested.

- scientific:

  Logical; if `TRUE`, scientific notation (e.g., `"1e3"`) is allowed.
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

Other string:
[`mgsub()`](https://andrisignorell.github.io/aurora/reference/mgsub.md),
[`strAbbr()`](https://andrisignorell.github.io/aurora/reference/strAbbr.md),
[`strAlign()`](https://andrisignorell.github.io/aurora/reference/strAlign.md),
[`strCap()`](https://andrisignorell.github.io/aurora/reference/strCap.md),
[`strChop()`](https://andrisignorell.github.io/aurora/reference/strChop.md),
[`strCountW()`](https://andrisignorell.github.io/aurora/reference/strCountW.md),
[`strDist()`](https://andrisignorell.github.io/aurora/reference/strDist.md),
[`strExtract()`](https://andrisignorell.github.io/aurora/reference/strExtract.md),
[`strExtractBetween()`](https://andrisignorell.github.io/aurora/reference/strExtractBetween.md),
[`strLen()`](https://andrisignorell.github.io/aurora/reference/strLen.md),
[`strPad()`](https://andrisignorell.github.io/aurora/reference/strPad.md),
[`strPos()`](https://andrisignorell.github.io/aurora/reference/strPos.md),
[`strRev()`](https://andrisignorell.github.io/aurora/reference/strRev.md),
[`strSpell()`](https://andrisignorell.github.io/aurora/reference/strSpell.md),
[`strSplit()`](https://andrisignorell.github.io/aurora/reference/strSplit.md),
[`strTrim()`](https://andrisignorell.github.io/aurora/reference/strTrim.md),
[`strTrunc()`](https://andrisignorell.github.io/aurora/reference/strTrunc.md),
[`strVal()`](https://andrisignorell.github.io/aurora/reference/strVal.md)

## Examples

``` r
x <- c("123", "-3.141", "1e3", "foo", "Inf")

strIsNumeric(x)
#> [1]  TRUE  TRUE FALSE FALSE FALSE
strIsNumeric(x, scientific = TRUE)
#> [1]  TRUE  TRUE  TRUE FALSE FALSE
```
