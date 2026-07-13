# Align Strings

Aligns a character vector to the left, right, center, or with respect to
the first occurrence of a specified separator.

## Usage

``` r
strAlign(x, sep = "\\r")
```

## Arguments

- x:

  a character vector

- sep:

  a character specifying the alignment mode:

  - `"\l"`: left alignment

  - `"\r"`: right alignment (default)

  - `"\c"`: centered alignment

  - any other character: align at the first occurrence of this separator

## Value

A character vector of aligned strings.

## Details

Alignment is achieved by padding strings with spaces so that all
elements have equal width. This is mainly useful for monospaced output.

For left, right, and center alignment, strings are padded to the maximum
width using spaces.

If a separator is provided, strings are aligned such that the first
occurrence of the separator is vertically aligned. If a string does not
contain the separator, it is treated as if the separator occurred at the
end.

This function uses Unicode-aware string handling via the stringi
package.

## See also

[`stri_pad`](https://rdrr.io/pkg/stringi/man/stri_pad.html),
[`stri_sub`](https://rdrr.io/pkg/stringi/man/stri_sub.html),
[`stri_trim_right`](https://rdrr.io/pkg/stringi/man/stri_trim.html)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in lyra.

## Examples

``` r
x <- c("here", "there", "everywhere")

# right align (default)
strAlign(x)
#> [1] "      here" "     there" "everywhere"

# left align
strAlign(x, "\\l")
#> [1] "here      " "there     " "everywhere"

# center align
strAlign(x, "\\c")
#> [1] "   here   " "  there   " "everywhere"

# align at decimal separator
z <- c("6.0", "45.12", "784")
strAlign(z, ".")
#> [1] "   6.0 " "  45.12" "  784  "
```
