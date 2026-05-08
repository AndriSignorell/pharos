
#' Create an Area Plot
#' 
#' Produce a stacked area plot, or add polygons to an existing plot.
#' 
#' @name plotArea  
#' @aliases plotArea plotArea.default plotArea.formula
#' @param x numeric vector of x values, or if \code{y=NULL} a numeric vector of
#' y values. Can also be a 1-dimensional table (x values in names, y values in
#' array), matrix or 2-dimensional table (x values in row names and y values in
#' columns), a data frame (x values in first column and y values in subsequent
#' columns), or a time-series object of class \code{ts/mts}.
#' @param y numeric vector of y values, or a matrix containing y values in
#' columns.
#' @param prop whether data should be plotted as proportions, so stacked areas
#' equal 1.
#' @param add whether polygons should be added to an existing plot.
#' @param xlab label for x axis. 
#' @param ylab label for y axis. 
#' @param col fill color of polygon(s). The default is a vector of gray colors.
#' @param frame.plot a logical indicating whether a box should be drawn around
#' the plot.
#' @param formula a \code{\link{formula}}, such as \code{y ~ x} or
#' \code{cbind(y1, y2) ~ x}, specifying x and y values. A dot on the left-hand
#' side, \code{formula = . ~ x}, means all variables except the one specified
#' on the right-hand side.
#' @param data a data frame (or list) from which the variables in
#' \code{formula} should be taken.
#' @param subset an optional vector specifying a subset of observations to be
#' used.
#' @param na.action a function which indicates what should happen when the data
#' contain \code{NA} values. Defaults to \code{getOption("na.action")}.
#' @param \dots further arguments are passed to \code{matplot} and
#' \code{polygon}.
#' @return Matrix of cumulative sums that was used for plotting. 
#' @author Arni Magnusson <thisisarni@@gmail.com>
#' @seealso \code{\link{barplot}}, \code{\link{polygon}},
#' \code{\link[areaplot]{areaplot}} 
#' 
#' @examples
#' plotArea(VADeaths, xaxt="n")
#' axis(1, at=1:5, labels=rownames(VADeaths))
#' 
#' # formula
#' plotArea(Armed.Forces~Year, data=longley)
#' plotArea(cbind(Armed.Forces,Unemployed)~Year, data=longley)
#' 
#' # add=TRUE
#' plot(1940:1970, 500*runif(31), ylim=c(0,500))
#' plotArea(Armed.Forces~Year, data=longley, add=TRUE)
#' 
#' # matrix
#' plotArea(WorldPhones)
#' plotArea(WorldPhones, prop=TRUE, col=rainbow(10))
#' 
#' # table
#' tab <- xtabs(ncases ~ agegp + alcgp, data = esoph)
#' plotArea(tab, xaxt="n", xlab="age group")
#' axis(1, labels=rownames(tab), at=seq(nrow(tab)))
#' 
#' # ts/mts
#' plotArea(austres)
#' plotArea(Seatbelts[,c("drivers","front","rear")],
#'          ylab="Killed or seriously injured")
#' abline(v=1983+1/12, lty=3)
#' 


#' @rdname plotArea  
#' @family plot.special
#' @concept graphics
#' @concept frequency-analysis
#'
#'
#' @export
plotArea <- function(x, ...) {
  # plotArea - mehrere Flaechen uebereinander
  # source: http://r.789695.n4.nabble.com/plotArea-td2255121.html
  # arni...
  UseMethod("plotArea")
}


#' @rdname plotArea  
#' @export
plotArea.default <- function(x, y=NULL, prop=FALSE, add=FALSE, xlab=NULL, ylab=NULL,
                             col=NULL, frame.plot=FALSE, ...) {

  .withGraphicsState({
      
    if(is.ts(x)) {  # ts/mts
      if(is.null(ylab)) ylab <- deparse(substitute(x))
      x <- data.frame(Time=time(x), x)
    }
    
    if(is.table(x)) { # table
      if(is.null(ylab)) ylab <- deparse(substitute(x))
      if(length(dim(x)) == 1)
        x <- t(t(unclass(x)))
      else
        x <- unclass(x)
    }
    
    if(is.matrix(x)) { # matrix
      if(!is.null(rownames(x)) && !any(is.na(suppressWarnings(as.numeric(rownames(x)))))) {
        x <- data.frame(as.numeric(rownames(x)), x)
        names(x)[1] <- ""
      } else {
        x <- data.frame(Index=seq_len(nrow(x)), x)
      }
    }
    
    if(is.list(x)) { # data.frame or list
      if(is.null(xlab))  xlab <- names(x)[1]
      if(is.null(ylab)) {
        if(length(x) == 2)
          ylab <- names(x)[2]
        else
          ylab <- ""
      }
      
      y <- x[-1]
      x <- x[[1]]
    }
    
    if(is.null(y)) { # one numeric vector passed, plot it on 1:n
      if(is.null(xlab))  xlab <- "Index"
      if(is.null(ylab))  ylab <- deparse(substitute(x))
      
      y <- x
      x <- seq_along(x)
    }
    
    if(is.null(xlab))  xlab <- deparse(substitute(x))
    if(is.null(ylab))  ylab <- deparse(substitute(y))
    
    y <- as.matrix(y)
    
    if(is.null(col))  col <- gray.colors(ncol(y))
    col <- rep(col, length.out=ncol(y))
    
    if(prop)  y <- prop.table(y, 1)
    
    y <- t(rbind(0, apply(y, 1, cumsum)))
    na <- is.na(x) | apply(is.na(y),1,any)
    x <- x[!na][order(x[!na])]
    y <- y[!na,][order(x[!na]),]
    
    
    if(!add)  
      suppressWarnings(matplot(x, y, type="n", xlab=xlab, ylab=ylab, frame.plot=frame.plot, ...))

    xx <- c(x, rev(x))

    
    for(i in 1:(ncol(y)-1)) {
      yy <- c(y[,i+1], rev(y[,i]))
      # suppressWarnings(polygon(xx, yy, col=col[i], ...))
      # think we don't need dots here, but can allow warnings, why not??
      # me: 2020-03-11
      polygon(xx, yy, col=col[i])
    }
  
  
  })  # close .withGraphicsState
  
  invisible(y[,-1])

}



#' @rdname plotArea  
#' @export
plotArea.formula <- function (formula, data, subset, na.action, ...) {
  
  m <- match.call(expand.dots=FALSE)
  if(is.matrix(eval(m$data,parent.frame())))   m$data <- as.data.frame(data)
  
  m$... <- NULL
  m[[1]] <- as.name("model.frame")
  
  if(as.character(formula[[2]]==".")) {
    rhs <- unlist(strsplit(deparse(formula[[3]])," *[:+] *"))
    lhs <- sprintf("cbind(%s)", paste(setdiff(names(data), rhs),collapse=","))
    m[[2]][[2]] <- parse(text=lhs)[[1]]
  }
  
  mf <- eval(m, parent.frame())
  if(is.matrix(mf[[1]])) {
    lhs <- as.data.frame(mf[[1]])
    names(lhs) <- as.character(m[[2]][[2]])[-1]
    plotArea.default(cbind(mf[-1],lhs), ...)
  } else {
    plotArea.default(mf[2:1], ...)
  }
  
}
