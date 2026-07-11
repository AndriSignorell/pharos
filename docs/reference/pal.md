# Get a Color Palette

Returns `n` colors from a named palette. All palettes always return
exactly `n` colors regardless of their base size:

- `n < length(base)`: evenly spaced sample for maximum contrast

- `n = length(base)`: returned as-is

- `n > length(base)`: interpolated via
  [`colorRampPalette`](https://rdrr.io/r/grDevices/colorRamp.html)

## Usage

``` r
pal(name, n = NA, alpha = 1)

# S3 method for class 'Palette'
plot(x, cex = 2.5, border = "grey70", ...)
```

## Arguments

- name:

  character or integer. Palette name (full match via
  [`match.arg`](https://rdrr.io/r/base/match.arg.html)) or index into
  [`palNames()`](https://andrisignorell.github.io/lyra/reference/palNames.md).
  If missing, returns the palette named in the active theme
  (`getTheme()$palette`, see
  [`getTheme`](https://andrisignorell.github.io/lyra/reference/getTheme.md)).

- n:

  integer, number of colors to return. Default `NA` returns the colors
  as contained in the palette.

- alpha:

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

[`palNames`](https://andrisignorell.github.io/lyra/reference/palNames.md),
[`colorRampPalette`](https://rdrr.io/r/grDevices/colorRamp.html),
[`adjustcolor`](https://rdrr.io/r/grDevices/adjustcolor.html)

Other color:
[`addAlpha()`](https://andrisignorell.github.io/lyra/reference/addAlpha.md),
[`colToOpaque()`](https://andrisignorell.github.io/lyra/reference/colToOpaque.md),
[`colToRGB()`](https://andrisignorell.github.io/lyra/reference/colToRGB.md),
[`contrastColor()`](https://andrisignorell.github.io/lyra/reference/contrastColor.md),
[`darken()`](https://andrisignorell.github.io/lyra/reference/darken.md),
[`findColor()`](https://andrisignorell.github.io/lyra/reference/findColor.md),
[`grayscale()`](https://andrisignorell.github.io/lyra/reference/grayscale.md),
[`hcol()`](https://andrisignorell.github.io/lyra/reference/hcol.md),
[`hexToRGB()`](https://andrisignorell.github.io/lyra/reference/hexToRGB.md),
[`lighten()`](https://andrisignorell.github.io/lyra/reference/lighten.md),
[`mixColors()`](https://andrisignorell.github.io/lyra/reference/mixColors.md),
[`palNames()`](https://andrisignorell.github.io/lyra/reference/palNames.md),
[`setBackCol()`](https://andrisignorell.github.io/lyra/reference/setBackCol.md)

## Examples

``` r
# default palette from options
pal()
#>      blue       red    orange    yellow      ecru     green      pink      moss 
#> "#8296C4" "#9A0941" "#F08100" "#FED037" "#CAB790" "#B3BA12" "#D35186" "#8FAE8C" 
#>     slate      sand     brown      plum 
#> "#5F6F9A" "#E6E2D3" "#6E5A3C" "#5B2A45" 
#> attr(,"name")
#> [1] "Helsana"
#> attr(,"class")
#> [1] "Palette"   "character"

# discrete palette — 3 maximally contrasting colors
pal("Dark", n = 3)
#> [1] "#1B9E77" "#E7298A" "#666666"
#> attr(,"name")
#> [1] "Dark"
#> attr(,"class")
#> [1] "Palette"   "character"

# continuous gradient — 50 colors
pal("RedWhiteBlue1", n = 50)
#>  [1] "#67001F" "#760421" "#850923" "#940E26" "#A41328" "#B2192B" "#BA2832"
#>  [8] "#C13639" "#C84540" "#D05447" "#D7624F" "#DD7059" "#E37E64" "#E98D6F"
#> [15] "#EF9B7A" "#F4A886" "#F6B394" "#F8BEA2" "#FAC9B0" "#FBD4BE" "#FDDDCB"
#> [22] "#FDE5D6" "#FDECE2" "#FEF3ED" "#FEFBF9" "#FAFCFD" "#F0F7FA" "#E7F1F7"
#> [29] "#DEECF4" "#D4E7F1" "#C9E1ED" "#BCDAEA" "#AFD4E6" "#A2CDE2" "#95C6DF"
#> [36] "#86BDDA" "#76B3D4" "#66A9CF" "#569FC9" "#4695C4" "#3D8BBF" "#3682BA"
#> [43] "#2F79B5" "#2870B1" "#2166AC" "#1B5C9E" "#16518E" "#10467F" "#0A3B70"
#> [50] "#053061"
#> attr(,"name")
#> [1] "RedWhiteBlue1"
#> attr(,"class")
#> [1] "Palette"   "character"

# by index
pal(1, n = 10)
#>  [1] "#FF0000" "#FF7100" "#FFE200" "#AAFF00" "#38FF00" "#00C638" "#0055A9"
#>  [8] "#0000E2" "#000071" "#000000"
#> attr(,"name")
#> [1] "RedToBlack"
#> attr(,"class")
#> [1] "Palette"   "character"

# with transparency
pal("Helsana", n = 5, alpha = 0.5)
#> [1] "#8296C480" "#FED03780" "#B3BA1280" "#5F6F9A80" "#5B2A4580"
#> attr(,"name")
#> [1] "Helsana"
#> attr(,"class")
#> [1] "Palette"   "character"

# show all names
palNames()
#>  [1] "RedToBlack"     "RedBlackGreen"  "SteelblueWhite" "RedWhiteGreen" 
#>  [5] "RedWhiteBlue0"  "RedWhiteBlue1"  "RedWhiteBlue2"  "RedWhiteBlue3" 
#>  [9] "RedGreen1"      "Helsana"        "Helsana1"       "Helsana2"      
#> [13] "Tibco"          "Spring"         "Soap"           "Maiden"        
#> [17] "Dark"           "Accent"         "Pastel"         "Fragile"       
#> [21] "Big"            "GrandBudapest"  "Moonrise1"      "Royal1"        
#> [25] "Moonrise2"      "Cavalcanti"     "Royal2"         "GrandBudapest2"
#> [29] "Moonrise3"      "Chevalier"      "Zissou"         "FantasticFox"  
#> [33] "Darjeeling"     "Rushmore"       "BottleRocket"   "Darjeeling2"   
#> [37] "Tequila"        "Long"           "Night"          "Dawn"          
#> [41] "Noon"           "Light"         
```
