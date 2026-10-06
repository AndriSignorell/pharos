# 📦 pharos

**Title:** Descriptive Statistics Graphics and Utilities  
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

- [`plotFreqDist()`](reference/plotFreqDist.md),
  [`plotDens()`](reference/plotDens.md),
  [`plotECDF()`](reference/plotECDF.md),
  [`plotProbDist()`](reference/plotProbDist.md)
- [`plotBox()`](reference/plotBox.md),
  [`plotViolin()`](reference/plotViolin.md),
  [`plotRidge()`](reference/plotRidge.md),
  [`plotDensBox()`](reference/plotDensBox.md)
- [`plotDot()`](reference/plotDot.md),
  [`plotBar()`](reference/plotBar.md),
  [`plotBag()`](reference/plotBag.md), [`plotQQ()`](reference/plotQQ.md)

### 🔹 Bivariate and Multivariate Plots

- [`plotXY()`](reference/plotXY.md),
  [`plotBubble()`](reference/plotBubble.md),
  [`plotDens2D()`](reference/plotDens2D.md),
  [`plotHexbin()`](reference/plotHexbin.md)
- [`plotCor()`](reference/plotCor.md),
  [`plotAssoc()`](reference/plotAssoc.md),
  [`plotMosaic()`](reference/plotMosaic.md),
  [`plotHeatmap()`](reference/plotHeatmap.md)
- [`plotTernary()`](reference/plotTernary.md),
  [`plotPolar()`](reference/plotPolar.md),
  [`plotCirc()`](reference/plotCirc.md),
  [`plotWeb()`](reference/plotWeb.md),
  [`plotTreemap()`](reference/plotTreemap.md)

### 🔹 Model and Diagnostic Displays

- [`plotLift()`](reference/plotLift.md),
  [`plotPropCI()`](reference/plotPropCI.md),
  [`plotMiss()`](reference/plotMiss.md),
  [`plotCatDist()`](reference/plotCatDist.md)
- [`plot.BlandAltman()`](reference/plot.BlandAltman.md),
  [`plot.Lc()`](reference/plot.lc.md),
  [`plotBinaryTree()`](reference/binaryTree.md)
- [`lines.lm()`](reference/linesLm.md),
  [`lines.loess()`](reference/lines.loess.md),
  [`splineCI()`](reference/splineCI.md)

### 🔹 Layout and Faceting

- [`plotFacet()`](reference/plotFacet.md) — panel layouts with a
  user-supplied panel function
- [`canvas()`](reference/canvas.md),
  [`plotArea()`](reference/plotArea.md), [`mar()`](reference/mar.md),
  [`abcCoords()`](reference/abcCoords.md),
  [`axisBreak()`](reference/axisBreak.md),
  [`axTicks()`](reference/axTicks.md),
  [`axisFmt()`](reference/axisFmt.md)
- [`spreadOut()`](reference/spreadOut.md),
  [`lineToUser()`](reference/lineToUser.md),
  [`isValidPlotRegion()`](reference/isValidPlotRegion.md)

### 🔹 Annotation

- [`boxedText()`](reference/boxedText.md),
  [`barText()`](reference/barText.md),
  [`textLegend()`](reference/textLegend.md),
  [`colLegend()`](reference/colLegend.md),
  [`errBars()`](reference/errBars.md), [`band()`](reference/band.md),
  [`stamp()`](reference/stamp.md),
  [`titleRect()`](reference/titleRect.md),
  [`lineSep()`](reference/lineSep.md)

### 🔹 Colour

- Conversions: [`colToHex()`](reference/colToHex.md),
  [`colToRgb()`](reference/colToRGB.md),
  [`colToHsv()`](reference/colToHSV.md),
  [`hexToRgb()`](reference/hexToRGB.md),
  [`rgbToCmy()`](reference/RGBToCMY.md),
  [`cmykToRgb()`](reference/CMYKToRGB.md),
  [`longToRgb()`](reference/longToRGB.md)
- Manipulation: [`addOpacity()`](reference/addOpacity.md),
  [`fade()`](reference/fade.md), [`darken()`](reference/darken.md),
  [`lighten()`](reference/lighten.md), [`shade()`](reference/shade.md),
  [`mixCol()`](reference/mixCol.md),
  [`contrastCol()`](reference/contrastCol.md),
  [`grayScale()`](reference/grayscale.md)
- Palettes: [`pal()`](reference/pal.md),
  [`palNames()`](reference/palNames.md), [`hcol()`](reference/hcol.md),
  [`findCol()`](reference/findCol.md),
  [`setBackCol()`](reference/setBackCol.md)

### 🔹 Geometry

- [`arc()`](reference/arc.md), [`bezier()`](reference/bezier.md),
  [`circle()`](reference/circle.md),
  [`ellipse()`](reference/ellipse.md), [`ring()`](reference/ring.md),
  [`polygonX()`](reference/polygonX.md),
  [`regPolygon()`](reference/regPolygon.md),
  [`polarGrid()`](reference/polarGrid.md)
- [`rotate()`](reference/rotate.md),
  [`transformXY()`](reference/transformXY.md), coordinate conversions,
  degree/radian conversion, [`convUnit()`](reference/convUnit.md)

### 🔹 Formatting and Strings

- [`fm()`](reference/fm.md), [`fmCI()`](reference/fmCI.md),
  [`unit()`](reference/unit.md),
  [`ftable.list()`](reference/ftable.list.md)
- [`strAbbr()`](reference/strAbbr.md),
  [`strAlign()`](reference/strAlign.md),
  [`strCap()`](reference/strCap.md),
  [`strChop()`](reference/strChop.md),
  [`strPad()`](reference/strPad.md),
  [`strTrunc()`](reference/strTrunc.md),
  [`strRev()`](reference/strRev.md),
  [`strDist()`](reference/strDist.md),
  [`strSpell()`](reference/strSpell.md),
  [`strExtract()`](reference/strExtract.md)

### 🔹 HTML Output

- [`asHtml()`](reference/asHtml.md),
  [`toHtmlTable()`](reference/toHtmlTable.md),
  [`escapeHtml()`](reference/escapeHtml.md),
  [`htmlNotation()`](reference/htmlNotation.md),
  [`htmlSubscript()`](reference/htmlSubscript.md),
  [`asImg()`](reference/asImg.md),
  [`asFileLink()`](reference/asFileLink.md),
  [`embedFile()`](reference/embedFile.md),
  [`preview()`](reference/preview.md)

## 🚀 Design Principles

- **Consistent** — lowerCamelCase API and uniform argument conventions
  across the whole DescToolsX suite
- **Themed** — colours, symbols and layout resolved centrally through
  [`theme()`](reference/theme.md) and [`style()`](reference/style.md)
- **Base graphics** — no grid, no extra graphics stack; plots compose
  with everything already in R
- **Fast** — performance-critical routines implemented in Rcpp

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

# faceting with a panel function
plotFacet(split(iris$Sepal.Length, iris$Species),
          dim = c(1, 3), FUN = plotDens)
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
