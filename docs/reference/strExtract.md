# Extract First Match from Strings

Extracts the first substring matching a regular expression from each
element of a character vector.

## Usage

``` r
strExtract(x, pattern, ...)
```

## Arguments

- x:

  a character vector

- pattern:

  a character string containing a regular expression to match

- ...:

  additional arguments passed to
  [`stri_extract_first_regex`](https://rdrr.io/pkg/stringi/man/stri_extract.html)

## Value

A character vector containing the first match for each element of `x`.
If no match is found, `NA` is returned.

## Details

This function is a thin wrapper around
[`stri_extract_first_regex`](https://rdrr.io/pkg/stringi/man/stri_extract.html)
providing a simplified interface for extracting the first match of a
pattern.

## See also

[`stri_extract_first_regex`](https://rdrr.io/pkg/stringi/man/stri_extract.html),
[`strExtractBetween`](https://andrisignorell.github.io/aurora/reference/strExtractBetween.md)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in lyra.

## Examples

``` r
x <- c("abc123", "no digits", "456xyz")

# extract first number
strExtract(x, "\\d+")
#> [1] "123" NA    "456"

# extract words
strExtract("hello world", "\\w+")
#> [1] "hello"
```
