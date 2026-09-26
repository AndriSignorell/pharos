# Create a Bagplot (Bivariate Boxplot)

Draws a bagplot (bivariate boxplot) based on halfspace (Tukey) depth.
The bag contains the innermost 50\\ hull of all non-outlying points, and
points outside the fence (the bag inflated by `factor`, not drawn) are
flagged as outliers.

## Usage

``` r
plotBag(x, ...)

# S3 method for class 'formula'
plotBag(
  formula,
  data,
  subset,
  na.action = na.omit,
  main = NULL,
  xlab = NULL,
  ylab = NULL,
  ...
)

# Default S3 method
plotBag(
  x,
  main = NULL,
  xlab = NULL,
  ylab = NULL,
  xlim = NULL,
  ylim = NULL,
  factor = 3,
  eps = 0.00000001,
  dither = FALSE,
  points = TRUE,
  bag = TRUE,
  loop = TRUE,
  fence = FALSE,
  out = TRUE,
  median = TRUE,
  grid = FALSE,
  box = TRUE,
  stamp = .useTheme,
  ...
)
```

## Arguments

- x:

  a numeric matrix or data frame with exactly two columns, or a formula
  of the form `y ~ x` (see the formula method). Incomplete rows are
  removed.

- ...:

  additional graphical parameters passed to
  [`par()`](https://rdrr.io/r/graphics/par.html).

- formula:

  a formula of the form `y ~ x`, where both variables are numeric. `x`
  is drawn on the horizontal, `y` on the vertical axis.

- data:

  an optional data frame containing the variables in `formula`.

- subset:

  an optional expression indicating which observations to use, evaluated
  in `data` (`subset = Weight > 2500`), as in
  [`plot.formula()`](https://rdrr.io/r/graphics/plot.formula.html).

- na.action:

  a function specifying how missing values are handled. Defaults to
  [`stats::na.omit()`](https://rdrr.io/r/stats/na.fail.html), as the
  depth computation requires complete pairs.

- main:

  main title. `NULL` (default) derives the title from the input: the
  formula, or the name of `x`. `""`, `NA`, or `FALSE` suppress the title
  and compact the top margin.

- xlab, ylab:

  axis labels. `NULL` (default) uses the variable names of the formula,
  resp. the column names of `x` (empty if it has none).

- xlim, ylim:

  numeric vectors of length 2 specifying axis limits. `NULL` (default)
  uses the range of the data, extended to the fence if it is drawn.

- factor:

  inflation factor for the fence (default: 3).

- eps:

  numeric tolerance used in depth computation and geometry, relative to
  the standardized coordinates.

- dither:

  logical, whether to add small noise (order `eps`) to the data. Default
  `FALSE`: ties are handled exactly, and dithering would only break
  duplicates apart and so lower their depth.

- points, bag, loop, fence, out, median, grid, box:

  object-oriented control of plot elements (see Details).

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, a string, or a named list
  for [`stamp()`](stamp.md).

## Value

Invisibly returns a list of class `"bagplot"` with components:

- `center` - Tukey median.

- `depth` - depth of the innermost region bounding the bag.

- `bag` - bag polygon (matrix).

- `fence` - fence polygon (matrix, not drawn by default).

- `loop` - loop polygon (matrix).

- `outliers` - outlier points (matrix).

- `depths` - halfspace depth of all observations.

## Details

All graphical elements are controlled via an object-oriented interface:
each element can be specified as `TRUE`, `FALSE`, or a `list(...)` of
graphical parameters. Internally, this is handled via
[`bedrock::callIf()`](https://andrisignorell.github.io/bedrock/reference/callIf.html).

The construction follows Rousseeuw, Ruts and Tukey (1999):

1.  The halfspace (Tukey) depth of every observation is computed using a
    direct port of the original Fortran routine `TUKDEPTH` (Rousseeuw &
    Ruts, 1996).

2.  The Tukey median is approximated by the mean of all observations
    with maximal depth.

3.  The *bag* is obtained by radial interpolation between the convex
    hulls of two adjacent depth regions, calibrated such that it
    contains \\\lfloor n/2 \rfloor\\ observations (up to ties on the
    polygon boundary).

4.  The *fence* is the bag inflated by `factor` relative to the Tukey
    median. Following the original proposal it is used for
    classification only and not drawn by default.

5.  Observations outside the fence are flagged as *outliers*.

6.  The *loop* is the convex hull of all non-outlying observations, so
    it always lies within the data range.

Two approximations remain relative to the strict theory: the Tukey
median is not computed via `HALFMED`, and the bag interpolates hulls of
sample depth regions rather than exact isodepth contours. Borderline
outlier classifications may therefore differ slightly from other
implementations (e.g. aplpack).

The depth computation handles exact ties and collinear configurations
(e.g. discrete data) exactly; no dithering is needed. All computations
run on standardized coordinates, so the result does not depend on the
units of measurement.

## Element Control

Each of the following arguments accepts:

- `TRUE` - draw element with defaults

- `FALSE` - suppress element

- `list(...)` - customize graphical parameters

Supported elements (in drawing order):

- `grid` - background grid

- `fence` - classification boundary (default `FALSE`)

- `loop` - convex hull of the non-outlying points

- `bag` - central 50\\

- `points` - raw data points

- `out` - outliers

- `median` - Tukey median

- `box` - plot frame

## References

P. J. Rousseeuw, I. Ruts, J. W. Tukey (1999): The bagplot: a bivariate
boxplot, *The American Statistician*, vol. 53, no. 4, 382–387.

P. J. Rousseeuw, I. Ruts (1996): Algorithm AS 307: Bivariate location
depth, *Applied Statistics*, vol. 45, no. 4, 516–526.

## See also

Other plot.bivariate: [`plotAssoc()`](plotAssoc.md),
[`plotCor()`](plotCor.md), [`plotDens2D()`](plotDens2D.md),
[`plotHeatmap()`](plotHeatmap.md), [`plotHexbin()`](plotHexbin.md),
[`plotMosaic()`](plotMosaic.md), [`plotXY()`](plotXY.md)

## Examples

``` r
set.seed(1)
x <- cbind(rnorm(200), rnorm(200))

# data of Rousseeuw et al. (1999): car weight vs engine displacement
cardata <- data.frame(
  Weight = c(2560, 2345, 1845, 2260, 2440,
           2285, 2275, 2350, 2295, 1900, 2390, 2075, 2330, 3320, 2885,
           3310, 2695, 2170, 2710, 2775, 2840, 2485, 2670, 2640, 2655,
           3065, 2750, 2920, 2780, 2745, 3110, 2920, 2645, 2575, 2935,
           2920, 2985, 3265, 2880, 2975, 3450, 3145, 3190, 3610, 2885,
           3480, 3200, 2765, 3220, 3480, 3325, 3855, 3850, 3195, 3735,
           3665, 3735, 3415, 3185, 3690),
  Disp = c(97, 114, 81, 91, 113, 97, 97,
         98, 109, 73, 97, 89, 109, 305, 153, 302, 133, 97, 125, 146,
         107, 109, 121, 151, 133, 181, 141, 132, 133, 122, 181, 146,
         151, 116, 135, 122, 141, 163, 151, 153, 202, 180, 182, 232,
         143, 180, 180, 151, 189, 180, 231, 305, 302, 151, 202, 182,
         181, 143, 146, 146)
)

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


# formula interface
plotBag(Disp ~ Weight, data = cardata)


# subset, evaluated in data
plotBag(Disp ~ Weight, data = cardata, subset = Weight > 2500)


# example of Rousseeuw et al. (1999): car weight vs engine displacement;
# the axis labels default to the column names
plotBag(cardata)

```
