# Format Styles

Interface for format templates, defined as a list consisting of any
accepted format features in [`fm()`](fm.md). This enables to define
templates globally and easily change or modify them later.

## Usage

``` r
styles()

style(
  x,
  digits = NULL,
  leadDigits = NULL,
  sci = NULL,
  bigMark = NULL,
  decMark = NULL,
  naForm = NULL,
  zeroForm = NULL,
  fmt = NULL,
  pThreshold = NULL,
  width = NULL,
  align = NULL,
  lang = NULL,
  label = NULL,
  ...
)

# S3 method for class 'Style'
print(x, ...)
```

## Arguments

- x:

  an object of class `Style` or the name of a style, defined either in
  the global environment or in the options. The format arguments
  supplied along with it overwrite its settings or are added to them. If
  no style with the given name is found, a warning is issued and an
  empty style is returned.

- digits:

  integer, the desired (fixed) number of digits after the decimal point.
  You will always get this number of digits, even if the last digit
  is 0. In scientific notation it is the number of decimals of the
  mantissa. Negative numbers of digits round to a power of ten
  (`digits=-2` would round to the nearest hundred) for standard numeric
  formats; engineering formats require nonnegative values

- leadDigits:

  number of leading zeros. `leadDigits=3` would make sure that at least
  3 digits on the left side will be printed, say `3.4` will be printed
  as `003.4`. Setting `leadDigits` to `0` will yield results like `.452`
  for `0.452`. The default `NULL` will leave the numbers as they are
  (meaning at least one 0 digit).

- sci:

  numeric scalar giving the absolute power-of-ten threshold for
  scientific notation. It applies to the absolute value of `x` and is
  used symmetrically: for `sci = 8`, a value is displayed scientifically
  if \\\|x\| \ge 10^8\\ or \\0 \< \|x\| \< 10^{-8}\\. The default is
  based on `getOption("scipen")`; an option value of zero is replaced by
  7

- bigMark:

  character; if not empty used as mark between every 3 digits before the
  decimal point. If `NULL`, the option `bigMark` is used and, if that is
  not set, "" (none).

- decMark:

  character specifying the decimal mark. If `NULL`, the current `OutDec`
  option is used

- naForm:

  character, string specifying how `NA`s should be specially formatted.
  If set to `NULL` (default) no special action will be taken.

- zeroForm:

  character, string specifying how zeros should be specially formatted.
  Useful for pretty printing 'sparse' objects. If set to `NULL`
  (default) no special action will be taken.

- fmt:

  a format code or date-time template, or a formatting function. See the
  Details of [`fm()`](fm.md).

- pThreshold:

  positive numeric threshold below which p-values are shown as
  `"< threshold"`

- width:

  nonnegative integer giving the minimum display width

- align:

  the character on whose position the strings will be aligned. Left
  alignment can be requested by setting `align = "\\l"`, right alignment
  by `"\\r"` and center alignment by `"\\c"`. Mind the backslashes, as
  if they are omitted, strings would be aligned to the **character** l,
  r or c respectively. The default is `NULL` which would just leave the
  strings as they are.  
  This argument is send directly to the function
  [`strAlign()`](strAlign.md) as argument `sep`.

- lang:

  optional value setting the language for the months and daynames. Can
  be either `"local"` for current locale or `"en"` for english. If left
  to `NULL`, the option `DescToolsX.lang` is used, falling back to
  `"en"`

- label:

  a description for the style

- ...:

  for `style()`, further components of the style: only arguments of
  [`fm()`](fm.md) and the metadata `name` are accepted, anything else is
  an error. Not used by the print method.

## Value

`style()` returns an object of class `Style`  
`styles()` returns a list of styles

## Details

`style()` takes any of the arguments of [`fm()`](fm.md) and combines
them to an object of class `"Style"`, which then can be handed over to
[`fm()`](fm.md) as argument `fmt`.  
Following will define a new format template named "`num.sty`". Passed to
[`fm()`](fm.md) this will result in a number displayed with 2 fixed
digits and a comma as big mark:

    num.sty <- style(digits=2, bigMark=",")
    fm(12222.89345, fmt=num.sty) = 12,222.89

This is the same result as if the arguments would have been supplied
directly, but helps to avoid boilerplate code:  
`fm(12222.89345, digits=2, bigMark=",")`.

