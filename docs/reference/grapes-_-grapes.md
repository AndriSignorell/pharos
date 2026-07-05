# Subscript notation

Infix operator producing an HTML subscript, e.g. for indexed symbols
such as \\x_i\\.

## Usage

``` r
x %_% i
```

## Arguments

- x:

  a character vector (the base symbol)

- i:

  a character vector (the subscript), recycled against `x`

## Value

a character vector: `x` followed by `<sub>i</sub>`

## Examples

``` r
"x" %_% "i"  # -> "x<sub>i</sub>"
#> [1] "x<sub>i</sub>"
```
