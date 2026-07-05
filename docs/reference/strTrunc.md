# Truncate Strings and Add Ellipses If a String is Truncated.

Truncates one or more strings to a specified length, adding an ellipsis
(...) to those strings that have been truncated. The truncation can also
be performed using word boundaries. Use
[`strAlign()`](https://andrisignorell.github.io/aurora/reference/strAlign.md)
to justify the strings if needed.

## Usage

``` r
strTrunc(x, maxlen = 20, ellipsis = "...", wbound = FALSE)
```

## Arguments

- x:

  a vector of strings.

- maxlen:

  the maximum length of the returned strings (NOT counting the appended
  ellipsis). `maxlen` is recycled.

- ellipsis:

  the string to be appended, if the string is longer than the given
  maximal length. The default is `"..."`.

- wbound:

  logical. Determines if the maximal length should be reduced to the
  next smaller word boundary and so words are not chopped. Default is
  `FALSE`.

## Value

The string(s) passed as `x` now with a maximum length of `maxlen` + 3
(for the ellipsis).

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
[`strTrim()`](https://andrisignorell.github.io/aurora/reference/strTrim.md),
[`strVal()`](https://andrisignorell.github.io/aurora/reference/strVal.md)

## Examples

``` r

x <- c("this is short", "and this is a longer text", 
       "whereas this is a much longer story, which could not be told shorter")

# simple truncation on 10 characters
strTrunc(x, maxlen=10)
#> [1] "this is sh..." "and this i..." "whereas th..."

# NAs remain NA
strTrunc(c(x, NA_character_), maxlen=15, wbound=TRUE)
#> [1] "this is short"      "and this is a..."   "whereas this is..."
#> [4] NA                  

# using word boundaries
for(i in 0:20)
  print(strTrunc(x, maxlen=i, wbound=TRUE))
#> [1] "..." "..." "..."
#> [1] "..." "..." "..."
#> [1] "..." "..." "..."
#> [1] "..."    "and..." "..."   
#> [1] "this..." "and..."  "..."    
#> [1] "this..." "and..."  "..."    
#> [1] "this..." "and..."  "..."    
#> [1] "this is..." "and..."     "whereas..."
#> [1] "this is..."  "and this..." "whereas..." 
#> [1] "this is..."  "and this..." "whereas..." 
#> [1] "this is..."  "and this..." "whereas..." 
#> [1] "this is..."     "and this is..." "whereas..."    
#> [1] "this is..."      "and this is..."  "whereas this..."
#> [1] "this is short"    "and this is a..." "whereas this..." 
#> [1] "this is short"    "and this is a..." "whereas this..." 
#> [1] "this is short"      "and this is a..."   "whereas this is..."
#> [1] "this is short"      "and this is a..."   "whereas this is..."
#> [1] "this is short"        "and this is a..."     "whereas this is a..."
#> [1] "this is short"        "and this is a..."     "whereas this is a..."
#> [1] "this is short"        "and this is a..."     "whereas this is a..."
#> [1] "this is short"           "and this is a longer..."
#> [3] "whereas this is a..."   

# compare
for(i in 0:20)
  print(strTrunc(x, maxlen=i, wbound=FALSE))
#> [1] "..." "..." "..."
#> [1] "t..." "a..." "w..."
#> [1] "th..." "an..." "wh..."
#> [1] "thi..." "and..." "whe..."
#> [1] "this..." "and ..." "wher..."
#> [1] "this ..." "and t..." "where..."
#> [1] "this i..." "and th..." "wherea..."
#> [1] "this is..." "and thi..." "whereas..."
#> [1] "this is ..." "and this..." "whereas ..."
#> [1] "this is s..." "and this ..." "whereas t..."
#> [1] "this is sh..." "and this i..." "whereas th..."
#> [1] "this is sho..." "and this is..." "whereas thi..."
#> [1] "this is shor..." "and this is ..." "whereas this..."
#> [1] "this is short"    "and this is a..." "whereas this ..."
#> [1] "this is short"     "and this is a ..." "whereas this i..."
#> [1] "this is short"      "and this is a l..." "whereas this is..."
#> [1] "this is short"       "and this is a lo..." "whereas this is ..."
#> [1] "this is short"        "and this is a lon..." "whereas this is a..."
#> [1] "this is short"         "and this is a long..." "whereas this is a ..."
#> [1] "this is short"          "and this is a longe..." "whereas this is a m..."
#> [1] "this is short"           "and this is a longer..."
#> [3] "whereas this is a mu..."
```
