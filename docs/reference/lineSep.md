# Create a Line Separator String

Generates a character string that can be used as a horizontal line
separator in console output.

## Usage

``` r
lineSep(sep = .getOption("linesep"))
```

## Arguments

- sep:

  A character string used as separator. If `NULL`, a default Unicode
  box-drawing character (`"\u2500"`) is used. If `sep` consists of a
  single visible character, it is repeated to match the current console
  width (minus two characters).

## Value

A character string representing a horizontal separator line.

## Details

ANSI escape sequences (e.g., color codes) are removed using
[`cli::ansi_strip()`](https://cli.r-lib.org/reference/ansi_strip.html)
when determining the visible width.

The console width is determined via `getOption("width", 80)`.

## See also

Other graphics.utils:
[`abcCoords()`](https://andrisignorell.github.io/lyra/reference/abcCoords.md),
[`axisBreak()`](https://andrisignorell.github.io/lyra/reference/axisBreak.md),
[`barText()`](https://andrisignorell.github.io/lyra/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/lyra/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/lyra/reference/colLegend.md),
[`degToRad()`](https://andrisignorell.github.io/lyra/reference/degToRad.md),
[`errBars()`](https://andrisignorell.github.io/lyra/reference/errBars.md),
[`lineToUser()`](https://andrisignorell.github.io/lyra/reference/lineToUser.md),
[`lines.lm()`](https://andrisignorell.github.io/lyra/reference/linesLm.md),
[`mar()`](https://andrisignorell.github.io/lyra/reference/mar.md),
[`preview()`](https://andrisignorell.github.io/lyra/reference/preview.md),
[`spreadOut()`](https://andrisignorell.github.io/lyra/reference/spreadOut.md),
[`stamp()`](https://andrisignorell.github.io/lyra/reference/stamp.md),
[`textLegend()`](https://andrisignorell.github.io/lyra/reference/textLegend.md),
[`titleRect()`](https://andrisignorell.github.io/lyra/reference/titleRect.md),
[`unit()`](https://andrisignorell.github.io/lyra/reference/unit.md)

## Examples

``` r
lineSep()
#> [1] "\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m\033[33m─\033[39m"
lineSep("-")
#> [1] "------------------------------------------------------------------------------"
lineSep(cli::col_red("="))
#> [1] "\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m\033[31m=\033[39m"
```
