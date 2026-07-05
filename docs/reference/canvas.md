# Canvas for Geometric Plotting

This is just a wrapper for creating an empty plot with suitable defaults
for plotting geometric shapes.

## Usage

``` r
canvas(xlim = NULL, ylim = xlim, main = NULL, asp = 1, usrbg = "white", ...)
```

## Arguments

- xlim, ylim:

  the xlims and ylims for the plot. Default is c(-1, 1).

- main:

  the main title on top of the plot.

- asp:

  numeric, giving the aspect ratio y/x. (See
  [`plot.window`](https://rdrr.io/r/graphics/plot.window.html) for
  details. Default is 1.

- usrbg:

  the color of the user space of the plot, defaults to "white".

- ...:

  additional arguments are passed to the
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) command.

## Value

a list of all the previous values of the parameters changed (returned
invisibly)

## Details

The plot is created with these settings:  
`asp = 1, xaxt = "n", yaxt = "n", xlab = "", ylab = "", frame.plot = FALSE`.

## See also

Other geometry:
[`arc()`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`band()`](https://andrisignorell.github.io/aurora/reference/band.md),
[`bezier()`](https://andrisignorell.github.io/aurora/reference/bezier.md),
[`polarGrid()`](https://andrisignorell.github.io/aurora/reference/polarGrid.md),
[`polygon()`](https://andrisignorell.github.io/aurora/reference/polygon.md),
[`rotate()`](https://andrisignorell.github.io/aurora/reference/rotate.md),
[`shade()`](https://andrisignorell.github.io/aurora/reference/shade.md),
[`transformXY()`](https://andrisignorell.github.io/aurora/reference/transformXY.md)

## Examples

``` r

canvas(7)
text(0, 0, "Hello world!", cex=5)

```
