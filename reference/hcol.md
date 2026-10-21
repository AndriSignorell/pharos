# Helsana Colors

Retrieve one or more colors from the helsana palette, optionally faded.

## Usage

``` r
hcol(..., fade = NULL)
```

## Arguments

- ...:

  character strings naming the colors to retrieve. Valid names are:
  `"blue"`, `"red"`, `"orange"`, `"yellow"`, `"ecru"`, `"green"`,
  `"pink"`, `"moss"`, `"slate"`, `"sand"`, `"brown"`, `"plum"`. If none
  are provided, the full palette is returned.

- fade:

  `NULL` (default) returns the colors unchanged. A number in \\\[0,
  1\]\\ returns the opaque tint the color has at this opacity on a white
  background, see [`fade()`](fade.md): `1` is the color itself, smaller
  values are lighter. Recycled over the colors, so
  `hcol("blue", fade = c(1, 0.6, 0.3))` gives three tints of one color.

## Value

A named character vector of hex color codes.

## See also

Other color.palettes: [`pal()`](pal.md), [`palNames()`](palNames.md)

## Examples

``` r
hcol("blue", "green")
#>      blue     green 
#> "#8296C4" "#B3BA12" 
hcol()
#>      blue       red    orange    yellow      ecru     green      pink      moss 
#> "#8296C4" "#9A0941" "#F08100" "#FED037" "#CAB790" "#B3BA12" "#D35186" "#8FAE8C" 
#>     slate      sand     brown      plum 
#> "#5F6F9A" "#E6E2D3" "#6E5A3C" "#5B2A45" 

# lighter tints, still opaque
hcol("blue", "red", fade = 0.4)
#>      blue       red 
#> "#CDD5E7" "#D79DB3" 
hcol("blue", fade = c(1, 0.6, 0.3))
#>      blue      blue      blue 
#> "#8296C4" "#B4C0DC" "#D9DFED" 
```
