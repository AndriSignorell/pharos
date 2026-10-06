# Themed Barplot with Grid, Labels and Optional Connecting Lines

Creates a themed wrapper around
[`graphics::barplot()`](https://rdrr.io/r/graphics/barplot.html) with
support for consistent styling, optional grid lines, value labels, and
connecting lines for stacked barplots.

## Usage

``` r
plotBar(
  height,
  main = NULL,
  xlab = NULL,
  ylab = NULL,
  yax = NULL,
  beside = FALSE,
  horiz = FALSE,
  col = .useTheme,
  border = .useTheme,
  grid = .useTheme,
  box = FALSE,
  text = NULL,
  connLines = NULL,
  stamp = .useTheme,
  ...
)
```

## Arguments

- height:

  A vector or matrix of bar heights passed directly to
  [`graphics::barplot()`](https://rdrr.io/r/graphics/barplot.html).

- main, xlab, ylab:

  optional plot labels. Defaults follow base graphics behaviour.

- yax:

  controls drawing of the numeric axis.

  Supported values are

  `TRUE`

  :   draw axis using package defaults

  `FALSE`

  :   suppress axis

  `NULL`

  :   do not draw a numeric axis at all

  `list(...)`

  :   custom axis parameters passed to the axis drawing routine

- beside:

  logical. If `TRUE`, bars are drawn side-by-side. If `FALSE` (default),
  bars are stacked.

- horiz:

  logical. If `TRUE`, bars are drawn horizontally. Defaults to `FALSE`.

- col:

  bar fill colours. `.useTheme` (default) resolves to
  `getTheme()$bar$col`.

- border:

  bar border colour. `.useTheme` (default) resolves to
  `getTheme()$bar$border`.

- grid:

  controls drawing of grid lines. Can be:

  - `.useTheme` (default): follow the active theme (`getTheme()$grid`),
    restricted to the axis perpendicular to the value axis (e.g.
    horizontal lines only for vertical bars)

  - `TRUE`: draw grid with theme settings

  - `FALSE`, `NULL`, or `NA`: suppress grid

  - a named list: arguments passed to
    [`graphics::grid()`](https://rdrr.io/r/graphics/grid.html),
    overriding the theme/function defaults for this call only

- box:

  controls drawing of the plot box. `.useTheme` (default) resolves to
  `getTheme()$box`. `TRUE`/`FALSE`/`NA`, or a named list, as for `grid`.

- text:

  optional list of arguments passed to [`barText()`](barText.md) to draw
  value labels on bars.

- connLines:

  optional list of arguments controlling connecting lines between
  stacked bars. Only supported when `beside = FALSE`.

- stamp:

  controls the corner stamp. `.useTheme` (default) resolves to
  `getTheme()$stamp`. `TRUE`/`FALSE`/`NULL`, or an explicit string, as
  for [`.withGraphicsState()`](graphics-framework.md) (internal).

- ...:

  additional arguments passed to
  [`graphics::barplot()`](https://rdrr.io/r/graphics/barplot.html) and
  graphical parameters (via
  [`graphics::par()`](https://rdrr.io/r/graphics/par.html)).

## Value

Invisibly returns the midpoints of the bars as returned by
[`graphics::barplot()`](https://rdrr.io/r/graphics/barplot.html).

## Details

The function first initializes the plotting region invisibly using
[`graphics::barplot()`](https://rdrr.io/r/graphics/barplot.html),
optionally adds grid lines, and then draws the actual bars and
additional layers (axis, connecting lines, text labels).

The function internally performs the following steps:

1.  Draws an invisible `barplot` to establish the coordinate system.

2.  Optionally adds grid lines.

3.  Draws the bars.

4.  Draws the numeric axis if enabled.

5.  Optionally adds connecting lines for stacked bars.

6.  Optionally adds value labels via [`barText()`](barText.md).

7.  Optionally draws a box around the plot region.

Graphical parameters such as `bg`, `cex`, `las`, `mar`, etc. can be
supplied via `...`.

The precedence of theme-aware settings (`col`, `border`, `grid`, `box`,
`stamp`) is


    explicit argument  >  function-specific default  >  active theme (getTheme())

## See also

[graphics::barplot](https://rdrr.io/r/graphics/barplot.html),
[barText](barText.md), [theme](theme.md)

Other plot.univariate: [`plotArea()`](plotArea.md),
[`plotBox()`](plotBox.md), [`plotCatDist()`](plotCatDist.md),
[`plotDens()`](plotDens.md), [`plotDensBox()`](plotDensBox.md),
[`plotDot()`](plotDot.md), [`plotECDF()`](plotECDF.md),
[`plotFreqDist()`](plotFreqDist.md), [`plotLines()`](plotLines.md),
[`plotQQ()`](plotQQ.md), [`plotViolin()`](plotViolin.md)

## Examples

``` r
# Simple barplot
plotBar(1:5)


# With grid lines
plotBar(1:5, grid = TRUE)


# Stacked bars with labels and connecting lines
m <- matrix(c(3,2,4,1,5,2), nrow = 2)
plotBar(m,
        text = list(pos = "mid"),
        connLines = list(col = "black"))


# Grouped bars
plotBar(VADeaths,
        beside = TRUE,
        col = gray.colors(nrow(VADeaths)))


# Horizontal bars
plotBar(VADeaths,
        horiz = TRUE,
        las = 1)

        
        
plotBar(VADeaths, ylim=c(0,250),
        grid=list(col = "grey", lty="dotted"), 
        las=1, main="MyTitle", 
        text = list(labels=VADeaths, 
        border = NA, srt=45, bg="navajowhite"))


plotBar(VADeaths, ylim=c(0,80),
        las=1, main="MyTitle",
        box=FALSE, 
        col=gray.colors(nrow(VADeaths)),
        beside=TRUE, 
        text = list(col="red", bg=addOpacity("white", 0.7), border=NA))


plotBar(VADeaths, connLines = list(lwd=1, col="blue"), 
        box=FALSE, las=1, main="Connecting Lines")


ptab <- proportions(VADeaths, margin=2)
plotBar(ptab,
        las=1, main="VADeaths in %",
        box=FALSE, horiz=TRUE, 
        col=(cols <- gray.colors(nrow(VADeaths))),
        beside=FALSE, mar=c(right=5),
        text = list(labels=fm(ptab, fmt="%"), border=NA, 
                    col=contrastCol(cols)))
legend(x="right", fill=cols, legend=rownames(VADeaths))


plotBar(VADeaths/1e3,  box=FALSE, bg="lightyellow", main="VADeaths",
        horiz=TRUE, 
        text=list(border=FALSE, cex=0.8, col=c("blue", "green","orange")), 
        mar=c(right=5), 
        yax = list(fmt="%", d=0, big=",", 
                   col="red", col.axis="blue", lwd=2))

```
