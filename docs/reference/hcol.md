# Helsana Colors

Retrieve one or more colors from the helsana palette.

## Usage

``` r
hcol(...)
```

## Arguments

- ...:

  character strings naming the colors to retrieve. Valid names are:
  `"blue"`, `"red"`, `"orange"`, `"yellow"`, `"ecru"`, `"green"`,
  `"pink"`, `"moss"`, `"slate"`, `"sand"`, `"brown"`, `"plum"`. If none
  are provided, the full palette is returned.

## Value

A named character vector of hex color codes.

## See also

Other color.palettes:
[`pal()`](https://andrisignorell.github.io/aurora/reference/pal.md),
[`palNames()`](https://andrisignorell.github.io/aurora/reference/palNames.md)

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
```
