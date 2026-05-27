
#' Format Numbers and Dates
#' 
#' Formatting numbers with base R tools often degenerates into a major
#' intellectual challenge for us little minds down here in the valley of tears.
#' There are a number of options available and quite often it's hard to work
#' out which one to use, when a more uncommon setting is needed. The
#' \code{fm()} function wraps all these functions and tries to offer a simpler,
#' less technical, but still flexible interface.
#' 
#' There's also an easygoing interface for format templates, defined as a list
#' consisting of any accepted format features. This enables to define templates
#' globally and easily change or modify them later.
#' 
#' \code{fm()} is the workhorse for formatting numbers and dates, supporting a
#' comprehensive range of format options that are likely to occur in everyday
#' reporting. Among these, the argument \code{fmt} deserves a more detailed
#' description due to its flexibility. It is used to generate a variety of
#' different special formats. \cr\cr If \code{x} is a date, it can take
#' ISO-8601–inspired token syntax similar to .NET or Moment.js (consisting of
#' \code{d}, \code{M} and \code{y} for day, month or year and \code{h/H},
#' \code{m}, \code{s}, \code{t} for hours, minutes, seconds and AM/PM
#' designator) and defining the combination of day month and year
#' representation.\cr
#' 
#' \tabular{ll}{ \bold{Code}\verb{ } \tab \bold{Description}\cr \code{d } \tab
#' day of the month without leading zero (1 - 31) \cr \code{dd} \tab day of the
#' month with leading zero (01 - 31)\cr \code{ddd} \tab abbreviated name for
#' the day of the week (e.g. Mon) in the current user's language \cr
#' \code{dddd} \tab full name for the day of the week (e.g. Monday) in the
#' current user's language \cr \code{do} \tab The token \code{do} (aka 'day
#' ordinal') formats the day of month using English ordinal suffixes (e.g. 1st,
#' 2nd, 3rd, 4th). This is an English-only feature. (For most other languages,
#' ordinal dates are written using punctuation in the format string, e.g.
#' \code{"d. MMM yyyy"}. Locale-specific ordinal rules beyond English are not
#' implemented by design.)\cr \code{M } \tab month without leading zero (1 -
#' 12) \cr \code{MM} \tab month with leading zero (01 - 12) \cr \code{MMM }
#' \tab abbreviated month name (e.g. Jan) in the current user's language \cr
#' \code{MMMM} \tab full month name (e.g. January) in the current user's
#' language \cr \code{y } \tab year without century, without leading zero (0 -
#' 99) \cr \code{yy } \tab year without century, with leading zero (00 - 99)
#' \cr \code{yyyy } \tab year with century. For example: 2005 \cr\cr \code{H/HH
#' } \tab Hour in 24h format, one digit / two digits \cr \code{h/hh } \tab Hour
#' in 12h format, one digit / two digits, note that in this case t must be set
#' also to ensure uniqueness.\cr \code{t/tt } \tab AM/PM description (one/two
#' characters)\cr \code{m/mm } \tab Minutes one digit / two digits\cr
#' \code{s/ss } \tab Seconds one digit / two digits\cr
#' 
#' \cr } Weekdays and month names can be expressed in the local language or in
#' English. The language can be controlled by the argument "\code{lang}".\cr
#' 
#' Even more variability is needed to display numeric values. For the most
#' frequently used formats there are the following special codes available:
#' \tabular{lll}{ \bold{Code} \tab \bold{Type} \tab \bold{Description} \cr
#' \code{e} \tab scientific \tab forces scientific representation of x, e.g.
#' 3.141e-05. The number of digits,\cr \tab \tab alignment and zero values are
#' further respected.\cr \tab\cr
#' 
#' \code{eng} \tab engineering \tab forces scientific representation of
#' \code{x}, but only with powers that are a multiple of 3. \cr
#' \code{engabb}\verb{ } \tab engineering abbr.\verb{ } \tab same as
#' \code{eng}, but replaces the exponential representation by codes, \cr
#' \tab\tab e.g. \code{M} for mega (1e6). \cr
#' 
#' \code{\%} \tab percent \tab will divide the given number by 100 and append
#' the \%-sign (without a separator).\cr \tab\cr \code{p} \tab p-value \tab
#' will wrap the function \code{\link{format.pval}} and return a p-value
#' format. \cr \tab \tab Use \code{pThreshold} to define the threshold to e.g.
#' switch to a \code{ <0.001 } representation.\cr \tab\cr \code{frac} \tab
#' fractions \tab will (try to) convert numbers to fractions. So 0.1 will be
#' displayed as 1/10. \cr \tab\tab See \code{\link[MASS]{fractions}()}.\cr
#' \tab\cr
#' 
#' \code{*} \tab significance \tab will produce a significance representation
#' of a p-value consisting of * and ., \cr \tab \tab while the breaks are set
#' according to the used defaults e.g. in \code{lm} as \cr \tab \tab \verb{[0, 0.001]}
#' = \code{***} \cr \tab \tab (0.001, 0.01\verb{]} = \code{**} \cr \tab \tab (0.01,
#' 0.05\verb{]} = \code{*} \cr \tab \tab (0.05, 0.1\verb{]} = \code{.} \cr \tab \tab (0.1,1\verb{]}
#' = \code{ }\cr
#' 
#' \code{p*}\tab p-value stars\tab will produce p-value and significance stars
#' 
#' }
#' 
#' \code{fmt} can as well be an object of class "\code{Style}" consisting of a
#' list out of the arguments above (as created by \code{\link{style}()}). This
#' allows to store and manage the full format in variables or as options and
#' use it as format template subsequently.
#' 
#' Finally \code{fmt} can also be a function in x, which makes formatting very
#' flexible.
#' 
#' @aliases fm fm.default fm.matrix fm.table 
#' @param x an atomic numerical, typically a vector of real numbers or a matrix
#' of numerical values. Factors will be converted to strings.
#' @param digits integer, the desired (fixed) number of digits after the
#' decimal point. Unlike \code{\link{formatC}} you will always get this number
#' of digits even if the last digit is 0.  Negative numbers of digits round to
#' a power of ten (\code{digits=-2} would round to the nearest hundred).
#' @param leadDigits number of leading zeros. \code{leadDigits=3} would make sure
#' that at least 3 digits on the left side will be printed, say \code{3.4} will
#' be printed as \code{003.4}. Setting \code{leadDigits} to \code{0} will yield
#' results like \code{.452} for \code{0.452}. The default \code{NULL} will
#' leave the numbers as they are (meaning at least one 0 digit).
#' @param sci integer. The power of 10 to be set when deciding to print numeric
#' values in exponential notation. Fixed notation will be preferred unless the
#' number is larger than 10^scipen. If just one value is set it will be used
#' for the left border 10^(-scipen) as well as for the right one (10^scipen). A
#' negative and a positive value can also be set independently. Default is
#' \code{getOption("scipen")}, whereas \code{scipen=0} is overridden.
#' @param bigMark character; if not empty used as mark between every 3
#' decimals before the decimal point. Default is "" (none).
#' @param decMark character, specifying the decimal mark to be used. If not
#' provided, the default set as \code{decMark} option is used.
#' @param naForm character, string specifying how \code{NA}s should be
#' specially formatted.  If set to \code{NULL} (default) no special action will
#' be taken.
#' @param zeroForm character, string specifying how zeros should be specially
#' formatted. Useful for pretty printing 'sparse' objects.  If set to
#' \code{NULL} (default) no special action will be taken.
#' @param fmt either a format string, allowing to flexibly define special
#' formats or an object of class \code{style}, consisting of a list of
#' \code{fm} arguments. See Details.
#' @param pThreshold a numerical tolerance used mainly for formatting p values,
#' those less than pThreshold are formatted as "\verb{\code{< [pThreshold]}}" (where '\verb{[pThreshold]}'
#' stands for \code{format(pThreshold, digits))}.  Default is \code{0.001}.
#' @param width integer, the defined fixed width of the strings.
#' @param align the character on whose position the strings will be aligned.
#' Left alignment can be requested by setting \code{sep = "\\l"}, right
#' alignment by \code{"\\r"} and center alignment by \code{"\\c"}. Mind the
#' backslashes, as if they are omitted, strings would be aligned to the
#' \bold{character} l, r or c respectively. The default is \code{NULL} which
#' would just leave the strings as they are.\cr This argument is send directly
#' to the function \code{\link[aurora]{strAlign}()} as argument \code{sep}.
#' @param lang optional value setting the language for the months and daynames.
#' Can be either \code{"local"} for current locale or \code{"en"} for english.
#' If left to \code{NULL}, the DescToolsOption \code{"lang"} will be searched
#' for and if not found \code{"local"} will be taken as default.
#' @param \dots further arguments to be passed to or from methods.
#' @return the formatted values as characters. \cr If \code{x} was a
#' \code{matrix}, then a the result will also be a \code{matrix}. (Hope this
#' will not surprise you...)
#' @seealso \code{\link{format}}, \code{\link{formatC}},
#' \code{\link{prettyNum}}, \code{\link{sprintf}}, \code{\link{symnum}},\cr
#' \code{\link{Sys.setlocale}},\cr \code{\link[DescToolsX]{weekday}}, 
#' \code{\link[DescToolsX]{month}},
#' \code{\link[DescToolsX]{setDescToolsXOption}}, \code{\link{style}}, \code{\link{styles}}
#' @keywords IO
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



