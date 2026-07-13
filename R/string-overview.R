#' String Functions in lyra
#'
#' @description
#' lyra provides a family of functions for manipulating and inspecting
#' character strings, built on top of \pkg{stringi} for Unicode-aware
#' behavior. They fall into two groups:
#'
#' **Manipulation** -- transform, extract, or reshape string content:
#'
#' | Function | Purpose |
#' |---|---|
#' | [strAbbr()] | Abbreviate strings uniquely |
#' | [strAlign()] | Align strings |
#' | [strCap()] | Capitalize strings |
#' | [strChop()] | Split a string into a number of sections of defined length |
#' | [strExtract()] | Extract first match from strings |
#' | [strExtractBetween()] | Extract substrings between patterns |
#' | [strLeft()] / [strRight()] | Return the left or the right part of a string |
#' | [strPad()] | Pad a string with justification |
#' | [strRev()] | Reverse strings |
#' | [strSpell()] | Spell strings using phonetic alphabets |
#' | [strSplit()] | Split strings |
#' | [strTrim()] | Remove leading/trailing whitespace from a string |
#' | [strTrunc()] | Truncate strings and add ellipses if a string is truncated |
#' | [strVal()] | Extract numeric values from strings |
#'
#' **Information** -- inspect properties of strings without changing them:
#'
#' | Function | Purpose |
#' |---|---|
#' | [strCountW()] | Count words in strings |
#' | [strDist()] | Compute distances between strings |
#' | [strIsNumeric()] | Check if character strings represent numeric values |
#' | [strLen()] | String length |
#' | [strPos()] | Find position of first occurrence of a string |
#'
#' @name string-overview
#' @seealso [base::substr()]
NULL
