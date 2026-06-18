

# internal getOption wrapper for DescToolsX options
.getOption <- function(name, default = NULL) {
  getOption(paste0("DescToolsX.", name), default)
}





## ---- Grid / Box: konsistent, theme-gesteuert, explizites Formal ----------

#' @noRd
.drawGrid <- function(grid, defaults = list()) {
  
  th <- getTheme()$grid
  
  spec <- if (identical(grid, .useTheme)) !isFALSE(th) else grid
  
  if (isFALSE(spec) || is.null(spec) ||
      (length(spec) == 1L && !is.list(spec) && is.na(spec)))
    return(invisible())
  
  themeDefaults <- if (is.list(th)) th[!startsWith(names(th), "group.")] else list()
  
  bedrock::callIf(graphics::grid, spec, defaults = .modifyListSafe(themeDefaults, defaults))
}

#' @noRd
.drawBox <- function(box, defaults = list()) {
  
  th <- getTheme()$box
  
  spec <- if (identical(box, .useTheme)) !isFALSE(th) else box
  
  if (isFALSE(spec) || is.null(spec) ||
      (length(spec) == 1L && !is.list(spec) && is.na(spec)))
    return(invisible())
  
  themeDefaults <- if (is.list(th)) th else list()
  
  bedrock::callIf(graphics::box, spec, defaults = .modifyListSafe(themeDefaults, defaults))
}


## ---- Graphics-State-Wrapper: stamp jetzt theme-gesteuert ------------------

#' @noRd
.withGraphicsState <- function(expr, stamp = .useTheme, resetLayout = FALSE) {
  
  keep <- c(
    "mar","mai","cex","cex.axis","cex.lab","cex.main","cex.sub",
    "las","tck","mgp","xaxs","yaxs","xaxt","yaxt",
    "col","col.axis","col.lab","col.main","col.sub",
    "lwd","lty","pch","bg","fg","xpd", "plt", 
    "oma", "omi"
  )
  
  op <- par(keep)
  
  withr::defer(par(op))
  withr::local_options(warn = 1)
  
  # stamp kann .useTheme/TRUE/FALSE/NULL/NA (Toggle), ein nackter String
  # oder eine Expression (= der Text selbst), oder eine Liste von
  # Argumenten fuer stamp() sein (z.B. list(text="...", las=2)).
  stampArgs <- if (is.list(stamp)) stamp else list(text = stamp)
  
  ok <- FALSE
  
  on.exit({
    if (ok)
      # 'stamp' hier meint die exportierte aurora::stamp()-Funktion, nicht
      # das lokale Formal-Argument 'stamp' dieses Aufrufs - R's Funktions-
      # Lookup ueberspringt Nicht-Funktionen in Aufrufposition, daher
      # loest sich das trotz Namensgleichheit korrekt auf.
      tryCatch(do.call(aurora::stamp, stampArgs), error = function(e) NULL)
    
    if (ok && resetLayout)
      tryCatch(layout(matrix(1)), error = function(e) NULL)
    
  }, add = TRUE)
  
  eval.parent(substitute(expr))
  
  ok <- TRUE
  invisible(NULL)
}




## ---- ApplyParFromDots: + Theme-par als unterste Präzedenzstufe -----------

#' @noRd
.applyParFromDots <- function(..., exclude = "cex", defaults = list()) {
  
  # exclude defaults to "cex": cex must never reach par() via the function-
  # default or user-dots passes (it scales line height and thus the
  # margins), see design_rules.md "cex policy". The theme 'par' pass below
  # is deliberately exempt - theme cex is global scaling, a different
  # concern from the gated function-argument cex (symbol size).
  
  patch_fourpar <- function(new_val, old_val, pname) {
    
    if (!is.null(names(new_val))) {
      idx <- match(names(new_val), c("bottom","left","top","right"))
      if (any(is.na(idx)))
        stop(sprintf("%s names must be bottom, left, top, right", pname))
      old_val[idx] <- new_val
      return(old_val)
    }
    
    new_val <- rep_len(new_val, 4)
    idx_na <- is.na(new_val)
    new_val[idx_na] <- old_val[idx_na]
    new_val
  }
  
  apply_set <- function(args, useExclude = TRUE) {
    
    args <- args[!is.na(names(args))]
    args <- args[names(args) %in% names(par(no.readonly = TRUE))]
    
    if (useExclude && !is.null(exclude))
      args <- args[!names(args) %in% exclude]
    
    if (!length(args)) return(invisible())
    
    p <- par(no.readonly = TRUE)
    
    if ("mar" %in% names(args)) args$mar <- patch_fourpar(args$mar, p$mar, "mar")
    if ("oma" %in% names(args)) args$oma <- patch_fourpar(args$oma, p$oma, "oma")
    
    do.call(par, args)
    invisible()
  }
  
  # Pass 0 (niedrigste Präzedenz, läuft zuerst): Theme-par. Bewusst ohne
  # 'exclude' - siehe Kommentar oben.
  apply_set(getTheme()$par, useExclude = FALSE)
  
  # Pass 1: Funktions-Defaults, ggf. durch eine gesetzte Option überschrieben
  if (length(defaults)) {
    defaults <- Map(function(nm, val) .resolvePar(nm, default = val),
                    names(defaults), defaults)
    apply_set(defaults)
  }
  
  # Pass 2 (höchste Präzedenz, läuft zuletzt): User-Dots
  apply_set(list(...))
  
  invisible()
}



