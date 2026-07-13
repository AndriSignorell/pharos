# Extract Numeric Values from Strings

Extracts numeric values from character strings using regular
expressions. The function supports integers, decimal numbers, and
scientific notation.

## Usage

``` r
strVal(
  x,
  collapse = FALSE,
  output = c("character", "numeric"),
  dec = getOption("OutDec")
)
```

## Arguments

- x:

  a character vector

- collapse:

  logical; if `TRUE`, all extracted numbers per element of `x` are
  concatenated into a single string. Otherwise, a list of character
  vectors is returned.

- output:

  character; controls the type of the returned values. `"character"`
  (default) returns strings; `"numeric"` coerces extracted values to
  numeric.

- dec:

  character; decimal separator used in the input. Defaults to
  `getOption("OutDec")`.

## Value

If `collapse = FALSE`, a list of character or numeric vectors containing
the extracted values for each element of `x`. If `collapse = TRUE`, a
character or numeric vector with concatenated values per element.

## Details

The function detects numeric values including optional signs, decimal
parts, and scientific notation (e.g., `"1.23e-4"`).

Whitespace between sign and number (e.g., `"- 2.5"`) is tolerated and
removed before returning results.

If `output = "numeric"` and the decimal separator `dec` differs from the
current system setting (`getOption("OutDec")`), values are converted
accordingly before coercion.

## See also

[`as.numeric`](https://rdrr.io/r/base/numeric.html),
[`stri_extract_all_regex`](https://rdrr.io/pkg/stringi/man/stri_extract.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in lyra.

## Examples

``` r
x <- c("value = 12.5", "x = -3.2e2 and 7", "no numbers here")

# extract as character
strVal(x)
#> [[1]]
#> [1] "12.5"
#> 
#> [[2]]
#> [1] "-3.2e2" "7"     
#> 
#> [[3]]
#> [1] NA
#> 

# extract as numeric
strVal(x, output = "numeric")
#> [[1]]
#> [1] 12.5
#> 
#> [[2]]
#> [1] -320    7
#> 
#> [[3]]
#> [1] NA
#> 

# concatenate values
strVal(x, collapse = TRUE)
#> [1] "12.5"    "-3.2e27" "NA"     

# different decimal separator
strVal("value = 3,14", dec = ",", output = "numeric")
#> [[1]]
#> [1] 3.14
#> 
```
