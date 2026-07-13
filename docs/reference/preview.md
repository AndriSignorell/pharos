# Preview an Object

Generic function for an explicit, on-demand preview of an object, as
distinct from [`print()`](https://rdrr.io/r/base/print.html).
`preview()` exists for object types where
[`print()`](https://rdrr.io/r/base/print.html) is shared with another
package's S3 generic dispatch (e.g. class `"html"`, used both by lyra
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

## Details

The default method simply calls
[`print()`](https://rdrr.io/r/base/print.html), so `preview()` is always
safe to call even for types with no dedicated method.

## See also

[`as.html`](https://andrisignorell.github.io/aurora/reference/as.html.md)