#' @family string.format
#' @concept string-formatting
#' @concept data-manipulation
#'
#'
#' @export  
fm <- function(x
               , digits = NULL, leadDigits = NULL, sci = NULL
               , bigMark=NULL, decMark = NULL
               , naForm = NULL, zeroForm = NULL
               , fmt = NULL, pThreshold = NULL
               , width = NULL, align = NULL
               , lang = NULL
               , ...){
  UseMethod("fm")
}



#' @export
fm.default <- function(x, digits = NULL, leadDigits = NULL, sci = NULL
                       , bigMark=NULL, decMark = NULL
                       , naForm = NULL, zeroForm = NULL
                       , fmt = NULL, pThreshold = NULL
                       , width = NULL, align = NULL
                       , lang = NULL, ...){

  # Format a vector x
  
  # refuse handling nonvectors
  if (is.list(x)) {
    stop("x must be an atomic vector, not a list", call. = FALSE)
  }

  # store names
  orig_names <- names(x)

  # store index of missing values in ina
  if ((has.na <- any(ina <- is.na(x))))
    x <- x[!ina]

  if(is.null(naForm)) naForm <- NA_real_
  
  # Dispatch on class of x **************
  
  if(all(inherits(x, c("Date", "POSIXct", "POSIXt")))) {
    
    # Format DATES
    
    # the language is only needed for date formats, so avoid looking up the option
    # for other types
    if(is.null(lang)) lang <- .getOption("lang", "en")
    
    if(lang=="en"){
      loc <- Sys.getlocale("LC_TIME")
      Sys.setlocale("LC_TIME", "C")
      on.exit(Sys.setlocale("LC_TIME", loc), add = TRUE)
    }
    
    # defunct! Use Rcpp function from now on ...
    # r <- format(x, as.CDateFmt(fmt=fmt))
    
    # CharacterVector FmDateTime_cpp(
    #   SEXP x,
    #   std::string fmt,
    #   bool strict = true,
    #   std::string locale = "current"
    # )
    
    # for dates only the fmt argument is relevant
    if(inherits(fmt, "Style")) fmt <- fmt[["fmt"]]
    
    r <- formatDateTime(x=x, fmt=fmt, strict=TRUE, locale="current")

  } else if(all(class(x) %in% c("character","factor","ordered"))) {
    
    # Format any form of TEXT
    
    r <- format(x)
    # handle NAs
    if (has.na) r[ina] <- naForm
    return(r)

  } else { 
  
    # Format any NUMERIC values
    
    # store index of missing values in ina
    has.zero <- any(iz <- isZero(x))
    
      
    # dispatch fmt *******************
    
    # fmt is a super flexible argument, it can contain
    # * a predefined style with class style
    # * a (character) name of a style defined as R option
    # * a special short cut for special format styles, currently:
    #     *       significance stars for p values
    #     p       the p value
    #     p*      both, p val and star
    #     %       a percentage value
    #     e       a scientific representation
    #     eng     engineering representation with powers of 10 in multiple of 3
    #     engabb  engineering representation with powers of 10 in multiple of 3
    # * a ISO-8601 code for dates
    # * a function

    if(!is.null(fmt)){
      
      if(is.function(fmt)){
        r <- fmt(x)
        
      } else if(inherits(x=fmt, what="Style")) {
        
        # class of fmt is: <style> 
        
        # we want to offer the user the option to overrun format definitions
        # consequence is, that all defaults of the function must be set to NULL
        # as we cannot distinguish between defaults and user sets else
        
        fmt <- unclass(fmt)
        
        a <- methods::formalArgs("fm")
        # do for all function arguments, besides x, ..., and fmt
        # (as it has the class "style" when landing here!)
        for( z in a[a %notin% c("x", "fmt", "...")]){
          # get the provided value for the argument
          value <- dynGet(z)
          # overwrite the style argument with the new value
          if( !is.null(value) ) fmt[z] <- value
        }
        
        # clear style class and rerun default routine
        class(fmt) <- setdiff(class(fmt), "Style")
        
        # return the formatted values by recursive call of Fm()
        return(do.call(fm, c(fmt, x=list(x))))
        
      } else {
        
        # class of fmt is <character> (or something else than <function> or <style>) 
        
        # special code: *, p, *p, e, ...
        if(fmt=="*"){
          r <- .format.stars(x)
          
        } else if(fmt=="p"){
          # better use 0.001 than .Machine$double.eps as eps
          r <- .format.pval(x, Coalesce(pThreshold, 1e-3), 
                            Coalesce(digits, 3), Coalesce(leadDigits, 1))
          
        } else if(fmt=="p*"){
          r <- .format.pstars(x, Coalesce(pThreshold, 1e-3), 
                              Coalesce(digits, 3), Coalesce(leadDigits, 1))
          
        } else if(fmt=="eng"){
          r <- .format.eng(x, digits=digits, leadDigits=leadDigits, 
                           zeroForm=zeroForm, naForm=naForm)
          
        } else if(fmt=="engabb"){
          r <- .format.engabb(x, digits=digits, leadDigits=leadDigits, 
                              zeroForm=zeroForm, naForm=naForm)
          
        } else if(fmt=="e"){
          # r <- formatC(x, digits = digits, width = width, format = "e",
          #              bigMark=bigMark, zero.print = zeroForm)
          r <- formatNum(x, digits = digits, sciBig = 0, sciSmall = 0)
          
        } else if(fmt=="%"){
          # we use 1 digit as default here
          if(is.null(digits)) digits <- 1
          r <- paste(formatNum(x * 100, digits = digits,
                               bigMark = bigMark,
                               leadDigits = leadDigits %||% 1L),
                     "%", sep="")
          
        } else if(fmt=="frac"){
          
          r <- as.character(MASS::fractions(x))
          
        } else if (fmt %in% names(styles())) {
          # so far fmt could be a character denoting the name of a style, 
          # defined either in the global environment or in the options
          r <- fm(x, fmt=styles()[[fmt]])

        } else {  # format else   ********************************************
          
          warning(gettextf("Non interpretable fmt code %s will be ignored.", fmt))
          r <- x
        }  
      } 
    } else {
      
      # fmt hat no value so proceed to basic numeric formatting
      
      # set the format defaults, if not provided ...

      CountDecimals <- function(x, digits = getOption("digits")) {
        decMark <- getOption("OutDec", ".")
        s <- formatC(x, digits = digits, format = "g")
        
        pos <- regexpr(decMark, s, fixed = TRUE)
        
        ifelse(
          pos > 0,
          nchar(s) - pos,
          0L
        )
      }

      # if sci is not set at all, the default will be 0, which leads to all numbers being
      # presented as scientific - this is definitely nonsense...
      if(is.null(sci))       sci <- Coalesce(naIf(getOption("scipen"), 0), 7) # default
      if(is.null(pThreshold))     pThreshold <- 1e-3
      if(is.null(bigMark))  bigMark <- getOption("bigMark", "")
      if(is.null(leadDigits))   leadDigits <- 1
      if(is.null(digits))    digits <- max(CountDecimals(x))

      if(!is.null(decMark)) { 
        opt <- options(OutDec = decMark)
        on.exit(options(opt), add=TRUE) 
      }

      # this is for sci big and sci small, this does not line up well with recyling rule!
      # ***** reconsider!! *****
      # sci <- rep(sci, length.out=2)
      # maybe better sci.big and sci.small (?)

      r <- formatNum(x,
                     digits = digits, leadDigits=leadDigits, # width = width, 
                     bigMark=bigMark, sciBig = sci, sciSmall = -sci)

    }
    
    # replace zeros with required zeroForm
    if(!is.null(zeroForm) & has.zero)
      r[iz] <- zeroForm
    
  }

  
  # the same with NAs
  if (has.na) {
    rok <- r
    r <- character(length(ina))
    r[!ina] <- rok
    r[ina] <- naForm
  }
  
  # Do the alignment
  if(!is.null(align)){
    r <- strAlign(r, sep = align)
  }
  
  
  # restore names
  if (!is.null(orig_names)) names(r) <- orig_names
  
  class(r) <- c("Fm", class(r))
  return(r)

}