To derive a style from an existing one we can provide `style()` with the
style, or with its name, and overwrite, resp. add new format options.
`style("num.sty", digits=1, sci=10)` will use the current version of the
numeric format and change the digits to 1 and the threshold to switch to
scientific presentation to numbers \>= 1e10 and \< 1e-10. The stored
style itself is not changed, so the result has to be assigned.

`styles()` returns all found style definitions in the global environment
or in the options.

The styles can be stored as options for convenience. To store a new
format we use the default
[`options()`](https://rdrr.io/r/base/options.html) approach:
`options(num.sty = style(digits=1, bigMark=" "))` Defined styles in the
options can be passed on to [`fm()`](fm.md) simply by their name. If a
style of the same name exists in the global environment, that one is
used.

Four default styles are registered as options when **pharos** is loaded,
unless options of these names already exist: `"abs.sty"` for counts,
`"num.sty"` for numeric values, `"per.sty"` for percentages and
`"pval.sty"` for p-values. They are used by several plot functions of
this package (e.g. [`plotHeatmap()`](plotHeatmap.md)) and by the report
functions in **DescToolsX** (e.g. `DescToolsX::tOne()`). Redefining them
with [`options()`](https://rdrr.io/r/base/options.html) changes these
formats globally.

## See also

[theme](theme.md)

Other format: [`convUnit()`](convUnit.md), [`fm()`](fm.md),
[`fmCI()`](fmCI.md), [`print.Unit()`](print.Unit.md),
[`unit()`](unit.md)

## Examples

``` r

# use style() to get and define new formats stored as option
num.sty <- style(digits=2, bigMark=" ")
abs.sty <- style(digits=0, bigMark=" ")
dat.sty <- style(fmt="MM, dd yyyy")

num.sty                             # displays the details of the style
#> Format name:   
#> Description:   
#> Definition:    digits=2, bigMark=' '
#> Example:       314 159.27
# editing styles
style("abs.sty")                    # looks for format "abs.sty"
#> Format name:   
#> Description:   Number format for counts
#> Definition:    digits=0, bigMark=''
#> Example:       314159
#> (Source:       options)
#> 
# style("nexist")                     # return for nonexisting style
style("abs.sty", bigMark="")       # get Style("abs") and overwrite bigMark
#> Format name:   
#> Description:   Number format for counts
#> Definition:    digits=0, bigMark=''
#> Example:       314159
#> (Source:       options)
#> 
style("abs.sty", naForm="-")       # get Style("abs") and add user defined naForm
#> Format name:   
#> Description:   Number format for counts
#> Definition:    digits=0, bigMark='', naForm='-'
#> Example:       314159
#> (Source:       options)
#> 

styles()                            # all defined formats
#> $abs.sty
#> Format name:   
#> Description:   Number format for counts
#> Definition:    digits=0, bigMark=''
#> Example:       314159
#> (Source:       options)
#> 
#> $num.sty
#> Format name:   
#> Description:   Number format for numeric values
#> Definition:    digits=3, bigMark=''
#> Example:       314159.265
#> (Source:       options)
#> 
#> $per.sty
#> Format name:   
#> Description:   Percentage number format
#> Definition:    digits=1, fmt='%'
#> Example:       3.1e+07%
#> (Source:       options)
#> 
#> $pval.sty
#> Format name:   
#> Description:   Number format for p-values
#> Definition:    fmt='p', pThreshold=0.001
#> Example:       NA
#> (Source:       options)
#> 
styles()[c("num.sty", "abs.sty")]   # numeric and integer styles
#> $num.sty
#> Format name:   
#> Description:   Number format for numeric values
#> Definition:    digits=3, bigMark=''
#> Example:       314159.265
#> (Source:       options)
#> 
#> $abs.sty
#> Format name:   
#> Description:   Number format for counts
#> Definition:    digits=0, bigMark=''
#> Example:       314159
#> (Source:       options)
#> 

# define totally new format and store as option
options(nob.sty=style(digits=5, naForm="nodat"))

# using styles
fm(314.1563, fmt=abs.sty)
#> [1] 314
fm(314.1563, fmt=num.sty)
#> [1] 314.16

fm(Sys.Date(), fmt=dat.sty)
#> [1] 10, 09 2026

# remove the option again
options(nob.sty=NULL)
```
