# Embed a plot as an inline HTML image

Evaluates a plotting expression in a temporary PNG device and returns
the resulting image as a self-contained, base64-encoded `<img>` tag
(class `"html"`, see
[`as.html`](https://andrisignorell.github.io/aurora/reference/as.html.md))
suitable for embedding directly in HTML text.

## Usage

``` r
as.img(x, ...)
```

## Arguments

- x:

  a string containing a plotting expression, e.g. `"plot(1:10)"` –
  evaluated via `eval(parse(text = x))` in the caller's environment

- ...:

  further arguments passed to
  [`png`](https://rdrr.io/r/grDevices/png.html) (e.g. `width`, `height`)

## Value

an object of class `"html"` containing an `<img>` tag with a
`data:image/png;base64,...` source

## See also

Other html:
[`as.html()`](https://andrisignorell.github.io/aurora/reference/as.html.md),
[`toHtmlTable()`](https://andrisignorell.github.io/aurora/reference/toHtmlTable.md)
