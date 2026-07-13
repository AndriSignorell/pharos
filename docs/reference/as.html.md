# Mark a character vector as HTML

Tags a character vector with the S3 class `"html"` so that it prints via
[`preview.html`](https://andrisignorell.github.io/aurora/reference/preview.html.md)
as readable text instead of as a raw character vector.

## Usage

``` r
as.html(x)
```

## Arguments

- x:

  a character vector, typically containing HTML markup

## Value

`x`, with class `"html"` added

## See also

Other html:
[`as.img()`](https://andrisignorell.github.io/aurora/reference/as.img.md),
[`htmlNotation`](https://andrisignorell.github.io/aurora/reference/htmlNotation.md),
[`htmlSubscript`](https://andrisignorell.github.io/aurora/reference/htmlSubscript.md),
[`toHtmlTable()`](https://andrisignorell.github.io/aurora/reference/toHtmlTable.md)

## Examples

``` r
as.html("<b>bold</b>")
#> <b>bold</b>
```
