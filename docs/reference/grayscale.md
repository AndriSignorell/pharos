# Convert Colors to grayScale

Convert colors to grayScale using luminance weighting.

## Usage

``` r
grayScale(col)
```

## Arguments

- col:

  vector of valid R colors.

## Value

Character vector of grayScale colors.

## Details

grayScale conversion uses the standard luminance approximation: \$\$0.3
R + 0.59 G + 0.11 B\$\$

## See also

[color-conversion-overview](https://andrisignorell.github.io/aurora/reference/color-conversion-overview.md)

## Examples

``` r
op <- par(no.readonly = TRUE)
par(mfcol=c(2,2))

tmp <- 1:3
names(tmp) <- c('red','green','blue')

barplot(tmp, col=c('red','green','blue'))
barplot(tmp, col=grayScale(c('red','green','blue')))

barplot(tmp, col=c('red','#008100','#3636ff'))
barplot(tmp, col=grayScale(c('red','#008100','#3636ff')))


par(op)
```
