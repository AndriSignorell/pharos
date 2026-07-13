# Add Error Bars to an Existing Plot

Add vertical or horizontal error bars to an existing plot.

## Usage

``` r
errBars(from, to = NULL, pos = NULL, horiz = TRUE, points = NULL, ...)
```

## Arguments

- from:

  coordinates of the lower end of the error bars.

  If `to = NULL` and `from` is a matrix:

  - a 2-column matrix is interpreted as `cbind(from, to)`

  - a 3-column matrix is interpreted as `cbind(point, from, to)`

- to:

  coordinates of the upper end of the error bars.

- pos:

  position of the error bars.

  For vertical bars this corresponds to x-positions; for horizontal bars
  to y-positions.

- horiz:

  logical; if `TRUE`, horizontal error bars are drawn.

- points:

  optional point specification.

- ...:

  additional graphical arguments passed to
  [`arrows`](https://rdrr.io/r/graphics/arrows.html).

## Value

Invisibly returns a list with components:

- from:

  Lower endpoints

- to:

  Upper endpoints

- pos:

  Positions of the error bars

- points:

  Point coordinates

## Details

This is a lightweight wrapper around
[`arrows`](https://rdrr.io/r/graphics/arrows.html) with optional point
symbols added via [`points`](https://rdrr.io/r/graphics/points.html).

Additional graphical arguments in `...` are passed to
[`arrows`](https://rdrr.io/r/graphics/arrows.html) and may be used to
control the appearance of the error bars.

Common examples include:

- `col`: line color

- `lwd`: line width

- `lty`: line type

- `code`: which end caps to draw

- `length`: length of the end caps

Point symbols may optionally be added:

- `points = TRUE`: draw default points halfway between `from` and `to`

- `points = numeric`: use these values as point coordinates

- `points = list(...)`: fully specify point coordinates and graphical
  parameters

Example:


    points = list(
      val = estimate,
      pch = 21,
      bg  = "gold",
      col = "black",
      cex = 1.2
    )

The default orientation is horizontal (`horiz = TRUE`), which suits the
typical use case of adding confidence intervals to a
[`dotchart`](https://rdrr.io/r/graphics/dotchart.html). Set
`horiz = FALSE` for vertical bars on barplots or similar.

## See also

[`arrows`](https://rdrr.io/r/graphics/arrows.html),
[`points`](https://rdrr.io/r/graphics/points.html)

Other graphics.annotation:
[`barText()`](https://andrisignorell.github.io/aurora/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/aurora/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/aurora/reference/colLegend.md),
[`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md),
[`textLegend()`](https://andrisignorell.github.io/aurora/reference/textLegend.md),
[`titleRect()`](https://andrisignorell.github.io/aurora/reference/titleRect.md)

## Examples

``` r
op <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))

b <- barplot(1:5, ylim = c(0, 6))

errBars(
  from = 1:5 - 0.5,
  to = 1:5 + 0.5,
  pos = b,
  length = 0.15
)

# midpoint symbols
b <- barplot(1:5, ylim = c(0, 6))

errBars(
  from = 1:5 - 0.5,
  to = 1:5 + 0.5,
  pos = b,
  points = TRUE
)

# custom points
dotchart(1:5, xlim = c(0, 6))

errBars(
  from = 1:5 - 0.2,
  to = 1:5 + 0.2,
  horiz = TRUE,
  points = list(
    val = 1:5,
    pch = 21,
    bg = "gold",
    col = "black",
    cex = 1.2
  )
)

par(op)

```
