# Confidence Interval Objects

Converts common confidence interval representations into a standardized
`"ci"` object.

## Usage

``` r
as.CI(x, ...)

is.CI(x)
```

## Arguments

- x:

  Object to convert.

- ...:

  Further arguments passed to methods.

## Value

A data frame of class `"ci"` with columns:

- est:

  Point estimate

- lci:

  Lower confidence limit

- uci:

  Upper confidence limit

Additional columns represent grouping variables.

## Details

A `ci` object is a data frame containing at least the columns `est`,
`lci`, and `uci`. Additional columns are interpreted as grouping
variables.

The primary purpose of `as.CI()` is to remove ambiguity between ordinary
matrices and confidence interval data. For example, a 3-column matrix
may either represent three groups or the columns `est`, `lci`, and
`uci`. Wrapping the object in `as.CI()` explicitly declares that the
structure should be treated as confidence interval data.

Supported inputs include:

- Numeric matrices with three columns representing `est`, `lci`, and
  `uci`.

- Data frames containing columns for estimate, lower confidence limit,
  and upper confidence limit.

- Named lists where each element contains `c(est, lci, uci)`.

- Results from [`tapply()`](https://rdrr.io/r/base/tapply.html) where
  the applied function returns `c(est, lci, uci)`. Grouping dimensions
  are automatically converted to grouping variables.

The returned object inherits from class `"ci"`.

## See also

[`plotDot`](https://andrisignorell.github.io/aurora/reference/plotDot.md),
`is.CI`

## Examples

``` r

# ----------------------------------------------------------
# matrix
# ----------------------------------------------------------

x <- matrix(
  c(
    10, 20, 30,
     8, 18, 28,
    12, 22, 32
  ),
  ncol = 3
)

as.CI(x)
#>   est lci uci
#> 1  10   8  12
#> 2  20  18  22
#> 3  30  28  32

# ----------------------------------------------------------
# data frame
# ----------------------------------------------------------

d <- data.frame(
  est = c(10, 20),
  lci = c(8, 18),
  uci = c(12, 22),
  sex = c("F", "M")
)

as.CI(d)
#>   est lci uci sex
#> 1  10   8  12   F
#> 2  20  18  22   M

# ----------------------------------------------------------
# tapply result
# ----------------------------------------------------------

if (FALSE) { # \dontrun{
xci <- with(
  Pizza,
  tapply(
    temperature,
    driver,
    lumen::meanCI,
    na.rm = TRUE
  )
)

plotDot(as.CI(xci))
} # }
```
