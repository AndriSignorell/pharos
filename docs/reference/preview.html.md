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
  [`print`](https://rdrr.io/r/base/print.html))

## Value

`x`, invisibly

## Details

If output does not support ANSI styling, bold/italic markup is rendered
as plain text (handled automatically by cli).
