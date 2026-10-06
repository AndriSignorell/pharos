
#' Treemap Plot
#'
#' Draws a treemap in which the area of each rectangle is proportional to the
#' corresponding value in `x`. Optionally, rectangles can be grouped into
#' higher-level regions.
#'
#' The appearance of individual rectangles is controlled through the
#' `area` and `labels` arguments, that of the groups through the elements
#' `area` and `labels` of a `groups` list. These accept logical values,
#' vectors, or lists.
#'
#' @param x numeric vector of positive values determining the rectangle sizes.
#' @param groups optional grouping variable. Values sharing the same group are
#'   placed within a common enclosing region. A list sets the appearance
#'   of the group regions as well: it holds the grouping variable (element
#'   `by`, or the one unnamed element) and the elements `area` and
#'   `labels`, which follow the conventions of the arguments `area` and
#'   `labels`, e.g.
#'   `groups = list(grp, area = list(border = "black", lwd = 2))`. By
#'   default, group names are used as labels when more than one group is
#'   present.
#' @param area controls the appearance of individual rectangles.
#'   \itemize{
#'     \item `NULL` or `TRUE`: use defaults.
#'     \item `FALSE` or `NA`: suppress rectangle fill.
#'     \item Atomic vector: interpreted as `col`.
#'     \item List: graphical parameters such as `col`, `border`,
#'       and `lwd`.
#'   }
#' @param labels controls the labels of individual rectangles.
#'   \itemize{
#'     \item `NULL` or `TRUE`: use default labels (`names(x)`).
#'     \item `FALSE` or `NA`: suppress labels.
#'     \item Character vector: interpreted as label text.
#'     \item List: label properties such as `text`, `col`, and
#'       `cex`.
#'   }
#' @param main main title of the plot.
#' @param stamp controls the corner stamp. `.useTheme` (default)
#'   resolves to `getTheme()$stamp`. `TRUE`/`FALSE`/
#'   `NULL`, a string, or a named list for [stamp()].
#' @param ... additional graphical parameters passed to
#'   `.applyParFromDots()`.
#'
#' @details
#' Individual rectangles are sized according to the values in `x`. When
#' `groups` is supplied, a treemap is first constructed for the groups,
#' and each group's area is then subdivided among its members.
#'
#' The arguments `area` and `labels` - and their counterparts in a
#' `groups` list - provide a flexible interface for controlling the
#' appearance of the plot while keeping the main function signature compact.
#'
#' @return Invisibly returns a list containing the coordinates of group centres
#' and the centres of their child rectangles.
#'
#' @examples
#' x <- c(A = 6, B = 5, C = 4, D = 3, E = 2, F = 1)
#'
#' plotTreemap(x)
#'
#' plotTreemap(
#'   x,
#'   labels = list(col = "white")
#' )
#'
#' grp <- c("G1", "G1", "G1", "G2", "G2", "G2")
#'
#' plotTreemap(
#'   x,
#'   groups = list(grp, labels = TRUE)
#' )
#'
#' plotTreemap(
#'   x,
#'   groups = list(grp, area = list(border = "black", lwd = 2)),
#'   area = terrain.colors(length(x)),
#'   labels = FALSE
#' )
#'



