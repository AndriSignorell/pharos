# Capitalize Strings

Capitalizes character strings in different ways: first letter, each
word, or title case.

## Usage

``` r
strCap(x, method = c("first", "word", "title"))
```

## Arguments

- x:

  a character vector

- method:

  character string specifying the capitalization method:

  - `"first"`: capitalize the first letter of the string

  - `"word"`: capitalize the first letter of each word

  - `"title"`: title case, excluding common stopwords

## Value

A character vector with capitalized strings.

## Details

The function uses Unicode-aware transformations from the stringi
package.

For `method = "title"`, common stopwords (e.g., `"a"`, `"the"`, `"of"`)
remain lowercase unless they appear as part of another word.

## See also

[`stri_trans_totitle`](https://rdrr.io/pkg/stringi/man/stri_trans_casemap.html),
[`stri_split_boundaries`](https://rdrr.io/pkg/stringi/man/stri_split_boundaries.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in pharos.

## Examples

``` r
x <- c("hello world", "the lord of the rings")

# first letter
strCap(x, "first")
#> [1] "Hello World"           "The Lord Of The Rings"

# each word
strCap(x, "word")
#> [1] "Hello World"           "The Lord Of The Rings"

# title case
strCap(x, "title")
#> [1] "Hello World"           "the Lord of the Rings"
```
