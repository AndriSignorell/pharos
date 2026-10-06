# String Functions in pharos

pharos provides a family of functions for manipulating and inspecting
character strings, built on top of stringi for Unicode-aware behavior.
They fall into two groups:

**Manipulation** – transform, extract, or reshape string content:

|  |  |
|----|----|
| Function | Purpose |
| [`strAbbr()`](strAbbr.md) | Abbreviate strings uniquely |
| [`strAlign()`](strAlign.md) | Align strings |
| [`strCap()`](strCap.md) | Capitalize strings |
| [`strChop()`](strChop.md) | Split a string into a number of sections of defined length |
| [`strExtract()`](strExtract.md) | Extract first match from strings |
| [`strExtractBetween()`](strExtractBetween.md) | Extract substrings between patterns |
| [`strLeft()`](strLeftRight.md) / [`strRight()`](strLeftRight.md) | Return the left or the right part of a string |
| [`strPad()`](strPad.md) | Pad a string with justification |
| [`strRev()`](strRev.md) | Reverse strings |
| [`strSpell()`](strSpell.md) | Spell strings using phonetic alphabets |
| [`strSplit()`](strSplit.md) | Split strings |
| [`strTrim()`](strTrim.md) | Remove leading/trailing whitespace from a string |
| [`strTrunc()`](strTrunc.md) | Truncate strings and add ellipses if a string is truncated |
| [`strVal()`](strVal.md) | Extract numeric values from strings |

**Information** – inspect properties of strings without changing them:

|  |  |
|----|----|
| Function | Purpose |
| [`strCountWords()`](strCountWords.md) | Count words in strings |
| [`strDist()`](strDist.md) | Compute distances between strings |
| [`strIsNumeric()`](strIsNumeric.md) | Check if character strings represent numeric values |
| [`strLen()`](strLen.md) | String length |
| [`strPos()`](strPos.md) | Find position of first occurrence of a string |

## See also

[`base::substr()`](https://rdrr.io/r/base/substr.html)