#' @family plot.special  
#' @concept frequency-table
#'
#'
#' @export
plotTreemap <- function(
    # DATA
    x,
    groups = NULL,

    # LABELS
    main = NULL,

    # FEATURES
    area   = NULL,
    labels = NULL,

    # FRAMEWORK
    stamp = .useTheme,
    ...
) {
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # groups: the grouping variable, or a list with the variable and the
    # appearance of the group regions
    groupSpec   <- .valueSpec(groups, "by", list(area = NULL, labels = NULL),
                              arg = "groups")
    groups      <- groupSpec$by
    groupArea   <- groupSpec$area
    groupLabels <- groupSpec$labels
    
    if(is.null(groups))
      groups <- rep(1, length(x))
    
    area <- .resolveArea(
      area,
      defaults = list(
        col    = rainbow(length(x)),
        border = "grey50",
        lwd    = 1
      )
    )
    
    labels <- .resolveLabels(
      labels,
      defaults = list(
        text = names(x),
        col  = "black",
        cex  = 1
      )
    )
    
    groupArea <- .resolveArea(
      groupArea,
      defaults = list(
        col    = NA,
        border = "grey50",
        lwd    = 5
      ),
      invisible = list(border = NA)
    )
    
    # sort
    
    ord <- order(groups, -x)
    
    x      <- x[ord]
    groups <- groups[ord]
    
    area$col <- rep_len(area$col, length(x))[ord]
    
    if(!is.null(labels))
      labels$text <- labels$text[ord]
    
    # group rectangles
    
    zg <- .sqMap(
      sort(
        tapply(x, groups, sum),
        decreasing = TRUE
      )
    )
    
    # group labels AFTER zg is known, so order matches display
    
    groupLabels <- .resolveLabels(
      groupLabels,
      defaults = list(
        text = if(nrow(zg) > 1)
          rownames(zg)
        else
          NA,
        col = "black",
        cex = 3
      )
    )
    
    tm <- cbind(
      zg[, 1:2],
      xs = zg$x1 - zg$x0,
      ys = zg$y1 - zg$y0
    )
    
    gmidpt <- data.frame(
      x = apply(zg[, c("x0", "x1")], 1, mean),
      y = apply(zg[, c("y0", "y1")], 1, mean)
    )
    
    canvas(
      c(0, 1),
      xpd = TRUE,
      asp = NA,
      main = main,
      mar = c(
        2.1,
        2.1,
        .marTop(main),
        2.1
      )
    )
    
    res <- vector("list", nrow(zg))
    
    for(i in seq_len(nrow(zg))) {
      
      idx <- groups == rownames(zg)[i]
      
      xg.rect <- .sqMap(
        sort(
          x[idx],
          decreasing = TRUE
        )
      )
      
      xg.rect[, c(1, 3)] <-
        xg.rect[, c(1, 3)] * tm[i, "xs"] + tm[i, "x0"]
      
      xg.rect[, c(2, 4)] <-
        xg.rect[, c(2, 4)] * tm[i, "ys"] + tm[i, "y0"]
      
      .plotSqMap(
        xg.rect,
        col    = area$col[idx],
        border = area$border,
        lwd    = area$lwd,
        add    = TRUE
      )
      
      res[[i]] <- list(
        groups = gmidpt[i, ],
        child = cbind(
          x = apply(xg.rect[, c("x0", "x1")], 1, mean),
          y = apply(xg.rect[, c("y0", "y1")], 1, mean)
        )
      )
      
      if(!is.null(labels)) {
        
        text(
          x = apply(xg.rect[, c("x0", "x1")], 1, mean),
          y = apply(xg.rect[, c("y0", "y1")], 1, mean),
          labels = labels$text[idx],
          col    = labels$col,
          cex    = labels$cex
        )
        
      }
      
    }
    
    names(res) <- rownames(zg)
    
    .plotSqMap(
      zg,
      col    = groupArea$col,
      border = groupArea$border,
      lwd    = groupArea$lwd,
      add    = TRUE
    )
    
    if(!is.null(groupLabels)) {
      
      text(
        x = apply(zg[, c("x0", "x1")], 1, mean),
        y = apply(zg[, c("y0", "y1")], 1, mean),
        labels = groupLabels$text,
        col    = groupLabels$col,
        cex    = groupLabels$cex
      )
      
    }
    
  }, stamp = stamp)
  
  invisible(res)
  
}


# == internal helper functions =============================================

.resolveLabels <- function(x, defaults) {
  
  if(isFALSE(x) || isNA(x))
    return(NULL)
  
  if(is.null(x) || isTRUE(x))
    return(defaults)
  
  if(is.character(x))
    return(modifyList(
      defaults,
      list(text = x)
    ))
  
  if(is.list(x))
    return(modifyList(defaults, x))
  
  stop("invalid label specification")
  
}


.resolveArea <- function(x, defaults,
                         invisible = list(col = NA)) {
  
  if(isFALSE(x) || isNA(x))
    return(modifyList(defaults, invisible))
  
  if(is.null(x) || isTRUE(x))
    return(defaults)
  
  if(is.atomic(x) && !is.list(x))
    return(modifyList(
      defaults,
      list(col = x)
    ))
  
  if(is.list(x))
    return(modifyList(defaults, x))
  
  stop("invalid area specification")
  
}


.sqMap <- function(x) {
  
  .calcsqmap <- function(z, x0 = 0, y0 = 0, x1 = 1, y1 = 1, lst=list()) {
    
    cz <- cumsum(z$area)/sum(z$area)
    n <- which.min(abs(log(max(x1/y1, y1/x1) * sum(z$area) * ((cz^2)/z$area))))
    more <- n < length(z$area)
    a <- c(0, cz[1:n])/cz[n]
    if (y1 > x1) {
      lst <- list( data.frame(idx=z$idx[1:n],
                              x0=x0 + x1 * a[1:(length(a) - 1)],
                              y0=rep(y0, n), x1=x0 + x1 * a[-1], 
                              y1=rep(y0 + y1 * cz[n], n)))
      if (more) {
        lst <- append(lst, Recall(z[-(1:n), ], x0, y0 + y1 * cz[n], 
                                  x1, y1 * (1 - cz[n]), lst))
      }
    } else {
      lst <- list( data.frame(idx=z$idx[1:n],
                              x0=rep(x0, n), y0=y0 + y1 * a[1:(length(a) - 1)],
                              x1=rep(x0 + x1 * cz[n], n), y1=y0 + y1 * a[-1]))
      if (more) {
        lst <- append(lst, Recall(z[-(1:n), ], x0 + x1 * cz[n], 
                                  y0, x1 * (1 - cz[n]), y1, lst))
      }
    }
    
    lst
    
  }
  
  if(is.null(names(x))) names(x) <- seq_along(x)
  x <- data.frame(idx=names(x), area=x)
  
  res <- do.call(rbind, .calcsqmap(x))
  rownames(res) <- x$idx
  
  return(res[,-1])
  
}


.plotSqMap <- function(z, col = NULL, border=NULL, lwd=par("lwd"), add=FALSE){
  
  if(is.null(col)) col <- as.character(z$col)
  
  # plot squarified treemap
  if(!add) canvas(c(0, 1), xpd=TRUE)
  
  for(i in 1:nrow(z)){
    rect(xleft=z[i,]$x0, ybottom=z[i,]$y0, xright=z[i,]$x1, ytop=z[i,]$y1,
         col=col[i], border=border, lwd=lwd)
  }
  
}


