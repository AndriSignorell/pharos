# Names a Style may carry that describe the Style itself rather than an
# argument of fm(). Single source of truth for fm() and style() - keep the
# two in step; it is the only reason a Style may hold a name that fm() does
# not know.
#' @noRd
.styleMetaNames <- c("label", "name")


# Argument names of DescTools' Format() that were renamed in fm(). Used only
# to make the "unknown component" messages actionable - nothing is translated
# silently, the old names remain invalid.
#' @noRd
.styleLegacyNames <- c(big.mark = "bigMark", decimal.mark = "decMark",
                       dec.mark = "decMark", ldigits = "leadDigits",
                       na.form = "naForm", zero.form = "zeroForm")


# Quote unknown names and add "did you mean" for known renamings
#' @noRd
.unknownNamesMsg <- function(x) {
  hint <- .styleLegacyNames[x]
  paste(sQuote(x),
        ifelse(is.na(hint), "", gettextf(" (did you mean %s?)", sQuote(hint))),
        sep = "", collapse = ", ")
}


#' Format Numbers and Dates
#' 
#' Formatting numbers with base R tools often degenerates into a major
#' intellectual challenge for us little minds down here in the valley of tears.
#' There are a number of options available and quite often it's hard to work
#' out which one to use, when a more uncommon setting is needed. The
#' `fm()` function wraps all these functions and tries to offer a simpler,
#' less technical, but still flexible interface.
#' 
#' There's also an easygoing interface for format templates, defined as a list
#' consisting of any accepted format features. This enables to define templates
#' globally and easily change or modify them later.
#' 
#' `fm()` is the workhorse for formatting numbers and dates, supporting a
#' comprehensive range of format options that are likely to occur in everyday
#' reporting. Among these, the argument `fmt` deserves a more detailed
#' description due to its flexibility. It is used to generate a variety of
#' different special formats. \cr\cr If `x` is a date, it can take
#' ISO-8601-inspired token syntax similar to .NET or Moment.js (consisting of
#' `d`, `M` and `y` for day, month or year and `h/H`,
#' `m`, `s`, `t` for hours, minutes, seconds and AM/PM
#' designator) and defining the combination of day month and year
#' representation.\cr
#' 
#' \tabular{ll}{ **Code**\verb{ } \tab **Description**\cr `d ` \tab
#' day of the month without leading zero (1 - 31) \cr `dd` \tab day of the
#' month with leading zero (01 - 31)\cr `ddd` \tab abbreviated name for
#' the day of the week (e.g. Mon) in the current user's language \cr
#' `dddd` \tab full name for the day of the week (e.g. Monday) in the
#' current user's language \cr `do` \tab The token `do` (aka 'day
#' ordinal') formats the day of month using English ordinal suffixes (e.g. 1st,
#' 2nd, 3rd, 4th). This is an English-only feature. (For most other languages,
#' ordinal dates are written using punctuation in the format string, e.g.
#' `"d. MMM yyyy"`. Locale-specific ordinal rules beyond English are not
#' implemented by design.)\cr `M ` \tab month without leading zero (1 -
#' 12) \cr `MM` \tab month with leading zero (01 - 12) \cr `MMM `
#' \tab abbreviated month name (e.g. Jan) in the current user's language \cr
#' `MMMM` \tab full month name (e.g. January) in the current user's
#' language \cr `y ` \tab year without century, without leading zero (0 -
#' 99) \cr `yy ` \tab year without century, with leading zero (00 - 99)
#' \cr `yyyy ` \tab year with century. For example: 2005 \cr\cr `H/HH
#' ` \tab Hour in 24h format, one digit / two digits \cr `h/hh ` \tab Hour
#' in 12h format, one digit / two digits, note that in this case t must be set
#' also to ensure uniqueness.\cr `t/tt ` \tab AM/PM description (one/two
#' characters)\cr `m/mm ` \tab Minutes one digit / two digits\cr
#' `s/ss ` \tab Seconds one digit / two digits\cr
#' 
#' \cr } Weekdays and month names can be expressed in the local language or in
#' English. The language can be controlled by the argument "`lang`".\cr
#' 
#' Even more variability is needed to display numeric values. For the most
#' frequently used formats there are the following special codes available:
#' \tabular{lll}{ **Code** \tab **Type** \tab **Description** \cr
#' `e` \tab scientific \tab forces scientific representation of x, e.g.
#' 3.141e-05. The number of digits,\cr \tab \tab alignment and zero values are
#' further respected.\cr \tab\cr
#' 
#' `eng` \tab engineering \tab forces scientific representation of
#' `x`, but only with powers that are a multiple of 3. \cr
#' `engabb`\verb{ } \tab engineering abbr.\verb{ } \tab same as
#' `eng`, but replaces the exponential representation by codes, \cr
#' \tab\tab e.g. `M` for mega (1e6). \cr
#' 
#' `\%` \tab percent \tab multiplies the given number by 100 and appends
#' the \%-sign (without a separator).\cr \tab\cr `p` \tab p-value \tab
#' formats values as p-values. \cr \tab \tab Use `pThreshold` to define
#' the threshold to e.g.
#' switch to a ` <0.001 ` representation.\cr \tab\cr `frac` \tab
#' fractions \tab will (try to) convert numbers to fractions. So 0.1 will be
#' displayed as 1/10. \cr \tab\tab See [MASS::fractions()].\cr
#' \tab\cr
#' 
#' `*` \tab significance \tab will produce a significance representation
#' of a p-value consisting of * and ., \cr \tab \tab while the breaks are set
#' according to the used defaults e.g. in `lm` as \cr \tab \tab \verb{[0, 0.001]}
#' = `***` \cr \tab \tab (0.001, 0.01\verb{]} = `**` \cr \tab \tab (0.01,
#' 0.05\verb{]} = `*` \cr \tab \tab (0.05, 0.1\verb{]} = `.` \cr \tab \tab (0.1,1\verb{]}
#' = ` `\cr
#' 
#' `p*`\tab p-value stars\tab will produce p-value and significance stars
#' 
#' }
#' 
#' `fmt` can as well be an object of class "`Style`" consisting of a
#' list out of the arguments above (as created by [style()]). This
#' allows to store and manage the full format in variables or as options and
#' use it as format template subsequently. Arguments supplied directly to
#' `fm()` override the corresponding Style settings, including an
#' explicitly supplied `NULL`.
#' 
#' For data frames, every formatting argument must have length one or the
#' number of columns. Length-one arguments are recycled, allowing each column
#' to use its own formatting settings without ambiguous partial recycling.
#' Functions and Style objects count as single settings; use a list to supply
#' different functions or Styles by column.
#'
#' Finally, `fmt` can be a function of `x`. Additional arguments in
#' `\dots` are forwarded to that function.
#'
#' @param x a numeric, logical, character, factor, `Date`, or
#'   `POSIXt` vector, or a matrix, table, ftable, or data frame
#' @param digits integer, the desired (fixed) number of digits after the
#' decimal point. Unlike [formatC()] you will always get this number
#' of digits even if the last digit is 0.  Negative numbers of digits round to
#' a power of ten (`digits=-2` would round to the nearest hundred) for
#' standard numeric formats; engineering formats require nonnegative values
#' @param leadDigits number of leading zeros. `leadDigits=3` would make sure
#' that at least 3 digits on the left side will be printed, say `3.4` will
#' be printed as `003.4`. Setting `leadDigits` to `0` will yield
#' results like `.452` for `0.452`. The default `NULL` will
#' leave the numbers as they are (meaning at least one 0 digit).
#' @param sci numeric scalar giving the absolute power-of-ten threshold for
#'   scientific notation. Its absolute value is used symmetrically: for
#'   `sci = 8`, nonzero values below \eqn{10^{-8}} and values at or above
#'   \eqn{10^8} are displayed scientifically. The default is based on
#'   `getOption("scipen")`; an option value of zero is replaced by 7
#' @param bigMark character; if not empty used as mark between every 3
#' decimals before the decimal point. Default is "" (none).
#' @param decMark character specifying the decimal mark. If `NULL`, the
#'   current `OutDec` option is used
#' @param naForm character, string specifying how `NA`s should be
#' specially formatted.  If set to `NULL` (default) no special action will
#' be taken.
#' @param zeroForm character, string specifying how zeros should be specially
#' formatted. Useful for pretty printing 'sparse' objects.  If set to
#' `NULL` (default) no special action will be taken.
#' @param fmt a format code or date-time template, a formatting function, a
#'   named Style, or an object of class `Style`. See Details
#' @param pThreshold positive numeric threshold below which p-values are shown
#'   as `"< threshold"`
#' @param width nonnegative integer giving the minimum display width
#' @param align the character on whose position the strings will be aligned.
#' Left alignment can be requested by setting `sep = "\\l"`, right
#' alignment by `"\\r"` and center alignment by `"\\c"`. Mind the
#' backslashes, as if they are omitted, strings would be aligned to the
#' **character** l, r or c respectively. The default is `NULL` which
#' would just leave the strings as they are.\cr This argument is send directly
#' to the function [pharos::strAlign()] as argument `sep`.
#' @param lang optional value setting the language for the months and daynames.
#' Can be either `"local"` for current locale or `"en"` for english.
#' If left to `NULL`, the package option `"lang"` is used, falling
#' back to `"en"`
#' @param \dots additional arguments passed to methods or to a formatting
#'   function supplied through `fmt`
#' @return formatted character values with the dimensions or tabular structure
#'   of `x` preserved where applicable, of class `noquote` so that
#'   they print without quotation marks. For a matrix or a table the entries
#'   are padded to one common width unless `width` is given, so that the
#'   decimal points line up: a character matrix prints left justified, which
#'   would otherwise shift every negative entry against the positive ones.
#' @examples
#' 
#' fm(as.Date(c("2014-11-28", "2014-1-2")), fmt="ddd, d mmmm yyyy")
#' fm(as.Date(c("2014-11-28", "2014-1-2")), fmt="ddd, d mmmm yyyy", lang="en")
#' 
#' # using english ordinal suffixes
#' fm(as.Date("2026-01-21"), fmt="MMMM do yyyy", lang="en")
#' # e.g. in context:
#' gettextf("Report generated on %s", 
#'          fm(as.Date("2026-05-04"), fmt="MMMM do, yyyy", lang="en"))
#' 
#' # numeric formats
#' x <- pi * 10^(-10:10)
#' 
#' fm(x, digits=3, fmt="%")
#' fm(x, digits=4, sci=4, leadDigits=0, width=9, align=".")
#' 
#' 
#' # format a matrix
#' m <- matrix(runif(100), nrow=10,
#'             dimnames=list(LETTERS[1:10], LETTERS[1:10]))
#' 
#' fm(m, digits=1)
#' 
#' # engineering format
#' fm(x, fmt="eng",  digits=2)
#' fm(x, fmt="engabb", leadDigits=2, digits=2)
#' # combine with grams [g]
#' paste(fm(x, fmt="engabb", leadDigits=2, digits=2), "g", sep="")
#' 
#' # example form symnum
#' pval <- rev(sort(c(outer(1:6, 10^-(1:3)))))
#' noquote(cbind(fm(pval, fmt="p"), fm(pval, fmt="*")))
#' 
#' # change the character to be used as the decimal point
#' fm(1200, digits=2, bigMark = ".", decMark=",")
#' 
#' @seealso [base::format], [base::formatC],
#' [base::prettyNum], [base::sprintf], [stats::symnum],\cr
#' [base::Sys.setlocale],\cr `DescToolsX::weekday`, 
#' `DescToolsX::month`,
#' [theme]
#' 
#' @family format  
#' @concept formatting  
#' @concept number-formatting
#'
#'
#' @export  
fm <- function(x, digits = NULL, leadDigits = NULL, 
               sci = NULL,
               bigMark = NULL, decMark = NULL,
               naForm = NULL, zeroForm = NULL,
               fmt = NULL, pThreshold = NULL,
               width = NULL, align = NULL,
               lang = NULL, ...) {
  UseMethod("fm")
}



