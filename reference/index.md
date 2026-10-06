# Package index

## Univariate & Distribution Plots

Plots for distributions, grouped data, functions, and time series.

- [`plotArea()`](plotArea.md) : Stacked Area Plot
- [`plotBar()`](plotBar.md) : Themed Barplot with Grid, Labels and
  Optional Connecting Lines
- [`plotBox()`](plotBox.md) : Grouped Boxplot
- [`plotCatDist()`](plotCatDist.md) : Categorical Distribution Plot
- [`plotDens()`](plotDens.md) : Grouped Density Plot
- [`plotDensBox()`](plotDensBox.md) : Density and Boxplot Combination
  (Grouped)
- [`plotDot()`](plotDot.md) : Dot Plot for Estimates and Confidence
  Intervals
- [`plotECDF()`](plotECDF.md) : Empirical Cumulative Distribution
  Function
- [`plotFreqDist()`](plotFreqDist.md) : Frequency Distribution Plot
- [`plotLines()`](plotLines.md) : Line Plot for Multiple Series
- [`plotQQ()`](plotQQ.md) : QQ-Plot for Any Distribution
- [`plotRidge(`*`<default>`*`)`](plotRidge.md)
  [`plotRidge(`*`<formula>`*`)`](plotRidge.md) : Ridge Plot (Stacked
  Density Plot)
- [`plotViolin()`](plotViolin.md) : Violin Plot
- [`plotFun()`](plotFun.md) : Plot Mathematical Functions
- [`plotProbDist()`](plotProbDist.md) : Plot Probability Distribution
- [`shade()`](shade.md) : Produce a shaded Curve

## Bivariate & Specialized Plots

Plots for relationships, contingency tables, diagnostics, and
specialized displays.

- [`plotAssoc()`](plotAssoc.md) : Association Plot for Contingency
  Tables

- [`plotBag()`](plotBag.md) : Create a Bagplot (Bivariate Boxplot)

- [`plotBubble(`*`<default>`*`)`](plotBubble.md)
  [`plotBubble(`*`<formula>`*`)`](plotBubble.md) : Bubble Plot

- [`plotCor()`](plotCor.md) : Correlation Matrix Plot with Theming and
  Optional Labels

- [`plotDens2D()`](plotDens2D.md) : Two-Dimensional Kernel Density Plot

- [`plotHeatmap()`](plotHeatmap.md) : Heatmap for Categorical Data

- [`plotHexbin()`](plotHexbin.md) : Hexagonal Binning Plot

- [`plotMosaic()`](plotMosaic.md) : Mosaic Plot for 2-Way Contingency
  Tables

- [`plotXY()`](plotXY.md) : Scatterplot with Optional Smooth Lines

- [`plotBinaryTree()`](binaryTree.md) : Binary Tree

- [`plotCirc()`](plotCirc.md) : Circular Chord Diagram

- [`plotFacet()`](plotFacet.md) : Facet Panel Matrix in Base Graphics

- [`plotLift()`](plotLift.md) : Lift Chart

- [`plotMiss()`](plotMiss.md) : Plot Missing Data

- [`plotPolar()`](plotPolar.md) : Polar Plot for Radial Data

- [`plotPropCI()`](plotPropCI.md) : Plot Proportions with Confidence
  Intervals

- [`plotTernary()`](plotTernary.md) : Ternary Plot

- [`plotTimeSeries()`](plotTimeSeries.md) : Combined Plot of a Time
  Series and Its ACF and PACF

- [`plotTreemap()`](plotTreemap.md) : Treemap Plot

- [`plotWeb()`](plotWeb.md) : Plot a Web of Connected Points

- [`plot(`*`<BlandAltman>`*`)`](plot.BlandAltman.md) : Bland-Altman Plot

- [`plot(`*`<Desc.qn>`*`)`](plot.Desc.qn.md) :

  Plot Method for Numeric-Categorical `Desc` Objects

- [`plot(`*`<Desc.table>`*`)`](plot.Desc.table.md) :

  Plot Method for Categorical-Categorical `Desc` Objects

- [`plot(`*`<Lc>`*`)`](plot.lc.md) [`lines(`*`<Lc>`*`)`](plot.lc.md)
  [`points(`*`<Lc>`*`)`](plot.lc.md)
  [`lines(`*`<LcList>`*`)`](plot.lc.md)
  [`points(`*`<LcList>`*`)`](plot.lc.md)
  [`plot(`*`<LcList>`*`)`](plot.lc.md) : Plot Methods for Lorenz Curve
  Objects

## Annotation, Axes & Layout

Plot annotation, axes, smoothers, themes, and graphics-state helpers.

- [`abcCoords()`](abcCoords.md) : Coordinates for Named Plot Positions
- [`axisBreak()`](axisBreak.md) : Place a Break Mark on an Axis
- [`axisFmt()`](axisFmt.md) : Draw an Axis With Formatted or Rotated
  Labels
