
#' Plot frequency tables with bar or dot representation
#'
#' Creates a mosaic plot for objects produced by \code{Desc.table()}.
#' Two mosaicplots are placed side by side
#'
#' Graphical parameters supplied via \code{...} are applied globally using
#' \code{par()} and affect all subplots consistently.
#'
#' @param x An object of class \code{Desc.table}.
#' @param ... Graphical parameters passed to \code{par()}, such as
#'   \code{cex}, \code{las}, \code{mar}, or \code{oma}.
#'
#'
#' @family topic.graphics
#' @concept base-graphics
#' @concept plotting
#' 

#'@export
plot.Desc.table <- function(x, ...){
  
  if(length(dim(x))>2){
    plotMosaic(x$pfreqr, ...)
  } else {
    message("Sorry, plot not yet implemented for higher dimensional tables.")
  }  
  
}


