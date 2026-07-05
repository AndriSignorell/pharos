# Split Strings

Splits character vectors into substrings. This is a convenience wrapper
around
[`stri_split_fixed`](https://rdrr.io/pkg/stringi/man/stri_split.html)
and
[`stri_split_regex`](https://rdrr.io/pkg/stringi/man/stri_split.html)
with simplified defaults.

## Usage

``` r
strSplit(x, split = "", fixed = FALSE)
```

## Arguments

- x:

  A character vector to be split.

- split:

  A character string specifying the delimiter (if `fixed = TRUE`) or a
  regular expression (if `fixed = FALSE`).

- fixed:

  Logical; if `TRUE`, `split` is treated as a fixed string. Otherwise,
  it is interpreted as a regular expression.

## Value

A list of character vectors. If `x` has length 1, a character vector is
returned.

## Details

If the input `x` has length 1, the result is returned as a character
vector instead of a list for convenience.

This function provides a simplified interface to string splitting using
the stringi package. It avoids some of the complexity of `strSplit`
while providing consistent and Unicode-aware behavior.

## See also

[`stri_split_fixed`](https://rdrr.io/pkg/stringi/man/stri_split.html),
[`stri_split_regex`](https://rdrr.io/pkg/stringi/man/stri_split.html)

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
[`strIsNumeric()`](https://andrisignorell.github.io/aurora/reference/strIsNumeric.md),
[`strLen()`](https://andrisignorell.github.io/aurora/reference/strLen.md),
[`strPad()`](https://andrisignorell.github.io/aurora/reference/strPad.md),
[`strPos()`](https://andrisignorell.github.io/aurora/reference/strPos.md),
[`strRev()`](https://andrisignorell.github.io/aurora/reference/strRev.md),
[`strSpell()`](https://andrisignorell.github.io/aurora/reference/strSpell.md),
[`strTrim()`](https://andrisignorell.github.io/aurora/reference/strTrim.md),
[`strTrunc()`](https://andrisignorell.github.io/aurora/reference/strTrunc.md),
[`strVal()`](https://andrisignorell.github.io/aurora/reference/strVal.md)

## Examples

``` r
strSplit("a,b,c", ",", fixed = TRUE)
#> [1] "a" "b" "c"

strSplit(c("a b", "c d"), " ")
#> [[1]]
#> [1] "a" "b"
#> 
#> [[2]]
#> [1] "c" "d"
#> 

# regex splitting
strSplit("a1b2c3", "\\d")
#> [1] "a" "b" "c" "" 
```
