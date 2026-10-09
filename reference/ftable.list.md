# Flat Contingency Table for tapply-Like Lists

Creates a flat contingency table from a list array, such as the result
of [`tapply()`](https://rdrr.io/r/base/tapply.html) when the applied
function returns a named vector.

## Usage

``` r
# S3 method for class 'list'
ftable(x, row.vars = NULL, col.vars = NULL, ...)
```

## Arguments

- x:

  A list with a `dim` attribute, typically produced by
  [`tapply()`](https://rdrr.io/r/base/tapply.html). Each element must be
  a vector of equal length and have identical names.

- row.vars:

  row variables passed to
  [`ftable()`](https://rdrr.io/r/stats/ftable.html). Defaults to all
  dimensions except those specified in `col.vars`.

- col.vars:

  column variables passed to
  [`ftable()`](https://rdrr.io/r/stats/ftable.html). Defaults to the
  dimension created from the names of the list elements.

- ...:

  further arguments passed to
  [`ftable()`](https://rdrr.io/r/stats/ftable.html).

## Value

An object of class `"ftable"`.

## Details

Each list element is expanded into an additional dimension corresponding
to the names of the returned vector. The resulting array is then passed
to [`ftable()`](https://rdrr.io/r/stats/ftable.html).

This is particularly useful for displaying multi-dimensional summaries
such as confidence intervals returned by `meanCI()`, where each cell
contains several statistics (e.g. estimate, lower CI, upper CI).

The names of the vectors stored in the list elements become an
additional dimension of the resulting array. By default, this new
dimension is shown in the columns of the flat contingency table.

## See also

[`tapply()`](https://rdrr.io/r/base/tapply.html),
[`ftable()`](https://rdrr.io/r/stats/ftable.html)

## Examples

``` r
# a function returning a named vector, here the mean and its
# confidence interval (as e.g. lumen::meanCI() returns them)
meanCI <- function(z) {
  ci <- t.test(z)$conf.int
  c(est = mean(z), lci = ci[1], uci = ci[2])
}

x <- with(
  warpbreaks,
  tapply(
    breaks,
    list(wool, tension),
    meanCI
  )
)

# the statistics form the columns
ftable(x)
#>           est      lci      uci
#>                                
#> A L  44.55556 30.64441 58.46670
#>   M  24.00000 17.34314 30.65686
#>   H  24.55556 16.65928 32.45183
#> B L  28.22222 20.64414 35.80031
#>   M  28.77778 21.52844 36.02711
#>   H  18.77778 15.01645 22.53911

# the second grouping variable in the columns as well
ftable(
  x,
  row.vars = 2,
  col.vars = c(3, 1)
)
#>           L                          M                          H                  
#>         est      lci      uci      est      lci      uci      est      lci      uci
#>                                                                                    
#> A  44.55556 30.64441 58.46670 24.00000 17.34314 30.65686 24.55556 16.65928 32.45183
#> B  28.22222 20.64414 35.80031 28.77778 21.52844 36.02711 18.77778 15.01645 22.53911
```
