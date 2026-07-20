# Split a String into a Number of Sections of Defined Length

Splitting a string into a number of sections of defined length is
needed, when we want to split a table given as a number of lines without
separator into columns. The cutting points can either be defined by the
lengths of the sections or directly by position.

## Usage

``` r
strChop(x, len = NULL, pos = NULL)
```

## Arguments

- x:

  the string to be cut in pieces

- len:

  a vector with the lengths of the pieces

- pos:

  a vector of cutting positions. Will be ignored when `len` has been
  defined.

## Value

a vector with the parts of the string.

## Details

If length is going over the end of the string the last part will be
returned, so if the rest of the string is needed, it's possible to
simply enter a big number as last partlength.

`len` and `pos` can't be defined simultaneously, only alternatively.

Typical usages are

     strChop(x, len) strChop(x, pos) 

## See also

[`strLeft`](https://andrisignorell.github.io/aurora/reference/strLeftRight.md),
[`substr`](https://rdrr.io/r/base/substr.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in pharos.

## Examples

``` r

x <- paste(letters, collapse="")
strChop(x=x, len = c(3,5,2))
#> [1] "abc"              "defgh"            "ij"               "klmnopqrstuvwxyz"

# and with the rest integrated
strChop(x=x, len = c(3, 5, 2, nchar(x)))
#> [1] "abc"              "defgh"            "ij"               "klmnopqrstuvwxyz"

# cutpoints at 5th and 10th position
strChop(x=x, pos=c(5, 10))
#> [1] "abcde"            "fghij"            "klmnopqrstuvwxyz"
```