# Top margin in lines depending on the presence of a main title.
# NULL/NA main -> compact top (room for axis only), else room for title.
# Values are theme defaults, not magic numbers at 40 call sites.
.marTop <- function(main) {
  noTitle <- isFALSE(main) || identical(main, "") || isTRUE(is.na(main))
  if (noTitle) 2.1 else 4.1
}


.resolvePar <- function(name, value = NULL, default = NULL) {
  
  if (!is.null(value)) {
    return(value)
  }
  
  opt <- .getOption(paste0("DescToolsX.plot.", name))
  if (!is.null(opt)) {
    return(opt)
  }
  
  default
}



#' @noRd
.resolveTitle <- function(main, default = "") {
  
  if (is.null(main))
    return(default)
  
  noTitle <- isFALSE(main) || identical(main, "") || isTRUE(is.na(main))
  
  if (noTitle) "" else main
}



.isLastPanel <- function(tol = 1e-7) {
  # returns TRUE if the current panel is the last on mfrow, layout screens
  
  if (par("page"))
    return(FALSE)
  
  mfg <- par("mfg")
  
  if(length(mfg) == 4)
    return(mfg[1] == mfg[3] && mfg[2] == mfg[4])
  
  # needed for split.screen or manuel set fig parameters
  fig <- par("fig")
  abs(fig[2] - 1) < tol && abs(fig[3] - 0) < tol
}






.neededMargin <- function(labels,
                          side = 2,
                          cex = par("cex.axis"),
                          pad = 0.5,
                          axis.line = 1) {
  
  if(length(labels) == 0)
    return(0)
  
  w <- max(strwidth(labels, units = "inches", cex = cex))
  h <- max(strheight(labels, units = "inches", cex = cex))
  
  size <- if(side %in% c(2,4)) w else h
  
  lineHeight <- par("csi") * par("mex")
  
  lines <- size / lineHeight
  
  ceiling(lines + axis.line + pad)
}


.marginLines <- function(labels,
                         side = 4,
                         las = par("las"),
                         cex = par("cex"),
                         pad = 0,
                         axis.line = 0) {
  
  if(is.null(labels) || !length(labels))
    return(0)
  
  w <- max(strwidth(labels, units = "inches", cex = cex))
  h <- max(strheight(labels, units = "inches", cex = cex))
  
  size <- if(las %in% c(2, 3)) {
    w
  } else {
    if(side %in% c(2, 4)) w else h
  }
  
  lineHeight <- par("csi") * par("mex")
  
  ceiling(
    1.15 * (size / lineHeight + axis.line + pad)
  )
  
}



.adjustMargin <- function(labels,
                          side = 2,
                          las = par("las"),
                          cex = par("cex.axis"),
                          pad = 0.5,
                          axis.line = 1) {
  
  if(is.null(labels) || !length(labels))
    return(invisible())
  
  needed <- .marginLines(
    labels    = labels,
    side      = side,
    las       = las,
    cex       = cex,
    pad       = pad,
    axis.line = axis.line
  )
  
  mar <- par("mar")
  
  if(needed > mar[side]) {
    mar[side] <- needed
    par(mar = mar)
  }
  
  .checkMargins()
  
  invisible()
}




.checkMargins <- function() {
  
  mar <- par("mar")
  fin <- par("fin")
  
  lineHeight <- par("csi") * par("mex")
  
  heightLines <- fin[2] / lineHeight
  widthLines  <- fin[1] / lineHeight
  
  if(mar[1] + mar[3] >= heightLines ||
     mar[2] + mar[4] >= widthLines) {
    
    # shrink proportionally
    scale <- 0.9 * min(
      heightLines / (mar[1] + mar[3]),
      widthLines  / (mar[2] + mar[4])
    )
    
    par(mar = mar * scale)
  }
  
  invisible()
}



.resolveCex <- function(dots) {
  
  cex <- dots$cex %||% par("cex")
  
  list(
    cex      = cex,
    cex.axis = dots$cex.axis %||% cex,
    cex.lab  = dots$cex.lab  %||% cex,
    cex.main = dots$cex.main %||% cex,
    cex.sub  = dots$cex.sub  %||% cex
  )
  
}



.outerAt <- function(at, side = 2) {
  
  usr <- par("usr")
  plt <- par("plt")
  
  if (side %in% c(2,4)) {
    # y direction
    plt[3] + (at - usr[3]) / diff(usr[3:4]) * diff(plt[3:4])
  } else {
    # x direction
    plt[1] + (at - usr[1]) / diff(usr[1:2]) * diff(plt[1:2])
  }
  
}



#' @noRd
.resolveToggle <- function(spec, themeValue) {
  if (identical(spec, .useTheme)) !isFALSE(themeValue) else spec
}


#' @noRd
.modifyListSafe <- function(x, val) {
  # utils::modifyList() treats a NULL value in 'val' as "delete this key"
  # rather than "set it to NULL" - that silently drops things like
  # ny = NULL, which graphics::grid() needs explicitly (its own formal
  # default is ny = nx, not ny = NULL). Same fix pattern as callIf()/
  # .theme() use internally; preserves explicit NULL values verbatim.
  for (nm in names(val)) {
    x[nm] <- list(val[[nm]])
  }
  x
}



