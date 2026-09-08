# Render a matrix as an HTML table

Converts a matrix (or vector) to a `<table>` HTML fragment, with
optional row/column headers, caption, per-column alignment and widths.
The result has class `c("html", "character")` (see
[`as.html()`](as.html.md)) and prints as a formatted text table via
[`preview.html()`](preview.html.md).

## Usage

``` r
toHtmlTable(
  m,
  sepCol = FALSE,
  caption = "",
  bodyAlign = "center",
  valign = "top",
  width = NULL,
  cellpadding = 3,
  border = 0,
  tableWidth = NA,
  captionAlign = "center",
  frame = TRUE,
  rowNames = TRUE,
  colNames = TRUE
)
```

## Arguments

- m:

  a matrix or vector

- sepCol:

  logical; if `TRUE`, insert a narrow empty separator column between
  each pair of columns

- caption:

  table caption text

- bodyAlign:

  horizontal alignment of body cells (`"left"`, `"center"`, `"right"`),
  recycled to the number of columns

- valign:

  vertical alignment of body cells (HTML `valign` attribute: `"top"`,
  `"middle"`, `"bottom"`), recycled to the number of columns

- width:

  column width(s) (HTML `width` attribute), recycled to the number of
  columns including an optional rowname column; use `NA` for columns
  without an explicit width

- cellpadding:

  HTML `cellpadding` attribute

- border:

  HTML `border` attribute

- tableWidth:

  overall table width (HTML `width` attribute on `<table>`), or `NA` for
  none

- captionAlign:

  horizontal alignment of the header row cells

- frame:

  logical; if `TRUE`, draw outer frame and group rules
  (`frame="hsides" rules="groups"`)

- rowNames:

  logical; render the row names as a leading header column. Ignored when
  `m` has none

- colNames:

  logical; render the column names as a header row. Ignored when `m` has
  none

## Value

an object of class `c("html", "character")`

## See also

[bedrock::appendEnum](https://andrisignorell.github.io/bedrock/reference/appendEnum.html)

Other html: [`as.fileLink()`](as.fileLink.md),
[`as.html()`](as.html.md), [`as.img()`](as.img.md),
[`embedFile()`](embedFile.md), [`escapeHtml()`](escapeHtml.md),
[`htmlNotation`](htmlNotation.md), [`htmlSubscript`](htmlSubscript.md)
