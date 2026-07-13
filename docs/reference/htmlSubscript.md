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

## See also

Other html:
[`as.html()`](https://andrisignorell.github.io/aurora/reference/as.html.md),
[`as.img()`](https://andrisignorell.github.io/aurora/reference/as.img.md),
[`htmlNotation`](https://andrisignorell.github.io/aurora/reference/htmlNotation.md),
[`toHtmlTable()`](https://andrisignorell.github.io/aurora/reference/toHtmlTable.md)

## Examples

``` r
"x" %_% "i"  # -> "x<sub>i</sub>"
#> [1] "x<sub>i</sub>"
```
