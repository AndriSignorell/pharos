# Preview an Object

Generic function for an explicit, on-demand preview of an object, as
distinct from [`print()`](https://rdrr.io/r/base/print.html).
`preview()` exists for object types where
[`print()`](https://rdrr.io/r/base/print.html) is shared with another
package's S3 generic dispatch (e.g. class `"html"`, used both by pharos
and htmltools for genuinely different purposes), so that registering an
own `print.*` method would silently overwrite - or be overwritten by -
the other package's behaviour.

## Usage

``` r
preview(x, ...)

# Default S3 method
preview(x, ...)
```

## Arguments

- x:

  object to preview.

- ...:

  further arguments passed to methods.

## Value

`x`, invisibly. Called for its side effect of displaying the object.

## Details

The default method simply calls
[`print()`](https://rdrr.io/r/base/print.html), so `preview()` is always
safe to call even for types with no dedicated method.

## See also

[`asHtml()`](asHtml.md)

## Examples

``` r
# without a dedicated method the object is simply printed
preview(1:3)
#> [1] 1 2 3

# HTML markup is rendered as text
preview(asHtml("<b>Note:</b> R<sup>2</sup> = 0.87"))
#> Note: R^2 = 0.87 
```
