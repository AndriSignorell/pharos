
#' Frequency Distribution Plot 
#' 
#' Creates a univariate graphical summary combining a histogram (or probability
#' mass plot for discrete data), a kernel density curve, a boxplot, and an
#' empirical cumulative distribution function in a single multi-panel figure.
#' Optional components include a rug, and fitted theoretical distribution
#' curves for both the histogram and the ECDF panel.
#'
#' Each plot component is controlled via a single argument accepting
#' \code{\link[bedrock]{callIf}} semantics:
#' \itemize{
#'   \item \code{TRUE}: draw with package defaults
#'   \item \code{FALSE}, \code{NULL}, or \code{NA}: suppress entirely
#'   \item a named list: draw with the given overrides merged into the defaults
#' }
#' 
#' Performance: for very large vectors (n > 1e7) the density curve, ECDF,
#' and semi-transparent boxplot outliers will still take noticeable time.
#' For exploratory work on very large data, consider sampling first:
#' \code{plotFdist(x[sample(length(x), 5000)])}.
#'
#' @param x numeric vector whose distribution is to be plotted.
#'
#' @param main main title. \code{NULL} (default) derives the title from
#'   \code{deparse(substitute(x))}. \code{""}, \code{NA}, or \code{FALSE}
#'   suppress the title and compact the top margin.
#' @param xlab label for the x-axis. The variable name is typically placed
#'   in \code{main}, so this defaults to \code{""}.
#' @param xlim range of the x-axis. \code{NULL} (default) uses a pretty
#'   range of \code{range(x, na.rm = TRUE)}.
#'
#' @param na.rm logical; should \code{NA}s be removed before plotting?
#'   The density function requires complete cases, so \code{TRUE} is
#'   recommended when \code{x} contains missing values. Default \code{FALSE}.
#' @param heights numeric vector of relative panel heights for
#'   \code{\link{layout}}: three values for histogram/boxplot/ecdf, two
#'   for histogram/boxplot or histogram/ecdf only. \code{NULL} (default)
#'   chooses automatically.
#'
#' @param hist controls the histogram panel. \code{TRUE} (default) uses
#'   package defaults; \code{FALSE}/\code{NA} suppresses the panel
#'   (not recommended: also disables automatic \code{xlim} detection);
#'   a list overrides specific arguments forwarded to
#'   \code{\link[graphics]{hist}}. The element \code{type} selects the
#'   plot style: \code{"hist"} (standard histogram, chosen automatically
#'   for continuous or high-cardinality data) or \code{"mass"} (vertical
#'   bars per unique value, for discrete/low-cardinality data).
#' @param dens controls the kernel density curve. \code{TRUE} (default)
#'   draws a curve via \code{\link[stats]{density}}; a list overrides
#'   specific arguments (e.g. \code{list(bw = 0.1, col = "red")}).
#' @param rug controls a rug plot. \code{FALSE} (default) suppresses it;
#'   \code{TRUE} or a list draw a rug via \code{\link[graphics]{rug}}.
#' @param curve controls a fitted theoretical distribution curve on the
#'   histogram. \code{FALSE} (default) suppresses it; \code{TRUE} or
#'   \code{NULL} draws a normal curve with \code{mean(x)}/\code{sd(x)};
#'   a list may include \code{expr} as a character string or expression
#'   for any distribution (e.g.
#'   \code{list(expr = "dt(x, df=2)", col = "darkgreen")}).
#' @param boxplot controls the boxplot panel. \code{TRUE} (default) draws
#'   a horizontal boxplot with a mean marker and CI band; \code{FALSE}/
#'   \code{NA} suppresses the panel. A list overrides arguments forwarded
#'   to \code{\link[graphics]{boxplot}}; two extra elements control the
#'   mean display: \code{pch.mean} (default \code{3}) and \code{col.meanci}
#'   (default \code{getTheme()$grid$col}). Set either to \code{NA} to
#'   suppress that element.
#' @param ecdf controls the ECDF panel. \code{TRUE} (default) calls
#'   \code{\link{plotECDF}}; a list overrides specific arguments.
#' @param curveEcdf controls a fitted theoretical CDF curve on the ECDF
#'   panel, analogous to \code{curve}. \code{FALSE} (default) suppresses
#'   it.
#'
#' @param stamp Controls the corner stamp. \code{.useTheme} (default)
#'   resolves to \code{getTheme()$stamp}. \code{TRUE}/\code{FALSE}/
#'   \code{NULL}, a string, or a named list for \code{\link{stamp}()}.
#' @param \dots further graphical parameters passed to \code{\link{par}}
#'   via the internal framework.
#'
#' @seealso \code{\link{hist}}, \code{\link{boxplot}}, \code{\link{plotECDF}},
#'   \code{\link{density}}, \code{\link{rug}}, \code{\link{layout}},
#'   \code{\link{getTheme}}
#'
#' @examples
#' plotFdist(faithful$eruptions, na.rm = TRUE)
#'
#' # custom histogram breaks, density color, boxplot styling
#' plotFdist(faithful$eruptions,
#'   hist    = list(breaks = 50),
#'   dens    = list(col = "olivedrab4"),
#'   na.rm   = TRUE,
#'   boxplot = list(col = "olivedrab2", pch.mean = NA, col.meanci = NA))
#'
#' # no density, no ecdf, add rug instead
#' plotFdist(faithful$eruptions,
#'   dens = FALSE, ecdf = FALSE,
#'   hist = list(xaxt = "s"),
#'   rug  = TRUE,
#'   heights = c(3, 2.5), 
#'   main = "Eruption time")
#'
#' # overlay a normal density curve
#' x <- rnorm(1000)
#' plotFdist(x, curve = TRUE, boxplot = FALSE, ecdf = FALSE)
#'
#' # compare with a t-distribution curve
#' plotFdist(x,
#'   curve   = list(expr = "dt(x, df=2)", col = "darkgreen"),
#'   boxplot = FALSE, ecdf = FALSE)
#'
#' # overlay gamma distribution on both histogram and ECDF
#' ozone <- airquality$Ozone
#' m <- mean(ozone, na.rm = TRUE)
#' v <- var(ozone, na.rm = TRUE)
#' plotFdist(ozone,
#'   hist       = list(breaks = 15),
#'   curve      = list(expr = "dgamma(x, shape = m^2/v, scale = v/m)",
#'                     col = "navajowhite3"),
#'   curveEcdf = list(expr = "pgamma(x, shape = m^2/v, scale = v/m)",
#'                     col = "navajowhite3"),
#'   na.rm = TRUE, main = "Airquality - Ozone")
#'

