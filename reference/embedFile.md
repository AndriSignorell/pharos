# Base64-encode a file

The building block behind [`asImg()`](asImg.md) and
[`asFileLink()`](asFileLink.md): reads a file and returns its contents
base64-encoded, ready to be placed in a data URI or in any container
format that carries binary payloads as text.

## Usage

``` r
embedFile(path)
```

## Arguments

- path:

  path to an existing file

## Value

a single character string

## See also

Other html: [`asFileLink()`](asFileLink.md), [`asHtml()`](asHtml.md),
[`asImg()`](asImg.md), [`escapeHtml()`](escapeHtml.md),
[`htmlNotation`](htmlNotation.md), [`htmlSubscript`](htmlSubscript.md),
[`toHtmlTable()`](toHtmlTable.md)

## Examples

``` r
fn <- tempfile(fileext = ".txt")
writeLines("hello", fn)
substr(embedFile(fn), 1, 8)
#> [1] "aGVsbG8K"
unlink(fn)
```
