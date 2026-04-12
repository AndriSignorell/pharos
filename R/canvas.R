
#' Canvas for Geometric Plotting 
#' 
#' This is just a wrapper for creating an empty plot with suitable defaults for
#' plotting geometric shapes. 
#' 
#' The plot is created with these settings:\cr \code{asp = 1, xaxt = "n", yaxt
#' = "n", xlab = "", ylab = "", frame.plot = FALSE}. 
#' 
#' @param xlim,ylim the xlims and ylims for the plot. Default is c(-1, 1). 
#' @param main the main title on top of the plot. 
#' @param asp numeric, giving the aspect ratio y/x. (See
#' \code{\link{plot.window}} for details. Default is 1. 
#' @param usrbg the color of the user space of the plot, defaults to "white".
#' @param \dots additional arguments are passed to the \code{plot()} command.
#' 
#' @return a list of all the previous values of the parameters changed
#' (returned invisibly)
#' 
#' @keywords hplot
#' @examples
#' 
#' canvas(7)
#' text(0, 0, "Hello world!", cex=5)
#' 
 

#' @export
canvas <- function(xlim=NULL, ylim=xlim, main=NULL, 
                   asp=1, usrbg="white", ...){
  
  
  
  .withGraphicsState({
    
    
    # par() aus ...
    # default: asp = FALSE, mar = c(0,0,2,0) + 1
    do.call(.applyParFromDots, 
            mergeArgs(defaults=list(
              mar=par("mar"), 
              bg=par("bg"), 
              xpd=par("xpd")),
              list(...)
            ))
    
  
    if(is.null(xlim)){
      xlim <- c(-1,1)
      ylim <- xlim
    }
    if(length(xlim)==1) {
      xlim <- c(-xlim,xlim)
      ylim <- xlim
    }

    plot( NA, NA, xlim=xlim, ylim=ylim, main=main, asp=asp, 
          type="n", xaxt="n", yaxt="n",
          xlab="", ylab="", frame.plot = FALSE, ...)
    
    
    if(usrbg != "white"){
      usr <- par("usr")
      rect(xleft=usr[1], ybottom=usr[3], 
           xright=usr[2], ytop=usr[4], col=usrbg, border=NA)
    }
    
  })      

  invisible()
  
}




# old
# canvas <- function(xlim=NULL, ylim=xlim, main=NULL, xpd=par("xpd"), 
#                    mar=c(5.1,5.1,5.1,5.1),
#                    asp=1, bg=par("bg"), usrbg="white", ...){
#   
#   SetPars <- function(...){
#     
#     # expand dots
#     arg <- unlist(match.call(expand.dots=FALSE)$...)
#     # match par arguments
#     par.args <- as.list(arg[names(par(no.readonly = TRUE)[names(arg)])])
#     # store old values
#     old <- par(no.readonly = TRUE)[names(par.args)]
#     
#     # set new values
#     do.call(par, par.args)
#     
#     # return old ones
#     invisible(old)
#     
#   }
#   
#   
#   if(is.null(xlim)){
#     xlim <- c(-1,1)
#     ylim <- xlim
#   }
#   if(length(xlim)==1) {
#     xlim <- c(-xlim,xlim)
#     ylim <- xlim
#   }
#   
#   oldpar <- par("xpd"=xpd, "mar"=mar, "bg"=bg) # ;  on.exit(par(usr))
#   
#   SetPars(...)
#   
#   plot( NA, NA, xlim=xlim, ylim=ylim, main=main, asp=asp, 
#         type="n", xaxt="n", yaxt="n",
#         xlab="", ylab="", frame.plot = FALSE, ...)
#   
#   if(usrbg != "white"){
#     usr <- par("usr")
#     rect(xleft=usr[1], ybottom=usr[3], xright=usr[2], ytop=usr[4], col=usrbg, border=NA)
#   }
#   
#   # we might want to reset parameters afterwards
#   invisible(oldpar)
#   
# }
