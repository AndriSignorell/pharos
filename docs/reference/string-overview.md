# String Functions in lyra

lyra provides a family of functions for manipulating and inspecting
character strings, built on top of stringi for Unicode-aware behavior.
They fall into two groups:

**Manipulation** – transform, extract, or reshape string content:

|  |  |
|----|----|
| Function | Purpose |
| [`strAbbr()`](https://andrisignorell.github.io/aurora/reference/strAbbr.md) | Abbreviate strings uniquely |
| [`strAlign()`](https://andrisignorell.github.io/aurora/reference/strAlign.md) | Align strings |
| [`strCap()`](https://andrisignorell.github.io/aurora/reference/strCap.md) | Capitalize strings |
| [`strChop()`](https://andrisignorell.github.io/aurora/reference/strChop.md) | Split a string into a number of sections of defined length |
| [`strExtract()`](https://andrisignorell.github.io/aurora/reference/strExtract.md) | Extract first match from strings |
| [`strExtractBetween()`](https://andrisignorell.github.io/aurora/reference/strExtractBetween.md) | Extract substrings between patterns |
| [`strLeft()`](https://andrisignorell.github.io/aurora/reference/strLeftRight.md) / [`strRight()`](https://andrisignorell.github.io/aurora/reference/strLeftRight.md) | Return the left or the right part of a string |
| [`strPad()`](https://andrisignorell.github.io/aurora/reference/strPad.md) | Pad a string with justification |
| [`strRev()`](https://andrisignorell.github.io/aurora/reference/strRev.md) | Reverse strings |
| [`strSpell()`](https://andrisignorell.github.io/aurora/reference/strSpell.md) | Spell strings using phonetic alphabets |
| [`strSplit()`](https://andrisignorell.github.io/aurora/reference/strSplit.md) | Split strings |
| [`strTrim()`](https://andrisignorell.github.io/aurora/reference/strTrim.md) | Remove leading/trailing whitespace from a string |
| [`strTrunc()`](https://andrisignorell.github.io/aurora/reference/strTrunc.md) | Truncate strings and add ellipses if a string is truncated |
| [`strVal()`](https://andrisignorell.github.io/aurora/reference/strVal.md) | Extract numeric values from strings |

**Information** – inspect properties of strings without changing them:

|  |  |
|----|----|
| Function | Purpose |
| [`strCountW()`](https://andrisignorell.github.io/aurora/reference/strCountW.md) | Count words in strings |
| [`strDist()`](https://andrisignorell.github.io/aurora/reference/strDist.md) | Compute distances between strings |
| [`strIsNumeric()`](https://andrisignorell.github.io/aurora/reference/strIsNumeric.md) | Check if character strings represent numeric values |
| [`strLen()`](https://andrisignorell.github.io/aurora/reference/strLen.md) | String length |
| [`strPos()`](https://andrisignorell.github.io/aurora/reference/strPos.md) | Find position of first occurrence of a string |

## See also

[`base::substr()`](https://rdrr.io/r/base/substr.html)
