# Link to a self-contained embedded file

Turns a file into a download link that carries the file with it: the
contents travel base64-encoded inside the `href`, so the resulting HTML
needs no server and no accompanying assets. The counterpart of
[`asImg()`](asImg.md) for non-image files – a data set next to a table,
a script next to its output.

## Usage

``` r
asFileLink(path, label = NULL, type = NULL)
```

## Arguments

- path:

  path to an existing file

- label:

  link text; defaults to the file name

- type:

  MIME type; guessed from the extension when `NULL`

## Value

an object of class `c("html", "character")`

## Details

Browsers limit the size of a data URI, so this suits spreadsheets and
text files rather than large binaries.

## See also

Other html: [`asHtml()`](asHtml.md), [`asImg()`](asImg.md),
[`embedFile()`](embedFile.md), [`escapeHtml()`](escapeHtml.md),
[`htmlNotation`](htmlNotation.md), [`htmlSubscript`](htmlSubscript.md),
[`toHtmlTable()`](toHtmlTable.md)

## Examples

``` r
fn <- tempfile(fileext = ".csv")
write.csv(head(iris), fn, row.names = FALSE)
asFileLink(fn, label = "iris")
#> <a href="data:text/csv;base64,IlNlcGFsLkxlbmd0aCIsIlNlcGFsLldpZHRoIiwiUGV0YWwuTGVuZ3RoIiwiUGV0YWwuV2lkdGgiLCJTcGVjaWVzIgo1LjEsMy41LDEuNCwwLjIsInNldG9zYSIKNC45LDMsMS40LDAuMiwic2V0b3NhIgo0LjcsMy4yLDEuMywwLjIsInNldG9zYSIKNC42LDMuMSwxLjUsMC4yLCJzZXRvc2EiCjUsMy42LDEuNCwwLjIsInNldG9zYSIKNS40LDMuOSwxLjcsMC40LCJzZXRvc2EiCg==" download="file193a3f86adb5.csv">iris</a>
unlink(fn)
```
