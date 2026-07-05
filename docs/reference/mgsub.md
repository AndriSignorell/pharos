# Multiple Gsub

Performs multiple substitions in one string or multiple strings.

## Usage

``` r
mgsub(pattern, replacement, x)
```

## Arguments

- pattern:

  character string containing a regular expression (or character string
  for fixed = TRUE) to be matched in the given character vector. Coerced
  by as.character to a character string if possible.

- replacement:

  a replacement for matched pattern as in
  [`sub`](https://rdrr.io/r/base/grep.html) and
  [`gsub`](https://rdrr.io/r/base/grep.html). See there for more
  information.

- x:

  a character vector where matches are sought, or an object which can be
  coerced by as.character to a character vector. Long vectors are
  supported.

## Value

a character vector of the same length and with the same attributes as x
(after possible coercion to character).

## See also

[`gsub`](https://rdrr.io/r/base/grep.html)

Other string:
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
[`strTrim()`](https://andrisignorell.github.io/aurora/reference/strTrim.md),
[`strTrunc()`](https://andrisignorell.github.io/aurora/reference/strTrunc.md),
[`strVal()`](https://andrisignorell.github.io/aurora/reference/strVal.md)

## Examples

``` r

x <- c("ABC", "BCD", "CDE")
mgsub(pattern=c("B", "C"), replacement=c("X","Y"), x)
#> [1] "AXY" "XYD" "YDE"
```
