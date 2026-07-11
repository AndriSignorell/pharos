# Add a Loess Smoother and Its Confidence Band

Add a loess smoother to an existing plot. The function first calculates
predictions from a `loess` object and then adds the fitted smoother
together with an optional confidence band.

## Usage

``` r
# S3 method for class 'loess'
lines(
  x,
  col = .useTheme,
  lwd = 2,
  lty = "solid",
  type = "l",
  n = 100,
  bandArgs = list(conf.level = 0.95),
  ...
)
```

## Arguments

- x:

  a fitted [`loess`](https://rdrr.io/r/stats/loess.html) object.

- col:

  line color of the smoother. `.useTheme` (default) resolves to
  `getTheme()$twin[1]` - the first of the theme's two-color pair (see
  [`getTheme`](https://andrisignorell.github.io/lyra/reference/getTheme.md)).

- lwd:

  line width.

- lty:

  line type.

- type:

  plotting type passed to
  [`lines`](https://rdrr.io/r/graphics/lines.html).

- n:

  number of points used for plotting the fit.

- bandArgs:

  controls the confidence band. May be `TRUE`, `FALSE`, `NULL`, `NA`, or
  a named list. The confidence level is specified via `conf.level`.
  Default is `list(conf.level = 0.95)`.

- ...:

  currently ignored.

## Details

The confidence band is controlled via `bandArgs`. This argument may be:

- `FALSE`, `NULL` or `NA`: suppress the band

- `TRUE`: draw the band with default settings

- a named list: customize the band appearance and confidence level

## Note

Loess can result in substantial computational load for large datasets.

## See also

[`loess`](https://rdrr.io/r/stats/loess.html),
[`scatter.smooth`](https://rdrr.io/r/stats/scatter.smooth.html),
[`smooth.spline`](https://rdrr.io/r/stats/smooth.spline.html),
[`getTheme`](https://andrisignorell.github.io/lyra/reference/getTheme.md)

## Examples

``` r
x <- runif(100)
y <- rnorm(100)

plot(x, y)
lines(loess(y ~ x))


plot(dist ~ speed, cars)
lines(
  loess(dist ~ speed, cars),
  bandArgs = list(
    conf.level = 0.99,
    col = addAlpha("red", 0.4),
    border = "black"
  )
)

```
