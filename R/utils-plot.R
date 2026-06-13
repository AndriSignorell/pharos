

# internal getOption wrapper for DescToolsX options
.getOption <- function(name, default = NULL) {
  getOption(paste0("DescToolsX.", name), default)
}





.withGraphicsState <- function(expr, stamp = .getOption("stamp", NULL), 
                               resetLayout = FALSE) {
  
  # nur "sichere" par-Parameter speichern
  keep <- c(
    "mar","mai","cex","cex.axis","cex.lab","cex.main","cex.sub",
    "las","tck","mgp","xaxs","yaxs","xaxt","yaxt",
    "col","col.axis","col.lab","col.main","col.sub",
    "lwd","lty","pch","bg","fg","xpd", "plt", 
    "oma", "omi"  # keep eye on this ...
  )
  
  op <- par(keep)
  
  withr::defer(par(op))
  withr::local_options(warn = 1)
  
  ok <- FALSE
  
  on.exit({
    if (ok && !is.null(stamp))
      tryCatch(stamp(), error = function(e) NULL)
    if (ok && resetLayout)
      tryCatch(layout(matrix(1)), error = function(e) NULL)
  }, add = TRUE)
  
  eval.parent(substitute(expr))
  
  ok <- TRUE
  invisible(NULL)
}



# Top margin in lines depending on the presence of a main title.
# NULL/NA main -> compact top (room for axis only), else room for title.
# Values are theme defaults, not magic numbers at 40 call sites.
.marTop <- function(main) {
  if (is.null(main) || isTRUE(is.na(main))) 2.1 else 4.1
}


