# Format Numbers and Dates

Formatting numbers with base R tools often degenerates into a major
intellectual challenge for us little minds down here in the valley of
tears. There are a number of options available and quite often it's hard
to work out which one to use, when a more uncommon setting is needed.
The `fm()` function wraps all these functions and tries to offer a
simpler, less technical, but still flexible interface.

## Usage

``` r
fm(
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
  ...
)

# Default S3 method
fm(
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
  ...
)

# S3 method for class 'data.frame'
fm(
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
  ...
)

# S3 method for class 'matrix'
fm(
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
  ...
)

# S3 method for class 'table'
fm(
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
  ...
)

# S3 method for class 'ftable'
fm(
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
  ...
)
```

## Arguments

- x:

  a numeric, logical, character, factor, `Date`, or `POSIXt` vector, or
  a matrix, table, ftable, or data frame

- digits:

  integer, the desired (fixed) number of digits after the decimal point.
  Unlike [`formatC()`](https://rdrr.io/r/base/formatc.html) you will
  always get this number of digits even if the last digit is 0. Negative
  numbers of digits round to a power of ten (`digits=-2` would round to
  the nearest hundred) for standard numeric formats; engineering formats
  require nonnegative values

- leadDigits:

  number of leading zeros. `leadDigits=3` would make sure that at least
  3 digits on the left side will be printed, say `3.4` will be printed
  as `003.4`. Setting `leadDigits` to `0` will yield results like `.452`
  for `0.452`. The default `NULL` will leave the numbers as they are
  (meaning at least one 0 digit).

- sci:

  numeric scalar giving the absolute power-of-ten threshold for
  scientific notation. Its absolute value is used symmetrically: for
  `sci = 8`, nonzero values below \\10^{-8}\\ and values at or above
  \\10^8\\ are displayed scientifically. The default is based on
  `getOption("scipen")`; an option value of zero is replaced by 7

- bigMark:

  character; if not empty used as mark between every 3 decimals before
  the decimal point. Default is "" (none).

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

  a format code or date-time template, a formatting function, a named
  Style, or an object of class `Style`. See Details

- pThreshold:

  positive numeric threshold below which p-values are shown as
  `"< threshold"`

- width:

  nonnegative integer giving the minimum display width

- align:

  the character on whose position the strings will be aligned. Left
  alignment can be requested by setting `sep = "\\l"`, right alignment
  by `"\\r"` and center alignment by `"\\c"`. Mind the backslashes, as
  if they are omitted, strings would be aligned to the **character** l,
  r or c respectively. The default is `NULL` which would just leave the
  strings as they are.  
  This argument is send directly to the function
  [`strAlign()`](strAlign.md) as argument `sep`.

- lang:

  optional value setting the language for the months and daynames. Can
  be either `"local"` for current locale or `"en"` for english. If left
  to `NULL`, the package option `"lang"` is used, falling back to `"en"`

- ...:

  additional arguments passed to methods or to a formatting function
  supplied through `fmt`

## Value

formatted character values with the dimensions or tabular structure of
`x` preserved where applicable, of class `noquote` so that they print
without quotation marks. For a matrix or a table the entries are padded
to one common width unless `width` is given, so that the decimal points
line up: a character matrix prints left justified, which would otherwise
shift every negative entry against the positive ones.

## Details

There's also an easygoing interface for format templates, defined as a
list consisting of any accepted format features. This enables to define
templates globally and easily change or modify them later.

`fm()` is the workhorse for formatting numbers and dates, supporting a
comprehensive range of format options that are likely to occur in
everyday reporting. Among these, the argument `fmt` deserves a more
detailed description due to its flexibility. It is used to generate a
variety of different special formats.  
  
If `x` is a date, it can take ISO-8601-inspired token syntax similar to
.NET or Moment.js (consisting of `d`, `M` and `y` for day, month or year
and `h/H`, `m`, `s`, `t` for hours, minutes, seconds and AM/PM
designator) and defining the combination of day month and year
representation.  

|  |  |
|----|----|
| **Code**` ` | **Description** |
| `d ` | day of the month without leading zero (1 - 31) |
| `dd` | day of the month with leading zero (01 - 31) |
| `ddd` | abbreviated name for the day of the week (e.g. Mon) in the current user's language |
| `dddd` | full name for the day of the week (e.g. Monday) in the current user's language |
| `do` | The token `do` (aka 'day ordinal') formats the day of month using English ordinal suffixes (e.g. 1st, 2nd, 3rd, 4th). This is an English-only feature. (For most other languages, ordinal dates are written using punctuation in the format string, e.g. `"d. MMM yyyy"`. Locale-specific ordinal rules beyond English are not implemented by design.) |
| `M ` | month without leading zero (1 - 12) |
| `MM` | month with leading zero (01 - 12) |
| `MMM ` | abbreviated month name (e.g. Jan) in the current user's language |
| `MMMM` | full month name (e.g. January) in the current user's language |
| `y ` | year without century, without leading zero (0 - 99) |
| `yy ` | year without century, with leading zero (00 - 99) |
| `yyyy ` | year with century. For example: 2005 |
|  | `H/HH ` |
| Hour in 24h format, one digit / two digits | `h/hh ` |
| Hour in 12h format, one digit / two digits, note that in this case t must be set also to ensure uniqueness. | `t/tt ` |
| AM/PM description (one/two characters) | `m/mm ` |
| Minutes one digit / two digits | `s/ss ` |
| Seconds one digit / two digits |  |

Weekdays and month names can be expressed in the local language or in
English. The language can be controlled by the argument "`lang`".  

Even more variability is needed to display numeric values. For the most
frequently used formats there are the following special codes available:

|  |  |  |
|----|----|----|
| **Code** | **Type** | **Description** |
| `e` | scientific | forces scientific representation of x, e.g. 3.141e-05. The number of digits, |
|  |  | alignment and zero values are further respected. |
|  |  | `eng` |
| engineering | forces scientific representation of `x`, but only with powers that are a multiple of 3. | `engabb`` ` |
| engineering abbr.` ` | same as `eng`, but replaces the exponential representation by codes, |  |
|  | e.g. `M` for mega (1e6). | `\%` |
| percent | multiplies the given number by 100 and appends the \\ formats values as p-values. |  |
|  | Use `pThreshold` to define the threshold to e.g. switch to a `<0.001` representation. |  |
|  | `frac` | fractions |
| will (try to) convert numbers to fractions. So 0.1 will be displayed as 1/10. |  |  |
| See [`MASS::fractions()`](https://rdrr.io/pkg/MASS/man/fractions.html). |  |  |
| `*` | significance | will produce a significance representation of a p-value consisting of \* and ., |
|  |  | while the breaks are set according to the used defaults e.g. in `lm` as |
|  |  | `[0, 0.001]` = `***` |
|  |  | (0.001, 0.01`]` = `**` |
|  |  | (0.01, 0.05`]` = `*` |
|  |  | (0.05, 0.1`]` = `.` |
|  |  | (0.1,1`]` = ` ` |
| `p*` | p-value stars | will produce p-value and significance stars |

`fmt` can as well be an object of class "`Style`" consisting of a list
out of the arguments above (as created by [`style()`](style.md)). This
allows to store and manage the full format in variables or as options
and use it as format template subsequently. Arguments supplied directly
to `fm()` override the corresponding Style settings, including an
explicitly supplied `NULL`.

For data frames, every formatting argument must have length one or the
number of columns. Length-one arguments are recycled, allowing each
column to use its own formatting settings without ambiguous partial
recycling. Functions and Style objects count as single settings; use a
list to supply different functions or Styles by column.

Finally, `fmt` can be a function of `x`. Additional arguments in `\dots`
are forwarded to that function.

## See also

[base::format](https://rdrr.io/r/base/format.html),
[base::formatC](https://rdrr.io/r/base/formatc.html),
[base::prettyNum](https://rdrr.io/r/base/formatc.html),
[base::sprintf](https://rdrr.io/r/base/sprintf.html),
[stats::symnum](https://rdrr.io/r/stats/symnum.html),  
[base::Sys.setlocale](https://rdrr.io/r/base/locales.html),  
`DescToolsX::weekday`, `DescToolsX::month`, [theme](theme.md)

Other format: [`convUnit()`](convUnit.md), [`fmCI()`](fmCI.md),
[`print.Unit()`](print.Unit.md), [`style()`](style.md),
[`unit()`](unit.md)

## Examples

``` r

fm(as.Date(c("2014-11-28", "2014-1-2")), fmt="ddd, d mmmm yyyy")
#> [1] Fri, 28 0000 2014 Thu, 2 0000 2014 
fm(as.Date(c("2014-11-28", "2014-1-2")), fmt="ddd, d mmmm yyyy", lang="en")
#> [1] Fri, 28 0000 2014 Thu, 2 0000 2014 

# using english ordinal suffixes
fm(as.Date("2026-01-21"), fmt="MMMM do yyyy", lang="en")
#> [1] January 21st 2026
# e.g. in context:
gettextf("Report generated on %s", 
         fm(as.Date("2026-05-04"), fmt="MMMM do, yyyy", lang="en"))
#> [1] "Report generated on May 4th, 2026"

# numeric formats
x <- pi * 10^(-10:10)

fm(x, digits=3, fmt="%")
#>  [1] 3.142e-08%   0.000%       0.000%       0.000%       0.000%      
#>  [6] 0.003%       0.031%       0.314%       3.142%       31.416%     
#> [11] 314.159%     3141.593%    31415.927%   314159.265%  3141592.654%
#> [16] 3.142e+07%   3.142e+08%   3.142e+09%   3.142e+10%   3.142e+11%  
#> [21] 3.142e+12%  
fm(x, digits=4, sci=4, leadDigits=0, width=9, align=".")
#>  [1]     3.1416e-10     3.1416e-09     3.1416e-08     3.1416e-07     3.1416e-06
#>  [6]     3.1416e-05      .0003          .0031          .0314          .3142    
#> [11]     3.1416        31.4159       314.1593      3141.5927         3.1416e+04
#> [16]     3.1416e+05     3.1416e+06     3.1416e+07     3.1416e+08     3.1416e+09
#> [21]     3.1416e+10


# format a matrix
m <- matrix(runif(100), nrow=10,
            dimnames=list(LETTERS[1:10], LETTERS[1:10]))

fm(m, digits=1)
#>   A   B   C   D   E   F   G   H   I   J  
#> A 0.4 0.3 0.5 0.7 0.2 0.6 0.3 0.7 0.7 0.8
#> B 0.2 0.7 0.3 0.7 0.0 0.7 0.0 0.4 1.0 0.7
#> C 0.7 0.2 0.0 0.2 0.7 0.3 0.6 0.3 0.3 0.5
#> D 0.6 0.3 0.3 0.7 0.4 0.2 0.9 0.2 0.6 0.1
#> E 0.8 0.1 0.2 0.6 0.1 0.4 0.6 0.1 0.4 0.2
#> F 0.3 0.8 0.4 0.2 0.7 0.2 0.9 0.8 1.0 0.8
#> G 0.1 0.7 0.9 0.1 0.7 0.3 0.2 0.2 0.0 0.1
#> H 0.6 1.0 0.9 0.0 1.0 0.8 0.1 0.5 0.3 0.7
#> I 0.4 0.3 0.5 0.5 0.3 0.1 0.5 1.0 0.6 0.3
#> J 0.7 0.2 0.7 0.1 0.5 0.2 0.3 0.6 0.1 0.6

# engineering format
fm(x, fmt="eng",  digits=2)
#>  [1] 314.16e-12 3.14e-09   31.42e-09  314.16e-09 3.14e-06   31.42e-06 
#>  [7] 314.16e-06 3.14e-03   31.42e-03  314.16e-03 3.14e+00   31.42e+00 
#> [13] 314.16e+00 3.14e+03   31.42e+03  314.16e+03 3.14e+06   31.42e+06 
#> [19] 314.16e+06 3.14e+09   31.42e+09 
fm(x, fmt="engabb", leadDigits=2, digits=2)
#>  [1] 314.16 p 03.14 n  31.42 n  314.16 n 03.14 u  31.42 u  314.16 u 03.14 m 
#>  [9] 31.42 m  314.16 m 03.14    31.42    314.16   03.14 k  31.42 k  314.16 k
#> [17] 03.14 M  31.42 M  314.16 M 03.14 G  31.42 G 
# combine with grams [g]
paste(fm(x, fmt="engabb", leadDigits=2, digits=2), "g", sep="")
#>  [1] "314.16 pg" "03.14 ng"  "31.42 ng"  "314.16 ng" "03.14 ug"  "31.42 ug" 
#>  [7] "314.16 ug" "03.14 mg"  "31.42 mg"  "314.16 mg" "03.14g"    "31.42g"   
#> [13] "314.16g"   "03.14 kg"  "31.42 kg"  "314.16 kg" "03.14 Mg"  "31.42 Mg" 
#> [19] "314.16 Mg" "03.14 Gg"  "31.42 Gg" 

# example form symnum
pval <- rev(sort(c(outer(1:6, 10^-(1:3)))))
noquote(cbind(fm(pval, fmt="p"), fm(pval, fmt="*")))
#>       [,1]  [,2]
#>  [1,] 0.600     
#>  [2,] 0.500     
#>  [3,] 0.400     
#>  [4,] 0.300     
#>  [5,] 0.200     
#>  [6,] 0.100 .   
#>  [7,] 0.060 .   
#>  [8,] 0.050 *   
#>  [9,] 0.040 *   
#> [10,] 0.030 *   
#> [11,] 0.020 *   
#> [12,] 0.010 **  
#> [13,] 0.006 **  
#> [14,] 0.005 **  
#> [15,] 0.004 **  
#> [16,] 0.003 **  
#> [17,] 0.002 **  
#> [18,] 0.001 *** 

# change the character to be used as the decimal point
fm(1200, digits=2, bigMark = ".", decMark=",")
#> [1] 1.200,00
```