#' @family plot.univariate  
#' @concept frequency-table
#'
#'
#' @export
plotFdist <- function(x,
                      
                      # LABELS
                      main  = NULL,
                      xlab  = "",
                      
                      # AXES
                      xlim  = NULL,
                      
                      # STRUCTURE
                      na.rm   = FALSE,
                      heights = NULL,

                      # STYLE (callIf semantics)
                      hist       = TRUE,
                      dens       = TRUE,
                      rug        = FALSE,
                      curve      = FALSE,
                      boxplot    = TRUE,
                      ecdf       = TRUE,
                      curveEcdf = FALSE,
                      
                      # FRAMEWORK
                      stamp = .useTheme,
                      
                      ...) {
  
  
  # --- Internal helper: probability mass plot ------------------------------
  .plotMass <- function(x, xlab = "", ylab = "",
                        xaxt = ifelse(add.boxplot || add.ecdf, "n", "s"),
                        xlim = NULL,        # NULL here, set explicitly below
                        ylim = NULL,
                        main = NA,
                        las  = 1,
                        yaxt = "n",
                        col  = 1,
                        lwd  = 3,
                        pch  = NA,
                        col.pch  = 1,
                        cex.pch  = 1,
                        bg.pch   = 0,
                        cex.axis = NULL,    # NULL here, not cex.axis - no recursive ref
                        ...) {
    
    pp <- prop.table(table(x))
    if (is.null(ylim)) ylim <- c(0, max(pretty(pp)))
    
    plot(pp, type = "h", lwd = lwd, col = col,
         xlab = "", ylab = "", cex.axis = cex.axis,
         xlim = xlim, ylim = ylim,
         xaxt = xaxt, main = NA, frame.plot = FALSE, las = las,
         panel.first = {
           abline(h = axTicks(2), col = "grey", lty = "dotted")
           abline(h = 0, col = "black")
         })
    
    if (!identical(pch, NA))
      points(pp, type = "p", pch = pch, col = col.pch, bg = bg.pch, cex = cex.pch)
  }
  
  
  mc           <- match.call()
  defaultTitle <- deparse(mc$x)
  
  .withGraphicsState({
    
    .applyParFromDots(...)
    
    # Read back effective par state - reflects theme defaults, function
    # defaults, AND any user override from ..., all already merged by
    # .applyParFromDots() above.
    las      <- par("las")
    cex.axis <- par("cex.axis")
    mar      <- if ("mar" %in% ...names()) par("mar") else NULL
    
    th     <- getTheme()
    twin   <- th$twin
    thGrid <- th$grid
    
    main <- .resolveTitle(main, default = defaultTitle)
    
    # Remove NAs FIRST
    if (na.rm) x <- x[!is.na(x)]
    
    # Resolve component specs
    hist_args <- .resolveSpec(hist, list(
      x    = x, xlab = "", ylab = "", freq = FALSE,
      xlim = xlim, ylim = NULL, main = NA, las = 1,
      col  = "white", border = "grey70", yaxt = "n",
      xaxt = NULL
    ))
    
    dens_args <- .resolveSpec(dens, list(
      x   = x,
      bw  = if (length(x) > 1000) "nrd0" else "SJ",
      col = twin[1], lwd = 2, lty = "solid"
    ))
    
    rug_args <- .resolveSpec(rug, list(x = x, col = "grey"))
    curve_args <- .resolveSpec(curve, list(
      expr = parse(text = gettextf("dnorm(x, %s, %s)", mean(x), sd(x))),
      add  = TRUE, n = 500,
      col  = twin[2], lwd = 2, lty = "solid"
    ))
    
    boxplot_args <- .resolveSpec(boxplot, list(
      x          = x,
      frame.plot = FALSE, main = NA, boxwex = 1,
      horizontal = TRUE, col = "grey95", at = 1,
      outcex     = 1.3, outcol = rgb(0, 0, 0, 0.5),
      cex.axis   = cex.axis,
      pch.mean   = 3,
      col.meanci = thGrid$col
    ))
    
    ecdf_args <- .resolveSpec(ecdf, list(
      x        = x, main = NA, ylim = c(0, 1),
      col      = twin[2], lwd = 2,
      xlab     = "", ylab = "",
      cex.axis = cex.axis, las = las,
      stamp    = FALSE
    ))
    
    curveEcdf_args <- .resolveSpec(curveEcdf, list(
      expr = parse(text = gettextf("pnorm(x, %s, %s)", mean(x), sd(x))),
      add  = TRUE, n = 500,
      col  = twin[2], lwd = 2, lty = "solid"
    ))
    
    add.hist    <- !is.null(hist_args)
    add.dens    <- !is.null(dens_args)
    add.rug     <- !is.null(rug_args)
    add.dcurve  <- !is.null(curve_args)
    add.boxplot <- !is.null(boxplot_args)
    add.ecdf    <- !is.null(ecdf_args)
    add.pcurve  <- !is.null(curveEcdf_args)
    
    if (add.hist)
      hist_args$xaxt <- ifelse(add.boxplot || add.ecdf, "n", "s")
    
    if (is.null(heights)) {
      if (add.boxplot) {
        heights <- if (add.ecdf) c(1.8, 0.6, 1.4) else c(2, 1.4)
      } else if (add.ecdf) {
        heights <- c(2, 1.4)
      }
    }

    ppp <- par()[grep("cex", names(par()))]
    if (add.ecdf && add.boxplot) {
      layout(matrix(c(1, 2, 3), nrow = 3, byrow = TRUE), heights = heights, TRUE)
    } else if (add.ecdf || add.boxplot) {
      layout(matrix(c(1, 2), nrow = 2, byrow = TRUE), heights = heights[1:2], TRUE)
    }
    par(ppp)

    if(add.boxplot)    {
      par(mar = c(0, 4.1, 2.1, 2.1))
    } else if(add.ecdf){
      par(mar = c(1.1, 4.1, 2.1, 2.1))
    } else {
      par(mar = c(ifelse(is.null(xlab), 3.1, 5.1), 4.1, 2.1, 2.1))
    } 

    if (!is.null(mar)) {
      par(oma = mar)
    } else if (nzchar(main)) {
      par(oma = c(0, 0, 2, 0))
    } else {
      par(oma = c(0, 0, 0, 0))
    }
    
    
    # =========================================================================
    # Panel 1: histogram or mass plot
    # =========================================================================
    
    if (add.hist) {
      
      panel.last    <- hist_args[["panel.last"]]
      hist_args[["panel.last"]] <- NULL
      
      type_override <- hist_args[["type"]]
      hist_args[["type"]] <- NULL
      do.hist <- if (is.null(type_override)) {
        !(isTRUE(all.equal(x, round(x), tol = sqrt(.Machine$double.eps))) &&
            isLowCardinality(x, maxUnique = 12))
      } else {
        type_override == "hist"
      }
      
      comp_keys <- c("x","breaks","include.lowest","right","nclass")
      x.hist    <- do.call("hist",
                           c(hist_args[names(hist_args) %in% comp_keys],
                             plot = FALSE))
      x.hist$xname <- deparse(mc$x)
      
      # xlim: add 5% padding so outermost bars/lines don't sit flush
      # against the axis edge
      if (is.null(hist_args$xlim)) {
        raw <- range(pretty(x.hist$breaks))
        pad <- diff(raw) * 0.05
        hist_args$xlim <- c(raw[1] - pad, raw[2] + pad)
      }
      
      xlim_plot <- hist_args$xlim
      
      if (do.hist) {
        
        if (add.dens) {
          x.dens <- tryCatch(
            do.call("density",
                    dens_args[!names(dens_args) %in% c("col","lwd","lty")]),
            error = function(e) {
              warning(gettextf("density curve could not be added\n%s",
                               conditionMessage(e)))
              NULL
            }
          )
          if (is.null(x.dens)) {
            add.dens <- FALSE
          } else if (is.null(hist_args[["ylim"]])) {
            hist_args[["ylim"]] <-
              range(pretty(c(0, max(c(x.dens$y, x.hist$density)))))
          }
        }
        
        plot_args <- hist_args[!names(hist_args) %in% comp_keys]
        do.call("plot", append(list(x.hist), plot_args))
        
        ticks <- axTicks(2)
        n     <- max(floor(log(ticks, base = 10)))
        if (abs(n) > 2) {
          lab <- fm(ticks * 10^(-n),
                    digits = max(nDec(as.character(zapsmall(ticks * 10^(-n))))))
          axis(2, at = ticks, labels = lab, las = las,
               cex.axis = par("cex.axis"))
          text(par("usr")[1], par("usr")[4], bquote(~~~x~10^.(n)),
               xpd = NA, pos = 3, cex = par("cex.axis") * 0.8)
        } else {
          axis(2, cex.axis = par("cex.axis"), las = las)
        }
        
        if (!is.null(panel.last))
          eval(parse(text = panel.last))
        
        if (add.dens)
          lines(x.dens, col = dens_args$col, lwd = dens_args$lwd,
                lty = dens_args$lty)
        
        if (add.dcurve) {
          if (is.character(curve_args$expr))
            curve_args$expr <- parse(text = curve_args$expr)
          do.call("curve", curve_args)
        }
        
        if (add.rug)
          do.call("rug", rug_args)
        
      } else {
        
        # --- mass plot: own defaults, not from hist_args ---
        # hist_args has col="white" (for histogram bars) which would make
        # the mass lines invisible. Build a clean arg list for .plotMass().
        mass_args <- list(
          x        = x,
          xlim     = xlim_plot,
          xaxt     = ifelse(add.boxplot || add.ecdf, "n", "s"),
          las      = las,
          cex.axis = cex.axis    # injected explicitly, no recursive ref
        )
        
        # forward any user overrides from the 'hist' spec (type already stripped)
        protected <- c("x", "xlim", "xaxt", "las", "cex.axis",
                       "type", "freq", "col", "border", "yaxt")
        if (is.list(hist) && length(hist) > 0)
          mass_args[setdiff(names(hist), protected)] <-
          hist[setdiff(names(hist), protected)]
        
        do.call(.plotMass, mass_args)
      }
    } else {
      xlim_plot <- xlim %||% c(0, 1)   # fallback if hist suppressed
    }
    
    
    # =========================================================================
    # Panel 2: boxplot
    # =========================================================================
    
    if (add.boxplot) {
      par(mar = c(ifelse(add.ecdf, 0, 5.1), 4.1, 0, 2.1))
      
      boxplot_args$ylim <- boxplot_args$ylim %||% xlim_plot
      boxplot_args$xaxt <- ifelse(add.ecdf, "n", "s")
      
      plot(1, type = "n",
           xlim = xlim_plot, ylim = c(0, 1) + 0.5,
           xlab = "", ylab = "", axes = FALSE)
      
      grid(ny = NA, col = thGrid$col, lty = thGrid$lty, lwd = thGrid$lwd)
      
      if (length(x) > 1) {
        ci <- .meanCI_raw(x)
        if (!is.na(boxplot_args$col.meanci))
          rect(xleft = ci[2], ybottom = 0.62, xright = ci[3], ytop = 1.35,
               col = boxplot_args$col.meanci, border = NA)
      } else {
        ci <- mean(x)
      }
      
      bp_extra   <- c("pch.mean", "col.meanci")
      pch.mean   <- boxplot_args$pch.mean
      boxplot_args$add <- TRUE
      do.call("boxplot", boxplot_args[!names(boxplot_args) %in% bp_extra])
      
      if (!is.na(pch.mean))
        points(ci[1], 1, cex = 1.5, col = "grey65", pch = pch.mean, bg = "white")
    }
    
    
    # =========================================================================
    # Panel 3: ECDF
    # =========================================================================
    
    if (add.ecdf) {
      
      ecdf_args$xlim   <- ecdf_args$xlim   %||% xlim_plot
      ecdf_args$breaks <- ecdf_args$breaks %||%
        if (add.hist && length(x) > 1000 && length(x.hist$mids) > 10) 1000 else NULL
      
      # mar passed explicitly to plotECDF() - it has its own
      # .applyParFromDots() call that would otherwise apply its own
      # left=5 default, misaligning the y-axis with the panels above
      ecdf_args$mar <- c(3.1 + ifelse(identical(xlab, ""), 0, 2), 4.1, 0, 2.1)
      ecdf_args$box <- FALSE
      
      ecdf_args$xlab <- xlab   # set directly - plotECDF() restores its own
      # par() on exit, so title() called from here
      # afterwards would write into the wrong state
      
      do.call("plotECDF", ecdf_args)
      
      if (add.pcurve) {
        if (is.character(curveEcdf_args$expr))
          curveEcdf_args$expr <- parse(text = curveEcdf_args$expr)
        do.call("curve", curveEcdf_args)
      }
    }
    
    if (nzchar(main))        title(main = main, outer = TRUE)
    if (!add.ecdf & !identical(xlab, "")) title(xlab = xlab)
    
  }, stamp = stamp, resetLayout = TRUE)
  
}