#' @export
print.Fm <- function (x, quote=FALSE, ...) {
  
  class(x) <- class(x)[class(x)!="Fm"]
  # print(x, quote=FALSE, right=TRUE, ...)
  NextMethod("print", quote = quote, right=TRUE, ...)
}



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
  
  class(x) <- c("Fm", class(x))
  x
}


#' @export
fm.matrix <- function(x, digits = NULL, leadDigits = NULL, sci = NULL
                      , bigMark=NULL, decMark = NULL
                      , naForm = NULL, zeroForm = NULL
                      , fmt = NULL, pThreshold = NULL
                      , width = NULL, align = NULL
                      , lang = NULL, ...){
  
  x[,] <- fm.default(x=x, digits=digits, sci=sci, bigMark=bigMark,
                         leadDigits=leadDigits, zeroForm=zeroForm, naForm=naForm,
                         fmt=fmt, align=align, width=width, lang=lang, 
                         pThreshold=pThreshold, decMark=decMark, ...)
  
  class(x) <- c("Fm", class(x))
  return(x)
}


#' @export
fm.table <- function(x, digits = NULL, leadDigits = NULL, sci = NULL
                     , bigMark=NULL, decMark = NULL
                     , naForm = NULL, zeroForm = NULL
                     , fmt = NULL, pThreshold = NULL
                     , width = NULL, align = NULL
                     , lang = NULL, ...){
  
  x[] <- fm.default(x=x, digits=digits, sci=sci, bigMark=bigMark,
                        leadDigits=leadDigits, zeroForm=zeroForm, naForm=naForm,
                        fmt=fmt, align=align, width=width, lang=lang, pThreshold=pThreshold, 
                        decMark=decMark,...)
  
  class(x) <- c("Fm", class(x))
  return(x)
}



