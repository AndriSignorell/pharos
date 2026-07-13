# List Available Palette Names

Returns the names of all palettes available in
[`pal`](https://andrisignorell.github.io/aurora/reference/pal.md),
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

[`pal`](https://andrisignorell.github.io/aurora/reference/pal.md)

Other color.palettes:
[`hcol()`](https://andrisignorell.github.io/aurora/reference/hcol.md),
[`pal()`](https://andrisignorell.github.io/aurora/reference/pal.md)

## Examples

``` r
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
palNames("continuous")
#> [1] "red-black"        "red-black-green"  "steelblue-white"  "red-white-green" 
#> [5] "red-white-blue-1" "red-white-blue-2" "red-white-blue-3" "red-white-blue-4"
#> [9] "red-green-1"     
palNames("discrete")
#>  [1] "helsana"          "helsana-1"        "helsana-2"        "tibco"           
#>  [5] "spring"           "soap"             "maiden"           "dark"            
#>  [9] "accent"           "pastel"           "fragile"          "big"             
#> [13] "grand-budapest"   "moonrise-1"       "royal-1"          "moonrise-2"      
#> [17] "cavalcanti"       "royal-2"          "grand-budapest-2" "moonrise-3"      
#> [21] "chevalier"        "zissou"           "fantastic-fox"    "darjeeling"      
#> [25] "rushmore"         "bottle-rocket"    "darjeeling-2"     "tequila"         
#> [29] "long"             "night"            "dawn"             "noon"            
#> [33] "light"           
```
