# Remove Leading/Trailing Whitespace From A String

The function removes whitespace characters as spaces, tabs and newlines
from the beginning and end of the supplied string. Whitespace characters
occurring in the middle of the string are retained.  
Trimming with method `"left"` deletes only leading whitespaces,
`"right"` only trailing. Designed for users who were socialized by SQL.

## Usage

``` r
strTrim(x, pattern = " \t\n", method = "both")
```

## Arguments

- x:

  the string to be trimmed

- pattern:

  the pattern of the whitespaces to be deleted, defaults to space, tab
  and newline: `" \t\n"`

- method:

  one out of `"both"` (default), `"left"`, `"right"`. Determines on
  which side the string should be trimmed.

## Value

the string x without whitespaces

## Details

The functions are defined depending on method as  
`both: gsub( pattern=gettextf("^[%s]+|[%s]+$", pattern, pattern), replacement="", x=x)`  
`left: gsub( pattern=gettextf("^[%s]+",pattern), replacement="", x=x)`  
`right: gsub( pattern=gettextf("[%s]+$",pattern), replacement="", x=x)`

## See also

[`trimws`](https://rdrr.io/r/base/trimws.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in pharos.

## Examples

``` r

strTrim("  Hello world! ")
#> [1] "Hello world!"

strTrim("  Hello world! ", method="left")
#> [1] "Hello world! "
strTrim("  Hello world! ", method="right")
#> [1] "  Hello world!"

# user defined pattern
strTrim(" ..Hello ... world! ", pattern=" \\.")
#> [1] "..Hello ... world!"
```
