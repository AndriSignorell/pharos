# Extract Substrings Between Patterns

Extracts substrings that occur between two delimiters.

## Usage

``` r
strExtractBetween(x, left, right, greedy = FALSE)
```

## Arguments

- x:

  A character vector.

- left:

  A character string or regular expression marking the left boundary.

- right:

  A character string or regular expression marking the right boundary.

- greedy:

  Logical; if `TRUE`, the match is greedy (longest match). If `FALSE`
  (default), the match is non-greedy (shortest match).

## Value

A character vector containing the extracted substrings. If no match is
found, `NA` is returned for that element.

## Details

The function uses regular expressions to extract the first substring
between `left` and `right`. Internally, it constructs a pattern of the
form:

- greedy: `left (.*) right`

- non-greedy: `left (.*?) right`

Extraction is performed using
[`stri_match_first_regex`](https://rdrr.io/pkg/stringi/man/stri_match.html),
which returns the first captured group.

## See also

[`stri_match_first_regex`](https://rdrr.io/pkg/stringi/man/stri_match.html),
[`strExtract`](https://andrisignorell.github.io/aurora/reference/strExtract.md)

Other string:
[`mgsub()`](https://andrisignorell.github.io/aurora/reference/mgsub.md),
[`strAbbr()`](https://andrisignorell.github.io/aurora/reference/strAbbr.md),
[`strAlign()`](https://andrisignorell.github.io/aurora/reference/strAlign.md),
[`strCap()`](https://andrisignorell.github.io/aurora/reference/strCap.md),
[`strChop()`](https://andrisignorell.github.io/aurora/reference/strChop.md),
[`strCountW()`](https://andrisignorell.github.io/aurora/reference/strCountW.md),
[`strDist()`](https://andrisignorell.github.io/aurora/reference/strDist.md),
[`strExtract()`](https://andrisignorell.github.io/aurora/reference/strExtract.md),
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
x <- c("a[123]b", "x[abc]y", "no match")

# non-greedy (default)
strExtractBetween(x, "\\[", "\\]")
#> [1] "123" "abc" NA   

# greedy
strExtractBetween("a[1]b[2]c", "\\[", "\\]", greedy = TRUE)
#> [1] "1]b[2"
```
