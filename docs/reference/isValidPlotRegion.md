# Check Whether the Current Plot Region Is Large Enough

Tests whether the plot region of the active graphics device meets a
minimal size requirement. This is useful before drawing into small
devices or heavily subdivided layouts (`mfrow`,
[`layout()`](https://rdrr.io/r/graphics/layout.html), Shiny render
panes), where an undersized region would otherwise fail with the rather
cryptic error `"figure margins too large"`.

## Usage

``` r
isValidPlotRegion(minPin = .getOption("plot.minPin", c(0.5, 0.5)))
```

## Arguments

- minPin:

  numeric vector of length 2, giving the minimal required width and
  height of the plot region in inches. Defaults to the option
  `DescToolsX.plot.minPin` and falls back to `c(0.5, 0.5)` if the option
  is not set.

## Value

a single logical: `TRUE` if the plot region is at least `minPin` inches
in both dimensions (or if no device is open), `FALSE` otherwise.

## Details

The plot region is the area inside the figure margins, as reported by
`par("pin")`. Its size results from the device dimensions minus the
current margins (`mar`, `oma`), so both a small device and oversized
margins can render it degenerate.

If no graphics device is open (`dev.cur() == 1`), the function returns
`TRUE`, since the next high-level plot call will open a fresh device
with default dimensions. Note that querying
[`par()`](https://rdrr.io/r/graphics/par.html) in this state would
itself open a device as a side effect, which this function deliberately
avoids.

The function has no side effects and never throws; it is meant as a
guard for conditional plotting, e.g.
`if (isValidPlotRegion()) plot(x) else message("device too small")`.

## See also

[`par`](https://rdrr.io/r/graphics/par.html) (entries `pin`, `fin`,
`mar`), [`dev.cur`](https://rdrr.io/r/grDevices/dev.html)

Other graphics.layout:
[`abcCoords()`](https://andrisignorell.github.io/aurora/reference/abcCoords.md),
[`axTicks`](https://andrisignorell.github.io/aurora/reference/axTicks.md),
[`axisBreak()`](https://andrisignorell.github.io/aurora/reference/axisBreak.md),
[`lineToUser()`](https://andrisignorell.github.io/aurora/reference/lineToUser.md),
[`mar()`](https://andrisignorell.github.io/aurora/reference/mar.md),
[`plotFacet()`](https://andrisignorell.github.io/aurora/reference/plotFacet.md),
[`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md)

## Examples

``` r
# guard a plot against a degenerate region
if (isValidPlotRegion()) {
  plot(rnorm(20))
} else {
  message("plot region too small")
}


# require a larger region, e.g. for a wide correlation plot
isValidPlotRegion(minPin = c(4, 3))
#> [1] TRUE

```
