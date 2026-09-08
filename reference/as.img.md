# Embed a plot as an inline HTML image

Evaluates a plotting expression in a temporary PNG device and returns
the resulting image as a self-contained, base64-encoded `<img>` tag
(class `"html"`, see [`as.html()`](as.html.md)), suitable for embedding
directly in HTML text – a report, a question, an e-mail.

## Usage

``` r
as.img(expr, width = 520, height = 440, res = 96, ...)
```

## Arguments

- expr:

  a plotting expression, evaluated once inside the device. Character
  input is evaluated via `eval(parse(text = expr))` for compatibility
  with the earlier form of this function.

- width, height:

  size of the device in pixels

- res:

  nominal resolution in dpi, which also scales the text: raise it for a
  larger picture with the same relative proportions

- ...:

  further arguments passed to
  [`grDevices::png()`](https://rdrr.io/r/grDevices/png.html)

## Value

an object of class `c("html", "character")` containing an `<img>` tag
with a `data:image/png;base64,...` source

## Details

The expression is passed unevaluated and carries its own environment, so
a plot built inside a function sees that function's local variables.
Several statements are given in braces, as in the examples below.

## See also

Other html: [`as.fileLink()`](as.fileLink.md),
[`as.html()`](as.html.md), [`embedFile()`](embedFile.md),
[`escapeHtml()`](escapeHtml.md), [`htmlNotation`](htmlNotation.md),
[`htmlSubscript`](htmlSubscript.md), [`toHtmlTable()`](toHtmlTable.md)

## Examples

``` r
img <- as.img(plot(1:10))

# several statements, and local variables
f <- function(n) {
  x <- seq_len(n)
  as.img({
    plot(x, x^2, type = "b")
    abline(h = mean(x^2), lty = 2)
  })
}
substr(f(10), 1, 30)
#> <img src="data:image/png;base6
```
