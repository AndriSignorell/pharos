# List Available Palette Names

Returns the names of all palettes available in
[`pal`](https://andrisignorell.github.io/lyra/reference/pal.md),
optionally filtered by type.

## Usage

``` r
palNames(type = c("all", "continuous", "discrete"))
```

## Arguments

- type:

  character, one of `"all"` (default), `"continuous"`, or `"discrete"`.

## Value

a character vector of palette names.

## See also

[`pal`](https://andrisignorell.github.io/lyra/reference/pal.md)

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
[`pal()`](https://andrisignorell.github.io/lyra/reference/pal.md),
[`setBackCol()`](https://andrisignorell.github.io/lyra/reference/setBackCol.md)

## Examples

``` r
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
palNames("continuous")
#> [1] "RedToBlack"     "RedBlackGreen"  "SteelblueWhite" "RedWhiteGreen" 
#> [5] "RedWhiteBlue0"  "RedWhiteBlue1"  "RedWhiteBlue2"  "RedWhiteBlue3" 
#> [9] "RedGreen1"     
palNames("discrete")
#>  [1] "Helsana"        "Helsana1"       "Helsana2"       "Tibco"         
#>  [5] "Spring"         "Soap"           "Maiden"         "Dark"          
#>  [9] "Accent"         "Pastel"         "Fragile"        "Big"           
#> [13] "GrandBudapest"  "Moonrise1"      "Royal1"         "Moonrise2"     
#> [17] "Cavalcanti"     "Royal2"         "GrandBudapest2" "Moonrise3"     
#> [21] "Chevalier"      "Zissou"         "FantasticFox"   "Darjeeling"    
#> [25] "Rushmore"       "BottleRocket"   "Darjeeling2"    "Tequila"       
#> [29] "Long"           "Night"          "Dawn"           "Noon"          
#> [33] "Light"         
```
