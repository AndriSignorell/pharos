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

  one of `"figure"` (default), `"plot"`, or `"device"`. Determines the
  coordinate region used.

- cex:

  character expansion factor. If `NULL` (default), the current
  `par("cex")` is used.

- inset:

  inset distance from the boundary, specified in lines of text
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

The positioning logic is adapted from
[`legend`](https://rdrr.io/r/graphics/legend.html). The inset is
computed in character units via
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

## See also

[`text`](https://rdrr.io/r/graphics/text.html),
[`legend`](https://rdrr.io/r/graphics/legend.html)

Other graphics.layout:
[`axTicks`](https://andrisignorell.github.io/aurora/reference/axTicks.md),
[`axisBreak()`](https://andrisignorell.github.io/aurora/reference/axisBreak.md),
[`isValidPlotRegion()`](https://andrisignorell.github.io/aurora/reference/isValidPlotRegion.md),
[`lineToUser()`](https://andrisignorell.github.io/aurora/reference/lineToUser.md),
[`mar()`](https://andrisignorell.github.io/aurora/reference/mar.md),
[`plotFacet()`](https://andrisignorell.github.io/aurora/reference/plotFacet.md),
[`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md)

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