- [`axTicksPosixct()`](axTicks.md) [`axTicksDate()`](axTicks.md) :
  Compute Axis Tickmark Locations (For POSIXct Axis)
- [`barText()`](barText.md) : Place Value Labels on a Barplot
- [`boxedText()`](boxedText.md) : Add Text in a Box to a Plot
- [`colLegend()`](colLegend.md) : Add a Color Legend to a Plot
- [`errBars()`](errBars.md) : Add Error Bars to an Existing Plot
- [`polarGrid()`](polarGrid.md) : Draw a Polar Grid with Optional Labels
- [`stamp()`](stamp.md) : Date/Time/Directory Stamp the Current Plot
- [`textLegend()`](textLegend.md) : Direct Labels in the Right Margin
- [`titleRect()`](titleRect.md) : Plot Boxed Annotation
- [`lines(`*`<lm>`*`)`](linesLm.md) [`lines(`*`<lmlog>`*`)`](linesLm.md)
  : Add a Linear Regression Line
- [`lines(`*`<loess>`*`)`](lines.loess.md) : Add a Loess Smoother and
  Its Confidence Band
- [`splineX()`](splineCI.md) [`lines(`*`<SplineX>`*`)`](splineCI.md) :
  Add a Spline Smoother
- [`.useTheme`](graphics-framework.md)
  [`.drawGrid()`](graphics-framework.md)
  [`.drawBox()`](graphics-framework.md)
  [`.withGraphicsState()`](graphics-framework.md)
  [`.applyParFromDots()`](graphics-framework.md)
  [`.marTop()`](graphics-framework.md)
  [`.resolveTitle()`](graphics-framework.md)
  [`.marginLines()`](graphics-framework.md) : Graphics Framework Helpers
- [`isValidPlotRegion()`](isValidPlotRegion.md) : Check Whether the
  Current Plot Region Is Large Enough
- [`mar()`](mar.md) : Get or set plot margins conveniently
- [`preview()`](preview.md) : Preview an Object
- [`setBackCol()`](setBackCol.md) : Background of a Plot
- [`spreadOut()`](spreadOut.md) : Spread Out a Vector of Numbers To a
  Minimum Interval
- [`getTheme()`](theme.md) [`setTheme()`](theme.md)
  [`resetTheme()`](theme.md) : pharos's Graphics and Formatting Theme

## Geometry & Coordinates

Geometric structures, coordinate conversions, and transformations.

- [`arc()`](arc.md) : Arc Geometry
- [`band()`](band.md) : Band Geometry
- [`bezier()`](bezier.md) : Bézier Geometry
- [`canvas()`](canvas.md) : Canvas for Geometric Plotting
- [`circle()`](circle.md) : Circle Geometry
- [`ellipse()`](ellipse.md) : Ellipse Geometry
- [`polygonX()`](polygonX.md) : Draw Polygonal Geometries
- [`regPolygon()`](regPolygon.md) : Regular Polygon Geometry
- [`ring()`](ring.md) : Ring Geometry
- [`polToCart()`](coordinate-conversions.md)
  [`cartToPol()`](coordinate-conversions.md)
  [`cartToSph()`](coordinate-conversions.md)
  [`sphToCart()`](coordinate-conversions.md) : Coordinate
  Transformations Cartesian/Polar/Spherical
- [`degToRad()`](degree-radians-conversion.md)
  [`radToDeg()`](degree-radians-conversion.md) : Convert Degrees to
  Radians and Vice Versa
- [`lineToUser()`](lineToUser.md) : Convert Line Coordinates To User
  Coordinates
- [`rotate()`](rotate.md) : Rotate a Geometric Structure
- [`transformXY()`](transformXY.md) : Apply Geometric Transformations to
  Coordinates

## Colours & Palettes

Colour conversion, manipulation, lookup, and palette construction.

- [`color-conversion-overview`](color-conversion-overview.md) : Color
  Conversion Functions in pharos
- [`cmykToCmy()`](CMYKToCMY.md) : Convert CMYK to CMY
- [`cmykToRgb()`](CMYKToRGB.md) : Convert CMYK to RGB
- [`cmyToCmyk()`](CMYToCMYK.md) : Convert CMY to CMYK
- [`colToHex()`](colToHex.md) : Convert R Colors to Hexadecimal Colors
- [`colToHsv()`](colToHSV.md) : Convert R Colors to HSV
- [`colToRgb()`](colToRGB.md) : Convert R Colors to RGB
- [`grayScale()`](grayscale.md) : Convert Colors to grayScale
- [`hexToCol()`](hexToCol.md) : Convert Hex Colors to Named R Colors
- [`hexToRgb()`](hexToRGB.md) : Convert Hex Colors to RGB
- [`longToRgb()`](longToRGB.md) : Convert Long Integers to RGB
- [`rgbToCmy()`](RGBToCMY.md) : Convert RGB to CMY
- [`rgbToCol()`](RGBToCol.md) : Convert RGB Colors to the Nearest Named
  R Color
