# Metric Prefixes

SI metric prefixes from yotta (\\10^{24}\\) down to yocto
(\\10^{-24}\\), with their name, symbol and multiplier. Used as default
lookup table by [`convUnit`](convUnit.md) and for SI-prefix formatting
in [`fm`](fm.md).

## Usage

``` r
Prefix
```

## Format

A `data.frame` with 20 rows and 3 columns:

- pref:

  `character`, name of the prefix (e.g. `"kilo"`).

- abbr:

  `character`, symbol of the prefix (e.g. `"k"`); `"u"` is used for
  micro.

- mult:

  `numeric`, multiplier, i.e. the power of ten the prefix stands for
  (e.g. `1000`).

## Value

A `data.frame` as described under *Format*; the object is a constant,
not a function.

## Examples

``` r
Prefix
#>     pref abbr  mult
#> 1  yotta    Y 1e+24
#> 2  zetta    Z 1e+21
#> 3    exa    E 1e+18
#> 4   peta    P 1e+15
#> 5   tera    T 1e+12
#> 6   giga    G 1e+09
#> 7   mega    M 1e+06
#> 8   kilo    k 1e+03
#> 9  hecto    h 1e+02
#> 10  deca   da 1e+01
#> 11  deci    d 1e-01
#> 12 centi    c 1e-02
#> 13 milli    m 1e-03
#> 14 micro    u 1e-06
#> 15  nano    n 1e-09
#> 16  pico    p 1e-12
#> 17 femto    f 1e-15
#> 18  atto    a 1e-18
#> 19 zepto    z 1e-21
#> 20 yocto    y 1e-24
Prefix[Prefix$abbr == "k", ]
#>   pref abbr mult
#> 8 kilo    k 1000
```
