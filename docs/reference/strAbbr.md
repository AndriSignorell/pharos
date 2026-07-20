# Abbreviate Strings Uniquely

Creates abbreviations of character strings such that they remain
distinguishable within the input vector.

## Usage

``` r
strAbbr(x, minchar = 1, method = c("left", "fix"))
```

## Arguments

- x:

  a character vector

- minchar:

  integer; minimum number of characters to retain

- method:

  character string specifying the abbreviation strategy:

  - `"left"`: abbreviate each string individually to the shortest unique
    prefix

  - `"fix"`: use a common prefix length for all strings such that they
    are distinguishable

## Value

A character vector of abbreviated strings.

## Details

The function ensures that abbreviations are unique (within the given
vector) while respecting the minimum length `minchar`.

For `method = "left"`, each string is shortened individually to the
shortest prefix that distinguishes it from all others.

For `method = "fix"`, a single prefix length is chosen such that all
strings are distinguishable.

Unicode-aware substring operations are performed using the stringi
package.

## See also

[`stri_sub`](https://rdrr.io/pkg/stringi/man/stri_sub.html),
[`stri_length`](https://rdrr.io/pkg/stringi/man/stri_length.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in pharos.

## Examples

``` r
x <- c("apple", "apricot", "banana")

# individual minimal abbreviations
strAbbr(x, method = "left")
#> [1] "app" "apr" "b"  

# fixed length abbreviations
strAbbr(x, method = "fix")
#> [1] "app" "apr" "ban"
```