#' @rdname fm
#' @export
fm.default <- function(x, digits = NULL, leadDigits = NULL, sci = NULL,
                       bigMark = NULL, decMark = NULL,
                       naForm = NULL, zeroForm = NULL,
                       fmt = NULL, pThreshold = NULL,
                       width = NULL, align = NULL,
                       lang = NULL, ...) {

  specialFormats <- c("*", "p", "p*", "eng", "engabb", "e", "%", "frac")

  if (!(is.null(fmt) || is.function(fmt) || inherits(fmt, "Style") ||
        (is.character(fmt) && length(fmt) == 1L && !is.na(fmt)))) {
    stop("'fmt' must be NULL, one character string, a function, or a Style",
         call. = FALSE)
  }

  # Resolve a named Style before touching x. This ensures that all Style
  # settings, including naForm, align, and lang, see the original input.
  if (is.character(fmt) && !fmt %in% specialFormats) {
    availableStyles <- styles()
    if (fmt %in% names(availableStyles)) {
      fmt <- availableStyles[[fmt]]
      if (!inherits(fmt, "Style"))
        stop("a named Style must inherit from 'Style'", call. = FALSE)
    }
  }

  if (inherits(fmt, "Style")) {
    styleArgs <- unclass(fmt)
    if (!is.list(styleArgs) || is.null(names(styleArgs)) ||
        any(!nzchar(names(styleArgs))) || anyDuplicated(names(styleArgs)))
      stop("a Style must be a named list", call. = FALSE)

    # An argument the caller gave explicitly overrides the Style. What
    # counts as "given" cannot be read off match.call() alone: the methods
    # for matrix, table and ftable pass EVERY formal on by name, NULL
    # included, so match.call() reported all of them as supplied and the
    # loop below then assigned NULL - which deletes a list element and
    # thereby wiped the Style clean. fm(pi, fmt = "num.sty") honoured
    # digits = 3, fm(cor(swiss), fmt = "num.sty") silently did not.
    #
    # NULL means "not specified" for every one of these arguments, so a
    # NULL value is not an override no matter how it arrived. There is
    # consequently no way to say "ignore the Style's digits and use fm's
    # own default" - that would need a sentinel, and no caller has asked
    # for it.
    supplied <- names(match.call(expand.dots = FALSE))
    supplied <- intersect(
      supplied,
      setdiff(names(formals(fm.default)), c("x", "fmt", "..."))
    )

    for (arg in supplied) {
      value <- get(arg, inherits = FALSE)
      if (!is.null(value))
        styleArgs[[arg]] <- value
    }

    styleArgs[["x"]] <- NULL

    # Components that describe the Style itself instead of parametrising
    # fm(). They are dropped here rather than passed on.
    styleArgs <- styleArgs[!names(styleArgs) %in% .styleMetaNames]

    # Everything else is passed on as an argument of fm(). A name that is
    # neither metadata nor an argument lands in '...' of the recursive call,
    # where it produces
    #   "'...' is only available when 'fmt' is a function"
    # - a message that names neither the Style nor the offending component,
    # and that appears wherever the Style happens to be used rather than
    # where it was built. Report it here instead, with the name.
    unknown <- setdiff(names(styleArgs),
                       setdiff(names(formals(fm.default)), c("x", "...")))
    if (length(unknown)) {
      # Not an error: a Style can come from options(), from an older version
      # of the suite or from another package, and refusing to format would
      # take down otherwise valid output - including print.Style(), which
      # formats an example and would then no longer be able to show what is
      # wrong. Drop the component and say so. style() still refuses to build
      # such a Style in the first place, where the mistake can be fixed.
      warning(gettextf(
        "ignoring Style component(s) that are neither arguments of fm() nor style metadata: %s",
        .unknownNamesMsg(unknown)), call. = FALSE)
      styleArgs <- styleArgs[!names(styleArgs) %in% unknown]
    }

    return(do.call(fm, c(list(x = x), styleArgs, list(...))))
  }

  dots <- list(...)
  if (length(dots) && !is.function(fmt)) {
    # Name the arguments. This message has now been reached three times from
    # three different causes (a Style component, a style() dots entry, a
    # legacy argument name in a direct call), and each time it named neither
    # the argument nor anything else one could act on.
    nms <- names(dots)
    nms <- if (is.null(nms)) "<unnamed>" else ifelse(nzchar(nms), nms, "<unnamed>")
    stop(gettextf("unused argument(s) %s: '...' is only available when 'fmt' is a function",
                  paste(sQuote(nms), collapse = ", ")), call. = FALSE)
  }

  .validateScalar <- function(value, name, mode = c("numeric", "character"),
                              integer = FALSE, lower = -Inf, upper = Inf) {
    if (is.null(value)) return(invisible(NULL))

    mode <- match.arg(mode)
    validType <- if (mode == "numeric") is.numeric(value) else is.character(value)
    valid <- validType && length(value) == 1L && !is.na(value)

    if (mode == "numeric") {
      valid <- valid && is.finite(value) && value >= lower && value <= upper
      if (integer) valid <- valid && value == trunc(value)
    }

    if (!valid)
      stop(gettextf("'%s' must be one valid %s value", name, mode),
           call. = FALSE)
  }

  .validateScalar(digits, "digits", integer = TRUE)
  .validateScalar(leadDigits, "leadDigits", integer = TRUE, lower = 0)
  .validateScalar(sci, "sci")
  .validateScalar(bigMark, "bigMark", mode = "character")
  .validateScalar(decMark, "decMark", mode = "character")
  .validateScalar(naForm, "naForm", mode = "character")
  .validateScalar(zeroForm, "zeroForm", mode = "character")
  .validateScalar(pThreshold, "pThreshold", lower = 0, upper = 1)
  .validateScalar(width, "width", integer = TRUE, lower = 0)
  .validateScalar(align, "align", mode = "character")
  .validateScalar(lang, "lang", mode = "character")

  if (!is.null(lang) && !lang %in% c("en", "local"))
    stop("'lang' must be 'en' or 'local'", call. = FALSE)

  if (!is.null(pThreshold) && pThreshold == 0)
    stop("'pThreshold' must be greater than zero", call. = FALSE)

  if (!is.null(decMark) && nchar(decMark, type = "chars") != 1L)
    stop("'decMark' must contain exactly one character", call. = FALSE)

  if (inherits(x, "POSIXlt"))
    x <- as.POSIXct(x)

  if (is.list(x))
    stop("'x' must be an atomic vector, not a list", call. = FALSE)

  isDateTime <- inherits(x, c("Date", "POSIXct", "POSIXt"))
  isText <- is.character(x) || is.factor(x) || is.logical(x)
  isNumber <- is.numeric(x) && !is.complex(x) && !isDateTime

  if (!isDateTime && !isText && !isNumber)
    stop("'x' must be numeric, logical, character, factor, Date, or POSIXt",
         call. = FALSE)

  # A character 'fmt' that is neither a special code nor a registered Style
  # warns and falls back to the default format: fm() is called deep inside
  # report functions (tOne(), desc()), where one mistyped or not-yet-
  # registered style name would otherwise take down a whole table.
  #
  # ONLY for numeric x. For a Date or POSIXct every string is a legal format
  # (see .formatDateTime(), which owns its own token grammar and reports an
  # unknown token itself), and for character/factor/logical a non-NULL 'fmt'
  # is refused further down. Checking this before isNumber is known would
  # reject "yyyy-MM-dd" as an unknown format code.
  #
  # The position is still ahead of the early return for an empty or all-NA
  # 'x', so the message does not depend on whether there are data.
  if (isNumber && is.character(fmt) && !fmt %in% specialFormats) {
    warning(gettextf("unknown format code '%s' in 'fmt'; using the default format",
                     fmt), call. = FALSE)
    fmt <- NULL
  }

  if (!is.null(decMark)) {
    oldOptions <- options(OutDec = decMark)
    on.exit(options(oldOptions), add = TRUE)
  }

  if (is.null(naForm)) naForm <- NA_character_
  if (is.null(bigMark)) bigMark <- getOption("bigMark", "")
  if (is.null(leadDigits)) leadDigits <- 1L
  if (is.null(pThreshold)) pThreshold <- 1e-3

  sciDefault <- coalesceX(naIf(getOption("scipen"), 0), 7)
  if (is.null(sci)) sci <- sciDefault

  .validateScalar(bigMark, "bigMark", mode = "character")
  .validateScalar(sci, "sci")
  sci <- abs(sci)

  originalNames <- names(x)
  missing <- is.na(x)
  values <- x[!missing]

  if (!length(values)) {
    result <- rep.int(naForm, length(x))
    result <- .finishFormat(result, width = width, align = align,
                            objectNames = originalNames)
    return(noquote(result))
  }

  zero <- if (isNumber) isZero(values) else rep.int(FALSE, length(values))

  if (is.function(fmt)) {
    result <- do.call(fmt, c(list(values), dots))

  } else if (isDateTime) {
    if (is.null(fmt)) {
      result <- format(values)
    } else {
      if (is.null(lang)) lang <- .getOption("lang", "en")

      .validateScalar(lang, "lang", mode = "character")
      if (!lang %in% c("en", "local"))
        stop("'lang' must be 'en' or 'local'", call. = FALSE)

      if (lang == "en") {
        oldLocale <- Sys.getlocale("LC_TIME")
        Sys.setlocale("LC_TIME", "C")
        on.exit(Sys.setlocale("LC_TIME", oldLocale), add = TRUE)
      }

      result <- .formatDateTime(values, fmt = fmt, strict = TRUE,
                                locale = "current")
    }

  } else if (isText) {
    if (!is.null(fmt))
      stop("character, factor, and logical values require 'fmt = NULL' or a function",
           call. = FALSE)
    result <- as.character(values)

  } else if (is.null(fmt)) {
    if (is.null(digits)) digits <- max(.countDecimals(values))

    result <- formatNum_cpp(values, digits = digits, leadDigits = leadDigits,
                        bigMark = bigMark, sciSmall = -sci, sciBig = sci)

  } else {
    result <- switch(
      fmt,
      "*" = .formatStars(values),
      "p" = .formatPval(values, pThreshold = pThreshold,
                         digits = digits %||% 3L, leadDigits = leadDigits),
      "p*" = .formatPstars(values, pThreshold = pThreshold,
                            digits = digits %||% 3L, leadDigits = leadDigits),
      "eng" = .formatEng(values, digits = digits,
                          leadDigits = leadDigits, bigMark = bigMark),
      "engabb" = .formatEngabb(values, digits = digits,
                                leadDigits = leadDigits, bigMark = bigMark),
      "e" = formatNum_cpp(values, digits = digits, leadDigits = leadDigits,
                       bigMark = bigMark, sciSmall = 0, sciBig = 0),
      "%" = paste0(
        formatNum_cpp(values * 100, digits = digits %||% 1L,
                  leadDigits = leadDigits, bigMark = bigMark,
                  sciSmall = -sci, sciBig = sci),
        "%"
      ),
      "frac" = as.character(MASS::fractions(values)),
      # unreachable: anything not in 'specialFormats' was turned into NULL
      # above. Kept so that the two lists cannot drift apart unnoticed.
      stop(gettextf("unknown format code '%s'", fmt), call. = FALSE)
    )
  }

  if (length(result) != length(values))
    stop("the formatter must return exactly one value for each element of 'x'",
         call. = FALSE)

  result <- as.character(result)
  if (!is.null(zeroForm) && any(zero)) result[zero] <- zeroForm

  if (any(missing)) {
    complete <- rep.int(NA_character_, length(x))
    complete[!missing] <- result
    complete[missing] <- naForm
    result <- complete
  }

  result <- .finishFormat(result, width = width, align = align,
                          objectNames = originalNames)

  noquote(result)
}




