# lyra

**Descriptive Statistics Graphics and Utilities**

Version 0.0.0.927 · License GPL (≥ 2)

## Overview

`lyra` is the graphics package of the **DescToolsX ecosystem**. It
provides a comprehensive collection of statistical plots, geometric
drawing primitives, color tools, annotation helpers, and formatting
utilities — all built directly on **base R graphics**.

Building on base graphics keeps the package lightweight and fully
compatible with everything base R offers
([`layout()`](https://rdrr.io/r/graphics/layout.html),
[`par()`](https://rdrr.io/r/graphics/par.html), custom devices), while a
central **theme system** and consistent argument conventions remove the
usual boilerplate: sensible defaults, automatic margin handling, and
uniform styling across all plot functions.

`lyra` is part of the DescToolsX package suite:

| Package   | Role                                       |
|-----------|--------------------------------------------|
| `bedrock` | core infrastructure and utilities          |
| `lyra`    | graphics and visualization (this package)  |
| `lumen`   | statistical tests and confidence intervals |
| `alloy`   | model fitting and evaluation               |
| `hermes`  | reporting and output                       |

## Installation

``` r

# development version from GitHub
remotes::install_github("AndriSignorell/lyra")
```

## Key Features

### Statistical plots

A large family of high-level `plot*()` functions with a consistent
interface (formula support, grouped variants, theme-driven styling):

- **Distributions:**
  [`plotDens()`](https://andrisignorell.github.io/aurora/reference/plotDens.md),
  [`plotDens2D()`](https://andrisignorell.github.io/aurora/reference/plotDens2D.md),
  [`plotDensBox()`](https://andrisignorell.github.io/aurora/reference/plotDensBox.md),
  [`plotViolin()`](https://andrisignorell.github.io/aurora/reference/plotViolin.md),
  [`plotRidge()`](https://andrisignorell.github.io/aurora/reference/plotRidge.md),
  [`plotBox()`](https://andrisignorell.github.io/aurora/reference/plotBox.md),
  [`plotECDF()`](https://andrisignorell.github.io/aurora/reference/plotECDF.md),
  [`plotFdist()`](https://andrisignorell.github.io/aurora/reference/plotFdist.md),
  [`plotQQ()`](https://andrisignorell.github.io/aurora/reference/plotQQ.md),
  [`plotProbDist()`](https://andrisignorell.github.io/aurora/reference/plotProbDist.md)
- **Categorical data:**
  [`plotBar()`](https://andrisignorell.github.io/aurora/reference/plotBar.md),
  [`plotDot()`](https://andrisignorell.github.io/aurora/reference/plotDot.md),
  [`plotMosaic()`](https://andrisignorell.github.io/aurora/reference/plotMosaic.md),
  [`plotCatDist()`](https://andrisignorell.github.io/aurora/reference/plotCatDist.md),
  [`plotTreemap()`](https://andrisignorell.github.io/aurora/reference/plotTreemap.md),
  [`plotWeb()`](https://andrisignorell.github.io/aurora/reference/plotWeb.md)
- **Relationships:**
  [`plotXY()`](https://andrisignorell.github.io/aurora/reference/plotXY.md),
  [`plotLines()`](https://andrisignorell.github.io/aurora/reference/plotLines.md),
  [`plotCor()`](https://andrisignorell.github.io/aurora/reference/plotCor.md),
  [`plotAssoc()`](https://andrisignorell.github.io/aurora/reference/plotAssoc.md),
  [`plotBubble()`](https://andrisignorell.github.io/aurora/reference/plotBubble.md),
  [`plotHexbin()`](https://andrisignorell.github.io/aurora/reference/plotHexbin.md),
  [`plotBag()`](https://andrisignorell.github.io/aurora/reference/plotBag.md)
- **Special purpose:**
  [`plotTimeSeries()`](https://andrisignorell.github.io/aurora/reference/plotTimeSeries.md),
  [`plotArea()`](https://andrisignorell.github.io/aurora/reference/plotArea.md),
  [`plotMiss()`](https://andrisignorell.github.io/aurora/reference/plotMiss.md),
  [`plotPropCI()`](https://andrisignorell.github.io/aurora/reference/plotPropCI.md),
  [`plotCirc()`](https://andrisignorell.github.io/aurora/reference/plotCirc.md),
  [`plotPolar()`](https://andrisignorell.github.io/aurora/reference/plotPolar.md),
  [`plotTernary()`](https://andrisignorell.github.io/aurora/reference/plotTernary.md),
  [`plotBinaryTree()`](https://andrisignorell.github.io/aurora/reference/binaryTree.md),
  [`plotFun()`](https://andrisignorell.github.io/aurora/reference/plotFun.md)

Plot methods for objects from the suite are included, e.g. `plot.Desc.*`
(for `desc()` results), `plot.Lc` (Lorenz curves), `plot.BlandAltman`,
and [`lines()`](https://rdrr.io/r/graphics/lines.html) methods for `lm`
and `loess` fits.

### Theme system

All plot functions draw their defaults from a central, replaceable
theme:

``` r

getTheme()                              # inspect the active theme
setTheme(list(palette = "Set2"))        # change one component globally
setTheme(list(grid = list(col = "grey90", lwd = 1, lty = "dotted")))
resetTheme()                            # back to the default
```

Explicit arguments always override the theme at the call site; the theme
in turn overrides the package defaults. One place to define the look —
every plot follows.

### Geometric drawing

Geometry follows a clean two-step design: **constructors** create
geometry objects —
[`circle()`](https://andrisignorell.github.io/aurora/reference/circle.md),
[`ellipse()`](https://andrisignorell.github.io/aurora/reference/ellipse.md),
[`arc()`](https://andrisignorell.github.io/aurora/reference/arc.md),
[`bezier()`](https://andrisignorell.github.io/aurora/reference/bezier.md),
[`band()`](https://andrisignorell.github.io/aurora/reference/band.md),
[`ring()`](https://andrisignorell.github.io/aurora/reference/ring.md),
[`regPolygon()`](https://andrisignorell.github.io/aurora/reference/regPolygon.md)
— and an overloaded
[`polygon()`](https://andrisignorell.github.io/aurora/reference/polygon.md)
generic (fully compatible with
[`graphics::polygon()`](https://rdrr.io/r/graphics/polygon.html)) draws
them.
[`canvas()`](https://andrisignorell.github.io/aurora/reference/canvas.md)
provides a blank, aspect-true plotting canvas,
[`polarGrid()`](https://andrisignorell.github.io/aurora/reference/polarGrid.md)
a polar coordinate system.

``` r

canvas()
polygon(circle(radius = 1), col = "lightblue")
polygon(regPolygon(radius = 0.7, numVertices = 5), border = "red")
```

Because geometries are plain objects, they can be transformed before
drawing
([`rotate()`](https://andrisignorell.github.io/aurora/reference/rotate.md),
[`transformXY()`](https://andrisignorell.github.io/aurora/reference/transformXY.md))
or combined into composite shapes.

### Colors

- **Manipulation:**
  [`addAlpha()`](https://andrisignorell.github.io/aurora/reference/addAlpha.md),
  [`fade()`](https://andrisignorell.github.io/aurora/reference/fade.md),
  [`darken()`](https://andrisignorell.github.io/aurora/reference/darken.md),
  [`lighten()`](https://andrisignorell.github.io/aurora/reference/lighten.md),
  [`mixColors()`](https://andrisignorell.github.io/aurora/reference/mixColors.md),
  [`grayscale()`](https://andrisignorell.github.io/aurora/reference/grayscale.md),
  [`colToOpaque()`](https://andrisignorell.github.io/aurora/reference/colToOpaque.md)
- **Analysis:**
  [`contrastColor()`](https://andrisignorell.github.io/aurora/reference/contrastColor.md)
  (legible text colors on any background),
  [`findColor()`](https://andrisignorell.github.io/aurora/reference/findColor.md)
  (nearest named color)
- **Conversion:** hex, RGB, HSV, CMY(K), and long integer
  representations
  ([`colToHex()`](https://andrisignorell.github.io/aurora/reference/colToHex.md),
  [`hexToRGB()`](https://andrisignorell.github.io/aurora/reference/hexToRGB.md),
  [`cmykToRgb()`](https://andrisignorell.github.io/aurora/reference/cmykToRgb.md),
  [`rgbToLong()`](https://andrisignorell.github.io/aurora/reference/rgbToLong.md),
  …)
- **Palettes:**
  [`pal()`](https://andrisignorell.github.io/aurora/reference/pal.md)
  and
  [`palNames()`](https://andrisignorell.github.io/aurora/reference/palNames.md)
  for the suite’s curated palettes

### Annotation and layout helpers

Utilities that handle the fiddly parts of base graphics:

- [`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md)
  — automatic plot stamping (author/date), theme-controlled
- [`boxedText()`](https://andrisignorell.github.io/aurora/reference/boxedText.md),
  [`barText()`](https://andrisignorell.github.io/aurora/reference/barText.md),
  [`textLegend()`](https://andrisignorell.github.io/aurora/reference/textLegend.md),
  [`colLegend()`](https://andrisignorell.github.io/aurora/reference/colLegend.md)
  — labels and legends beyond
  [`text()`](https://rdrr.io/r/graphics/text.html)/[`legend()`](https://rdrr.io/r/graphics/legend.html)
- [`errBars()`](https://andrisignorell.github.io/aurora/reference/errBars.md),
  [`shade()`](https://andrisignorell.github.io/aurora/reference/shade.md),
  [`splineCI()`](https://andrisignorell.github.io/aurora/reference/splineCI.md),
  [`band()`](https://andrisignorell.github.io/aurora/reference/band.md)
  — uncertainty display
- [`axisBreak()`](https://andrisignorell.github.io/aurora/reference/axisBreak.md),
  [`axTicks()`](https://andrisignorell.github.io/aurora/reference/axTicks.md),
  [`titleRect()`](https://andrisignorell.github.io/aurora/reference/titleRect.md),
  [`lineSep()`](https://andrisignorell.github.io/aurora/reference/lineSep.md)
  — axis and title furniture
- [`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md)
  — de-overlapping label positions
- [`isValidPlotRegion()`](https://andrisignorell.github.io/aurora/reference/isValidPlotRegion.md)
  — check the device geometry before drawing

### Formatting and output

- [`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md) /
  [`fmCI()`](https://andrisignorell.github.io/aurora/reference/fmCI.md)
  — flexible number and confidence interval formatting
- [`notation()`](https://andrisignorell.github.io/aurora/reference/notation.md),
  [`style()`](https://andrisignorell.github.io/aurora/reference/style.md)
  — notation and style control
- [`as.html()`](https://andrisignorell.github.io/aurora/reference/as.html.md),
  [`toHtmlTable()`](https://andrisignorell.github.io/aurora/reference/toHtmlTable.md),
  [`preview()`](https://andrisignorell.github.io/aurora/reference/preview.md)
  — HTML rendering of tables and plots, e.g. for quick reports

### Coordinates, units, and strings

- Coordinate transformations:
  [`transformXY()`](https://andrisignorell.github.io/aurora/reference/transformXY.md),
  [`rotate()`](https://andrisignorell.github.io/aurora/reference/rotate.md),
  [`degToRad()`](https://andrisignorell.github.io/aurora/reference/degToRad.md),
  [`lineToUser()`](https://andrisignorell.github.io/aurora/reference/lineToUser.md),
  [`abcCoords()`](https://andrisignorell.github.io/aurora/reference/abcCoords.md)
- Unit conversion engine:
  [`convUnit()`](https://andrisignorell.github.io/aurora/reference/convUnit.md)
  with SI and derived units
- A complete `str*()` family for string handling
  ([`strTrim()`](https://andrisignorell.github.io/aurora/reference/strTrim.md),
  [`strPad()`](https://andrisignorell.github.io/aurora/reference/strPad.md),
  [`strAlign()`](https://andrisignorell.github.io/aurora/reference/strAlign.md),
  [`strExtract()`](https://andrisignorell.github.io/aurora/reference/strExtract.md),
  [`strDist()`](https://andrisignorell.github.io/aurora/reference/strDist.md),
  [`strAbbr()`](https://andrisignorell.github.io/aurora/reference/strAbbr.md),
  …)

## Example

``` r

library(lyra)

# grouped violin plot, styled by the active theme
plotViolin(mpg ~ cyl, data = mtcars)

# correlation matrix plot
plotCor(cor(mtcars))

# custom geometric graphic
canvas(main = "lyra primitives")
polygon(circle(radius = 1), col = addAlpha("steelblue", 0.4))
polygon(regPolygon(radius = 0.7, numVertices = 6), border = "red")
```

## Design principles

- **Base graphics, no grid** — lightweight, transparent, hackable
- **Consistent API** — lowerCamelCase, uniform argument names and
  ordering across the whole suite
- **Theme-driven** — one place to define the look, every plot follows
- **Robust by default** — automatic margin adjustment, device geometry
  checks, protected graphics state
- **Performance-aware** — Rcpp under the hood where it matters

## Documentation

- Website: <https://andrisignorell.github.io/lyra/>
- Bug reports: <https://github.com/AndriSignorell/lyra/issues>

## License

GPL (≥ 2)
