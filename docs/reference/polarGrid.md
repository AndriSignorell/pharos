# Draw a Polar Grid with Optional Labels

Adds a polar coordinate grid (circles and radial lines) to an existing
plot. Optionally includes labels for radii and angles.

## Usage

``` r
polarGrid(
  nr = NULL,
  ntheta = NULL,
  col = "lightgray",
  lty = "dotted",
  lwd = par("lwd"),
  rlabels = NULL,
  alabels = NULL,
  lblradians = FALSE,
  cex.lab = 1,
  las = 1,
  adj = NULL,
  dist = NULL
)
```

## Arguments

- nr:

  numeric or vector controlling radial grid lines:

  `NULL`

  :   Uses default "pretty" axis values.

  single numeric

  :   Number of radial grid lines.

  numeric vector

  :   Explicit radii at which to draw circles.

  all `NA`

  :   Suppress radial grid lines.

- ntheta:

  numeric or vector controlling angular grid lines:

  `NULL`

  :   Uses 12 equally spaced angles.

  single numeric

  :   Number of angular divisions.

  numeric vector

  :   Explicit angles (in radians).

  all `NA`

  :   Suppress angular grid lines.

- col:

  color of grid lines.

- lty:

  line type for grid lines.

- lwd:

  line width for grid lines.

- rlabels:

  optional labels for radial grid lines (excluding zero). If `NULL`,
  labels are generated automatically. Use `NA` to suppress labels.

- alabels:

  optional labels for angular grid lines. If `NULL`, labels are
  generated automatically (degrees or radians). Use `NA` to suppress
  labels.

- lblradians:

  logical; if `TRUE`, angle labels are shown in radians, otherwise in
  degrees.

- cex.lab:

  character expansion factor for labels.

- las:

  integer controlling label orientation (as in
  [`par`](https://rdrr.io/r/graphics/par.html)).

- adj:

  numeric vector specifying text justification.

- dist:

  numeric distance from origin for angular labels.

## Value

Invisibly returns `NULL`.

## Details

This function is intended to be used together with polar plotting
functions such as `plotPolar`. It assumes an existing plot with equal
aspect ratio.

Radial grid lines are drawn as concentric circles, while angular grid
lines are drawn as segments from the origin.

Label placement and formatting can be customized via `adj`, `las`, and
`dist`.

## See also

[`grid()`](https://rdrr.io/r/graphics/grid.html)

Other graphics.setup:
[`canvas()`](https://andrisignorell.github.io/aurora/reference/canvas.md),
[`setBackCol()`](https://andrisignorell.github.io/aurora/reference/setBackCol.md)

## Examples

``` r
plot(0, 0, type = "n", xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)
polarGrid()


# custom grid
plot(0, 0, type = "n", xlim = c(-2, 2), ylim = c(-2, 2), asp = 1)
polarGrid(nr = 4, ntheta = 8, col = "gray")

# suppress labels
polarGrid(rlabels = NA, alabels = NA)


```
