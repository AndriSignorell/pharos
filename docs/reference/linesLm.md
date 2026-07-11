# Add a Linear Regression Line

Add a linear regression line to an existing plot. The function first
calculates predictions from an `lm` object and then adds the fitted line
together with optional confidence and prediction bands.

## Usage

``` r
# S3 method for class 'lm'
lines(
  x,
  col = pal()[1],
  lwd = 2,
  lty = "solid",
  type = "l",
  n = 100,
  cbandArgs = list(conf.level = 0.95),
  pbandArgs = NA,
  xpred = NULL,
  ...
)

# S3 method for class 'lmlog'
lines(
  x,
  col = pal()[1],
  lwd = 2,
  lty = "solid",
  type = "l",
  n = 100,
  cbandArgs = list(conf.level = 0.95),
  pbandArgs = NA,
  xpred = NULL,
  ...
)
```

## Arguments

- x:

  linear model object as returned by
  [`lm`](https://rdrr.io/r/stats/lm.html).

- col:

  line color. Defaults to `pal()[1]`.

- lwd:

  line width.

- lty:

  line type.

- type:

  plotting type passed to
  [`lines`](https://rdrr.io/r/graphics/lines.html).

- n:

  number of points used for plotting the fit.

- cbandArgs:

  controls the confidence band. May be `TRUE`, `FALSE`, `NULL`, `NA`, or
  a named list. The confidence level is specified via `conf.level`.
  Default is `list(conf.level=0.95)`.

- pbandArgs:

  controls the prediction band. May be `TRUE`, `FALSE`, `NULL`, `NA`, or
  a named list. The confidence level is specified via `conf.level`.
  Default is `NA`.

- xpred:

  optional numeric vector defining the range over which predictions
  should be calculated.

- ...:

  currently ignored.

## Value

No return value; called for its side effect.

## Details

In contrast to [`abline`](https://rdrr.io/r/graphics/abline.html),
polynomial models and transformed predictors are supported as long as
the model contains exactly one predictor.

Confidence and prediction bands are controlled via `cbandArgs` and
`pbandArgs`. These arguments can be:

- `FALSE`, `NULL` or `NA`: suppress the band

- `TRUE`: draw the band with default settings

- a named list: customize the band appearance and confidence level

## See also

[`lines`](https://rdrr.io/r/graphics/lines.html),
[`lm`](https://rdrr.io/r/stats/lm.html)

Other graphics.utils:
[`abcCoords()`](https://andrisignorell.github.io/lyra/reference/abcCoords.md),
[`axisBreak()`](https://andrisignorell.github.io/lyra/reference/axisBreak.md),
[`barText()`](https://andrisignorell.github.io/lyra/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/lyra/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/lyra/reference/colLegend.md),
[`degToRad()`](https://andrisignorell.github.io/lyra/reference/degToRad.md),
[`errBars()`](https://andrisignorell.github.io/lyra/reference/errBars.md),
[`lineSep()`](https://andrisignorell.github.io/lyra/reference/lineSep.md),
[`lineToUser()`](https://andrisignorell.github.io/lyra/reference/lineToUser.md),
[`mar()`](https://andrisignorell.github.io/lyra/reference/mar.md),
[`preview()`](https://andrisignorell.github.io/lyra/reference/preview.md),
[`spreadOut()`](https://andrisignorell.github.io/lyra/reference/spreadOut.md),
[`stamp()`](https://andrisignorell.github.io/lyra/reference/stamp.md),
[`textLegend()`](https://andrisignorell.github.io/lyra/reference/textLegend.md),
[`titleRect()`](https://andrisignorell.github.io/lyra/reference/titleRect.md),
[`unit()`](https://andrisignorell.github.io/lyra/reference/unit.md)
