# Mark a character vector as HTML

Tags a character vector with the S3 class `"html"` so that it prints via
[`preview.html()`](preview.html.md) as readable text instead of as a raw
character vector.

## Usage

``` r
asHtml(x)
```

## Arguments

- x:

  a character vector, typically containing HTML markup

## Value

`x`, with class `"html"` added

## See also

Other html: [`asFileLink()`](asFileLink.md), [`asImg()`](asImg.md),
[`embedFile()`](embedFile.md), [`escapeHtml()`](escapeHtml.md),
[`htmlNotation`](htmlNotation.md), [`htmlSubscript`](htmlSubscript.md),
[`toHtmlTable()`](toHtmlTable.md)

## Examples

``` r
asHtml("<b>bold</b>")
#> <b>bold</b>
```