#' @rdname fm
#' @export
#' @export
fm.data.frame <- function(x,
                          digits = NULL, leadDigits = NULL, sci = NULL,
                          bigMark = NULL, decMark = NULL,
                          naForm = NULL, zeroForm = NULL,
                          fmt = NULL, pThreshold = NULL,
                          width = NULL, align = NULL,
                          lang = NULL, ...) {
  
  n <- ncol(x)
  
  ## --- collect optional formatting arguments ----------------------
  args <- list(
    digits     = digits,
    leadDigits   = leadDigits,
    sci        = sci,
    bigMark  = bigMark,
    decMark    = decMark,
    naForm   = naForm,
    zeroForm = zeroForm,
    fmt        = fmt,
    pThreshold      = pThreshold,
    width      = width,
    align      = align,
    lang       = lang
  )
  
  ## drop NULL arguments
  args <- args[!vapply(args, is.null, logical(1))]
  
  ## recycle each argument to ncol(x)
  args <- Map(
    function(a, nm) .recycle_to_ncol(a, n, nm),
    args,
    names(args)
  )
  
  ## --- apply fm column-wise ---------------------------------------
  for (i in seq_len(n)) {
    
    col_args <- lapply(args, `[[`, i)
    
    x[[i]] <- do.call(
      fm,
      c(list(x[[i]]), col_args)
    )
  }
  
  x
}



