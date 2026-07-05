# HTML notation for hat and bar diacritics

Append the HTML entity for a circumflex (“hat”, as in an estimator
\\\hat{x}\\) or macron (“bar”, as in a sample mean \\\bar{x}\\) to a
label.

## Usage

``` r
htmlHat(x)

htmlBar(x)
```

## Arguments

- x:

  a character vector, typically a variable name or symbol

## Value

a character vector with the diacritic's HTML entity appended

## Examples

``` r
htmlHat("p")  # -> "p&#770;"   (renders as p with a circumflex)
#> [1] "p&#770;"
htmlBar("x")  # -> "x&#772;"   (renders as x with a macron)
#> [1] "x&#772;"
```
