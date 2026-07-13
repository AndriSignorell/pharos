

#' Bubble Plot
#'
#' Draws a bubble plot where the position is given by \code{x} and \code{y},
#' and the size of each bubble is proportional to \code{area}.
#'
#' The function supports both a default interface and a formula interface
#' of the form \code{y ~ x | area}.
#'
#' @details
#' Bubble sizes are interpreted as areas and internally converted to radii
#' via \eqn{r = \sqrt{area / \pi}}. Aspect ratio is corrected to ensure
#' visually accurate circles.
#'
#' Graphical elements such as grids are controlled via the unified plot
#' design system using \code{bedrock::callIf()} and \code{.theme()}.
#'
#' @param x numeric vector of x positions.
#' @param y numeric vector of y positions.
#' @param area numeric vector controlling bubble sizes (interpreted as area).
#' @param ... additional graphical parameters passed to \code{par()}.
#'
#' @param col fill color(s) of the bubbles.
#' @param border border color(s) of the bubbles.
#' @param cex scaling factor applied to bubble areas.
#'
#' @param add logical; if \code{TRUE}, adds to an existing plot.
#'
#' @param grid logical, \code{NA}, or list controlling background grid.
#'
#' @param xlim,ylim axis limits.
#'
#' @param main,xlab,ylab plot labels.
#'
#' @param na.rm logical; remove missing values.
#'
#' @param formula A formula of the form \code{y ~ x | area}.
#' @param data optional data frame.
#' @param subset optional subset expression.
#' @param na.action function to handle missing values.
#'
#' @return Invisibly returns \code{NULL}.
#' 
#' @concept base-graphics
#' @concept plotting
#' 
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(100)
#' y <- rnorm(100)
#' a <- runif(100, 1, 10)
#'
#' plotBubble(x, y, a)
#'
#' df <- data.frame(x = x, y = y, a = a)
#' plotBubble(y ~ x | a, data = df)
#'
#' US <- data.frame(state.x77, State=state.name, 
#'                    Region=state.region, Abb=state.abb)
#' plotBubble(Income ~ Population | Area , 
#'            data=US, 
#'            grid=TRUE, col=addOpacity(pal("helsana")[US$Region]), cex=1.2 )
#' 
#' text(Income ~ Population, US, labels=US$Abb, cex=0.8)
#' 

#'
#' @seealso \code{\link{symbols}}
#'
#' @name plotBubble
NULL



#' @family plot.bivariate  
#' @concept scatterplot  
#' @concept bivariate
#'
#'
#' @export
plotBubble <- function(x, ...) {
  UseMethod("plotBubble")
}


