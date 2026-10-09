# Fade Colors

Apply transparency and remove the alpha channel afterwards.

## Usage

``` r
fade(col, opacity = 0.5)
```

## Arguments

- col:

  vector of valid R colors

- opacity:

  opacity value between 0 and 1

## Value

Character vector of colors.

## See also

Other color.manipulation: [`addOpacity()`](addOpacity.md),
[`colToOpaque()`](colToOpaque.md), [`darken()`](darken.md),
[`lighten()`](lighten.md), [`mixCol()`](mixCol.md)

## Examples

``` r
fade("tomato")
#> #FF634780 
#> "#FFB1A3" 
fade(c("tomato", "royalblue"), opacity = 0.2)
#> #FF634733 #4169E133 
#> "#FFE0DA" "#D9E1F9" 

# same tint, but the faded color hides what lies behind it
cols <- c(addOpacity("tomato", 0.4), fade("tomato", 0.4))
barplot(c(1, 1), col = cols,
        panel.first = abline(h = 0.5, lwd = 10, col = "grey35"))

```