#' @export
fm.ftable <- function(x, digits = NULL, leadDigits = NULL, sci = NULL
                      , bigMark=NULL, decMark = NULL
                      , naForm = NULL, zeroForm = NULL
                      , fmt = NULL, pThreshold = NULL
                      , width = NULL, align = NULL
                      , lang = NULL, ...){
  
  # convert ftable first to matrix, then to data.frame in order to 
  # apply recycled arguments columnwise, which is a common need
  res <- fm(as.data.frame(as.matrix(x)), digits = digits, sci = sci, bigMark = bigMark,
                leadDigits = leadDigits, zeroForm = zeroForm, naForm = naForm,
                fmt = fmt, align = align, width = width, lang = lang, 
                pThreshold = pThreshold, decMark=decMark, ...)
  
  x[] <- as.matrix(res)
  
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



.is_ch_locale <- function() {
  # are CH-settings active?
  any(grepl("_CH|Switzerland", Sys.getlocale()))
}

.dec_sep <- function() gsub("1", "", format(1.1))


.thousands_sep <- function(sep="") {
  
  # try to get a default thousand's separator
  
  Coalesce(
    # take user's choice first
    getOption("thousands_sep"), 
    
    # if not there, use locale definition in R environment
    # but treat blank as "not defined"
    naIf(Sys.localeconv()["thousands_sep"], ""),
    
    # try to get the system's setting
    if(Sys.info()[["sysname"]] == "Windows"){
      readRegistry("Control Panel\\International", hive = "HCU")$sThousand
      
    } else {
      # Sys.info()[["sysname"]] %in% c("Linux", "Darwin")
      out <- system("locale -k thousands_sep", intern = TRUE)
      sub(".*=", "", out[1])
    },
    
    # if all else fails, fallback to the given default ""
    sep)
}  






.format.stars <- function(x, 
                          breaks=c(0,0.001,0.01,0.05,0.1,1), 
                          labels=c("***","** ","*  ",".  ","   ")){
  
  # format significance stars ***, **, * ... 
  # example: Fm(c(0.3, 0.08, 0.042, 0.001), fmt="*")
  
  res <- as.character(sapply(x, cut, 
                             breaks=breaks, 
                             labels=labels, include.lowest=TRUE))
  return(res)
  
}


.format.pstars <- function(x, pThreshold, digits, leadDigits)
  # format p-val AND stars
  paste(.format.pval(x, pThreshold, digits, leadDigits), .format.stars(x))



.format.pval <- function(x, pThreshold=0.001, digits=3, leadDigits=1){
  
  # format p-values  
  # this is based on original code from format.pval
  
  # if(is.null(digits))
  #   digits <- NA
  # 
  # digits <- rep(digits, length.out=3)
  
  # 1 has no digits
  is1 <- isZero(x-1)
  # do not accept p-values outside [0,1]
  isna <- x %)(% c(0,1)
  
  r <- character(length(is0 <- x < pThreshold))
  if (any(!is0)) {
    rr <- x <- x[!is0]
    expo <- floor(log10(ifelse(x > 0, x, 1e-50)))
    fixp <- (expo >= -3)
    
    if (any(fixp))
      rr[fixp] <- fm(x[fixp], digits=Coalesce(digits, 4), leadDigits=leadDigits)
    
    if (any(!fixp))
      rr[!fixp] <- format(x[!fixp], digits=Coalesce(digits, 3), scientific=TRUE)
    
    r[!is0] <- rr
  }
  if (any(is0)) {
    if(log10(pThreshold) >= -3)
      pThreshold <- fm(pThreshold, digits=digits, leadDigits=leadDigits)
    else
      pThreshold <- fm(pThreshold, digits=1, fmt="e")
    
    r[is0] <- gettextf("< %s", pThreshold)
  }
  
  r[is1] <- 1
  r[isna] <- NA
  
  return(r)
  
}



.format.eng <- function(x, digits = NULL, leadDigits = 1
                        , zeroForm = NULL, naForm = NULL){
  
  # engineering format, snap to powers of 10^3
  
  s <- lapply(strsplit(format(x, scientific=TRUE), "e"), as.numeric)
  y <- unlist(lapply(s, "[[", 1))
  pwr <- unlist(lapply(s, "[", 2))
  
  return(paste(fm(y * 10^(pwr %% 3), digits=digits, leadDigits=leadDigits,
                  zeroForm = zeroForm, naForm=naForm)
               , "e"
               , c("-","+")[(pwr >= 0) + 1]
               , fm(abs((pwr - (pwr %% 3))), leadDigits = 2, digits=0)
               , sep="")
  )
  
}


.format.engabb <- function(x, digits = NULL, leadDigits = 1
                           , zeroForm = NULL, naForm = NULL){
  
  s <- lapply(strsplit(format(x, scientific=TRUE), "e"), as.numeric)
  y <- unlist(lapply(s, "[[", 1))
  pwr <- unlist(lapply(s, "[", 2))
  
  a <- paste("1e"
             , c("-","+")[(pwr >= 0) + 1]
             , fm(abs((pwr - (pwr %% 3))), leadDigits=2, digits=0)
             , sep="")
  am <- d.prefix$abbr[match(as.numeric(a), d.prefix$mult)]
  
  a[!is.na(am)] <- am[!is.na(am)]
  a[a == "1e+00"] <- ""
  
  return(paste(fm(y * 10^(pwr %% 3), digits=digits, leadDigits=leadDigits,
                  zeroForm = zeroForm, naForm=naForm)
               , " " , a
               , sep="")
  )
  
}




