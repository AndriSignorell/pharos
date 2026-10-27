# 📦 pharos <img src="man/figures/logo.png" align="right" height="139" alt="pharos logo" />

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/pharos)](https://CRAN.R-project.org/package=pharos)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
[![R-CMD-check](https://github.com/AndriSignorell/pharos/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/AndriSignorell/pharos/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

**Title:** Descriptive Statistics Graphics and Utilities\
**License:** GPL (≥ 2)

## 🧩 Overview

`pharos` is the graphics layer of the **DescToolsX ecosystem**. It draws
statistical graphics on top of base graphics — distribution and density
displays, bivariate and categorical plots, diagnostic and model
evaluation panels — and supplies the colour, geometry, formatting and
HTML tools they are built from.

A theme system resolves colours, symbols and layout centrally, so the
look of a whole analysis can be set once instead of being repeated at
every call.

The package is self-contained and usable without the rest of the suite.

📖 **Documentation:** <https://andrisignorell.github.io/pharos/>

## ⚙️ Installation

``` r
install.packages("pharos")
```

Or the development version from GitHub:

``` r
remotes::install_github("AndriSignorell/pharos")
```

## 📚 Core Features

### 🔹 Univariate and Distribution Plots

-   `plotFreqDist()`, `plotDens()`, `plotECDF()`, `plotProbDist()`
-   `plotBox()`, `plotViolin()`, `plotRidge()`, `plotDensBox()`
-   `plotDot()`, `plotBar()`, `plotBag()`, `plotQQ()`
-   `plotLines()`, `plotTimeSeries()`, `plotFun()`

### 🔹 Bivariate and Multivariate Plots

-   `plotXY()`, `plotBubble()`, `plotDens2D()`, `plotHexbin()`
-   `plotCor()`, `plotAssoc()`, `plotMosaic()`, `plotHeatmap()`
-   `plotTernary()`, `plotPolar()`, `plotCirc()`, `plotSankey()`,
    `plotWeb()`, `plotTreemap()`

### 🔹 Model and Diagnostic Displays

-   `plotLift()`, `plotPropCI()`, `plotMiss()`, `plotCatDist()`
-   `plot()` methods for Bland-Altman and Lorenz curve objects,
    `plotBinaryTree()`
-   `lines()` methods for `lm` and `loess` fits

### 🔹 Layout and Faceting

-   `plotFacet()` — panel layouts with a user-supplied panel function
-   `canvas()`, `plotArea()`, `mar()`, `abcCoords()`, `axisBreak()`,
    `axTicksPosixct()`, `axisFmt()`
-   `spreadOut()`, `lineToUser()`, `isValidPlotRegion()`

### 🔹 Annotation

-   `boxedText()`, `barText()`, `textLegend()`, `colLegend()`,
    `errBars()`, `band()`, `stamp()`, `titleRect()`, `lineSep()`

### 🔹 Colour

-   Conversions: `colToHex()`, `colToRgb()`, `colToHsv()`,
    `hexToRgb()`, `rgbToCmy()`, `cmykToRgb()`, `longToRgb()`
-   Manipulation: `addOpacity()`, `fade()`, `darken()`, `lighten()`,
    `shade()`, `mixCol()`, `contrastCol()`, `grayScale()`
-   Palettes: `pal()`, `palNames()`, `hcol()`, `findCol()`,
    `setBackCol()`

### 🔹 Geometry

-   `arc()`, `bezier()`, `circle()`, `ellipse()`, `ring()`,
    `polygonX()`, `regPolygon()`, `polarGrid()`
-   `rotate()`, `transformXY()`, coordinate conversions, degree/radian
    conversion, `convUnit()`

### 🔹 Formatting and Strings

-   `fm()`, `fmCI()`, `unit()`, `ftable()` method for lists
-   `strAbbr()`, `strAlign()`, `strCap()`, `strChop()`, `strPad()`,
    `strTrunc()`, `strRev()`, `strDist()`, `strSpell()`, `strExtract()`

### 🔹 HTML Output

-   `asHtml()`, `toHtmlTable()`, `escapeHtml()`, `htmlHat()`,
    `htmlBar()`, `%_%`, `asImg()`, `asFileLink()`, `embedFile()`,
    `preview()`

## 🚀 Design Principles

-   **Consistent** — lowerCamelCase API and uniform argument
    conventions across the whole DescToolsX suite
-   **Themed** — colours, symbols and layout resolved centrally through
    `getTheme()`, `setTheme()` / `resetTheme()` and `style()`
-   **Base graphics** — no grid, no extra graphics stack; plots compose
    with everything already in R
-   **Fast** — performance-critical routines implemented in Rcpp

## 🧪 Example

``` r
library(pharos)

# distribution overview: histogram, density, boxplot, ecdf in one panel
plotFreqDist(rnorm(500))

# named plot positions without arithmetic
plot(rnorm(20), type = "n")
xy <- abcCoords("topleft", inset = 1)
text(xy$xy$x, xy$xy$y, "annotation", adj = xy$adj)

# colour manipulation
fade(pal("dark"), 0.4)

# faceting: one panel per sample, drawn by a panel function
samples <- lapply(split(iris, iris$Species),
                  function(d) list(x = d$Sepal.Length, y = d$Petal.Length))

plotFacet(samples, dim = c(1, 3),
          FUN  = function(x, y, col, pch, ...) points(x, y, col = col, pch = pch),
          xlab = "Sepal length", ylab = "Petal length")

# flows between stages: one row per flow
plotSankey(data.frame(from  = c("A", "A", "B", "C", "D"),
                      to    = c("C", "D", "D", "E", "F"),
                      value = c(5, 3, 4, 5, 7)))
```

## 🧱 The Suite

`pharos` builds on `bedrock` (base utilities). `DescToolsX` (descriptive
statistics), `lumen` (tests and intervals), `alloy` (modelling), `pons`
(MS-Office) and `swissValet` (RStudio addins) complete the family.

## 🙏 Acknowledgements

Parts of the code and documentation were reviewed with the help of large
language models (OpenAI Codex, Anthropic Claude). Every suggestion was
assessed, edited and verified by the maintainer, who remains solely
responsible for the content of this package.

## 📜 License

GPL (≥ 2)
