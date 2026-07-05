# Flat Contingency Table for tapply-Like Lists

Creates a flat contingency table from a list array, such as the result
of [`tapply`](https://rdrr.io/r/base/tapply.html) when the applied
function returns a named vector.

## Usage

``` r
# S3 method for class 'list'
ftable(x, row.vars = NULL, col.vars = NULL, ...)
```

## Arguments

- x:

  A list with a `dim` attribute, typically produced by
  [`tapply`](https://rdrr.io/r/base/tapply.html). Each element must be a
  vector of equal length and have identical names.

- row.vars:

  Row variables passed to
  [`ftable`](https://rdrr.io/r/stats/ftable.html). Defaults to all
  dimensions except those specified in `col.vars`.

- col.vars:

  Column variables passed to
  [`ftable`](https://rdrr.io/r/stats/ftable.html). Defaults to the
  dimension created from the names of the list elements.

- ...:

  Further arguments passed to
  [`ftable`](https://rdrr.io/r/stats/ftable.html).

## Value

An object of class `"ftable"`.

## Details

Each list element is expanded into an additional dimension corresponding
to the names of the returned vector. The resulting array is then passed
to [`ftable`](https://rdrr.io/r/stats/ftable.html).

This is particularly useful for displaying multi-dimensional summaries
such as confidence intervals returned by `meanCI()`, where each cell
contains several statistics (e.g. estimate, lower CI, upper CI).

The names of the vectors stored in the list elements become an
additional dimension of the resulting array. By default, this new
dimension is shown in the columns of the flat contingency table.

## See also

[`tapply`](https://rdrr.io/r/base/tapply.html),
[`ftable`](https://rdrr.io/r/stats/ftable.html)

## Examples

``` r
if (FALSE) { # \dontrun{

x <- with(
  Pizza,
  tapply(
    temperature,
    list(area, driver),
    lumen::meanCI,
    na.rm = TRUE
  )
)

ftable(x)

ftable(
  x,
  row.vars = c(2, 3),
  col.vars = 1
)

} # }
```
