# Escape HTML special characters

Replaces the three characters that would otherwise be read as markup.
Use it on any text of unknown origin – a variable label, a file name, a
user-supplied caption – before pasting it into HTML or XML.

## Usage

``` r
escapeHtml(x, attribute = FALSE)
```

## Arguments

- x:

  a character vector

- attribute:

  logical; also escape single and double quotes

## Value

a character vector of the same length

## Details

Quotes are escaped as well when `attribute = TRUE`, which is required
for text placed inside an attribute value rather than between tags.

## See also

Other html: [`asFileLink()`](asFileLink.md), [`asHtml()`](asHtml.md),
[`asImg()`](asImg.md), [`embedFile()`](embedFile.md),
[`htmlNotation`](htmlNotation.md), [`htmlSubscript`](htmlSubscript.md),
[`toHtmlTable()`](toHtmlTable.md)

## Examples

``` r
escapeHtml("Anteil < 5% & steigend")
#> [1] "Anteil &lt; 5% &amp; steigend"
escapeHtml('say "hi"', attribute = TRUE)
#> [1] "say &quot;hi&quot;"
```
