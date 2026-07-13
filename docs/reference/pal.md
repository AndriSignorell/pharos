# Get a Color Palette

Returns `n` colors from a named palette. All palettes always return
exactly `n` colors regardless of their base size:

- `n < length(base)`: evenly spaced sample for maximum contrast

- `n = length(base)`: returned as-is

- `n > length(base)`: interpolated via
  [`colorRampPalette`](https://rdrr.io/r/grDevices/colorRamp.html)

## Usage

``` r
pal(name, n = NA, opacity = 1)

# S3 method for class 'Palette'
plot(x, cex = 2.5, border = "grey70", ...)
```

## Arguments

- name:

  character or integer. Palette name (full match via
  [`match.arg`](https://rdrr.io/r/base/match.arg.html)) or index into
  [`palNames()`](https://andrisignorell.github.io/aurora/reference/palNames.md).
  If missing, returns the palette named in the active theme
  (`getTheme()$palette`, see
  [theme](https://andrisignorell.github.io/aurora/reference/theme.md)).

- n:

  integer, number of colors to return. Default `NA` returns the colors
  as contained in the palette.

- opacity:

  numeric in \\\[0, 1\]\\, opacity. Default `1` (opaque). Applied via
  [`adjustcolor`](https://rdrr.io/r/grDevices/adjustcolor.html).

- x:

  palette object to be plotted.

- cex:

  character extension.

- border:

  color for the border.

- ...:

  further params.

## Value

a character vector of `n` hex color codes of class
`c("palette", "character")` with a `"name"` attribute.

## See also

[`palNames`](https://andrisignorell.github.io/aurora/reference/palNames.md),
[`colorRampPalette`](https://rdrr.io/r/grDevices/colorRamp.html),
[`adjustcolor`](https://rdrr.io/r/grDevices/adjustcolor.html)

Other color.palettes:
[`hcol()`](https://andrisignorell.github.io/aurora/reference/hcol.md),
[`palNames()`](https://andrisignorell.github.io/aurora/reference/palNames.md)

## Examples

``` r
# default palette from options
pal()
#>      blue       red    orange    yellow      ecru     green      pink      moss 
#> "#8296C4" "#9A0941" "#F08100" "#FED037" "#CAB790" "#B3BA12" "#D35186" "#8FAE8C" 
#>     slate      sand     brown      plum 
#> "#5F6F9A" "#E6E2D3" "#6E5A3C" "#5B2A45" 
#> attr(,"name")
#> [1] "helsana"
#> attr(,"class")
#> [1] "Palette"   "character"

# discrete palette — 3 maximally contrasting colors
pal("dark", n = 3)
#> [1] "#1B9E77" "#E7298A" "#666666"
#> attr(,"name")
#> [1] "dark"
#> attr(,"class")
#> [1] "Palette"   "character"

# continuous gradient — 50 colors
pal("red-white-blue-2", n = 50)
#>  [1] "#67001F" "#760421" "#850923" "#940E26" "#A41328" "#B2192B" "#BA2832"
#>  [8] "#C13639" "#C84540" "#D05447" "#D7624F" "#DD7059" "#E37E64" "#E98D6F"
#> [15] "#EF9B7A" "#F4A886" "#F6B394" "#F8BEA2" "#FAC9B0" "#FBD4BE" "#FDDDCB"
#> [22] "#FDE5D6" "#FDECE2" "#FEF3ED" "#FEFBF9" "#FAFCFD" "#F0F7FA" "#E7F1F7"
#> [29] "#DEECF4" "#D4E7F1" "#C9E1ED" "#BCDAEA" "#AFD4E6" "#A2CDE2" "#95C6DF"
#> [36] "#86BDDA" "#76B3D4" "#66A9CF" "#569FC9" "#4695C4" "#3D8BBF" "#3682BA"
#> [43] "#2F79B5" "#2870B1" "#2166AC" "#1B5C9E" "#16518E" "#10467F" "#0A3B70"
#> [50] "#053061"
#> attr(,"name")
#> [1] "red-white-blue-2"
#> attr(,"class")
#> [1] "Palette"   "character"

# by index
pal(1, n = 10)
#>  [1] "#FF0000" "#FF7100" "#FFE200" "#AAFF00" "#38FF00" "#00C638" "#0055A9"
#>  [8] "#0000E2" "#000071" "#000000"
#> attr(,"name")
#> [1] "red-black"
#> attr(,"class")
#> [1] "Palette"   "character"

# with transparency
pal("helsana", n = 5, opacity = 0.5)
#> [1] "#8296C480" "#FED03780" "#B3BA1280" "#5F6F9A80" "#5B2A4580"
#> attr(,"name")
#> [1] "helsana"
#> attr(,"class")
#> [1] "Palette"   "character"

# show all names
palNames()
#>  [1] "red-black"        "red-black-green"  "steelblue-white"  "red-white-green" 
#>  [5] "red-white-blue-1" "red-white-blue-2" "red-white-blue-3" "red-white-blue-4"
#>  [9] "red-green-1"      "helsana"          "helsana-1"        "helsana-2"       
#> [13] "tibco"            "spring"           "soap"             "maiden"          
#> [17] "dark"             "accent"           "pastel"           "fragile"         
#> [21] "big"              "grand-budapest"   "moonrise-1"       "royal-1"         
#> [25] "moonrise-2"       "cavalcanti"       "royal-2"          "grand-budapest-2"
#> [29] "moonrise-3"       "chevalier"        "zissou"           "fantastic-fox"   
#> [33] "darjeeling"       "rushmore"         "bottle-rocket"    "darjeeling-2"    
#> [37] "tequila"          "long"             "night"            "dawn"            
#> [41] "noon"             "light"           
```