#' @rdname fm
#' @export
fm.matrix <- function(x, digits = NULL, leadDigits = NULL, sci = NULL, 
                      bigMark = NULL, decMark = NULL, naForm = NULL, 
                      zeroForm = NULL, fmt = NULL, pThreshold = NULL, 
                      width = NULL, align = NULL, lang = NULL, ...) {
  dn <- dimnames(x)
  d  <- dim(x)
  result <- fm.default(x = as.vector(x), digits = digits, sci = sci, 
                       bigMark = bigMark, leadDigits = leadDigits, 
                       zeroForm = zeroForm, naForm = naForm, fmt = fmt, 
                       align = align, width = width, lang = lang, 
                       pThreshold = pThreshold, decMark = decMark, ...)
  
  # noquote() is what fm.default() returns, and matrix() drops the class -
  # so fm() on a matrix printed with quotes while fm() on a vector did not.
  # unclass() first, because matrix() on a classed vector is what lost it.
  if (is.null(width))
    result <- .padMatrixWidth(result, align = align)

  result <- matrix(unclass(result), nrow = d[1], ncol = d[2], dimnames = dn)

  noquote(result)
  
}


#' @rdname fm
#' @export
fm.table <- function(x, digits = NULL, leadDigits = NULL, sci = NULL,
                     bigMark = NULL, decMark = NULL, naForm = NULL, 
                     zeroForm = NULL, fmt = NULL, pThreshold = NULL,
                     width = NULL, align = NULL, lang = NULL, ...) {
  
  dn <- dimnames(x)
  d  <- dim(x)
  result <- fm.default(x = as.vector(x), digits = digits, sci = sci,
                       bigMark = bigMark, leadDigits = leadDigits,
                       zeroForm = zeroForm, naForm = naForm, fmt = fmt,
                       align = align, width = width, lang = lang,
                       pThreshold = pThreshold, decMark = decMark, ...)
  
  # print.table() defaults to right = FALSE for character storage, so the
  # same padding is needed here; it prints unquoted by itself.
  if (is.null(width))
    result <- .padMatrixWidth(result, align = align)

  result <- array(unclass(result), dim = d, dimnames = dn)
  class(result) <- c("table", class(result))
  result
}



