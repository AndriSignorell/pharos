# Direct Labels in the Right Margin

Draw a legend in the right margin consisting of short line segments and
text labels, placed next to the (typically last) values of the plotted
series. This labels lines directly instead of using a boxed
[`legend()`](https://rdrr.io/r/graphics/legend.html), as commonly
preferred for time series and profile plots.

## Usage

``` r
textLegend(
  y,
  labels = names(y),
  line = c(1, 1),
  width = 1,
  col = par("fg"),
  lty = par("lty"),
  lwd = par("lwd"),
  cex = par("cex"),
  main = NULL,
  mindist = NULL
)
```

## Arguments

- y:

  numeric vector with the vertical anchor positions in user coordinates,
  typically the last observed value of each series, in series (column)
  order. Sorting and collision handling are done internally.

- labels:

  character vector of labels, parallel to `y`. Defaults to `names(y)`,
  or the series index if `y` is unnamed.

- line:

  numeric vector of length 1 or 2 (recycled), in margin lines of side 4.
  The first element is the offset of the segments from the plot region,
  the second the gap between segments and labels.

- width:

  length of the line segments in margin lines. Set to `NA` to suppress
  the segments; the labels are then placed directly at `line[1]`.

- col, lty, lwd:

  color, line type and width of the segments, parallel to `y` (in series
  order, recycled). Ignored if `width` is `NA`.

- cex:

  character expansion for the labels. Also enters the default vertical
  spacing, so larger text automatically gets wider spacing.

- main:

  optional title for the legend, drawn at the top of the plot region.
  Default is `NULL` (none).

- mindist:

  minimal vertical distance between labels in user coordinates, passed
  to
  [`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md).
  Default is `1.2 * strheight("M") * cex`.

## Value

The (sorted and spread) vertical label positions, invisibly. Useful for
adding further annotation next to the labels.

## Details

The function owns the legend geometry: the anchor positions `y` are
sorted internally so the legend follows the vertical order of the lines,
the graphical parameters are recycled accordingly, and vertical label
collisions are resolved via
[`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md).
Callers therefore simply pass the values in series order, parallel to
`col`, `lty` and `lwd`.

Drawing uses [`mtext()`](https://rdrr.io/r/graphics/mtext.html) and
[`segments()`](https://rdrr.io/r/graphics/segments.html) in the device
margin; `xpd` is set to `TRUE` and restored on exit. Horizontal
positions are given in margin lines of side 4 and converted to user
coordinates via
[`lineToUser()`](https://andrisignorell.github.io/aurora/reference/lineToUser.md).

Make sure the right margin is wide enough for segments and labels, e.g.
via the `mar` argument of the calling plot function.

## See also

[`plotLines`](https://andrisignorell.github.io/aurora/reference/plotLines.md),
[`mtext`](https://rdrr.io/r/graphics/mtext.html),
[`segments`](https://rdrr.io/r/graphics/segments.html),
[`legend`](https://rdrr.io/r/graphics/legend.html)

Other graphics.utils:
[`abcCoords()`](https://andrisignorell.github.io/aurora/reference/abcCoords.md),
[`axisBreak()`](https://andrisignorell.github.io/aurora/reference/axisBreak.md),
[`barText()`](https://andrisignorell.github.io/aurora/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/aurora/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/aurora/reference/colLegend.md),
[`degToRad()`](https://andrisignorell.github.io/aurora/reference/degToRad.md),
[`errBars()`](https://andrisignorell.github.io/aurora/reference/errBars.md),
[`lineSep()`](https://andrisignorell.github.io/aurora/reference/lineSep.md),
[`lineToUser()`](https://andrisignorell.github.io/aurora/reference/lineToUser.md),
[`lines.lm()`](https://andrisignorell.github.io/aurora/reference/linesLm.md),
[`mar()`](https://andrisignorell.github.io/aurora/reference/mar.md),
[`preview()`](https://andrisignorell.github.io/aurora/reference/preview.md),
[`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md),
[`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md),
[`titleRect()`](https://andrisignorell.github.io/aurora/reference/titleRect.md),
[`unit()`](https://andrisignorell.github.io/aurora/reference/unit.md)

## Examples

``` r
m <- EuStockMarkets[seq(1, 1860, 10), ]
op <- par(mar = c(5, 4, 4, 8))
matplot(m, type = "l", lty = 1, lwd = 2, col = 1:4, las = 1,
        main = "EU Stock Markets")
textLegend(y = m[nrow(m), ], labels = colnames(m),
           col = 1:4, lwd = 2, main = "Index")

par(op)
```
