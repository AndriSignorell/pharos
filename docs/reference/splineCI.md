# Add a Spline Smoother

Fit a smoothing spline and optionally add confidence bands.

## Usage

``` r
splineX(x, ...)

# Default S3 method
splineX(x, ...)

# S3 method for class 'formula'
splineX(formula, data, subset, na.action = na.omit, weights, ...)

# S3 method for class 'SplineX'
lines(
  x,
  col = pal()[1],
  lwd = 2,
  lty = "solid",
  type = "l",
  bandArgs = list(conf.level = 0.95),
  ...
)
```

## Arguments

- x:

  spline object returned by `splineX()`.

- ...:

  further arguments passed to
  [`smooth.spline`](https://rdrr.io/r/stats/smooth.spline.html).

- formula:

  A formula of the form `lhs ~ rhs`, where `lhs` gives the response
  values and `rhs` the corresponding groups or explanatory variables.

- data:

  An optional matrix or data frame (or similar; see
  [`model.frame`](https://rdrr.io/r/stats/model.frame.html)) containing
  the variables in the formula. By default the variables are taken from
  `environment(formula)`.

- subset:

  An optional vector specifying a subset of observations to be used in
  the analysis.

- na.action:

  A function which indicates what should happen when the data contain
  `NA`s. Defaults to `getOption("na.action")`.

- weights:

  optional vector of weights of the same length as x.

- col:

  line color of the smoother.

- lwd:

  line width.

- lty:

  line type.

- type:

  plotting type passed to
  [`lines`](https://rdrr.io/r/graphics/lines.html).

- bandArgs:

  controls the confidence band. May be `TRUE`, `FALSE`, `NULL`, `NA`, or
  a named list. The confidence level is specified via `conf.level`.
  Default is `list(conf.level = 0.95)`.

## Details

Confidence bands are controlled via `bandArgs`. These arguments can be:

- `FALSE`, `NULL` or `NA`: suppress the band

- `TRUE`: draw the band with default settings

- a named list: customize the band appearance and confidence level

## See also

[`loess`](https://rdrr.io/r/stats/loess.html),
[`scatter.smooth`](https://rdrr.io/r/stats/scatter.smooth.html)

Other plot.utils:
[`axTicks`](https://andrisignorell.github.io/aurora/reference/axTicks.md)

## Examples

``` r
op <- par(no.readonly = TRUE)
par(mfrow = c(1, 2))

x <- runif(100)
y <- rnorm(100)

plot(x, y)
lines(splineX(y ~ x))

plot(dist ~ speed, cars)
lines(splineX(dist ~ speed, cars))


plot(dist ~ speed, cars)
lines(
  splineX(dist ~ speed, cars),
  bandArgs = list(
    conf.level = 0.99,
    col = addOpacity("red", 0.3),
    border = "black"
  )
)
#> Warning: Ignoring forbidden argument(s) for '.calcSplineCI': col, border

par(op)

```
