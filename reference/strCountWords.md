# Count Words in Strings

Counts the number of words in each element of a character vector.

## Usage

``` r
strCountWords(x)
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

[`stringi::stri_count_words()`](https://rdrr.io/pkg/stringi/man/stri_count_boundaries.html)

[string-overview](string-overview.md) for an overview of all string
utilities in pharos.

## Examples

``` r
strCountWords("This is a sentence.")
#> [1] 4

strCountWords(c("One word", "Two words here", NA))
#> [1]  2  3 NA
```
