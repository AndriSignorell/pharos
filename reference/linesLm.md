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
  cband = list(conf.level = 0.95),
  pband = NA,
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
  cband = list(conf.level = 0.95),
  pband = NA,
  xpred = NULL,
  ...
)
```

## Arguments

- x:

  linear model object as returned by
  [`lm()`](https://rdrr.io/r/stats/lm.html).

- col:

  line color. Defaults to `pal()[1]`.

- lwd:

  line width.

- lty:

  line type.

- type:

  plotting type passed to
  [`lines()`](https://rdrr.io/r/graphics/lines.html).

- n:

  number of points used for plotting the fit.

- cband:

  controls the confidence band. May be `TRUE`, `FALSE`, `NULL`, `NA`, or
  a named list. The confidence level is specified via `conf.level`, all
  other elements are graphical parameters of the band. Default is
  `list(conf.level=0.95)`.

- pband:

  controls the prediction band, as `cband`. Default is `NA`.

- xpred:

  optional numeric vector defining the range over which predictions
  should be calculated.

- ...:

  further graphical parameters passed to
  [`lines()`](https://rdrr.io/r/graphics/lines.html) for the fitted
  line.

## Value

No return value; called for its side effect.

## Details

In contrast to [`abline()`](https://rdrr.io/r/graphics/abline.html),
polynomial models and transformed predictors are supported as long as
the model contains exactly one predictor variable. A polynomial,
`y ~ poly(x, 2)` or `y ~ x + I(x^2)`, is drawn against `x`; a single
transformed term such as `y ~ log(x)` is drawn against the transformed
values, matching `plot(y ~ log(x))`.

Confidence and prediction bands are controlled via `cband` and `pband`.
These arguments can be:

- `FALSE`, `NULL` or `NA`: suppress the band

- `TRUE`: draw the band with default settings

- a named list: customize the band appearance and confidence level

## See also

[`lines()`](https://rdrr.io/r/graphics/lines.html),
[`lm()`](https://rdrr.io/r/stats/lm.html)

Other graphics.trendlines: [`lines.loess()`](lines.loess.md),
[`splineCI`](splineCI.md)
