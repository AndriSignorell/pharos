# Ridge Plot (Stacked Density Plot)

Draws stacked kernel density estimates (ridge plot) for grouped data.
Each group is displayed as a density curve shifted along the y-axis.

## Usage

``` r
# Default S3 method
plotRidge(
  x,
  ...,
  add = FALSE,
  bw = "nrd0",
  scale = 1,
  spacing = 1,
  col = NULL,
  border = NULL,
  lwd = 1,
  lty = 1,
  fill = TRUE,
  grid = NA,
  main = "",
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL
)

# S3 method for class 'formula'
plotRidge(
  formula,
  data = NULL,
  subset,
  na.action = na.omit,
  ...,
  add = FALSE,
  bw = "nrd0",
  scale = 1,
  spacing = 1,
  col = NULL,
  border = NULL,
  lwd = 1,
  lty = 1,
  fill = TRUE,
  grid = NA,
  main = "",
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL
)
```

## Arguments

- x:

  A numeric vector, or a list of numeric vectors representing groups.

- ...:

  Additional graphical parameters passed to
  [`par()`](https://rdrr.io/r/graphics/par.html).

- add:

  Logical; if `TRUE`, adds to an existing plot.

- bw:

  Bandwidth for [`density`](https://rdrr.io/r/stats/density.html).

- scale:

  Scaling factor for density height.

- spacing:

  Vertical spacing between ridges.

- col:

  Fill color(s).

- border:

  Border color(s).

- lwd:

  Line width(s).

- lty:

  Line type(s).

- fill:

  Logical; fill area under densities.

- grid:

  Logical, `NA`, or list controlling grid.

- main, xlab, ylab:

  Plot labels.

- xlim, ylim:

  Axis limits.

- formula:

  A formula of the form `y ~ group`.

- data:

  Optional data frame.

- subset:

  Optional subset expression.

- na.action:

  Function to handle missing values.

## Value

Invisibly returns `NULL`.

## Details

Ridge plots are useful for comparing distributions across multiple
groups. Each density is normalized and vertically offset, improving
readability compared to overlaid density plots.

## See also

[`plotDens`](https://andrisignorell.github.io/lyra/reference/plotDens.md)

Other topic.graphics:
[`plotBubble()`](https://andrisignorell.github.io/lyra/reference/plotBubble.md),
[`plotDens()`](https://andrisignorell.github.io/lyra/reference/plotDens.md),
[`plotDens2D()`](https://andrisignorell.github.io/lyra/reference/plotDens2D.md)

## Examples

``` r
set.seed(1)
df <- data.frame(
  value = c(rnorm(100), rnorm(100, 2), rnorm(100, 4)),
  group = rep(c("A", "B", "C"), each = 100)
)

plotRidge(value ~ group, data = df)

```
