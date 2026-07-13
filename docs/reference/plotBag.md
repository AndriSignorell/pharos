# Create a Bagplot (Bivariate Boxplot)

Draws a bagplot (bivariate boxplot) based on halfspace (Tukey) depth.
The bag contains approximately the innermost 50\\ is an inflated version
of the bag, and points outside the loop are flagged as outliers.

## Usage

``` r
plotBag(
  x,
  main = "",
  xlab = "",
  ylab = "",
  xlim = NULL,
  ylim = NULL,
  factor = 3,
  eps = 0.00000001,
  dither = TRUE,
  points = TRUE,
  bag = TRUE,
  loop = TRUE,
  out = TRUE,
  median = TRUE,
  grid = FALSE,
  box = TRUE,
  stamp = NULL,
  ...
)
```

## Arguments

- x:

  A numeric matrix or data frame with exactly two columns.

- main, xlab, ylab:

  character strings for plot annotations.

- xlim, ylim:

  numeric vectors of length 2 specifying axis limits.

- factor:

  inflation factor for the loop (default: 3).

- eps:

  numeric tolerance used in depth computation and geometry.

- dither:

  logical; whether to add small noise to break ties.

- points, bag, loop, out, median, grid, box:

  Object-oriented control of plot elements (see Details).

- stamp:

  optional stamp passed to `.withGraphicsState()`.

- ...:

  additional graphical parameters passed to
  [`par()`](https://rdrr.io/r/graphics/par.html).

## Value

Invisibly returns a list with components:

- `center` – Tukey median

- `depth` – depth threshold defining the bag

- `bag` – bag polygon (matrix)

- `loop` – loop polygon (matrix)

- `outliers` – outlier points (matrix)

- `depths` – depth of all observations

## Details

All graphical elements are controlled via an object-oriented interface:
each element can be specified as `TRUE`, `FALSE`, or a `list(...)` of
graphical parameters. Internally, this is handled via
[`bedrock::callIf()`](https://rdrr.io/pkg/bedrock/man/callIf.html).

## Details

The halfspace (Tukey) depth is computed using a direct port of the
original Fortran routine `TUKDEPTH` (Rousseeuw & Ruts, 1996), ensuring a
numerically faithful implementation of the depth itself.

The resulting bagplot is based on standard practical approximations: the
bag is constructed as the convex hull of all observations with depth
greater than or equal to the 50\\ is obtained by affine inflation of the
bag around the Tukey median.

While this approach is consistent with common implementations, it does
not represent the exact continuous depth regions defined in the original
theory. In particular, the loop is not derived from an isodepth contour
but from a geometric scaling of the bag. Consequently, small deviations
from other implementations (e.g. `aplpack`) may occur, especially in the
shape of the loop and the classification of borderline outliers.

## Element Control

Each of the following arguments accepts:

- `TRUE` – draw element with defaults

- `FALSE` – suppress element

- `list(...)` – customize graphical parameters

Supported elements:

- `points` – raw data points

- `bag` – central 50\\

- `loop` – inflated bag (fence)

- `out` – outliers

- `median` – Tukey median

- `grid` – background grid

- `box` – plot frame

## References

P. J. Rousseeuw, I. Ruts, J. W. Tukey (1999): The bagplot: a bivariate
boxplot, *The American Statistician*, vol. 53, no. 4, 382–387

## See also

Other plot.bivariate:
[`plotAssoc()`](https://andrisignorell.github.io/aurora/reference/plotAssoc.md),
[`plotCor()`](https://andrisignorell.github.io/aurora/reference/plotCor.md),
[`plotDens2D()`](https://andrisignorell.github.io/aurora/reference/plotDens2D.md),
[`plotHeatmap()`](https://andrisignorell.github.io/aurora/reference/plotHeatmap.md),
[`plotHexbin()`](https://andrisignorell.github.io/aurora/reference/plotHexbin.md),
[`plotMosaic()`](https://andrisignorell.github.io/aurora/reference/plotMosaic.md),
[`plotXY()`](https://andrisignorell.github.io/aurora/reference/plotXY.md)

## Examples

``` r
set.seed(1)
x <- cbind(rnorm(200), rnorm(200))

plotBag(x)


# Custom styling
plotBag(x,
  bag = list(col = adjustcolor("green", 0.3), border = "darkgreen"),
  loop = list(border = "black", lty = 3),
  out = list(col = "red", pch = 17),
  grid = TRUE
)


# Minimal plot
plotBag(x, points = FALSE, median = FALSE)


# example of Rousseeuw et al.
cardata <- data.frame( 
Weight= c(2560,2345,1845,2260,2440,
          2285, 2275, 2350, 2295, 1900, 2390, 2075, 2330, 3320, 2885,
          3310, 2695, 2170, 2710, 2775, 2840, 2485, 2670, 2640, 2655,
          3065, 2750, 2920, 2780, 2745, 3110, 2920, 2645, 2575, 2935,
          2920, 2985, 3265, 2880, 2975, 3450, 3145, 3190, 3610, 2885,
          3480, 3200, 2765, 3220, 3480, 3325, 3855, 3850, 3195, 3735,
          3665, 3735, 3415, 3185, 3690),
Disp=c(97, 114, 81, 91, 113, 97, 97,
       98, 109, 73, 97, 89, 109, 305, 153, 302, 133, 97, 125, 146,
       107, 109, 121, 151, 133, 181, 141, 132, 133, 122, 181, 146,
       151, 116, 135, 122, 141, 163, 151, 153, 202, 180, 182, 232,
       143, 180, 180, 151, 189, 180, 231, 305, 302, 151, 202, 182,
       181, 143, 146, 146)
)
# Minimal plot
plotBag(x, points = FALSE, median = FALSE)
```