- [`rgbToHex()`](RGBToHex.md) : Convert RGB to Hexadecimal Colors
- [`rgbToLong()`](RGBToLong.md) : Convert RGB to Long Integers
- [`addOpacity()`](addOpacity.md) : Add an Alpha Channel to Colors
- [`colToOpaque()`](colToOpaque.md) : Equivalent Opaque Color for
  Transparent Color
- [`contrastCol()`](contrastCol.md) : Choose Optimal Text Color Based on
  WCAG Contrast
- [`darken()`](darken.md) : Darken Colors
- [`fade()`](fade.md) : Fade Colors
- [`findCol()`](findCol.md) : Get Color on a Defined Color Range
- [`lighten()`](lighten.md) : Lighten Colors
- [`mixCol()`](mixCol.md) : Mix Colors
- [`hcol()`](hcol.md) : Helsana Colors
- [`pal()`](pal.md) [`plot(`*`<Palette>`*`)`](pal.md) : Get a Color
  Palette
- [`palNames()`](palNames.md) : List Available Palette Names

## Formatting, Units & Tables

Formatting of values and confidence intervals, units, and table helpers.

- [`fm()`](fm.md) : Format Numbers and Dates
- [`fmCI()`](fmCI.md) : Format Confidence Intervals
- [`styles()`](style.md) [`style()`](style.md)
  [`print(`*`<Style>`*`)`](style.md) : Format Styles
- [`as.CI()`](as.CI.md) [`isCI()`](as.CI.md) : Confidence Interval
  Objects
- [`convUnit()`](convUnit.md) : Symbolic Unit Conversion Engine
- [`print(`*`<Unit>`*`)`](print.Unit.md) : Print Object with Unit
- [`unit()`](unit.md) [`` `unit<-`() ``](unit.md) : Get or Set Unit
  Attribute
- [`Formulas`](Formulas.md) : Formula Interface – Common Arguments
- [`ftable(`*`<list>`*`)`](ftable.list.md) : Flat Contingency Table for
  tapply-Like Lists
- [`Prefix`](constants.md) : DescToolsX Constants

## Strings

String inspection, extraction, transformation, and formatting.

- [`string-overview`](string-overview.md) : String Functions in pharos
- [`strCountWords()`](strCountWords.md) : Count Words in Strings
- [`strDist()`](strDist.md) : Compute Distances Between Strings
- [`strIsNumeric()`](strIsNumeric.md) : Check if Character Strings
  Represent Numeric Values
- [`strLen()`](strLen.md) : String length
- [`strPos()`](strPos.md) : Find Position of First Occurrence Of a
  String
- [`strChop()`](strChop.md) : Split a String into a Number of Sections
  of Defined Length
- [`strExtract()`](strExtract.md) : Extract First Match from Strings
- [`strExtractBetween()`](strExtractBetween.md) : Extract Substrings
  Between Patterns
- [`strLeft()`](strLeftRight.md) [`strRight()`](strLeftRight.md) :
  Returns the Left Or the Right Part Of a String
- [`strSplit()`](strSplit.md) : Split Strings
- [`strVal()`](strVal.md) : Extract Numeric Values from Strings
- [`lineSep()`](lineSep.md) : Create a Line Separator String
- [`strAbbr()`](strAbbr.md) : Abbreviate Strings Uniquely
- [`strAlign()`](strAlign.md) : Align Strings
- [`strCap()`](strCap.md) : Capitalize Strings
- [`strPad()`](strPad.md) : Pad a String With Justification
- [`strRev()`](strRev.md) : Reverse Strings
- [`strSpell()`](strSpell.md) : Spell Strings Using Phonetic Alphabets
- [`strTrim()`](strTrim.md) : Remove Leading/Trailing Whitespace From A
  String
- [`strTrunc()`](strTrunc.md) : Truncate Strings and Add Ellipses If a
  String is Truncated.

## HTML & Embedding

HTML markup, embedded files and images, and self-contained HTML tables.

- [`asHtml()`](asHtml.md) : Mark a character vector as HTML
- [`preview(`*`<html>`*`)`](preview.html.md) : Print HTML markup as
  readable text
- [`asFileLink()`](asFileLink.md) : Link to a self-contained embedded
  file
- [`asImg()`](asImg.md) : Embed a plot as an inline HTML image
- [`embedFile()`](embedFile.md) : Base64-encode a file
- [`escapeHtml()`](escapeHtml.md) : Escape HTML special characters
- [`htmlHat()`](htmlNotation.md) [`htmlBar()`](htmlNotation.md) : HTML
  notation for hat and bar diacritics
- [`` `%_%` ``](htmlSubscript.md) : Subscript notation
- [`toHtmlTable()`](toHtmlTable.md) : Render a matrix as an HTML table
