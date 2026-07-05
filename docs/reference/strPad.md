# Pad a String With Justification

`strPad` will fill a string x with defined characters to fit a given
length.

## Usage

``` r
strPad(x, width = NULL, pad = " ", adj = "left")
```

## Arguments

- x:

  a vector of strings to be padded.

- width:

  resulting width of padded string. If x is a vector and width is left
  to NULL, it will be set to the length of the largest string in x.

- pad:

  string to pad with. Will be repeated as often as necessary. Default is
  " ".

- adj:

  adjustement of the old string, one of `"left"`, `"right"`, `"center"`.
  If set to `"left"` the old string will be adjusted on the left and the
  new characters will be filled in on the right side.

## Value

the string

## Details

If a string x has more characters than width, it will be chopped on the
length of width.

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
[`strPos()`](https://andrisignorell.github.io/aurora/reference/strPos.md),
[`strRev()`](https://andrisignorell.github.io/aurora/reference/strRev.md),
[`strSpell()`](https://andrisignorell.github.io/aurora/reference/strSpell.md),
[`strSplit()`](https://andrisignorell.github.io/aurora/reference/strSplit.md),
[`strTrim()`](https://andrisignorell.github.io/aurora/reference/strTrim.md),
[`strTrunc()`](https://andrisignorell.github.io/aurora/reference/strTrunc.md),
[`strVal()`](https://andrisignorell.github.io/aurora/reference/strVal.md)

## Examples

``` r

strPad("My string", 25, "XoX", "center")
#> [1] "XoXXoXXoMy stringXoXXoXXo"
 # [1] "XoXXoXXoMy stringXXoXXoXX"
```