#' @rdname fm
#' @export
fm.ftable <- function(x, digits = NULL, leadDigits = NULL, sci = NULL,
                      bigMark = NULL, decMark = NULL, naForm = NULL, 
                      zeroForm = NULL, fmt = NULL, pThreshold = NULL,
                      width = NULL, align = NULL, lang = NULL, ...) {
  
  # convert ftable first to matrix, then to data.frame in order to
  # apply recycled arguments columnwise, which is a common need
  res <- fm(as.data.frame(as.matrix(x)), digits = digits, sci = sci, 
            bigMark = bigMark, leadDigits = leadDigits, zeroForm = zeroForm, 
            naForm = naForm, fmt = fmt, align = align, width = width, 
            lang = lang, pThreshold = pThreshold, decMark = decMark, ...)
  
  m <- as.matrix(res)
  x[] <- m[seq_len(prod(dim(x)))]
  
  return(x)
}



# ---- internal helper functions --------------------------------------


# New super flexible and comprehensive format function

# Alternative names: Fx(), Fmt(), Frm(), Frmt()

# References:
# http://stackoverflow.com/questions/3443687/formatting-decimal-places-in-r
# http://my.ilstu.edu/~jhkahn/apastats.html
# https://en.wikipedia.org/wiki/Significant_figures
# http://www.originlab.com/doc/Origin-Help/Options-Dialog-NumFormat-Tab



