# Extract First Match from Strings

Extracts the first substring matching a regular expression from each
element of a character vector.

## Usage

``` r
strExtract(x, pattern, ...)
```

## Arguments

- x:

  A character vector.

- pattern:

  A character string containing a regular expression to match.

- ...:

  Additional arguments passed to
  [`stri_extract_first_regex`](https://rdrr.io/pkg/stringi/man/stri_extract.html).

## Value

A character vector containing the first match for each element of `x`.
If no match is found, `NA` is returned.

## Details

This function is a thin wrapper around
[`stri_extract_first_regex`](https://rdrr.io/pkg/stringi/man/stri_extract.html)
providing a simplified interface for extracting the first match of a
pattern.

## See also

[`stri_extract_first_regex`](https://rdrr.io/pkg/stringi/man/stri_extract.html),
[`strExtractBetween`](https://andrisignorell.github.io/aurora/reference/strExtractBetween.md)

Other string:
[`mgsub()`](https://andrisignorell.github.io/aurora/reference/mgsub.md),
[`strAbbr()`](https://andrisignorell.github.io/aurora/reference/strAbbr.md),
[`strAlign()`](https://andrisignorell.github.io/aurora/reference/strAlign.md),
[`strCap()`](https://andrisignorell.github.io/aurora/reference/strCap.md),
[`strChop()`](https://andrisignorell.github.io/aurora/reference/strChop.md),
[`strCountW()`](https://andrisignorell.github.io/aurora/reference/strCountW.md),
[`strDist()`](https://andrisignorell.github.io/aurora/reference/strDist.md),
[`strExtractBetween()`](https://andrisignorell.github.io/aurora/reference/strExtractBetween.md),
[`strIsNumeric()`](https://andrisignorell.github.io/aurora/reference/strIsNumeric.md),
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
x <- c("abc123", "no digits", "456xyz")

# extract first number
strExtract(x, "\\d+")
#> [1] "123" NA    "456"

# extract words
strExtract("hello world", "\\w+")
#> [1] "hello"
```
