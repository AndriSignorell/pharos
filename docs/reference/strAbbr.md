# Abbreviate Strings Uniquely

Creates abbreviations of character strings such that they remain
distinguishable within the input vector.

## Usage

``` r
strAbbr(x, minchar = 1, method = c("left", "fix"))
```

## Arguments

- x:

  A character vector.

- minchar:

  Integer; minimum number of characters to retain.

- method:

  Character string specifying the abbreviation strategy:

  - `"left"`: abbreviate each string individually to the shortest unique
    prefix

  - `"fix"`: use a common prefix length for all strings such that they
    are distinguishable

## Value

A character vector of abbreviated strings.

## Details

The function ensures that abbreviations are unique (within the given
vector) while respecting the minimum length `minchar`.

For `method = "left"`, each string is shortened individually to the
shortest prefix that distinguishes it from all others.

For `method = "fix"`, a single prefix length is chosen such that all
strings are distinguishable.

Unicode-aware substring operations are performed using the stringi
package.

## See also

[`stri_sub`](https://rdrr.io/pkg/stringi/man/stri_sub.html),
[`stri_length`](https://rdrr.io/pkg/stringi/man/stri_length.html)

Other string:
[`mgsub()`](https://andrisignorell.github.io/aurora/reference/mgsub.md),
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
[`strSplit()`](https://andrisignorell.github.io/aurora/reference/strSplit.md),
[`strTrim()`](https://andrisignorell.github.io/aurora/reference/strTrim.md),
[`strTrunc()`](https://andrisignorell.github.io/aurora/reference/strTrunc.md),
[`strVal()`](https://andrisignorell.github.io/aurora/reference/strVal.md)

## Examples

``` r
x <- c("apple", "apricot", "banana")

# individual minimal abbreviations
strAbbr(x, method = "left")
#> [1] "app" "apr" "b"  

# fixed length abbreviations
strAbbr(x, method = "fix")
#> [1] "app" "apr" "ban"
```
