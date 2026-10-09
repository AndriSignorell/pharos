
#' Format Styles
#' 
#' Interface for format templates, defined as a list consisting of any accepted
#' format features in `fm()`.  This enables to define templates globally
#' and easily change or modify them later. 
#' 
#' `style()` takes any of the arguments of `fm()` and combines them to an
#' object of class `"Style"`, which then can be handed over to `fm()` as
#' argument `fmt`. \cr 
#' Following will define a new format template named
#' "`num.sty`".  Passed to `fm()` this will result in a number
#' displayed with 2 fixed digits and a comma as big mark: 
#' \preformatted{num.sty <- style(digits=2, bigMark=",") 
#' fm(12222.89345, fmt=num.sty) = 12,222.89}
#' This is the same result as if the arguments would have been supplied
#' directly, but helps to avoid boilerplate code: \cr `fm(12222.89345,
#' digits=2, bigMark=",")`.
#' 
#' To derive a style from an existing one we can provide `style()` with the
#' style, or with its name, and overwrite, resp. add new format options.
#' `style("num.sty", digits=1, sci=10)` will use the current version of the
#' numeric format and change the digits to 1 and the threshold to switch to
#' scientific presentation to numbers >= 1e10 and < 1e-10. The stored style
#' itself is not changed, so the result has to be assigned.
#' 
#' `styles()` returns all found style definitions in the global
#' environment or in the options.
#' 
#' The styles can be stored as options for convenience.  To store a new format
#' we use the default `options()` approach: `options(num.sty =
#' style(digits=1, bigMark=" "))` Defined styles in the options can be passed
#' on to `fm()` simply by their name. If a style of the same name exists in
#' the global environment, that one is used.
#' 
#' Four default styles are registered as options when **pharos** is loaded,
#' unless options of these names already exist: `"abs.sty"` for counts,
#' `"num.sty"` for numeric values, `"per.sty"` for percentages and
#' `"pval.sty"` for p-values. They are used by several plot functions of this
#' package (e.g. [plotHeatmap()]) and by the report functions in
#' **DescToolsX** (e.g. `DescToolsX::tOne()`). Redefining them with
#' `options()` changes these formats globally.
#' 
#' @name style
#' @aliases style styles
#' 
#' @inheritParams fm
#' @param x an object of class `Style` or the name of a style, defined
#' either in the global environment or in the options. The format arguments
#' supplied along with it overwrite its settings or are added to them. If no
#' style with the given name is found, a warning is issued and an empty style
#' is returned.
#' @param fmt a format code or date-time template, or a formatting function.
#' See the Details of [fm()].
#' @param label a description for the style
#' @param \dots for `style()`, further components of the style: only
#' arguments of [fm()] and the metadata `name` are accepted, anything else
#' is an error. Not used by the print method.
#' 
#' @return `style()` returns an object of class `Style`\cr
#' `styles()` returns a list of styles
#' 
#' @seealso [theme]
#' 
#' @examples
#' 
#' # use style() to get and define new formats stored as option
#' num.sty <- style(digits=2, bigMark=" ")
#' abs.sty <- style(digits=0, bigMark=" ")
#' dat.sty <- style(fmt="MM, dd yyyy")
#' 
#' num.sty                             # displays the details of the style
#' # editing styles
#' style("abs.sty")                    # looks for format "abs.sty"
#' # style("nexist")                     # return for nonexisting style
#' style("abs.sty", bigMark="")       # get Style("abs") and overwrite bigMark
#' style("abs.sty", naForm="-")       # get Style("abs") and add user defined naForm
#' 
#' styles()                            # all defined formats
#' styles()[c("num.sty", "abs.sty")]   # numeric and integer styles
#' 
#' # define totally new format and store as option
#' options(nob.sty=style(digits=5, naForm="nodat"))
#' 
#' # using styles
#' fm(314.1563, fmt=abs.sty)
#' fm(314.1563, fmt=num.sty)
#' 
#' fm(Sys.Date(), fmt=dat.sty)
#' 
#' # remove the option again
#' options(nob.sty=NULL)
#' 

#' @rdname style
#' @family format
#' @concept formatting
#' @concept number-formatting
#'
#' @export
styles <- function(){
  
  # all styles found in environment
  env <- ls(envir = .GlobalEnv)
  
  # check if completely empty
  if(!identical(env, character(0))){
    
    found <- env[
      sapply(env, function(x) 
        inherits(get(x, envir = .GlobalEnv), "Style"))
    ]
    
    res_env <- setNamesX(lapply(found, get, envir = .GlobalEnv), names=found)
    res_env <- lapply(res_env, function(x) {
      attr(x, "source") <- "GlobalEnv"
      x
    })
  } else {
    res_env <- NULL
  }
  
  # all styles defined in R options
  opt <- options()
  # sapply(opt, class) returns a LIST as soon as one option holds an object
  # with several classes (a data frame, a POSIXct, ...), and comparing that
  # list with "Style" then fails outright. inherits() asks the question that
  # was meant. (Same construction as the ctype detection in tOne().)
  res_opt <- opt[vapply(opt, inherits, logical(1L), what = "Style")]
  res_opt <- lapply(res_opt, function(x) {
    attr(x, "source") <- "options"
    x
  })
  
  # return all found styles 
  res <- append(res_env, res_opt)
  
  return(res)
  
}