#' @rdname plotBubble
#' @method plotBubble default
#' @export
plotBubble.default <- function(
    
  # DATA
  x, y, area,
  
  ...,
  
  # STRUCTURE
  add = FALSE,
  
  # STYLE
  col = NA,
  border = NULL,
  cex = 1,
  grid = NA,
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # DATA HANDLING
  na.rm = FALSE,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = ""
  
) {
  
  # --- data prep ------------------------------------------------
  
  d.frm <- as.data.frame(
    recycle(
      x      = x,
      y      = y,
      area   = area,
      col    = col,
      border = border %||% par("fg")
    ),
    stringsAsFactors = FALSE
  )
  
  d.frm <- bedrock::sortX(
    d.frm,
    ord = 3,
    decreasing = TRUE
  )
  
  if (na.rm)
    d.frm <- d.frm[complete.cases(d.frm), ]
  
  if (nrow(d.frm) == 0)
    stop("no valid observations")
  
  # --- ranges ---------------------------------------------------
  
  if (is.null(xlim))
    xlim <- range(pretty(range(d.frm$x, na.rm = TRUE)))
  
  if (is.null(ylim))
    ylim <- range(pretty(range(d.frm$y, na.rm = TRUE)))
  
  # --- theme ----------------------------------------------------
  
  th <- .theme(
    grid = list(
      col = "grey90",
      lwd = 1,
      lty = "dotted"
    )
  )
  
  # --- plotting -------------------------------------------------
  
  .withGraphicsState({
    
    .applyParFromDots(..., 
                      defaults=list(
                        mar=c(left=5, top=.marTop(naIf(main, ""))),
                        col.axis = "grey40", 
                        fg       = "grey50"             
                      ))
    
    if (!add) {
      
      plot(
        NA,
        xlim = xlim,
        ylim = ylim,
        main = main,
        xlab = xlab,
        ylab = ylab,
        type = "n"
      )
      
    }
    
    # --- grid ---------------------------------------------------
    
    bedrock::callIf(
      graphics::grid,
      grid,
      defaults = th$grid[
        !startsWith(names(th$grid), "group.")
      ]
    )
    
    # --- bubble scaling (screen based) --------------------------
    
    # r.in <- 0.15 * cex *
    #   sqrt(
    #     d.frm$area /
    #       max(d.frm$area, na.rm = TRUE)
    #   )
     
    r.in <- 0.35 * cex *
      (d.frm$area/max(d.frm$area))^0.4

    # r.in <- r.max *
    #   (d.frm$area / max(d.frm$area, na.rm = TRUE))^scale
        
    d.frm$rx <- r.in *
      diff(par("usr")[1:2]) /
      par("pin")[1]
    
    d.frm$ry <- r.in *
      diff(par("usr")[3:4]) /
      par("pin")[2]
    
    # --- draw bubbles -------------------------------------------
    
    polygon(
      ellipse(
        x       = d.frm$x,
        y       = d.frm$y,
        radiusX = d.frm$rx,
        radiusY = d.frm$ry
      ),
      col    = d.frm$col,
      border = d.frm$border
    )
    
  })
  
  invisible(d.frm)
  
}



#' @rdname plotBubble
#' @method plotBubble formula
#' @export
plotBubble.formula <- function(
    
  # DATA
  formula,
  data = NULL,
  subset,
  na.action = na.omit,
  
  ...,
  
  # STRUCTURE
  add = FALSE,
  
  # STYLE
  col = NA,
  border = NULL,
  cex = 1,
  grid = NA,
  
  # AXES
  xlim = NULL,
  ylim = NULL,
  
  # LABELS
  main = "",
  xlab = "",
  ylab = ""
  
) {
  
  # --- formula parsing -----------------------------------------
  
  rhs <- formula[[3]]
  
  if (length(rhs) != 3 || rhs[[1]] != as.name("|"))
    stop("formula must be of the form y ~ x | area")
  
  y_var <- formula[[2]]
  x_var <- rhs[[2]]
  a_var <- rhs[[3]]
  
  # --- rewrite formula for model.frame -------------------------
  
  f <- as.formula(
    paste(
      deparse(y_var),
      "~",
      deparse(x_var),
      "+",
      deparse(a_var)
    )
  )
  
  # --- model.frame ---------------------------------------------
  
  m <- match.call(expand.dots = FALSE)
  
  m$formula <- f
  m[[1L]] <- quote(stats::model.frame)
  
  if (!missing(subset))
    m$subset <- substitute(subset)
  else
    m$subset <- NULL
  
  # remove plot-specific arguments
  m$add    <- NULL
  m$col    <- NULL
  m$border <- NULL
  m$cex    <- NULL
  m$grid   <- NULL
  m$xlim   <- NULL
  m$ylim   <- NULL
  m$main   <- NULL
  m$xlab   <- NULL
  m$ylab   <- NULL
  
  mf <- eval(m, parent.frame())
  
  # --- extract -------------------------------------------------
  
  y <- mf[[1]]
  x <- mf[[2]]
  a <- mf[[3]]
  
  # --- default labels ------------------------------------------
  
  if (!nzchar(xlab))
    xlab <- deparse(x_var)
  
  if (!nzchar(ylab))
    ylab <- deparse(y_var)
  
  # --- call default method -------------------------------------
  
  plotBubble.default(
    x = x,
    y = y,
    area = a,
    
    add = add,
    
    col = col,
    border = border,
    cex = cex,
    grid = grid,
    
    xlim = xlim,
    ylim = ylim,
    
    main = main,
    xlab = xlab,
    ylab = ylab,
    
    ...
  )
  
}
