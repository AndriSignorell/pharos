# Capitalize Strings

Capitalizes character strings in different ways: first letter, each
word, or title case.

## Usage

``` r
strCap(x, method = c("first", "word", "title"))
```

## Arguments

- x:

  A character vector.

- method:

  Character string specifying the capitalization method:

  - `"first"`: capitalize the first letter of the string

  - `"word"`: capitalize the first letter of each word

  - `"title"`: title case, excluding common stopwords

## Value

A character vector with capitalized strings.

## Details

The function uses Unicode-aware transformations from the stringi
package.

For `method = "title"`, common stopwords (e.g., `"a"`, `"the"`, `"of"`)
remain lowercase unless they appear as part of another word.

## See also

[`stri_trans_totitle`](https://rdrr.io/pkg/stringi/man/stri_trans_casemap.html),
[`stri_split_boundaries`](https://rdrr.io/pkg/stringi/man/stri_split_boundaries.html)

Other string:
[`mgsub()`](https://andrisignorell.github.io/aurora/reference/mgsub.md),
[`strAbbr()`](https://andrisignorell.github.io/aurora/reference/strAbbr.md),
[`strAlign()`](https://andrisignorell.github.io/aurora/reference/strAlign.md),
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
x <- c("hello world", "the lord of the rings")

# first letter
strCap(x, "first")
#> [1] "Hello World"           "The Lord Of The Rings"

# each word
strCap(x, "word")
#> [1] "Hello World"           "The Lord Of The Rings"

# title case
strCap(x, "title")
#> [1] "Hello World"           "the Lord of the Rings"
```
