# Plot Methods for Lorenz Curve Objects

Visualize objects of class `"Lc"` and `"LcList"` returned by
[`lc()`](https://rdrr.io/pkg/DescToolsX/man/lc.html). The
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) method draws a
new Lorenz curve plot including the line of perfect equality;
[`lines()`](https://rdrr.io/r/graphics/lines.html) and
[`points()`](https://rdrr.io/r/graphics/points.html) add to an existing
plot.

## Usage

``` r
# S3 method for class 'Lc'
plot(
  x,
  main = NULL,
  xlab = "p",
  ylab = "L(p)",
  xlim = NULL,
  ylim = NULL,
  general = FALSE,
  line = TRUE,
  points = TRUE,
  grid = TRUE,
  box = TRUE,
  ...
)

# S3 method for class 'Lc'
lines(x, general = FALSE, col = NULL, lwd = 2, lty = 1, cbandArgs = NA, ...)

# S3 method for class 'Lc'
points(x, general = FALSE, pch = 16, col = NULL, ...)

# S3 method for class 'LcList'
lines(x, col = NULL, ...)

# S3 method for class 'LcList'
points(x, col = NULL, ...)

# S3 method for class 'LcList'
plot(x, col = NULL, ...)
```

## Arguments

- x:

  Object of class `"Lc"` (for `plot.Lc()`, `lines.Lc()`, `points.Lc()`)
  or `"LcList"` (for the `*.LcList()` methods).

- main, xlab, ylab:

  Main title and axis labels, used by `plot.Lc()` only. Defaults are
  `NULL`, `"p"`, and `"L(p)"`, respectively.

- xlim, ylim:

  Numeric vectors of length 2 giving axis limits, used by `plot.Lc()`
  only. Default `NULL`, which resolves to `c(0, 1)`.

- general:

  Logical. If `TRUE`, the generalized Lorenz curve (scaled by the mean)
  is displayed instead of the standard curve. Default is `FALSE`. Used
  by `plot.Lc()`, `lines.Lc()`, and `points.Lc()`; for the `"LcList"`
  methods it is passed through `...` to the underlying `Lc` method.

- line:

  Logical or list, used by `plot.Lc()` to control drawing of the Lorenz
  curve line. `TRUE` (default) draws the line with package defaults
  (`col = "black"`, `lty = 1`, `lwd = 2`); `FALSE` suppresses it; a list
  overrides individual defaults and is forwarded to
  [`lines()`](https://rdrr.io/r/graphics/lines.html).

- points:

  Logical or list, used by `plot.Lc()` to control drawing of points on
  the Lorenz curve. `TRUE` (default) draws points with package defaults
  (`pch = 21`, `bg = "white"`, `col = "black"`, `cex = 1.4`); `FALSE`
  suppresses them; a list overrides individual defaults and is forwarded
  to [`points()`](https://rdrr.io/r/graphics/points.html).

- grid:

  Logical or list, used by `plot.Lc()` only. If `TRUE` (default) or a
  list, a grid is drawn before the curve via
  [`grid()`](https://rdrr.io/r/graphics/grid.html); a list is forwarded
  as arguments to that function.

- box:

  Logical, used by `plot.Lc()` only. If `TRUE` (default), a box is drawn
  around the plot area.

- ...:

  Further arguments. For `plot.Lc()`, graphical parameters passed to
  [`par()`](https://rdrr.io/r/graphics/par.html) via
  `.applyParFromDots()` (e.g. `mar`, `cex.axis`, `las`). For
  `lines.Lc()` and `points.Lc()`, further arguments passed on to
  [`lines()`](https://rdrr.io/r/graphics/lines.html) and
  [`points()`](https://rdrr.io/r/graphics/points.html), respectively.
  For the `"LcList"` methods, arguments passed through to the
  corresponding `Lc` method for each group.

- col:

  Color for the curve or points. For `lines.Lc()` and `points.Lc()`, a
  single color (default `NULL`, i.e. the current device default). For
  the `"LcList"` methods, a vector recycled over groups (default `NULL`,
  i.e. `seq_len(k)`).

- lwd:

  Line width, used by `lines.Lc()` only. Default is `2`.

- lty:

  Line type, used by `lines.Lc()` only. Default is `1`.

- cbandArgs:

  Used by `lines.Lc()` only. `NA` to suppress the confidence band
  (default), or a list of arguments passed to
  [`predict.Lc()`](https://rdrr.io/pkg/DescToolsX/man/lc.html) to
  control bootstrap confidence intervals.

- pch:

  Plotting symbol, used by `points.Lc()` only. Default is `16`.

## Value

All methods return `NULL` invisibly.

## Details

For `"LcList"` objects (grouped Lorenz curves),
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) draws the first
group and overlays the remaining groups with
[`lines()`](https://rdrr.io/r/graphics/lines.html). Colors cycle
automatically when `col` is not supplied.

The confidence band in `lines.Lc()` is drawn via `cbandArgs`. Pass a
list of arguments to
[`predict.Lc()`](https://rdrr.io/pkg/DescToolsX/man/lc.html) to control
the bootstrap (e.g. `cbandArgs = list(conf.level = 0.90, n = 500)`). Set
`cbandArgs = NA` (default) to suppress the band.

## See also

[`lc()`](https://rdrr.io/pkg/DescToolsX/man/lc.html) for computing the
Lorenz curve,
[`predict.Lc()`](https://rdrr.io/pkg/DescToolsX/man/lc.html) for
bootstrap confidence intervals,
[`gini()`](https://rdrr.io/pkg/DescToolsX/man/gini.html) for the Gini
coefficient.

Other plot.s3:
[`plot.BlandAltman()`](https://andrisignorell.github.io/aurora/reference/plot.BlandAltman.md),
[`plot.Desc.qn()`](https://andrisignorell.github.io/aurora/reference/plot.Desc.qn.md),
[`plot.Desc.table()`](https://andrisignorell.github.io/aurora/reference/plot.Desc.table.md)
