# Print HTML markup as readable text

Renders an `"html"` object as text in the console: tags are stripped or
translated (`<sub>`/`<sup>` become `_`/`^`,
`<b>`/`<strong>`/`<i>`/`<em>` become bold/italic via ANSI codes), common
HTML entities (`&nbsp;`, `&beta;`, ...) are decoded, and `<table>`
blocks are rendered as aligned text tables.

## Usage

``` r
# S3 method for class 'html'
preview(x, ...)
```

## Arguments

- x:

  an object of class `"html"`

- ...:

  further arguments, currently unused (kept for consistency with
  [`print()`](https://rdrr.io/r/base/print.html))

## Value

`x`, invisibly

## Details

If output does not support ANSI styling, bold/italic markup is rendered
as plain text (handled automatically by cli).

## Examples

``` r
preview(asHtml(
  "<b>Model:</b> y = &beta;<sub>0</sub> + &beta;<sub>1</sub>x + &varepsilon;"
))
#> Model: y = β_0 + β_1x + ε 

# tables are rendered as aligned text
m <- matrix(c(12.3, 4.56, 7.8, 91.2), nrow = 2,
            dimnames = list(c("a", "b"), c("mean", "sd")))
preview(toHtmlTable(m))
#>  | mean | sd
#> --+------+-----
#> a | 12.3 | 7.8 
#> b | 4.56 | 91.2 
```
