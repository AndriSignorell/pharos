
# 🌌 aurora

**Version:** 0.0.0.910\
**Title:** Descriptive Statistics Graphics and Utilities\
**License:** GPL (≥ 2)

## 🧩 Overview

`aurora` is the visualization and graphics package of the **DescToolsX
ecosystem**.\
It provides a large collection of plotting utilities, geometric drawing
functions, color manipulation tools, coordinate transformations, and
statistical graphics. fileciteturn3file0

The package focuses on:

-   elegant base-R graphics
-   geometric plotting
-   statistical visualization
-   color science and palettes
-   annotation utilities
-   publication-ready helper functions

Unlike many modern plotting frameworks, `aurora` builds directly on top
of **base graphics**, making it lightweight, flexible, and highly
customizable.

------------------------------------------------------------------------

## ⚙️ Installation

``` r
remotes::install_github("AndriSignorell/aurora")
```

------------------------------------------------------------------------

## 🎨 Core Features

### 🔹 Statistical Graphics

-   `plotDens()` -- density plots
-   `plotHeatmap()` -- heatmaps
-   `plotMosaic()` -- mosaic plots
-   `plotQQ()` -- QQ plots
-   `plotViolin()` -- violin plots
-   `plotCor()` -- correlation plots
-   `plotBubble()` -- bubble charts
-   `plotTreemap()` -- treemap visualization
-   `plotTimeSeries()` -- time-series plotting
-   `plotAssoc()` -- association visualization

------------------------------------------------------------------------

### 🔹 Geometric Drawing

-   `drawCircle()`
-   `drawEllipse()`
-   `drawArc()`
-   `drawBezier()`
-   `drawRegPolygon()`
-   `drawBand()`

Together with:

-   `canvas()`
-   `polarGrid()`

these functions enable low-level geometric graphics and custom diagram
creation.

------------------------------------------------------------------------

### 🔹 Colors & Transparency

-   `addAlpha()` -- alpha transparency
-   `colToOpaque()`
-   `contrastColor()` -- WCAG-aware contrast colors
-   `findColor()`
-   `pal()` / `palNames()`

Includes RGB, HSV, CMYK, and grayscale conversion utilities.

------------------------------------------------------------------------

### 🔹 Plot Annotation Utilities

-   `boxedText()`
-   `barText()`
-   `colLegend()`
-   `errBars()`
-   `shade()`
-   `stamp()`
-   `titleRect()`
-   `axisBreak()`

These helpers simplify complex plot annotations and labeling.

------------------------------------------------------------------------

### 🔹 Coordinate & Unit Systems

-   Cartesian ↔ polar ↔ spherical transforms
-   Degree/radian conversion
-   Unit conversion engine (`convUnit()`)

Supports symbolic SI units and derived unit systems.

------------------------------------------------------------------------

### 🔹 String Utilities

Includes numerous text-processing helpers:

-   `strTrim()`
-   `strSplit()`
-   `strPad()`
-   `strExtract()`
-   `strAlign()`
-   `strCountW()`

------------------------------------------------------------------------

## 🚀 Design Principles

-   Built on base graphics
-   Lightweight and dependency-conscious
-   Publication-oriented plotting
-   Reusable geometric primitives
-   High customizability
-   Strong color utility support

------------------------------------------------------------------------

## 🧪 Examples

``` r
library(aurora)

# transparency
addAlpha("steelblue", 0.4)

# geometric canvas
canvas()
drawCircle(outerR = 1, col = addAlpha("red", 0.4))

# violin plot
plotViolin(mpg ~ cyl, data = mtcars)

# heatmap
plotHeatmap(cor(mtcars))
```

------------------------------------------------------------------------

## 📦 Dependencies

Core imports include:

-   `Rcpp`
-   `graphics`
-   `bedrock`
-   `MASS`
-   `cli`
-   `stringi`
-   `withr`

------------------------------------------------------------------------

## 📖 Documentation

-   🌐 Website:\
    https://andrisignorell.github.io/aurora/

-   🐛 Issues:\
    https://github.com/AndriSignorell/aurora/issues

------------------------------------------------------------------------

## 🧠 Typical Use Cases

-   Publication-ready statistical graphics
-   Custom geometry and diagrams
-   Educational visualizations
-   Color analysis and manipulation
-   Advanced base-R graphics workflows
-   Lightweight alternatives to ggplot2

------------------------------------------------------------------------

## 📜 License

GPL (≥ 2)
