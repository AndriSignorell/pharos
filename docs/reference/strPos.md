# Find Position of First Occurrence Of a String

Returns the numeric position of the first occurrence of a substring
within a string. If the search string is not found, the result will be
`NA`.

## Usage

``` r
strPos(x, pattern, pos = 1)
```

## Arguments

- x:

  a character vector in which to search for the pattern, or an object
  which can be coerced by as.character to a character vector.

- pattern:

  character string (search string) containing the pattern to be matched
  in the given character vector. This can be a character string or a
  regular expression.

- pos:

  integer, defining the start position for the search within x. The
  result will then be relative to the begin of the truncated string.
  Will be recycled.

## Value

a vector of the first position of pattern in x

## Details

This is just a wrapper for the function
[`regexpr`](https://rdrr.io/r/base/grep.html).

## See also

[`strChop`](https://andrisignorell.github.io/aurora/reference/strChop.md),
[`regexpr`](https://rdrr.io/r/base/grep.html)

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
[`strRev()`](https://andrisignorell.github.io/aurora/reference/strRev.md),
[`strSpell()`](https://andrisignorell.github.io/aurora/reference/strSpell.md),
[`strSplit()`](https://andrisignorell.github.io/aurora/reference/strSplit.md),
[`strTrim()`](https://andrisignorell.github.io/aurora/reference/strTrim.md),
[`strTrunc()`](https://andrisignorell.github.io/aurora/reference/strTrunc.md),
[`strVal()`](https://andrisignorell.github.io/aurora/reference/strVal.md)

## Examples

``` r

strPos(x=rownames(mtcars), pattern="y")
#>  [1] NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA  4 NA NA  3  3 NA NA NA NA
#> [26] NA NA NA NA NA NA NA

# first t, starting with position 4
strPos(x=rownames(mtcars), pattern="t", pos=4)
#>  [1] NA NA NA  3  3  4  1 NA NA NA NA NA NA NA 11  9 NA  1 NA  2  2 NA NA NA  1
#> [26]  1 NA NA  6 NA  4 NA

```
