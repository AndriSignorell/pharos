# Symbolic Unit Conversion Engine

Converts numeric values between units using a symbolic unit system,
SI-derived expansions, and graph-based conversion for non-SI units.

## Usage

``` r
convUnit(x, from, to, prefix = NULL, units = NULL)
```

## Arguments

- x:

  numeric value(s) to convert.

- from:

  character string specifying the source unit.

- to:

  character string specifying the target unit.

- prefix:

  data frame of SI prefixes with columns `abbr` and `mult`.

- units:

  data frame of unit conversion factors with columns `from`, `to`, and
  `fact`.

## Value

Numeric value(s) converted to the target unit.

## Details

Supports:

- SI base units (m, kg, s, A, K, mol, cd)

- Derived units (N, Pa, J, W, Hz)

- Prefixes (k, m, µ, etc.)

- Compound units (e.g. `"km/h"`, `"kg*m/s^2"`)

- Unit powers (e.g. `"m2"`, `"s^-1"`)

- Temperature conversion (C, F, K)

The function internally:

1.  Parses units into symbolic components

2.  Expands derived units (e.g. `N = kg*m/s^2`)

3.  Computes dimensional vectors

4.  Applies prefix scaling

5.  Uses a graph search (Dijkstra) for non-SI conversions

The function checks dimensional consistency before conversion. If units
are not compatible, an error is thrown.

For non-SI units (e.g. `"mi"`, `"bar"`), conversion paths are resolved
via a graph representation of `Units`.

Temperature conversions are handled separately and do not use
multiplicative scaling.

## See also

Other format:
[`fm()`](https://andrisignorell.github.io/aurora/reference/fm.md),
[`fmCI()`](https://andrisignorell.github.io/aurora/reference/fmCI.md),
[`print.Unit()`](https://andrisignorell.github.io/aurora/reference/print.Unit.md),
[`style()`](https://andrisignorell.github.io/aurora/reference/style.md),
[`unit()`](https://andrisignorell.github.io/aurora/reference/unit.md)

## Examples

``` r
convUnit(100, "km/h", "m/s")
#> [1] 27.77778

convUnit(1, "N", "kg*m/s^2")
#> [1] 1
convUnit(1, "Pa", "N/m^2")
#> [1] 1
convUnit(25, "C", "F")
#> [1] 77
convUnit(1, "ml", "l")
#> [1] 0.001
```
