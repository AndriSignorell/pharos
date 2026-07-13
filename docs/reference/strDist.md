# Compute Distances Between Strings

`strDist` computes distances between strings following to Levenshtein or
Hamming method.

## Usage

``` r
strDist(
  x,
  y,
  method = "levenshtein",
  mismatch = 1,
  gap = 1,
  ignoreCase = FALSE
)
```

## Arguments

- x:

  character vector, first string

- y:

  character vector, second string

- method:

  character, name of the distance method. This must be `"levenshtein"`,
  `"normlevenshtein"` or `"hamming"`. Default is `"levenshtein"`, the
  classical Levenshtein distance.

- mismatch:

  numeric, distance value for a mismatch between symbols

- gap:

  numeric, distance value for inserting a gap

- ignoreCase:

  if `FALSE` (default), the distance measure will be case sensitive and
  if `TRUE`, case is ignored

## Value

`strDist` returns an object of class `"dist"`; cf.
[`dist`](https://rdrr.io/r/stats/dist.html).

## Details

The function computes the Hamming and the Levenshtein (edit) distance of
two given strings (sequences). The Hamming distance between two vectors
is the number of mismatches between corresponding entries.

In case of the Hamming distance the two strings must have the same
length.

In case of the Levenshtein (edit) distance a scoring and a trace-back
matrix are computed and are saved as attributes `"ScoringMatrix"` and
`"TraceBackMatrix"`. The numbers in the trace-back matrix reflect
insertion of a gap in string `y` (1), match/mismatch (2), and insertion
of a gap in string `x` (3).

The edit distance is useful, but normalizing the distance to fall within
the interval `[0,1]` is preferred because it is somewhat difficult to
judge whether an LD of for example 4 suggests a high or low degree of
similarity. The method `"normlevenshtein"` for normalizing the LD is
sensitive to this scenario. In this implementation, the Levenshtein
distance is transformed to fall in this interval as follows: \$\$lnd =
1 - \frac{ld}{max(length(x), length(y))}\$\$

where `ld` is the edit distance and `max(length(x), length(y))` denotes
that we divide by the length of the larger of the two character strings.
This normalization, referred to as the Levenshtein normalized distance
(lnd), yields a statistic where 1 indicates perfect agreement between
the two strings, and a 0 denotes imperfect agreement. The closer a value
is to 1, the more certain we can be that the character strings are the
same; the closer to 0, the less certain.

## Note

For distances between strings and for string alignments see also
Bioconductor package Biostrings

Based on code by Matthias Kohl, adapted to conform to package standards.

## References

R. Merkl and S. Waack (2009) *Bioinformatik Interaktiv*. Wiley.

Harold C. Doran (2010) *MiscPsycho. An R Package for Miscellaneous
Psychometric Analyses*

## See also

[`adist`](https://rdrr.io/r/utils/adist.html),
[`dist`](https://rdrr.io/r/stats/dist.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in lyra.

## Examples

``` r

x <- "GACGGATTATG"
y <- "GATCGGAATAG"
## Levenshtein distance
d <- strDist(x, y)
d
#>             GACGGATTATG
#> GATCGGAATAG           3
attr(d, "ScoringMatrix")
#>     gap  G A T C G G A A T  A  G
#> gap   0  1 2 3 4 5 6 7 8 9 10 11
#> G     1  0 1 2 3 4 5 6 7 8  9 10
#> A     2  1 0 1 2 3 4 5 6 7  8  9
#> C     3  2 1 1 1 2 3 4 5 6  7  8
#> G     4  3 2 2 2 1 2 3 4 5  6  7
#> G     5  4 3 3 3 2 1 2 3 4  5  6
#> A     6  5 4 4 4 3 2 1 2 3  4  5
#> T     7  6 5 4 5 4 3 2 2 2  3  4
#> T     8  7 6 5 5 5 4 3 3 2  3  4
#> A     9  8 7 6 6 6 5 4 3 3  2  3
#> T    10  9 8 7 7 7 6 5 4 3  3  3
#> G    11 10 9 8 8 7 7 6 5 4  4  3
attr(d, "TraceBackMatrix")
#>     gap     G     A     T      C        G      G     A     A      T   A     
#> gap "start" "i"   "i"   "i"    "i"      "i"    "i"   "i"   "i"    "i" "i"   
#> G   "d"     "m"   "i"   "i"    "i"      "m/i"  "m/i" "i"   "i"    "i" "i"   
#> A   "d"     "d"   "m"   "i"    "i"      "i"    "i"   "m/i" "m/i"  "i" "m/i" 
#> C   "d"     "d"   "d"   "mm"   "m"      "i"    "i"   "i"   "i"    "i" "i"   
#> G   "d"     "d/m" "d"   "d/mm" "d/mm"   "m"    "m/i" "i"   "i"    "i" "i"   
#> G   "d"     "d/m" "d"   "d/mm" "d/mm"   "d/m"  "m"   "i"   "i"    "i" "i"   
#> A   "d"     "d"   "d/m" "d/mm" "d/mm"   "d"    "d"   "m"   "m/i"  "i" "m/i" 
#> T   "d"     "d"   "d"   "m"    "d/mm/i" "d"    "d"   "d"   "mm"   "m" "i"   
#> T   "d"     "d"   "d"   "d/m"  "mm"     "d"    "d"   "d"   "d/mm" "m" "mm/i"
#> A   "d"     "d"   "d/m" "d"    "d/mm"   "d/mm" "d"   "d/m" "m"    "d" "m"   
#> T   "d"     "d"   "d"   "d/m"  "d/mm"   "d/mm" "d"   "d"   "d"    "m" "d"   
#> G   "d"     "d/m" "d"   "d"    "d/mm"   "m"    "d/m" "d"   "d"    "d" "d/mm"
#>     G     
#> gap "i"   
#> G   "m/i" 
#> A   "i"   
#> C   "i"   
#> G   "m/i" 
#> G   "m/i" 
#> A   "i"   
#> T   "i"   
#> T   "mm/i"
#> A   "i"   
#> T   "mm"  
#> G   "m"   

## Hamming distance
strDist(x, y, method="hamming")
#>             GACGGATTATG
#> GATCGGAATAG           7
```
