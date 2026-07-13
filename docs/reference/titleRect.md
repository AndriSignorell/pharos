# Plot Boxed Annotation

The function can be used to add a title to a plot surrounded by a
rectangular box. This is useful for plotting several plots in narrow
distances.

## Usage

``` r
titleRect(
  label,
  bg = "grey",
  border = 1,
  col = "black",
  xjust = 0.5,
  line = 2,
  ...
)
```

## Arguments

- label:

  the main title

- bg:

  the background color of the box.

- border:

  the border color of the box

- col:

  the font color of the title

- xjust:

  the x-justification of the text. This can be `c(0, 0.5, 1)` for left,
  middle- and right alignement.

- line:

  on which MARgin line, starting at 0 counting outwards

- ...:

  the dots are passed to the
  [`text`](https://rdrr.io/r/graphics/text.html) function, which can be
  used to change font and similar arguments.

## Value

nothing is returned

## See also

[`title`](https://rdrr.io/r/graphics/title.html)

Other graphics.annotation:
[`barText()`](https://andrisignorell.github.io/aurora/reference/barText.md),
[`boxedText()`](https://andrisignorell.github.io/aurora/reference/boxedText.md),
[`colLegend()`](https://andrisignorell.github.io/aurora/reference/colLegend.md),
[`errBars()`](https://andrisignorell.github.io/aurora/reference/errBars.md),
[`stamp()`](https://andrisignorell.github.io/aurora/reference/stamp.md),
[`textLegend()`](https://andrisignorell.github.io/aurora/reference/textLegend.md)

## Examples

``` r

plot(pressure)
titleRect("pressure")


```
