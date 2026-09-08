# Plot Methods for Lorenz Curve Objects

Visualize objects of class `"Lc"` and `"LcList"` returned by
`DescToolsX::lc()`. The
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
  xlab = NULL,
  ylab = NULL,
  xlim = NULL,
  ylim = NULL,
  general = FALSE,
  col = NULL,
  line = TRUE,
  points = NULL,
  eqline = TRUE,
  grid = .useTheme,
  box = .useTheme,
  cbandArgs = NA,
  stamp = .useTheme,
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
plot(x, col = NULL, general = FALSE, ylim = NULL, ...)
```

## Arguments

- x:

  object of class `"Lc"` (for `plot.Lc()`, `lines.Lc()`, `points.Lc()`)
  or `"LcList"` (for the `*.LcList()` methods).

- main, xlab, ylab:

  main title and axis labels, used by `plot.Lc()` only. All default to
  `NULL`: no title, `"p"`, and `"L(p)"` (`"GL(p)"` if `general = TRUE`),
  respectively.

- xlim, ylim:

  numeric vectors of length 2 giving axis limits, used by `plot.Lc()`
  and `plot.LcList()`. Default `NULL`, which resolves to `c(0, 1)` for
  `xlim` and, for `ylim`, to `c(0, 1)` for the standard and
  `c(0, max(L))` for the generalized curve.

- general:

  logical. If `TRUE`, the generalized Lorenz curve (scaled by the mean)
  is displayed instead of the standard curve. Default is `FALSE`.

- col:

  color of curve and symbols. For `plot.Lc()`, `lines.Lc()` and
  `points.Lc()` a single color (default `NULL`, i.e. `"black"` in
  `plot.Lc()` and the device default in the low-level methods). For the
  `"LcList"` methods a vector recycled to the number of groups (default
  `NULL`, i.e. `seq_len(k)`).

- line:

  logical or list, used by `plot.Lc()` to control drawing of the Lorenz
  curve. `TRUE` (default) draws it with package defaults (`lty = 1`,
  `lwd = 2`); `FALSE` suppresses it (and the confidence band); a list
  overrides individual defaults and is forwarded to `lines.Lc()`.

- points:

  `NULL`, logical or list, used by `plot.Lc()` to control drawing of
  symbols on the curve. `NULL` (default) is automatic: symbols are drawn
  only while the curve has at most
  `getOption("DescToolsX.plot.maxSymbols")` knots (100 by default),
  which keeps large samples legible. `TRUE` always draws them with
  package defaults (`pch = 21`, `bg = "white"`, `cex = 1.4`); `FALSE`
  suppresses them; a list overrides individual defaults and is forwarded
  to `points.Lc()`.

- eqline:

  logical or list, used by `plot.Lc()` only. Controls the line of
  perfect equality: `TRUE` (default) draws it with package defaults
  (`col = "grey50"`, `lty = 2`), `FALSE` suppresses it, a list is
  forwarded to
  [`graphics::abline()`](https://rdrr.io/r/graphics/abline.html). Its
  slope is `1` for the standard and `max(L)` for the generalized curve;
  overriding `a`/`b` is possible but rarely sensible.

- grid, box:

  callIf-style specs for the grid and the box around the plot region,
  used by `plot.Lc()` only. `.useTheme` (default) lets
  [`getTheme()`](theme.md) decide, `TRUE`/`FALSE` force
  drawing/suppression, and a named list is forwarded to
  [`graphics::grid()`](https://rdrr.io/r/graphics/grid.html) resp.
  [`graphics::box()`](https://rdrr.io/r/graphics/box.html).

- cbandArgs:

  used by `plot.Lc()` and `lines.Lc()`. `NA` to suppress the confidence
  band (default), or a list of arguments passed to
  `DescToolsX::predict.Lc()` to control bootstrap confidence intervals.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/ `NULL`, a string, or a named list
  for [`stamp()`](stamp.md).

- ...:

  further arguments. For `plot.Lc()`, graphical parameters passed to
  [`graphics::par()`](https://rdrr.io/r/graphics/par.html) via
  [`.applyParFromDots()`](graphics-framework.md) (e.g. `mar`,
  `cex.axis`, `las`). For `lines.Lc()` and `points.Lc()`, further
  arguments passed on to
  [`graphics::lines()`](https://rdrr.io/r/graphics/lines.html) and
  [`graphics::points()`](https://rdrr.io/r/graphics/points.html),
  respectively. For `plot.LcList()`, arguments are passed to `plot.Lc()`
  for the first group and, restricted to those the low-level method
  understands, to `lines.Lc()` for the remaining ones.

- lwd:

  line width, used by `plot.Lc()` (via `line`) and `lines.Lc()`. Default
  is `2`.

- lty:

  line type, used by `plot.Lc()` (via `line`) and `lines.Lc()`. Default
  is `1`.

- pch:

  plotting symbol, used by `points.Lc()` only. Default is `16`.

## Value

All methods return `NULL` invisibly.

## Details

For `"LcList"` objects (grouped Lorenz curves),
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) draws the first
group and overlays the remaining groups with
[`lines()`](https://rdrr.io/r/graphics/lines.html). Colors cycle
automatically when `col` is not supplied and are recycled to the number
of groups otherwise.

The curve of `plot.Lc()` is drawn by `lines.Lc()` and the symbols by
`points.Lc()`, so all three methods share one code path and one set of
semantics - including the confidence band, which is controlled by
`cbandArgs` in `plot.Lc()` exactly as it is in `lines.Lc()`. Pass a list
of arguments to `DescToolsX::predict.Lc()` to control the bootstrap
(e.g. `cbandArgs = list(conf.level = 0.90, n = 500)`). Set
`cbandArgs = NA` (default) to suppress the band. Note that
`line = FALSE` suppresses the band along with the curve.

With `general = TRUE` the generalized Lorenz curve is displayed. It ends
at the mean rather than at 1, so the default `ylim` and the slope of the
equality line follow the data; for `"LcList"` objects the panel is sized
to accommodate *all* groups, not just the first.

## See also

`DescToolsX::lc()` for computing the Lorenz curve,
`DescToolsX::predict.Lc()` for bootstrap confidence intervals,
`DescToolsX::gini()` for the Gini coefficient.

Other plot.s3: [`plot.BlandAltman()`](plot.BlandAltman.md),
[`plot.Desc.qn()`](plot.Desc.qn.md),
[`plot.Desc.table()`](plot.Desc.table.md)
