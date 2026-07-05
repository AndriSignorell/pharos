# Remove Leading/Trailing Whitespace From A String

The function removes whitespace characters as spaces, tabs and newlines
from the beginning and end of the supplied string. Whitespace characters
occurring in the middle of the string are retained.  
Trimming with method `"left"` deletes only leading whitespaces,
`"right"` only trailing. Designed for users who were socialized by SQL.

## Usage

``` r
strTrim(x, pattern = " \t\n", method = "both")
```

## Arguments

- x:

  the string to be trimmed.

- pattern:

  the pattern of the whitespaces to be deleted, defaults to space, tab
  and newline: `" \t\n"`.

- method:

  one out of `"both"` (default), `"left"`, `"right"`. Determines on
  which side the string should be trimmed.

## Value

the string x without whitespaces

## Details

The functions are defined depending on method as  
`both: gsub( pattern=gettextf("^[%s]+|[%s]+$", pattern, pattern), replacement="", x=x)`  
`left: gsub( pattern=gettextf("^[%s]+",pattern), replacement="", x=x)`  
`right: gsub( pattern=gettextf("[%s]+$",pattern), replacement="", x=x)`

## See also

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
[`strSplit()`](https://andrisignorell.github.io/aurora/reference/strSplit.md),
[`strTrunc()`](https://andrisignorell.github.io/aurora/reference/strTrunc.md),
[`strVal()`](https://andrisignorell.github.io/aurora/reference/strVal.md)

## Examples

``` r

strTrim("  Hello world! ")
#> [1] "Hello world!"

strTrim("  Hello world! ", method="left")
#> [1] "Hello world! "
strTrim("  Hello world! ", method="right")
#> [1] "  Hello world!"

# user defined pattern
strTrim(" ..Hello ... world! ", pattern=" \\.")
#> [1] "..Hello ... world!"
```
