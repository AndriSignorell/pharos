# Spell Strings Using Phonetic Alphabets

Converts characters in a string into their corresponding phonetic
representations using either the NATO phonetic alphabet or Morse code.

## Usage

``` r
strSpell(x, upr = "CAP", type = c("NATO", "Morse"))
```

## Arguments

- x:

  A character vector (typically of length 1).

- upr:

  Character string used as a prefix for uppercase letters. Default is
  `"CAP"`. If `NA`, no prefix is added.

- type:

  Character string specifying the encoding system:

  - `"NATO"`: NATO phonetic alphabet (default)

  - `"Morse"`: Morse code

## Value

A character vector with each character of `x` replaced by its phonetic
representation.

## Details

Letters (A–Z, a–z) and digits (0–9) are mapped to their corresponding
phonetic representations. Other characters are returned unchanged.

For `type = "NATO"`, uppercase letters can optionally be prefixed (e.g.,
`"CAP Alfa"`) to distinguish them from lowercase letters.

The function uses Unicode-aware character splitting via
[`stri_split_boundaries`](https://rdrr.io/pkg/stringi/man/stri_split_boundaries.html).

## See also

[`strTrim`](https://andrisignorell.github.io/aurora/reference/strTrim.md),
[`stri_split_boundaries`](https://rdrr.io/pkg/stringi/man/stri_split_boundaries.html)

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
[`strSplit()`](https://andrisignorell.github.io/aurora/reference/strSplit.md),
[`strTrim()`](https://andrisignorell.github.io/aurora/reference/strTrim.md),
[`strTrunc()`](https://andrisignorell.github.io/aurora/reference/strTrunc.md),
[`strVal()`](https://andrisignorell.github.io/aurora/reference/strVal.md)

## Examples

``` r
# NATO spelling
strSpell("ABC")
#> [1] "CAP Alfa"    "CAP Bravo"   "CAP Charlie"

# with digits
strSpell("A1B2")
#> [1] "CAP Alfa"  "One"       "CAP Bravo" "Two"      

# Morse code
strSpell("SOS", type = "Morse")
#> [1] "..." "---" "..."

# without uppercase prefix
strSpell("ABC", upr = NA)
#> [1] "Alfa"    "Bravo"   "Charlie"
```