# defined styles (defaults in options()) used by reporting functions
# abs.sty <- coalesceX(
#                Styles("abs"),
#                Style(digits=0, bigMark = .thousands_sep))
# num.sty <- coalesceX(
#                Styles("num"), 
#                Style(digits=3, bigMark = .thousands_sep))
# perc.sty <- coalesceX(
#                 Styles("perc"),
#                 Style(fmt="%", digits=1))
# pval.sty <- coalesceX(
#                 Styles("pval"),
#                 Style(fmt="pval", pThreshold=3))



#' @rdname style
#' @export
style <- function( x, digits = NULL, leadDigits = NULL, sci = NULL
                   , bigMark=NULL, decMark = NULL
                   , naForm = NULL, zeroForm = NULL
                   , fmt = NULL, pThreshold = NULL
                   , width = NULL, align = NULL
                   , lang = NULL
                   , label = NULL
                   , ...){
  
  
  # following does not much more than return the non null provided arguments 
  # in a new class <style>
  
  # all function arguments, same arguments as Fm() uses
  # (for default values, we would use: a <- formals(get("Style", pos=1)))
  
  # so get all arguments from the Style() function
  a <- methods::formalArgs(style)
  
  # remove dots name from the list
  a <- a[!a %in% c("x","label","...")]
  
  # get the values of all the arguments.
  # lapply, not sapply: with every single argument supplied and of length 1
  # sapply would simplify to an atomic vector, and the resulting "Style"
  # would no longer be the named list that fm() requires.
  v <- lapply(a, dynGet)
  names(v) <- a
  
  # Anything in the dots becomes a component of the Style and is later
  # handed to fm() as an argument. A name that fm() does not know used to be
  # accepted here without a word and only surfaced much later, wherever the
  # Style happened to be used, as
  #   "'...' is only available when 'fmt' is a function"
  # - a message naming neither the Style nor the component. Report it where
  # the mistake is made instead.
  dots <- match.call(expand.dots = FALSE)$...
  if (length(dots)) {
    known <- c(setdiff(names(formals(fm.default)), c("x", "...")),
               .styleMetaNames)
    unknown <- setdiff(names(dots), known)
    if (length(unknown) || is.null(names(dots)))
      stop(gettextf(
        "style() got argument(s) that fm() does not know: %s",
        .unknownNamesMsg(if (is.null(names(dots))) "<unnamed>" else unknown)),
        call. = FALSE)
  }
  
  # get rid of NULLs and append dots again
  res <- c(v[!vapply(v, is.null, logical(1L))],
           unlist(dots))    
  
  sty <- NA
  if(!missing(x)){
    if(inherits(x, "Style"))
      sty <- x
    else if(is.character(x)){
      if(x %in% names(styles()))
        sty <- styles()[[x]]
    }
    
    if(!identical(sty, NA)) {
      # a style with the given <name> has been found in the options
      # overwrite or append separately provided arguments
      sty[names(res)] <- res
      res <- sty
      
    } else {
      # An NA carrying class "Style" used to be returned here, which only
      # failed later inside fm() with "a Style must be a named list". An
      # empty Style formats with fm()'s defaults instead.
      warning(gettextf("style '%s' could not be found",
                       if (is.character(x)) x else deparse(substitute(x))),
              call. = FALSE)
      res <- structure(list(), names = character(0))
    }
  }
  
  if(!is.null(label))
    label(res) <- label
  
  class(res) <- "Style"
  return(res)
  
}




#' @rdname style
#' @export
print.Style <- function(x, ...){
  
  CollapseList <- function(x){
    z <- x
    # opt <- options(useFancyQuotes=FALSE); on.exit(options(opt))
    z[unlist(lapply(z, inherits, "character"))] <- shQuote(z[unlist(lapply(z, inherits, "character"))])
    z <- paste(names(z), "=", z, sep="", collapse = ", ")
    
    return(z)
  }
  
  # gettextf() with a NULL argument returns character(0), and cat() then
  # drops the whole line: neither fmt_name nor label is ever set by style(),
  # so the first two lines silently disappeared.
  orEmpty <- function(z) if (length(z) == 0L) "" else as.character(z)[1L]
  
  # A style built for dates (fmt = "MM, dd yyyy") cannot demonstrate itself
  # on a number - it used to abort the whole print method. Try a number
  # first and fall back to a date.
  notNumeric <- FALSE
  ex <- withCallingHandlers(
    fm(pi * 1e5, fmt = x),
    warning = function(w) {
      notNumeric <<- TRUE
      invokeRestart("muffleWarning")
    })
  if (notNumeric)
    ex <- tryCatch(fm(as.Date("2024-03-05"), fmt = x),
                   error = function(e) NA_character_)
  
  cat(gettextf("Format name:   %s%s\n", orEmpty(attr(x, "fmt_name")), 
               ifelse(identical(attr(x, "default"), TRUE), " (default)", "")),  
      gettextf("Description:   %s\n", orEmpty(label(x))),
      gettextf("Definition:    %s\n", CollapseList(x)),
      gettextf("Example:       %s\n", orEmpty(ex)),
      sep = ""
  )
  if(!is.null(attr(x, "source"))){
    cat(cli::col_silver(gettextf("(Source:       %s)\n", attr(x, "source"))))
  }
  
  invisible(x)
  
}

