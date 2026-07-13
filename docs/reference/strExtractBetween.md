# Extract Substrings Between Patterns

Extracts substrings that occur between two delimiters.

## Usage

``` r
strExtractBetween(x, left, right, greedy = FALSE)
```

## Arguments

- x:

  a character vector

- left:

  a character string or regular expression marking the left boundary

- right:

  a character string or regular expression marking the right boundary

- greedy:

  logical; if `TRUE`, the match is greedy (longest match). If `FALSE`
  (default), the match is non-greedy (shortest match).

## Value

A character vector containing the extracted substrings. If no match is
found, `NA` is returned for that element.

## Details

The function uses regular expressions to extract the first substring
between `left` and `right`. Internally, it constructs a pattern of the
form:

- greedy: `left (.*) right`

- non-greedy: `left (.*?) right`

Extraction is performed using
[`stri_match_first_regex`](https://rdrr.io/pkg/stringi/man/stri_match.html),
which returns the first captured group.

## See also

[`stri_match_first_regex`](https://rdrr.io/pkg/stringi/man/stri_match.html),
[`strExtract`](https://andrisignorell.github.io/aurora/reference/strExtract.md)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in lyra.

## Examples

``` r
x <- c("a[123]b", "x[abc]y", "no match")

# non-greedy (default)
strExtractBetween(x, "\\[", "\\]")
#> [1] "123" "abc" NA   

# greedy
strExtractBetween("a[1]b[2]c", "\\[", "\\]", greedy = TRUE)
#> [1] "1]b[2"
```