.asColumnArgument <- function(x) {
  if (is.function(x) || inherits(x, "Style")) return(list(x))
  as.list(x)
}


.countDecimals <- function(x, digits = getOption("digits")) {
  decimalMark <- getOption("OutDec", ".")
  formatted <- formatC(x, digits = digits, format = "g")
  formatted <- sub("[eE].*$", "", formatted)
  position <- regexpr(decimalMark, formatted, fixed = TRUE)

  ifelse(position > 0L, nchar(formatted) - position, 0L)
}


# Pads the entries of a formatted matrix or table to one common width.
#
# A character matrix prints LEFT justified - print.default() and
# print.table() both default to right = FALSE for character storage. Without
# padding, every negative entry therefore shifts one place against the
# positive ones and the decimal points do not line up, which is the whole
# point of a formatted table. Numeric matrices do not have the problem
# because format() has already padded them.
#
# NA entries are left alone: .finishFormat() pads only the non-missing ones,
# and format() would turn NA into the string "NA".
#' @noRd
.padMatrixWidth <- function(x, align = NULL) {

  chars <- nchar(as.character(x), type = "width")

  if (!any(!is.na(chars)))
    return(x)

  # align is passed for the justification only - the alignment character
  # itself has already been applied by .finishFormat() inside fm.default(),
  # and running strAlign() a second time would pad twice
  just <- if (identical(align, "\\l")) "\\l" else
          if (identical(align, "\\c")) "\\c" else NULL

  .finishFormat(x, width = max(chars, na.rm = TRUE), align = just)
}


