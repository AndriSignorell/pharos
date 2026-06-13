
# # internal utils

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



