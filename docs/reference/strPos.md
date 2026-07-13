# Find Position of First Occurrence Of a String

Returns the numeric position of the first occurrence of a substring
within a string. If the search string is not found, the result will be
`NA`.

## Usage

``` r
strPos(x, pattern, pos = 1)
```

## Arguments

- x:

  a character vector in which to search for the pattern, or an object
  which can be coerced by as.character to a character vector

- pattern:

  character string (search string) containing the pattern to be matched
  in the given character vector. This can be a character string or a
  regular expression.

- pos:

  integer, defining the start position for the search within x. The
  result will then be relative to the begin of the truncated string.
  Will be recycled.

## Value

a vector of the first position of pattern in x

## Details

This is just a wrapper for the function
[`regexpr`](https://rdrr.io/r/base/grep.html).

## See also

[`strChop`](https://andrisignorell.github.io/aurora/reference/strChop.md),
[`regexpr`](https://rdrr.io/r/base/grep.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in lyra.

## Examples

``` r

strPos(x=rownames(mtcars), pattern="y")
#>  [1] NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA  4 NA NA  3  3 NA NA NA NA
#> [26] NA NA NA NA NA NA NA

# first t, starting with position 4
strPos(x=rownames(mtcars), pattern="t", pos=4)
#>  [1] NA NA NA  3  3  4  1 NA NA NA NA NA NA NA 11  9 NA  1 NA  2  2 NA NA NA  1
#> [26]  1 NA NA  6 NA  4 NA

```