.finishFormat <- function(x, width = NULL, align = NULL,
                          objectNames = NULL) {
  x <- as.character(x)
  present <- !is.na(x)

  if (!is.null(align) && any(present))
    x[present] <- strAlign(x[present], sep = align)

  if (!is.null(width) && any(present)) {
    currentWidth <- nchar(x[present], type = "width")
    padding <- pmax.int(width - currentWidth, 0L)

    justify <- if (identical(align, "\\l")) {
      "left"
    } else if (identical(align, "\\c")) {
      "centre"
    } else {
      "right"
    }

    if (justify == "left") {
      x[present] <- paste0(x[present], strrep(" ", padding))
    } else if (justify == "centre") {
      left <- padding %/% 2L
      right <- padding - left
      x[present] <- paste0(strrep(" ", left), x[present], strrep(" ", right))
    } else {
      x[present] <- paste0(strrep(" ", padding), x[present])
    }
  }

  if (!is.null(objectNames)) names(x) <- objectNames
  x
}


.isChLocale <- function() {
  any(grepl("_CH|Switzerland", Sys.getlocale()))
}


.thousandsSep <- function(sep = "") {
  systemSep <- tryCatch(
    if (Sys.info()[["sysname"]] == "Windows") {
      utils::readRegistry("Control Panel\\International", hive = "HCU")$sThousand
    } else {
      out <- system2("locale", c("-k", "thousands_sep"),
                     stdout = TRUE, stderr = FALSE)
      if (length(out)) sub(".*=", "", out[1L]) else NULL
    },
    error = function(e) NULL
  )

  coalesceX(
    getOption("thousands_sep"),
    naIf(Sys.localeconv()["thousands_sep"], ""),
    naIf(systemSep, ""),
    sep
  )
}


.formatStars <- function(x,
                         breaks = c(0, 0.001, 0.01, 0.05, 0.1, 1),
                         labels = c("***", "** ", "*  ", ".  ", "   ")) {
  as.character(cut(x, breaks = breaks, labels = labels,
                   include.lowest = TRUE))
}


.formatPstars <- function(x, pThreshold, digits, leadDigits) {
  pValue <- .formatPval(x, pThreshold, digits, leadDigits)
  stars <- .formatStars(x)
  result <- paste(pValue, stars)
  result[is.na(pValue) | is.na(stars)] <- NA_character_
  result
}


.formatPval <- function(x, pThreshold = 0.001, digits = 3,
                        leadDigits = 1) {
  invalid <- is.na(x) | !is.finite(x) | x < 0 | x > 1
  one <- !invalid & isZero(x - 1)
  below <- !invalid & !one & x < pThreshold
  regular <- !invalid & !one & !below

  result <- rep.int(NA_character_, length(x))

  if (any(regular)) {
    values <- x[regular]
    exponent <- floor(log10(values))
    fixed <- exponent >= -3
    formatted <- character(length(values))

    if (any(fixed))
      formatted[fixed] <- fm(values[fixed], digits = digits,
                             leadDigits = leadDigits)

    if (any(!fixed))
      formatted[!fixed] <- fm(values[!fixed], digits = digits, fmt = "e",
                              leadDigits = leadDigits)

    result[regular] <- formatted
  }

  if (any(below)) {
    threshold <- if (log10(pThreshold) >= -3) {
      fm(pThreshold, digits = digits, leadDigits = leadDigits)
    } else {
      fm(pThreshold, digits = 1L, fmt = "e", leadDigits = leadDigits)
    }
    result[below] <- gettextf("< %s", threshold)
  }

  result[one] <- "1"
  result
}


