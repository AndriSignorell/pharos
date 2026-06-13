
#' Grouped Density Plot
#'
#' Draws kernel density estimates for one or more groups. Supports both
#' classical density plots and conditional density plots.
#'
#' @details
#' The function supports two modes:
#' \itemize{
#'   \item \code{type = "density"}: standard kernel density estimates.
#'   \item \code{type = "conditional"}: conditional densities \eqn{P(Y | X)}
#'     using \code{\link[graphics]{cdplot}}.
#' }
#'
#' If \code{type = NULL}, the function attempts to infer the appropriate mode:
#' \itemize{
#'   \item \code{y ~ g} → density
#'   \item \code{y ~ x | g} → conditional density
#' }
#'
#' Graphical elements such as grids are controlled via the unified plot
#' design system using \code{bedrock::callIf()} and \code{.theme()}.
#'
#' @param ... Additional graphical parameters passed to \code{par()}.
#'
#' @param formula A formula of the form \code{y ~ group} or \code{y ~ x | group}.
#' @param data Optional data frame.
#' @param subset Optional subset expression.
#' @param na.action Function to handle missing values.
#'
#' @param add Logical; if \code{TRUE}, adds to an existing plot.
#' @param bw Bandwidth passed to \code{\link[stats]{density}} or \code{cdplot}.
#' @param type Character string specifying the plot type. One of
#'   \code{"density"}, \code{"conditional"}, or \code{NULL} (auto-detect).
#'
#' @param col Line color(s).
#' @param lwd Line width(s).
#' @param lty Line type(s).
#' @param fill Logical; if \code{TRUE}, fills densities (only for type="density").
#' @param grid Logical, \code{NA}, or list controlling background grid.
#'
#' @param main,xlab,ylab Plot labels.
#' @param xlim,ylim Axis limits.
#'
#' @return Invisibly returns \code{NULL}.
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(100)
#' g <- rep(c("A", "B"), each = 50)
#'
#' # standard density
#' plotDens(x ~ g)
#'
#' # conditional density
#' y <- rbinom(100, 1, plogis(x))
#' plotDens(y ~ x | g)
#'
#' @seealso \code{\link[stats]{density}}, \code{\link[graphics]{cdplot}}
#' 
#' @family topic.graphics
#' @concept base-graphics
#' @concept plotting
#' 
#' @name plotDens
NULL


#' @param x A numeric vector or list of numeric vectors.
#' @export
plotDens <- function(x, ...) {
  UseMethod("plotDens")
}


#' @export
plotDens.default <- function(
    x, ...,
    add = FALSE,
    bw = "nrd0",
    col = NULL,
    lwd = 2,
    lty = 1,
    fill = FALSE,
    grid = NULL,
    main = "",
    xlab = "",
    ylab = "density",
    xlim = NULL,
    ylim = NULL
) {
  
  dots <- list(...)
  named <- names(dots) != ""
  
  groups <- if (is.list(x)) x else c(list(x), dots[!named])
  n <- length(groups)
  
  if (n == 0)
    stop("invalid input")
  
  dens_list <- lapply(groups, function(xi) {
    xi <- xi[!is.na(xi)]
    if (length(xi) < 2) return(NULL)
    density(xi, bw = bw)
  })
  
  valid <- !sapply(dens_list, is.null)
  dens_list <- dens_list[valid]
  groups <- groups[valid]
  n <- length(dens_list)
  
  if (n == 0)
    stop("no valid groups")
  
  xr <- range(unlist(lapply(dens_list, `[[`, "x")), na.rm = TRUE)
  yr <- range(unlist(lapply(dens_list, `[[`, "y")), na.rm = TRUE)
  
  xlim <- xlim %||% xr
  ylim <- ylim %||% yr
  
  if (is.null(col))
    col <- .getOption("palette", grDevices::palette())[seq_len(n)]
  
  col <- rep_len(col, n)
  lwd <- rep_len(lwd, n)
  lty <- rep_len(lty, n)
  
  th <- .theme(
    grid = list(col = "grey80", 
                lwd = 1, lty = "dotted"),
    box  = list(col = "grey")
  )
  
  par(mar      = mar(left = 5),  # default
      col.axis = "grey40", 
      fg       = "grey50")       # border inherits from here

  .withGraphicsState({
    
    .applyParFromDots(...)
    
    if (!add) {
      plot(NA,
           xlim = xlim,
           ylim = ylim,
           main = main,
           xlab = xlab,
           ylab = ylab,
           type = "n")
    }
    
    bedrock::callIf(graphics::grid, grid,
            defaults = th$grid[!startsWith(names(th$grid), "group.")])
    
    for (i in seq_len(n)) {
      
      d <- dens_list[[i]]
      
      if (isTRUE(fill)) {
        polygon(c(d$x, rev(d$x)),
                c(d$y, rep(0, length(d$y))),
                col = adjustcolor(col[i], alpha.f = 0.3),
                border = NA)
      }
      
      lines(d$x, d$y,
            col = col[i],
            lwd = lwd[i],
            lty = lty[i])
    }
    
  })
  
  invisible(NULL)
}


