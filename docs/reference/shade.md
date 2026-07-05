# Produce a shaded Curve

Sometimes the area under a density curve has to be color shaded, for
instance to illustrate a p-value or a specific region under the normal
curve. This function draws a curve corresponding to a function over the
interval `[from, to]`. It can plot also an expression in the variable
`xname`, default `x`.

## Usage

``` r
shade(expr, col = par("fg"), breaks, density = 10, n = 101, xname = "x", ...)
```

## Arguments

- expr:

  the name of a function, or a
  [`call`](https://rdrr.io/r/base/call.html) or an
  [`expression`](https://rdrr.io/r/base/expression.html) written as a
  function of `x` which will evaluate to an object of the same length as
  `x`.

- col:

  color to fill or shade the shape with. The default is taken from
  `par("fg")`.

- breaks:

  numeric, a vector giving the breakpoints between the distinct areas to
  be shaded differently. Should be finite as there are no plots with
  infinite limits.

- density:

  the density of the lines as needed in polygon.

- n:

  integer; the number of x values at which to evaluate. Default is 101.

- xname:

  character string giving the name to be used for the x axis.

- ...:

  the dots are passed on to
  [`polygon`](https://andrisignorell.github.io/aurora/reference/polygon.md).

## Value

A list with components `x` and `y` of the points that were drawn is
returned invisibly.

## Details

Useful for shading the area under a curve as often needed for explaining
significance tests.

## See also

[`polygon`](https://andrisignorell.github.io/aurora/reference/polygon.md),
[`curve`](https://rdrr.io/r/graphics/curve.html)

Other geometry:
[`arc()`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`band()`](https://andrisignorell.github.io/aurora/reference/band.md),
[`bezier()`](https://andrisignorell.github.io/aurora/reference/bezier.md),
[`canvas()`](https://andrisignorell.github.io/aurora/reference/canvas.md),
[`polarGrid()`](https://andrisignorell.github.io/aurora/reference/polarGrid.md),
[`polygon()`](https://andrisignorell.github.io/aurora/reference/polygon.md),
[`rotate()`](https://andrisignorell.github.io/aurora/reference/rotate.md),
[`transformXY()`](https://andrisignorell.github.io/aurora/reference/transformXY.md)

## Examples

``` r

curve(dt(x, df=5), xlim=c(-6,6),
      main=paste("Student t-Distribution Probability Density Function, df = ", 5, ")", sep=""),
      type="n", las=1, ylab="probability", xlab="t")

shade(dt(x, df=5), breaks=c(-6, qt(0.025, df=5), qt(0.975, df=5), 6),
      col=c("deeppink4", "skyblue3"), density=c(20, 7))

```