.engineeringParts <- function(x, digits = NULL) {
  if (!is.null(digits) && digits < 0)
    stop("engineering formats require nonnegative 'digits'", call. = FALSE)

  exponent <- rep.int(NA_real_, length(x))
  mantissa <- x
  finite <- is.finite(x)
  nonzero <- finite & x != 0

  exponent[finite] <- 0
  logValue <- log10(abs(x[nonzero]))
  exponent[nonzero] <- floor(logValue)
  exponent[nonzero] <- exponent[nonzero] - exponent[nonzero] %% 3
  mantissa[nonzero] <- sign(x[nonzero]) *
    10^(logValue - exponent[nonzero])

  if (!is.null(digits)) {
    shift <- nonzero & abs(round(mantissa, digits = digits)) >= 1000
    if (any(shift)) {
      mantissa[shift] <- mantissa[shift] / 1000
      exponent[shift] <- exponent[shift] + 3
    }
  }

  list(mantissa = mantissa, exponent = exponent, finite = finite)
}


.formatEng <- function(x, digits = NULL, leadDigits = 1,
                       bigMark = "") {
  parts <- .engineeringParts(x, digits = digits)
  result <- as.character(x)

  if (any(parts$finite)) {
    mantissa <- fm(parts$mantissa[parts$finite], digits = digits,
                   leadDigits = leadDigits, bigMark = bigMark)
    exponent <- sprintf("e%+03d", as.integer(parts$exponent[parts$finite]))
    result[parts$finite] <- paste0(mantissa, exponent)
  }

  result
}


.formatEngabb <- function(x, digits = NULL, leadDigits = 1,
                          bigMark = "") {
  parts <- .engineeringParts(x, digits = digits)
  result <- as.character(x)

  if (any(parts$finite)) {
    exponent <- as.integer(parts$exponent[parts$finite])
    prefixExponent <- round(log10(Prefix$mult))
    abbreviation <- Prefix$abbr[match(exponent, prefixExponent)]
    fallback <- sprintf("e%+03d", exponent)
    hasAbbreviation <- !is.na(abbreviation)
    suffix <- ifelse(hasAbbreviation, abbreviation, fallback)
    suffix[exponent == 0L] <- ""

    mantissa <- fm(parts$mantissa[parts$finite], digits = digits,
                   leadDigits = leadDigits, bigMark = bigMark)
    separator <- ifelse(hasAbbreviation & nzchar(suffix), " ", "")
    result[parts$finite] <- paste0(mantissa, separator, suffix)
  }

  result
}


#' Format a Date or Date-Time
#'
#' Renders a `Date`, `POSIXct` or `POSIXlt` with the
#' package's own format tokens. This is the entry point used by
#' [fm()]; the compiled kernel behind it,
#' `formatDateTimeUtc_cpp()`, works exclusively in UTC.
#'
#' The time zone is resolved here rather than in C++. The C runtime's
#' `localtime()` is not usable for the job: on Windows
#' `_tzset()` understands only POSIX-style `TZ` strings and
#' falls back to UTC for IANA names such as `"Europe/Zurich"`, and
#' `localtime_r()` is not even required to consult `TZ`. R
#' carries its own time zone database, so the shift belongs on this side -
#' which is also what makes the result agree with
#' [format()] for a `POSIXct` that carries a
#' `tzone` attribute.
#'
#' @param x a `Date`, `POSIXct` or `POSIXlt` vector
#' @param fmt a format string
#' @param strict logical; reject unknown or ambiguous format tokens
#' @param locale locale for month and weekday names, or `"current"`
#'
#' @return a character vector
#' @noRd
.formatDateTime <- function(x, fmt, strict = TRUE, locale = "current") {
  formatDateTimeUtc_cpp(x = .toWallClock(x), fmt = fmt, strict = strict,
                    locale = locale)
}


# Reinterpret a date-time in its own time zone as if that wall-clock
# reading were UTC, so that .formatDateTime() - which always uses
# gmtime() - prints the zone the user expects.
#
# A Date has no time zone and passes through untouched. A POSIXct uses
# its tzone attribute, falling back to the session zone when it carries
# none, exactly like format.POSIXct(). A POSIXlt is converted first: the
# compiled routine reads a numeric vector and would choke on the list.
#
# The reinterpretation goes through POSIXlt rather than through
# format()/as.POSIXct(), which would be a character round trip, and
# rather than through lt$gmtoff, which is NA on some platforms.
#' @noRd
.toWallClock <- function(x) {

  if(inherits(x, "Date"))
    return(x)

  if(inherits(x, "POSIXlt"))
    x <- as.POSIXct(x)

  tz <- attr(x, "tzone")
  if (is.null(tz) || !length(tz) || is.na(tz[1L]) || !nzchar(tz[1L]))
    tz <- Sys.timezone()

  if (!length(tz) || is.na(tz[1L])) tz <- ""

  lt <- as.POSIXlt(x, tz = tz)

  attr(lt, "tzone") <- "UTC"
  # [] on the component: a bare lt$isdst <- 0L would replace the whole
  # vector with a single element and leave the POSIXlt fields ragged
  lt$isdst[] <- 0L

  as.POSIXct(lt)
}
