# Split Strings

Splits character vectors into substrings. This is a convenience wrapper
around
[`stri_split_fixed`](https://rdrr.io/pkg/stringi/man/stri_split.html)
and
[`stri_split_regex`](https://rdrr.io/pkg/stringi/man/stri_split.html)
with simplified defaults.

## Usage

``` r
strSplit(x, split = "", fixed = FALSE)
```

## Arguments

- x:

  a character vector to be split

- split:

  a character string specifying the delimiter (if `fixed = TRUE`) or a
  regular expression (if `fixed = FALSE`)

- fixed:

  logical; if `TRUE`, `split` is treated as a fixed string. Otherwise,
  it is interpreted as a regular expression.

## Value

A list of character vectors. If `x` has length 1, a character vector is
returned.

## Details

If the input `x` has length 1, the result is returned as a character
vector instead of a list for convenience.

This function provides a simplified interface to string splitting using
the stringi package. It avoids some of the complexity of
[`strsplit`](https://rdrr.io/r/base/strsplit.html) while providing
consistent and Unicode-aware behavior.

## See also

[`stri_split_fixed`](https://rdrr.io/pkg/stringi/man/stri_split.html),
[`stri_split_regex`](https://rdrr.io/pkg/stringi/man/stri_split.html),
[`strsplit`](https://rdrr.io/r/base/strsplit.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in lyra.

## Examples

``` r
strSplit("a,b,c", ",", fixed = TRUE)
#> [1] "a" "b" "c"

strSplit(c("a b", "c d"), " ")
#> [[1]]
#> [1] "a" "b"
#> 
#> [[2]]
#> [1] "c" "d"
#> 

# regex splitting
strSplit("a1b2c3", "\\d")
#> [1] "a" "b" "c" "" 
```