#' @rdname plotDens
#' @param formula A formula of the form ...
#' @param data Optional data frame.
#' @param subset Optional subset.
#' @param na.action NA handling.

#' @method plotDens formula
#' @export
plotDens.formula <- function(
    
  formula,
  data,
  subset,
  na.action = na.omit,
  
  ...,
  
  add = FALSE,
  bw = "nrd0",
  type = NULL,
  
  col = NULL,
  lwd = 2,
  lty = 1,
  fill = FALSE,
  grid = NA,
  
  main = "",
  xlab = "",
  ylab = NULL,
  
  xlim = NULL,
  ylim = NULL
  
) {

    
  args <- list(
    formula   = formula,
    na.action = na.action,
    allowed   = c(
      "one-sample",
      "two-sample-independent",
      "n-sample-independent",
      "n-sample-dependent"
    )
  )

  if (!missing(data))
    args$data <- data
  
  if (!missing(subset))
    args$subset <- substitute(subset)
  
  r <- do.call( bedrock::resolveFormula, args )
  

  # ============================================================
  # ordinary densities
  # ============================================================
  
  if (r$type != "n-sample-dependent") {
    
    if (is.null(type)) {
      
      type <- "density"
      
    } else {
      
      type <- match.arg(type,
                        c("density", "conditional"))
    }
    
    if (type != "density")
      stop(
        "conditional densities require formula ",
        "y ~ x | group"
      )
    
    split_data <- switch(
      
      r$type,
      
      "one-sample" =
        list(r$x),
      
      "two-sample-independent" =
        split(r$x, r$group),
      
      "n-sample-independent" =
        split(r$x, r$group)
    )
    
    if (!nzchar(xlab))
      xlab <- names(r$mf)[1]
    
    if (is.null(ylab))
      ylab <- "density"
    
    plotDens(
      split_data,
      add  = add,
      bw   = bw,
      col  = col,
      lwd  = lwd,
      lty  = lty,
      fill = fill,
      grid = grid,
      main = main,
      xlab = xlab,
      ylab = ylab,
      xlim = xlim,
      ylim = ylim,
      ...
    )
    
    return(invisible(NULL))
  }
  
  # ============================================================
  # conditional densities
  # ============================================================
  
  if (is.null(type)) {
    
    type <- "conditional"
    
  } else {
    
    type <- match.arg(type,
                      c("density", "conditional"))
  }
  
  if (type != "conditional")
    stop("use type='conditional' for y ~ x | group")
  
  y <- r$response
  x <- r$group
  g <- r$block
  
  ptx <- if (is.null(xlim))
    pretty(range(x, na.rm = TRUE), n = 200)
  else
    pretty(xlim, n = 200)
  
  g <- factor(g)
  
  lev <- levels(g)
  n   <- length(lev)
  
  if (is.null(col))
    col <- .getOption(
      "palette",
      grDevices::palette()
    )[seq_len(n)]
  
  col <- rep_len(col, n)
  lwd <- rep_len(lwd, n)
  lty <- rep_len(lty, n)
  
  th <- .theme(
    grid = list(
      col = "grey90",
      lwd = 1,
      lty = "dotted"
    )
  )
  
  if (is.null(ylab)) {
    
    ylab <- paste0(
      "P(",
      names(r$mf)[1],
      " | ",
      names(r$mf)[2],
      ")"
    )
  }
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    if (!add) {
      
      plot(
        NA,
        xlim = range(ptx),
        ylim = c(0, 1),
        main = main,
        xlab = names(r$mf)[2],
        ylab = ylab,
        type = "n"
      )
    }
    
    bedrock::callIf(
      graphics::grid,
      grid,
      defaults = th$grid[
        !startsWith(
          names(th$grid),
          "group."
        )
      ]
    )
    
    for (i in seq_len(n)) {
      
      idx <- g == lev[i]
      
      xi <- x[idx]
      yi <- y[idx]
      
      if (!is.factor(yi))
        yi <- factor(yi)
      
      fit <- cdplot(
        yi ~ xi,
        plot = FALSE,
        bw = bw
      )
      
      fx <- fit[[1]]
      
      yy <- fx(ptx)
      
      lines(
        ptx,
        yy,
        col = col[i],
        lwd = lwd[i],
        lty = lty[i]
      )
    }
    
  })
  
  invisible(NULL)
}

