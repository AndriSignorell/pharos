# Returns the Left Or the Right Part Of a String

Returns the left part or the right part of a string. The number of
characters are defined by the argument `n`. If `n` is negative, this
number of characters will be cut off from the other side.

## Usage

``` r
strLeft(x, n)

strRight(x, n)
```

## Arguments

- x:

  a vector of strings

- n:

  a positive or a negative integer, the number of characters to cut. If
  n is negative, this number of characters will be cut off from the
  right with `strLeft` and from the left with `strRight`.  
  n will be recycled.

## Value

the left (right) n characters of x

## Details

The functions `strLeft` and `strRight` are simple wrappers to `substr`.

## See also

[string-overview](https://andrisignorell.github.io/aurora/reference/string-overview.md)
for an overview of all string utilities in lyra.

## Examples

``` r

strLeft("Hello world!", n=5)
#> [1] "Hello"
strLeft("Hello world!", n=-5)
#> [1] "Hello w"

strRight("Hello world!", n=6)
#> [1] "world!"
strRight("Hello world!", n=-6)
#> [1] "world!"

strLeft(c("Lorem", "ipsum", "dolor","sit","amet"), n=2)
#> [1] "Lo" "ip" "do" "si" "am"

strRight(c("Lorem", "ipsum", "dolor","sit","amet"), n=c(2,3))
#> [1] "em"  "sum" "or"  "sit" "et" 


```
