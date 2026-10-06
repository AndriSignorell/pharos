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
  band = list(conf.level = 0.95),
  ...
)
```

## Arguments

- x:

  spline object returned by `splineX()`.

- ...:

  for `splineX()`, further arguments passed to
  [`stats::smooth.spline()`](https://rdrr.io/r/stats/smooth.spline.html);
  for [`lines()`](https://rdrr.io/r/graphics/lines.html), further
  graphical parameters passed to
  [`lines()`](https://rdrr.io/r/graphics/lines.html).

- formula:

  A formula of the form `lhs ~ rhs`, where `lhs` gives the response
  values and `rhs` the corresponding groups or explanatory variables.

- data:

  an optional matrix or data frame (or similar; see
  [`stats::model.frame()`](https://rdrr.io/r/stats/model.frame.html))
  containing the variables in the formula. By default the variables are
  taken from `environment(formula)`.

- subset:

  an optional vector specifying a subset of observations to be used in
  the analysis.

- na.action:

  A function which indicates what should happen when the data contain
  `NA`s. Defaults to `getOption("na.action")`.

- weights:

  optional vector of weights, a column of `data` or a vector of the
  length of the original data. It is subject to `subset` and `na.action`
  like the variables of the formula.

- col:

  line color of the smoother.

- lwd:

  line width.

- lty:

  line type.

- type:

  plotting type passed to
  [`lines()`](https://rdrr.io/r/graphics/lines.html).

- band:

  controls the confidence band. May be `TRUE`, `FALSE`, `NULL`, `NA`, or
  a named list. The confidence level is specified via `conf.level`, all
  other elements are graphical parameters of the band. Default is
  `list(conf.level = 0.95)`.

## Details

Confidence bands are controlled via `band`. These arguments can be:

- `FALSE`, `NULL` or `NA`: suppress the band

- `TRUE`: draw the band with default settings

- a named list: customize the band appearance and confidence level

## See also

[`loess()`](https://rdrr.io/r/stats/loess.html),
[`scatter.smooth()`](https://rdrr.io/r/stats/scatter.smooth.html)

Other graphics.trendlines: [`lines.lm()`](linesLm.md),
[`lines.loess()`](lines.loess.md)

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


# subset and weights, both evaluated in data
plot(dist ~ speed, cars)
lines(splineX(dist ~ speed, cars, subset = speed > 10,
              weights = sqrt(speed)))

plot(dist ~ speed, cars)
lines(
  splineX(dist ~ speed, cars),
  band = list(
    conf.level = 0.99,
    col = addOpacity("red", 0.3),
    border = "black"
  )
)


par(op)
```
