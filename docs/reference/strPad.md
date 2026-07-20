# Pad a String With Justification

`strPad` will fill a string x with defined characters to fit a given
length.

## Usage

``` r
strPad(x, width = NULL, pad = " ", adj = "left")
```

## Arguments

- x:

  a vector of strings to be padded

- width:

  resulting width of padded string. If x is a vector and width is left
  to NULL, it will be set to the length of the largest string in x.

- pad:

  string to pad with. Will be repeated as often as necessary. Default is
  " ".

- adj:

  adjustment of the old string, one of `"left"`, `"right"`, `"center"`.
  If set to `"left"` the old string will be adjusted on the left and the
  new characters will be filled in on the right side.

## Value

the string

## Details

If a string x has more characters than width, it will be chopped on the
length of width.

## See also

[`strAlign`](https://andrisignorell.github.io/aurora/reference/strAlign.md),
[`strTrunc`](https://andrisignorell.github.io/aurora/reference/strTrunc.md)

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in pharos.

## Examples

``` r

strPad("My string", 25, "XoX", "center")
#> [1] "XoXXoXXoMy stringXoXXoXXo"
 # [1] "XoXXoXXoMy stringXXoXXoXX"
```
