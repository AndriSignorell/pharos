
# internal utils

# isNA <- function(x) identical(x, NA)
# better, also for NA_real_, NA_integer_ etc.
isNA <- function(x) length(x) == 1 && is.na(x)


# old:
# .callIf.0 <- function(fun, arg) {
#   
#   if (isFALSE(arg) || is.null(arg) || isNA(arg))
#     return(invisible(NULL))
#   
#   if (isTRUE(arg))
#     return(fun())
#   
#   if (is.list(arg))
#     return(do.call(fun, arg))
#   
#   stop("Argument must be TRUE, FALSE, NA/NULL or a list.")
# }


.callIf <- function(fun, arg, defaults = NULL, forbidden = NULL, warn = TRUE) {
  
  if (isFALSE(arg) || is.null(arg) || isNA(arg))
    return(invisible(NULL))
  
  if (isTRUE(arg))
    args <- defaults %||% list()
  
  else if (is.list(arg)) {
    
    if (!is.null(forbidden)) {
      
      bad <- intersect(names(arg), forbidden)
      
      if (length(bad)) {
        
        msg <- sprintf(
          "Ignoring forbidden argument(s): %s",
          paste(bad, collapse = ", ")
        )
        
        if (warn) warning(msg)
        
        arg[bad] <- NULL
      }
    }
    
    args <- if (is.null(defaults)) arg else modifyList(defaults, arg)
    
  } else {
    stop("Argument must be TRUE, FALSE, NA/NULL or a list.")
  }
  
  do.call(fun, args)
  
}



.fm_num <- function(x, digits){
  
  format(
    x,
    digits = digits,
    nsmall = digits,
    scientific = FALSE,
    trim = TRUE
  )
  
}

.setDescToolsXOption <- function (...) {
  opts <- list(...)
  stopifnot(length(opts) > 0)
  names(opts) <- paste0("DescToolsX.", names(opts))
  options(opts)
}


.meanCI_raw <- function(x){
  
  x <- x[!is.na(x)]
  a <- qt(p = 0.025, df = length(x) - 1) * sd(x)/sqrt(length(x))
  
  return( c(est=mean(x), lci=mean(x) + a, uci=mean(x) - a) )
}


.binomCI_raw <- function(x, n, conf.level=0.95){
  setNamesX(c(est=x/n, prop.test(x, n, conf.level = conf.level, correct=FALSE)$conf.int),
             names=c("est", "lci", "uci"))
}




.linScale <- function (x, low = NULL, high = NULL, newlow = 0, newhigh = 1)  {
  
  x <- as.matrix(x)
  
  if(is.null(low)) {
    low <- apply(x, 2, min, na.rm=TRUE)
  } else {
    low <- rep(low, length.out=ncol(x))
  }
  if(is.null(high)) {
    high <- apply(x, 2, max, na.rm=TRUE)
  } else {
    high <- rep(high, length.out=ncol(x))
  }
  # do the recycling job
  newlow <- rep(newlow, length.out=ncol(x))
  newhigh <- rep(newhigh, length.out=ncol(x))
  
  xcntr <- (low * newhigh - high * newlow) / (newhigh - newlow)
  xscale <- (high - low) / (newhigh - newlow)
  
  return( scale(x, center = xcntr, scale = xscale))
  
}



.recycle_to_ncol <- function(x, n, name = "") {
  
  if (length(x) == n)
    return(x)
  
  if (length(x) == 1L)
    return(rep(x, n))
  
  stop(
    sprintf(
      "Argument '%s' has length %d, but must be 1 or %d",
      name, length(x), n
    ),
    call. = FALSE
  )
}




