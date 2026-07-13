# Date/Time/Directory Stamp the Current Plot

Stamp the current plot in the extreme lower right corner. A free text or
expression can be defined as text to the stamp.

## Usage

``` r
stamp(text = .useTheme, las = NULL, cex = 0.6, col = "grey40")
```

## Arguments

- text:

  character string, expression, or toggle controlling the stamp text.
  `.useTheme` (default) or `TRUE` resolve to `getTheme()$stamp`,
  evaluated lazily at draw time. `FALSE`, `NULL`, or `NA` suppress the
  stamp. Any other string or unevaluated
  [`expression()`](https://rdrr.io/r/base/expression.html) is used as
  given.

- las:

  orientation; see [`par`](https://rdrr.io/r/graphics/par.html). `NULL`
  (default) inherits the current `par("las")`. `las = 3` places the
  stamp vertically along the right edge instead of horizontally along
  the bottom.

- cex, col:

  size and color of the stamp text.

## Details

The text can be freely defined as option. If user and date should be
included by default, the following option using an expression will help:

    setDescToolsXOption(stamp=expression(gettextf('
    Sys.getenv('USERNAME'), Today() )))

For R results may not be satisfactory if `par(mfrow=)` is in effect.

## See also

[`text`](https://rdrr.io/r/graphics/text.html)

Other graphics.annotation:
[`barText()`](https://andrisignorell.github.io/aurora/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/aurora/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/aurora/reference/colLegend.md),
[`errBars()`](https://andrisignorell.github.io/aurora/reference/errBars.md),
[`textLegend()`](https://andrisignorell.github.io/aurora/reference/textLegend.md),
[`titleRect()`](https://andrisignorell.github.io/aurora/reference/titleRect.md)

## Examples

``` r

plot(1:20)
stamp()

```
