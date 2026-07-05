# Preview an Object

Generic function for an explicit, on-demand preview of an object, as
distinct from [`print()`](https://rdrr.io/r/base/print.html).
`preview()` exists for object types where
[`print()`](https://rdrr.io/r/base/print.html) is shared with another
package's S3 generic dispatch (e.g. class `"html"`, used both by aurora
and htmltools for genuinely different purposes), so that registering an
own `print.*` method would silently overwrite - or be overwritten by -
the other package's behaviour.

## Usage

``` r
preview(x, ...)

# Default S3 method
preview(x, ...)
```

## Arguments

- x:

  object to preview.

- ...:

  further arguments passed to methods.

## Details

The default method simply calls
[`print()`](https://rdrr.io/r/base/print.html), so `preview()` is always
safe to call even for types with no dedicated method.

## See also

[`as.html`](https://andrisignorell.github.io/aurora/reference/as.html.md)

Other graphics.utils:
[`abcCoords()`](https://andrisignorell.github.io/aurora/reference/abcCoords.md),
[`axisBreak()`](https://andrisignorell.github.io/aurora/reference/axisBreak.md),
[`barText()`](https://andrisignorell.github.io/aurora/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/aurora/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/aurora/reference/colLegend.md),
[`degToRad()`](https://andrisignorell.github.io/aurora/reference/degToRad.md),
[`errBars()`](https://andrisignorell.github.io/aurora/reference/errBars.md),
[`lineSep()`](https://andrisignorell.github.io/aurora/reference/lineSep.md),
[`lineToUser()`](https://andrisignorell.github.io/aurora/reference/lineToUser.md),
[`lines.lm()`](https://andrisignorell.github.io/aurora/reference/linesLm.md),
[`mar()`](https://andrisignorell.github.io/aurora/reference/mar.md),
[`spreadOut()`](https://andrisignorell.github.io/aurora/reference/spreadOut.md),
[`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md),
[`textLegend()`](https://andrisignorell.github.io/aurora/reference/textLegend.md),
[`titleRect()`](https://andrisignorell.github.io/aurora/reference/titleRect.md),
[`unit()`](https://andrisignorell.github.io/aurora/reference/unit.md)
