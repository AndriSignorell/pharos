# Format Confidence Intervals

Format confidence intervals using a flexible template.

## Usage

``` r
fmCI(x, template = NULL, ...)
```

## Arguments

- x:

  the numerical values, given in the order in which they are used in the
  template.

- template:

  character string as template for the desired format. %s are the
  placeholders for the numerical values. Default is
  `\code{"%s [%s, %s]"}` for `<est> [<lci>, <uci>]`.

- ...:

  the dots are passed on to the
  [`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md)
  function.

## Value

a formatted string

## See also

[`fm`](https://andrisignorell.github.io/aurora/reference/fm.md)

Other format:
[`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md)

## Examples

``` r

x <- c(est=2.1, lci=1.5, uci=3.8)

# default template
fmCI(x)
#> [1] "2.1 [1.5, 3.8]"
# user defined template (note the double percent code)
fmCI(x, template="%s (95%%-CI %s-%s)", digits=1)
#> [1] "2.1 (95%-CI 1.5-3.8)"

# in higher datastructures
tapply(warpbreaks$breaks, warpbreaks$wool, 
       function(x) fmCI(c(mean(x), t.test(x)$conf.int),
                        digits=1))
#>                   A                   B 
#> "31.0 [24.8, 37.3]" "25.3 [21.6, 28.9]" 
```
