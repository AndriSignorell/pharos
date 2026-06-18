## ============================================================================
## Theme-System für aurora
## ============================================================================
## Zentrale Default-Werte für Grafik- und Format-Parameter, package-weit über
## getOption("aurora.theme") gesteuert. Plot-Funktionen konsumieren das Theme
## über .theme()/.drawGrid()/.drawBox()/.withGraphicsState() und können es via
## explizite Argumente lokal überschreiben (Präzedenz: User-Argument >
## Funktions-Default > Theme-Default).


## ---- Master-Default-Theme --------------------------------------------------

.themeDefaults <- list(
  
  # Achsenbeschriftung, Linienstärke etc. - läuft als eigener par()-Pass
  # OHNE die cex-Exclude-Sperre (siehe .applyParFromDots). Diese cex meint
  # die globale Skalierung, nicht das gesperrte Funktionsargument-cex
  # (Symbolgrösse), das nie über par() laufen darf.
  par = list(
    col.axis = "grey40",
    las      = 1,
    cex      = 1.1
  ),
  
  # Hauptgitter + untergeordnetes Gitter (group.* Präfix-Konvention, wird
  # von .drawGrid() via startsWith(..., "group.") herausgefiltert, bevor
  # es an graphics::grid() geht)
  grid = list(
    col       = "grey80",
    lwd       = 1,
    lty       = "dotted",
    group.col = "grey50",
    group.lwd = 1,
    group.lty = "dotted"
  ),
  
  box = list(
    col = "grey50",
    lwd = 1,
    lty = "solid"
  ),
  
  points = list(
    pch = 21,
    col = "grey50",
    bg  = addAlpha("grey"),   # Alpha fix im Theme-Default, nicht bei jedem Plot-Call
    cex = 1.1
  ),
    
  # Zwei Farben: feste, benannte Wahl. Mehr als zwei: Paletten-Lookup.
  # Wenn ein Kontext zwei Farben braucht, aber nicht 'twin' passt, muss
  # der Funktionsaufruf das explizit selbst definieren (kein impliziter
  # Fallback auf palette(n=2)).
  # twin    = c("steelblue", "darkorange"),
  twin    = pal("Helsana")[c(6, 1)],
  palette = "Helsana",
  
  bar = list(
    col    = "grey80",
    border = NA
  ),
  
  # Format-Codes für fm(), genested statt vier Top-Level-Keys
  sty = list(
    abs  = "abs.sty",
    perc = "per.sty",
    num  = "num.sty",
    pval = "pval.sty"
  ),
  
  # Unevaluiert gespeichert - eval() passiert lazy beim tatsächlichen Plot,
  # nie beim Laden/Setzen des Themes, sonst frieren Username/Datum ein.
  stamp = expression(
    gettextf("%s / %s", Sys.getenv("USERNAME"), format(Sys.Date(), "%Y-%m-%d"))
  )
)



## ---- Öffentliche Session-API -----------------------------------------------

#' Get or Set the Active Graphics/Format Theme
#'
#' \code{getTheme()} returns the currently active theme (a named list of
#' graphical and formatting defaults consumed by aurora's plotting
#' functions). \code{setTheme()} updates it for the current session, either
#' by merging a partial list into the active theme or by switching to a
#' named preset. \code{resetTheme()} restores the package defaults.
#'
#' @param theme either a named list of theme components to merge into the
#'   active theme (only the given top-level elements are replaced; e.g.
#'   \code{setTheme(list(palette = "Set2"))} changes only the palette), or
#'   a single string naming a preset in \code{.themePresets}.
#'
#' @return \code{getTheme()} and \code{resetTheme()} return the (new)
#'   active theme; \code{setTheme()} returns the new active theme,
#'   invisibly.
#'
#' @name getTheme
#' @export
getTheme <- function() {
  getOption("aurora.theme", .themeDefaults)
}

#' @rdname getTheme
#' @export
setTheme <- function(theme) {
  
  new <- if (is.character(theme) && length(theme) == 1L) {
    
    .themePresets[[theme]] %||%
      stop("unknown theme preset: '", theme, "'. Available: ",
           paste(names(.themePresets), collapse = ", "))
    
  } else if (is.list(theme)) {
    
    utils::modifyList(getTheme(), theme)
    
  } else {
    stop("'theme' must be a named list or a preset name")
  }
  
  options(aurora.theme = new)
  invisible(new)
}

#' @rdname getTheme
#' @export
resetTheme <- function() {
  options(aurora.theme = .themeDefaults)
  invisible(.themeDefaults)
}


## ---- Preset-Registry (vorerst leer, Presets folgen bei Bedarf) -----------

.themePresets <- list()


## ---- Lokaler Resolver: Funktions-Defaults gegen aktives Theme auflösen ----

#' @noRd
.theme <- function(...) {
  
  fallback <- list(...)
  active   <- getTheme()
  
  if (length(fallback) == 0L) return(active)
  
  out <- fallback
  
  for (nm in names(fallback)) {
    # modifyList(arg) <- list(NULL) statt out[[nm]] <- NULL: ein NULL-Eintrag
    # in active[[nm]] würde durch normales Zuweisen den Key aus 'out' löschen
    # statt ihn auf NULL zu setzen (gleiche Falle wie bei callIf()).
    if (!is.null(active[[nm]]))
      out[[nm]] <- utils::modifyList(fallback[[nm]], active[[nm]])
  }
  
  out
}


## ---- Sentinel: "kein expliziter Wert übergeben -> Theme entscheidet" ------

# Eigenständiges Objekt statt TRUE/FALSE/NA/NULL als Formal-Default, damit es
# nie mit einem legitimen, dokumentierten User-Wert kollidiert (z.B. ist
# grid = NULL bei manchen Funktionen bereits "explizit unterdrücken" - das
# darf durch die Theme-Integration nicht überschrieben werden). Kein
# dots-Sniffing, kein neues ...-Argument - reines, explizites Formal-Matching.
.useTheme <- structure(list(), class = "aurora_useTheme")

# theme.R, neben .theme()/.useTheme


#' @noRd
.useThemeValue <- function(value, ...) {
  if (!identical(value, .useTheme)) return(value)
  th <- getTheme()
  for (key in list(...)) th <- th[[key]]
  th
}
