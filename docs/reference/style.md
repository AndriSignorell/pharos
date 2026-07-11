# Format Styles

Interface for format templates, defined as a list consisting of any
accepted format features in
[`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md). This
enables to define templates globally and easily change or modify them
later.

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

  an object of class `Style` or a the name of a style, defined either in
  the global enviroment or in the options.

- digits:

  integer, the desired (fixed) number of digits after the decimal point.
  Unlike [`formatC`](https://rdrr.io/r/base/formatc.html) you will
  always get this number of digits even if the last digit is 0. Negative
  numbers of digits round to a power of ten (`digits=-2` would round to
  the nearest hundred).

- leadDigits:

  number of leading zeros. `leadDigits=3` would make sure that at least
  3 digits on the left side will be printed, say `3.4` will be printed
  as `003.4`. Setting `leadDigits` to `0` will yield results like `.452`
  for `0.452`. The default `NULL` will leave the numbers as they are
  (meaning at least one 0 digit).

- sci:

  integer. The power of 10 to be set when deciding to print numeric
  values in exponential notation. Fixed notation will be preferred
  unless the number is larger than 10^scipen. If just one value is set
  it will be used for the left border 10^(-scipen) as well as for the
  right one (10^scipen). A negative and a positive value can also be set
  independently. Default is `getOption("scipen")`, whereas `scipen=0` is
  overridden.

- bigMark:

  character; if not empty used as mark between every 3 decimals before
  the decimal point. Default is "" (none).

- decMark:

  character, specifying the decimal mark to be used. If not provided,
  the default set as `decMark` option is used.

- naForm:

  character, string specifying how `NA`s should be specially formatted.
  If set to `NULL` (default) no special action will be taken.

- zeroForm:

  character, string specifying how zeros should be specially formatted.
  Useful for pretty printing 'sparse' objects. If set to `NULL`
  (default) no special action will be taken.

- fmt:

  either a format string, allowing to flexibly define special formats or
  an object of class `style`, consisting of a list of `fdm` arguments.
  See Details.

- pThreshold:

  a numerical tolerance used mainly for formatting p values, those less
  than pThreshold are formatted as "`\code{< [pThreshold]}`" (where
  '`[pThreshold]`' stands for `format(pThreshold, digits))`. Default is
  `0.001`.

- width:

  integer, the defined fixed width of the strings.

- align:

  the character on whose position the strings will be aligned. Left
  alignment can be requested by setting `sep = "\l"`, right alignment by
  `"\r"` and center alignment by `"\c"`. Mind the backslashes, as if
  they are omitted, strings would be aligned to the **character** l, r
  or c respectively. The default is `NULL` which would just leave the
  strings as they are.  
  This argument is send directly to the function
  [`strAlign()`](https://andrisignorell.github.io/aurora/reference/strAlign.md)
  as argument `sep`.

- lang:

  optional value setting the language for the months and daynames. Can
  be either `"local"` for current locale or `"en"` for english. If left
  to `NULL`, the DescToolsOption `"lang"` will be searched for and if
  not found `"local"` will be taken as default.

- label:

  a description for the style

- ...:

  further arguments to be passed to or from methods.

## Value

`style()` returns an object of class `Style`  
`styles()` returns a list of styles

## Details

`style()` can either create new styles or edit existing ones. `style()`
can be used to create new styles. It takes any of the arguments from
[`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md) and
combines them to an object of class `"Style"`, which then can be handed
over to
[`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md) as
argument `fmt`.  
Following will define a new format template named "`num.sty`". Passed to
[`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md) this
will result in a number displayed with 2 fixed digits and a comma as big
mark:

    num.sty
    <- style(digits=2, bigMark=",") fm(12222.89345, fmt=num.sty) = 12,222.89

This is the same result as if the arguments would have been supplied
directly, but helps to avoid boilerplate code:  
`fm(12222.89345, digits=2, bigMark=",")`.

To edit a style we can provide `style()` with its name and overwrite,
resp. add new format options. `style("num.sty", digits=1, sci=10)` will
use the current version of the numeric format and change the digits to 1
and the threshold to switch to scientifc presentation to numbers \> 1e10
and \< 1e-10.

`styles()` returns all found style definitions in the global environment
or in the options.

The styles can be stored as options for convenience. To store a new
format we use the default
[`options()`](https://rdrr.io/r/base/options.html) approach:
`options(num.sty = style(digits=1, bigMark=" "))` Defined styles in the
options can be passed on to
[`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md) simply
by their name.

Many report functions (e.g.
[`tOne()`](https://rdrr.io/pkg/DescToolsX/man/tOne.html)) in
**DescToolsX** use three default formats for counts (named `"abs.sty"`),
numeric values (`"num.sty"`) and percentages (`"per.sty"`).

## See also

[`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md)

Other theme:
[`getTheme()`](https://andrisignorell.github.io/aurora/reference/getTheme.md)

## Examples

``` r

# use style() to get and define new formats stored as option
num.sty <- style(digits=2, bigMark=" ")
abs.sty <- style(digits=0, bigMark=" ")
dat.sty <- style(fmt="MM, dd yyyy")

num.sty                             # displays the details of the style
#> Definition:    digits=2, bigMark=" "
#> Example:       314 159.27
# editing styles
style("abs.sty")                    # looks for format "abs.sty"
#> Definition:    digits=0, big.mark="", label="Number format for counts"
#> Example:       314159
#> (Source:       options)
#> 
# style("nexist")                     # return for nonexisting style
style("abs.sty", bigMark="")       # get Style("abs") and overwrite bigMark
#> Definition:    digits=0, big.mark="", label="Number format for counts", bigMark=""
#> Example:       314159
#> (Source:       options)
#> 
style("abs.sty", naForm="-")       # get Style("abs") and add user defined naForm
#> Definition:    digits=0, big.mark="", label="Number format for counts", naForm="-"
#> Example:       314159
#> (Source:       options)
#> 

styles()                            # all defined formats
#> $abs.sty
#> Definition:    digits=0, big.mark="", label="Number format for counts"
#> Example:       314159
#> (Source:       options)
#> 
#> $num.sty
#> Definition:    digits=3, big.mark="", label="Number format for numeric values"
#> Example:       314159.265
#> (Source:       options)
#> 
#> $per.sty
#> Definition:    digits=1, fmt="%", name="per", label="Percentage number format"
#> Example:       31415926.5%
#> (Source:       options)
#> 
#> $pval.sty
#> Definition:    fmt="p", eps=0.001, label="Number format for p-values"
#> Example:       NA
#> (Source:       options)
#> 
styles()[c("num.sty", "abs.sty")]   # numeric and integer styles
#> $num.sty
#> Definition:    digits=3, big.mark="", label="Number format for numeric values"
#> Example:       314159.265
#> (Source:       options)
#> 
#> $abs.sty
#> Definition:    digits=0, big.mark="", label="Number format for counts"
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
#> [1] 07, 11 2026
```
