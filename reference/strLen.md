# String length

Intuitive alias for [`nchar()`](https://rdrr.io/r/base/nchar.html).

## Usage

``` r
strLen(x, ...)
```

## Arguments

- x:

  a character vector

- ...:

  further arguments passed to `nchar`

## Value

An integer vector with the number of characters of the elements of `x`,
see [`nchar()`](https://rdrr.io/r/base/nchar.html).

## See also

[`base::nchar()`](https://rdrr.io/r/base/nchar.html)

[string-overview](string-overview.md) for an overview of all string
utilities in pharos.

## Examples

``` r
strLen(c("pharos", "", NA))
#> [1]  6  0 NA
strLen(month.name)
#>  [1] 7 8 5 5 3 4 4 6 9 7 8 8

# a number is converted to a string first
strLen(123456)
#> [1] 6
```
