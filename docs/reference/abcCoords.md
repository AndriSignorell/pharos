# Coordinates for Named Plot Positions

Returns the xy-coordinates and text-adjustment values for named anchor
positions such as `"topleft"`, `"center"`, etc., as used by
[`legend`](https://rdrr.io/r/graphics/legend.html). Useful for placing
text or other annotations at consistent, region-aware positions.

## Usage

``` r
abcCoords(
  x = "topleft",
  region = c("figure", "plot", "device"),
  cex = NULL,
  inset = 0
)
```

## Arguments

- x:

  A character string specifying the anchor position. One of
  `"bottomright"`, `"bottom"`, `"bottomleft"`, `"left"`, `"topleft"`,
  `"top"`, `"topright"`, `"right"`, or `"center"`. Partial matching is
  supported.

- region:

  One of `"figure"` (default), `"plot"`, or `"device"`. Determines the
  coordinate region used.

- cex:

  Character expansion factor. If `NULL` (default), the current
  `par("cex")` is used.

- inset:

  Inset distance from the boundary, specified in lines of text
  (character heights/widths). May be a scalar (applied to both x and y)
  or a length-2 vector (x inset, y inset). Default `0`.

## Value

A list with two components:

- `xy`:

  A list with elements `x` and `y` giving the anchor coordinates in user
  space.

- `adj`:

  A numeric vector of length 2, suitable for the `adj` argument of
  [`text`](https://rdrr.io/r/graphics/text.html).

## Details

The inset is computed in character units via
[`strwidth`](https://rdrr.io/r/graphics/strwidth.html) and
[`strheight`](https://rdrr.io/r/graphics/strwidth.html), making it
robust to device resizing, font changes, and plot-range scaling.

Three regions are supported:

- `"plot"`:

  The inner plot area (`par("usr")`).

- `"figure"`:

  The figure region within the device, accounting for `par("fig")`.

- `"device"`:

  The full device area.

## Note

The positioning logic is adapted from
[`legend`](https://rdrr.io/r/graphics/legend.html).

## See also

[`text`](https://rdrr.io/r/graphics/text.html),
[`legend`](https://rdrr.io/r/graphics/legend.html),
[`boxedText`](https://andrisignorell.github.io/aurora/reference/boxedText.md)

Other graphics.utils:
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
[`textLegend()`](https://andrisignorell.github.io/aurora/reference/textLegend.md),
[`titleRect()`](https://andrisignorell.github.io/aurora/reference/titleRect.md),
[`unit()`](https://andrisignorell.github.io/aurora/reference/unit.md)

## Examples

``` r
plot(x = rnorm(10), type = "n", xlab = "", ylab = "")

# coordinates only
abcCoords("bottomleft")
#> $xy
#> $xy$x
#> [1] -0.8287469
#> 
#> $xy$y
#> [1] -3.399057
#> 
#> 
#> $adj
#> [1] 0 0
#> 

# place text at a named position
xy <- abcCoords("bottomleft", region = "plot")
text(x = xy$xy$x, y = xy$xy$y, labels = "My Label",
     adj = xy$adj, xpd = NA)

# all nine positions with inset
sapply(c("topleft", "top", "topright",
         "left",    "center", "right",
         "bottomleft", "bottom", "bottomright"),
  function(p) {
    xy <- abcCoords(p, region = "plot", inset = 1)
    text(x = xy$xy$x, y = xy$xy$y,
         labels = p, adj = xy$adj, xpd = NA)
  })

#> $topleft
#> NULL
#> 
#> $top
#> NULL
#> 
#> $topright
#> NULL
#> 
#> $left
#> NULL
#> 
#> $center
#> NULL
#> 
#> $right
#> NULL
#> 
#> $bottomleft
#> NULL
#> 
#> $bottom
#> NULL
#> 
#> $bottomright
#> NULL
#> 
```
