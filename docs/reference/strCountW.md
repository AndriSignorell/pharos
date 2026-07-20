# Count Words in Strings

Counts the number of words in each element of a character vector.

## Usage

``` r
strCountW(x)
```

## Arguments

- x:

  a character vector

## Value

An integer vector giving the number of words in each element of `x`.

## Details

Words are detected using Unicode-aware word boundaries as implemented in
stringi. This ensures robust handling of different languages,
punctuation, and whitespace.

## See also

[`stri_count_words`](https://rdrr.io/pkg/stringi/man/stri_count_boundaries.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in pharos.

## Examples

``` r
strCountW("This is a sentence.")
#> [1] 4

strCountW(c("One word", "Two words here", NA))
#> [1]  2  3 NA
```
