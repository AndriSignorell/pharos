# Align Strings

Aligns a character vector to the left, right, center, or with respect to
the first occurrence of a specified separator.

## Usage

``` r
strAlign(x, sep = "\\r")
```

## Arguments

- x:

  A character vector.

- sep:

  A character specifying the alignment mode:

  - `"\l"`: left alignment

  - `"\r"`: right alignment (default)

  - `"\c"`: centered alignment

  - any other character: align at the first occurrence of this separator

## Value

A character vector of aligned strings.

## Details

Alignment is achieved by padding strings with spaces so that all
elements have equal width. This is mainly useful for monospaced output.

For left, right, and center alignment, strings are padded to the maximum
width using spaces.

If a separator is provided, strings are aligned such that the first
occurrence of the separator is vertically aligned. If a string does not
contain the separator, it is treated as if the separator occurred at the
end.

This function uses Unicode-aware string handling via the stringi
package.

## See also

[`stri_pad`](https://rdrr.io/pkg/stringi/man/stri_pad.html),
[`stri_sub`](https://rdrr.io/pkg/stringi/man/stri_sub.html),
[`stri_trim_right`](https://rdrr.io/pkg/stringi/man/stri_trim.html)

Other string:
[`mgsub()`](https://andrisignorell.github.io/aurora/reference/mgsub.md),
[`strAbbr()`](https://andrisignorell.github.io/aurora/reference/strAbbr.md),
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
x <- c("here", "there", "everywhere")

# right align (default)
strAlign(x)
#> [1] "      here" "     there" "everywhere"

# left align
strAlign(x, "\\l")
#> [1] "here      " "there     " "everywhere"

# center align
strAlign(x, "\\c")
#> [1] "   here   " "  there   " "everywhere"

# align at decimal separator
z <- c("6.0", "45.12", "784")
strAlign(z, ".")
#> [1] "   6.0 " "  45.12" "  784  "
```
