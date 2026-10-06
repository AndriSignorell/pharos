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

Other html: [`asFileLink()`](asFileLink.md), [`asHtml()`](asHtml.md),
[`asImg()`](asImg.md), [`embedFile()`](embedFile.md),
[`escapeHtml()`](escapeHtml.md), [`htmlNotation`](htmlNotation.md),
[`toHtmlTable()`](toHtmlTable.md)

## Examples

``` r
"x" %_% "i"  # -> "x<sub>i</sub>"
#> [1] "x<sub>i</sub>"
```
