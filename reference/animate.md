# Animate a Plot

Evaluates a plot call repeatedly while one or more running parameters
step through their values.

## Usage

``` r
animate(expr, ..., delay = 0.2, loops = 1)
```

## Arguments

- expr:

  the plot call (or a [`{}`](https://rdrr.io/r/base/Paren.html) block of
  several calls) containing the running parameter(s).

- ...:

  the running parameters as named vectors or lists, e.g. `i = 1:20`.
  Several parameters are stepped through in parallel and recycled to the
  longest one. Names must be unique, empty parameters are not allowed.

- delay:

  time per frame in seconds, a single finite, non-negative number.

- loops:

  number of runs, a non-negative whole number. `Inf` repeats until
  interrupted.

## Value

The number of frames per run, invisibly.

## Details

The plot call is captured unevaluated, so it can be handed over directly
or by means of the native pipe (`plot(...) |> animate(i = 1:10)`). Each
frame is drawn within
[`grDevices::dev.hold()`](https://rdrr.io/r/grDevices/dev.flush.html) /
[`grDevices::dev.flush()`](https://rdrr.io/r/grDevices/dev.flush.html)
to avoid flickering. The time needed for drawing is deducted from
`delay`, such that the frame rate stays constant as long as drawing is
faster than `delay`.

## Examples

``` r
# \donttest{
x <- cumsum(rnorm(100))
animate(plot(x[1:i], type = "l", xlim = c(1, 100), ylim = range(x)),
        i = 2:100, delay = 0.05)




































































































# two parameters running in parallel, using the pipe
curve(dnorm(x, mean = m), -6, 6, col = col, lwd = 2, ylim = c(0, 0.4)) |>
  animate(m = seq(-3, 3, 0.25), col = hcl.colors(25), delay = 0.1)

























# }
```
