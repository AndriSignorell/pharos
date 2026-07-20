# Reverse Strings

Reverses each element of a character vector.

## Usage

``` r
strRev(x)
```

## Arguments

- x:

  a character vector

## Value

A character vector with each string reversed.

## Details

This function uses
[`stri_reverse`](https://rdrr.io/pkg/stringi/man/stri_reverse.html),
which correctly handles Unicode characters and multi-byte encodings.

## See also

[`stri_reverse`](https://rdrr.io/pkg/stringi/man/stri_reverse.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in pharos.

## Examples

``` r
strRev("abc")
#> [1] "cba"

strRev(c("hello", "world"))
#> [1] "olleh" "dlrow"

# Unicode-safe
strRev("äöü")
#> [1] "üöä"
```