.resolvePar <- function(name, value = NULL, default = NULL) {
  
  if (!is.null(value)) {
    return(value)
  }
  
  opt <- .getOption(paste0("descToolsX.plot.", name))
  if (!is.null(opt)) {
    return(opt)
  }
  
  default
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



.applyParFromDots <- function(..., exclude = "cex", defaults = list()) {
  
  # exclude defaults to "cex": cex must never reach par() (it scales line
  # height and thus the margins), see design_rules.md "cex policy".
  # Callers can override with exclude = NULL if they really know better.
  
  # WHY exclude/defaults sit AFTER the dots:
  # formals placed after ... require exact names, so partial matching can
  # never hijack them (and a user's def=/exc= in the dots stays in the dots).
  # See design_rules.md "Argument matching & signature design".
  
  # Patch a 4-element par (mar, oma) element-wise instead of replacing it:
  # a user saying mar=c(bottom=2) means "change the bottom", not "throw away
  # the function's left/right/top defaults". Two input styles are supported:
  #   - named:    c(left=5)        -> only named sides are replaced
  #   - unnamed:  c(2, NA, NA, NA) -> NA means "keep current value"
  patch_fourpar <- function(new_val, old_val, pname) {
    
    if (!is.null(names(new_val))) {
      idx <- match(names(new_val), c("bottom","left","top","right"))
      # fail loudly on typos ("botom"), silently dropping them would be
      # a debugging nightmare
      if (any(is.na(idx)))
        stop(sprintf("%s names must be bottom, left, top, right", pname))
      old_val[idx] <- new_val
      return(old_val)
    }
    
    # unnamed: recycle to length 4 so mar=2 works as shorthand,
    # then fill NA positions from the current values
    new_val <- rep_len(new_val, 4)
    idx_na <- is.na(new_val)
    new_val[idx_na] <- old_val[idx_na]
    new_val
  }
  
  # One shared worker for both passes (defaults, user dots), so filtering,
  # exclusion and mar/oma patching behave identically on both levels --
  # this was previously duplicated (and once even duplicated *within* the
  # function body).
  apply_set <- function(args) {
    
    # drop unnamed elements: positional args in the dots belong to
    # plot()/points(), not to par()
    args <- args[!is.na(names(args))]
    
    # keep only genuine par() parameters; everything else in the dots
    # (xlim, main, ...) is meant for the plotting functions downstream.
    # no.readonly = TRUE so we never try to set read-only pars (cin, ...)
    args <- args[names(args) %in% names(par(no.readonly = TRUE))]
    
    # exclude applies to BOTH passes, deliberately: if "cex" must not be
    # set via par() (it scales line height and thus the margins, see
    # plotQQ), that holds for function defaults just as for user input
    if (!is.null(exclude))
      args <- args[!names(args) %in% exclude]
    
    if (!length(args)) return(invisible())
    
    # snapshot AFTER filtering and INSIDE each pass: the second pass must
    # patch against the state the first pass produced, so user mar values
    # compose with the function's mar defaults instead of resetting them
    p <- par(no.readonly = TRUE)
    
    if ("mar" %in% names(args)) args$mar <- patch_fourpar(args$mar, p$mar, "mar")
    if ("oma" %in% names(args)) args$oma <- patch_fourpar(args$oma, p$oma, "oma")
    
    do.call(par, args)
    invisible()
  }
  
  # Precedence: user dots > options() > function defaults.
  # Implemented as two sequential par() passes rather than one merged list:
  # sequential application is what makes element-wise composition of
  # mar/oma across levels possible (a merged list could only replace
  # whole vectors, losing e.g. the default left margin when the user
  # only changes the bottom).
  if (length(defaults)) {
    # resolve each default against a possible user option
    # (DescToolsX.plot.<name>) before applying -- this is the hook that
    # was missing in the old two-pattern approach, where options() never
    # had a chance to take effect
    defaults <- Map(function(nm, val) .resolvePar(nm, default = val),
                    names(defaults), defaults)
    apply_set(defaults)
  }
  
  # user dots last, so they always win
  apply_set(list(...))
  
  invisible()
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



.adjustMargin <- function(labels,
                          side = 2,
                          las = par("las"),
                          cex = par("cex.axis"),
                          pad = 0.5,
                          axis.line = 1) {
  
  if(is.null(labels) || !length(labels))
    return(invisible())
  
  w <- max(strwidth(labels, units="inches", cex=cex))
  h <- max(strheight(labels, units="inches", cex=cex))
  
  size <- if(las %in% c(2,3)) {
    w
  } else {
    if(side %in% c(2,4)) w else h
  }
  
  lineHeight <- par("csi") * par("mex")
  
  lines <- size / lineHeight
  
  needed <- ceiling(1.15 * (lines + axis.line + pad))
  
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


# .adjustMargin <- function(labels,
#                           side = 2,
#                           las = par("las"),
#                           cex = par("cex.axis"),
#                           pad = 0.5,
#                           axis.line = 1) {
#   
#   if(is.null(labels) || !length(labels))
#     return(invisible())
#   
#   w <- max(strwidth(labels, units="inches", cex=cex))
#   h <- max(strheight(labels, units="inches", cex=cex))
#   
#   size <- if(las %in% c(2,3)) w else if(side %in% c(2,4)) w else h
#   
#   lineHeight <- par("csi") * par("mex")
#   
#   lines <- size / lineHeight
#   
#   needed <- ceiling(1.15 * (lines + axis.line + pad))
#   
#   mar <- par("mar")
#   
#   # limit margins to avoid "figure margins too large"
#   needed <- min(needed, 0.45 * sum(par("fin") / lineHeight))
#   
#   if(needed > mar[side]) {
#     mar[side] <- needed
#     par(mar = mar)
#   }
#   
#   invisible()
# }


# .adjustMargin <- function(labels,
#                           side = 2,
#                           las = par("las"),
#                           cex = par("cex.axis"),
#                           pad = 0.5,
#                           axis.line = 1) {
#   
#   if(is.null(labels) || !length(labels))
#     return(invisible())
#   
#   w <- max(strwidth(labels, units="inches", cex=cex))
#   h <- max(strheight(labels, units="inches", cex=cex))
#   
#   size <- if(las %in% c(2, 3)) {
#     w
#   } else {
#     if(side %in% c(2,4)) w else h
#   }
#   
#   lineHeight <- par("csi") * par("mex")
#   
#   lines <- size / lineHeight
#   
#   # slightly inflate to avoid clipping
#   needed <- ceiling(1.15 * (lines + axis.line + pad))
#   
#   mar <- par("mar")
#   
#   if(needed > mar[side]) {
#     mar[side] <- needed
#     par(mar = mar)
#   }
#   
#   invisible()
# }
# 
# 



# 
# .adjustLeftMarginForLabels <- function(labels, pad=0.5) {
#   
#   if (is.null(labels) || !length(labels))
#     return(invisible())
#   
#   # w <- max(strwidth(labels,
#   #                   units = "inches",
#   #                   cex = par("cex.axis")))
#   # 
#   # lineHeight <- par("csi") * par("mex")
#   # 
#   # needed <- 1.1 * (ceiling(w / lineHeight) + 1)
#   
#   needed <- .neededMargin(labels, pad=pad)
#   
#   mar <- par("mar")
#   
#   if (needed > mar[2]) {
#     mar[2] <- needed
#     par(mar = mar)
#   }
#   
#   invisible()
# }
# 
# 
# 
# .adjustBottomMarginForLas2 <- function(labels) {
#   
#   if (is.null(labels) || !length(labels))
#     return(invisible())
#   
#   w <- max(strwidth(labels,
#                     units = "inches",
#                     cex = par("cex.axis")))
#   
#   lineHeight <- par("csi") * par("mex")
#   
#   needed <- ceiling(w / lineHeight) + 1
#   
#   mar <- par("mar")
#   
#   if (needed > mar[1]) {
#     mar[1] <- needed
#     par(mar = mar)
#   }
#   
#   invisible()
# }
# 
# 
# 
# 
 


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




# options(DescToolsX.theme = list(
#   bg        = "white",
#   col       = "grey70",
#   border    = "white",
#   grid      = TRUE,
#   grid.col  = "grey85",
#   grid.lty  = 1,
#   grid.lwd  = 1
# ))


.getTheme <- function() {
  th <- getOption("DescToolsX.theme")
  if (is.null(th))
    th <- list()
  th
}



.theme <- function(...) {
  
  args <- list(...)
  th   <- .getTheme()
  
  out <- list()
  
  for (nm in names(args)) {
    
    arg <- args[[nm]]
    
    # theme entries belonging to this object
    idx <- startsWith(names(th), paste0(nm, "."))
    th_sub <- th[idx]
    
    # convert flat theme names -> property names
    if (length(th_sub)) {
      names(th_sub) <- sub(paste0("^", nm, "\\."), "", names(th_sub))
    }
    
    # special rename for pch.id -> pch
    if (nm == "pch" && "id" %in% names(th_sub)) {
      names(th_sub)[names(th_sub) == "id"] <- "pch"
    }
    
    # combine argument + theme
    if (is.null(arg) || isTRUE(arg)) {
      
      out[[nm]] <- th_sub
      
    } else if (is.list(arg)) {
      
      # ** this would be elegant, but removes things like ny=NULL
      # out[[nm]] <- modifyList(th_sub, arg)
      
      merged <- th_sub
      for (nm2 in names(arg))
        merged[nm2] <- list(arg[[nm2]])
      out[[nm]] <- merged
      
    } else {
      
      # simple scalar (e.g. pch=16)
      if (nm == "pch")
        out[[nm]] <- modifyList(th_sub, list(pch = arg))
      else
        out[[nm]] <- modifyList(th_sub, list(col = arg))
      
    }
  }
  
  out
}






## == old stuff ============================================================

# 
# .theme <- function(...) {
#   
#   args <- list(...)
#   th   <- .getTheme()
#   
#   out <- vector("list", length(args))
#   names(out) <- names(args)
#   
#   for (nm in names(args)) {
#     out[[nm]] <- args[[nm]] %||% th[[nm]]
#   }
#   
#   out
# }
# 
# 


# # internal function to restore settings after a plot has been created
# 
# .withGraphicsState <- function(expr) {
#   
#   op <- par(no.readonly = TRUE)
#   ok <- FALSE
#   
#   on.exit({
#     # layout(matrix(1))
#     par(op)
#     
#     if (ok) {   ## && !is.null(.getOption("stamp"))) {
#       tryCatch(stamp(), error = function(e) NULL)
#     }
#     
#   }, add = TRUE)
#   
#   force(expr)
#   ok <- TRUE
#   
# }
# 


# base version
# # with layout saving option
# .withGraphicsState <- function(expr) {
#   
#   op <- par(no.readonly = TRUE)
#   opt <- options()
#   
#   hasLayout <- {
#     n <- layout.show(n = 0)
#     isTRUE(n > 0)
#   }
#   
#   ok <- FALSE
#   
#   on.exit({
#     par(op)
#     options(opt)
#     
#     if (hasLayout) {
#       ## layout wiederherstellen (falls ihr das implementiert habt)
#     }
#     
#     if (ok) {
#       tryCatch(stamp(), error = function(e) NULL)
#     }
#     
#   }, add = TRUE)
#   
#   # force(expr)
#   eval.parent(substitute(expr))
#   
#   ok <- TRUE
# }
# 
# 
# .withGraphicsState <- function(expr) {
#   
#   op <- par(no.readonly = TRUE)
#   ow <- options(warn = 1)
#   
#   ok <- FALSE
#   
#   on.exit({
#     if (ok) tryCatch(stamp(), error = function(e) NULL)
#     par(op)
#     options(ow)
#   }, add = FALSE)
#   
#   eval.parent(substitute(expr))
#   
#   ok <- TRUE
#   
#   invisible(NULL)
# }


# .withGraphicsState <- function(expr) {
# 
#   op <- par(no.readonly = TRUE)
#   withr::defer(par(op))
# 
#   withr::local_options(list(warn = 1))
# 
#   ok <- FALSE
# 
#   on.exit({
#     if (ok) tryCatch(stamp(), error = function(e) NULL)
#   }, add = TRUE)
# 
#   eval.parent(substitute(expr))
# 
#   ok <- TRUE
# 
#   invisible(NULL)
# }



# .withGraphicsState <- function(expr) {
#   
#   forbidden <- c(
#     "mfrow","mfcol","mfg",
#     "fig","plt","pin","fin",
#     "usr","new"
#   )
#   
#   before <- par(no.readonly = TRUE)
#   
#   op <- before[setdiff(names(before), forbidden)]
#   withr::defer(par(op))
#   
#   withr::local_options(warn = 1)
#   
#   stamp_opt <- .getOption("stamp")
#   
#   ok <- FALSE
#   
#   on.exit({
#     if (ok && !is.null(stamp_opt) && .isLastPanel())
#       tryCatch(stamp(), error = function(e) NULL)
#   }, add = TRUE)
#   
#   eval.parent(substitute(expr))
#   
#   after <- par(no.readonly = TRUE)
#   
#   changed <- forbidden[
#     vapply(forbidden, function(p)
#       !identical(before[[p]], after[[p]]), logical(1))
#   ]
#   
#   if (length(changed)) {
#     warning(
#       "The following 'par' parameters should not be modified inside this plotting function: ",
#       paste(changed, collapse = ", "),
#       call. = FALSE
#     )
#   }
#   
#   ok <- TRUE
#   
#   invisible(NULL)
# }
# 
