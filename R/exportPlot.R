#' Export a Plot to Graphics Files
#'
#' @description
#' Draws a plot to one or several graphics files (PNG, TIFF, PDF, SVG) in a
#' single call, controlled by a session-wide switch. It is meant for analysis
#' scripts that produce publication figures: the plot call is written once,
#' piped into `exportPlot()`, and the files are only (re)written when the
#' switch is on. Running a chunk interactively then shows the plot on screen
#' without overwriting the figures produced by an earlier, final run.
#'
#' ```r
#' options(pharos.exportPlot = TRUE)   # once, at the top of the script
#'
#' plotXY(y ~ x, data = d) |>
#'   exportPlot("fig1", type = c("png", "tif"))
#' ```
#'
#' @details
#' `exportPlot()` does not receive a finished plot but the plot *call*. The
#' native pipe rewrites `f(x) |> exportPlot()` into `exportPlot(f(x))`, and
#' since R evaluates arguments lazily, `f(x)` has not been run when
#' `exportPlot()` starts. The call is captured with [substitute()] and
#' evaluated once per output file on a freshly opened device, and finally
#' once on the current device. Every file is therefore drawn at its own size
#' and resolution: margins, label widths and font sizes that a plot function
#' computes from the device (e.g. via [strwidth()]) are right for each
#' format. Replaying a recorded plot ([recordPlot()]) would freeze the values
#' computed on the screen device instead.
#'
#' This only works with the native pipe `|>` or with a direct call
#' `exportPlot(plot(...), ...)`, which also accepts a braced block of several
#' drawing calls (see Examples). The magrittr pipe `%>%` hands over a
#' placeholder, not the call.
#'
#' **Repeated evaluation.** Everything in `expr` runs once per output file
#' and once more on the screen if requested (`screen`): assignments,
#' messages, file operations and
#' expensive computations included. Prepare the data beforehand and pass
#' only the drawing calls.
#'
#' **Random numbers.** If a random number generator state exists, it is
#' restored before each evaluation, so every output starts from the same
#' state, and the state after the call is that of a single evaluation. A plot
#' that draws random numbers (jitter, sampling) then comes out the same in
#' every file, as long as it consumes the same random numbers on every
#' device; a plot that branches on device properties may not. In a fresh
#' session in which no random number has been drawn yet there is no state to
#' restore, and the outputs are not synchronised; call [set.seed()] first.
#'
#' **Graphics systems.** Base graphics are drawn by the call itself.
#' `ggplot` and `trellis` objects, which are only drawn when printed, are
#' printed on each device; a grob is drawn on a new page with
#' [grid::grid.draw()]. This applies only to a *visible* result, as at the
#' console: `exportPlot(p, ...)` draws the ggplot `p`, while
#' `exportPlot(print(p), ...)` draws it once through `print()`, which
#' returns it invisibly. An object returned invisibly is never drawn
#' automatically.
#'
#' **Switch.** `create` defaults to the option `pharos.exportPlot`, which
#' is `FALSE` unless set. A script thus decides in one place whether its
#' figures are written, while single calls can still override it.
#'
#' **Devices.** Each file device is closed by its own number after drawing,
#' also if the plot call fails or opens or activates another device. The
#' device that was current before the call is made current again, provided
#' it is still open. If a file device cannot be opened, `exportPlot()`
#' stops before drawing, with the device's own message as the reason; the
#' current device is left untouched, and files of earlier types in `type`
#' remain written.
#'
#' @param expr a call that draws a plot, typically piped in with `|>`, or a
#'   braced block of drawing calls. It is not evaluated before
#'   `exportPlot()` runs, and is evaluated several times (see Details).
#' @param file the path of the output file, without extension; one file per
#'   element of `type` is written, with the extension of that type. A
#'   trailing extension `.png`, `.tif`, `.tiff`, `.pdf` or `.svg` is
#'   removed. Required if `create = TRUE`.
#' @param type one or several of `"png"`, `"tif"`, `"pdf"` and `"svg"`.
#'   Default is `"png"`. TIFF files are LZW-compressed; SVG needs a working
#'   cairo device. `capabilities("cairo")` is not enough to tell: on macOS
#'   it can be `TRUE` while [svg()] cannot open a device (XQuartz missing).
#'   A device that cannot be opened is an error.
#' @param width,height the size of the plot in inches. The default width of
#'   `16/3` inches gives 1600 pixels at 300 dpi; `height` defaults to
#'   `width`.
#' @param res the resolution in dpi for the bitmap formats PNG and TIFF.
#'   Ignored for PDF and SVG.
#' @param create logical; if `TRUE`, the files are written. Defaults to the
#'   option `pharos.exportPlot`, or `FALSE` if the option is not set.
#' @param screen logical; if `TRUE` (default), the plot is also drawn on the
#'   current device when files are written. Without files (`create = FALSE`)
#'   the plot is always drawn on the current device.
#'
#' @return the paths of the written files as a character vector, invisibly;
#'   `character(0)` if `create = FALSE`.
#'
#' @seealso [stamp()] for the corner stamp, which plot functions in pharos
#'   draw by default and which is usually suppressed (`stamp = FALSE`) in
#'   figures for publication.
#'
#' @examples
#' # without the switch, the plot is only drawn
#' plot(1:10) |>
#'   exportPlot(file.path(tempdir(), "demo"))
#'
#' # write a PNG and a PDF, nothing on the screen
#' f <- plot(1:10, main = "Demo") |>
#'   exportPlot(file.path(tempdir(), "demo"), type = c("png", "pdf"),
#'              width = 4, create = TRUE, screen = FALSE)
#' f
#' file.exists(f)
#' unlink(f)
#'
#' # a composed base plot: the model is fitted outside, as expr is
#' # evaluated once per file
#' fit <- lm(dist ~ speed, data = cars)
#' f <- exportPlot({
#'   plot(dist ~ speed, data = cars)
#'   abline(fit)
#'   legend("topleft", legend = "Regression", lty = 1)
#' }, file.path(tempdir(), "figure1"), create = TRUE, screen = FALSE)
#' unlink(f)
#'
#' # switch it on for the whole script
#' opt <- options(pharos.exportPlot = TRUE)
#' f <- plot(1:10) |>
#'   exportPlot(file.path(tempdir(), "demo"), screen = FALSE)
#' unlink(f)
#' options(opt)
#'
#' @family graphics.framework
#' @concept reproducibility
#' @concept graphics-export
#'
#' @importFrom bedrock checkFlag
#' @importFrom grDevices png tiff pdf svg dev.off dev.cur dev.set dev.list
#' @importFrom grid grid.newpage grid.draw
#' @export
exportPlot <- function(expr, file, type = "png",
                       width = 16/3, height = width, res = 300,
                       create = getOption("pharos.exportPlot", FALSE),
                       screen = TRUE) {

  # capture the plot call before anything can force the promise
  e   <- substitute(expr)
  env <- parent.frame()

  # partial matching as match.arg(), but with the argument name in the
  # message (match.arg() with explicit choices reports 'arg')
  types <- c("png", "tif", "pdf", "svg")
  idx <- if (is.character(type) && length(type) > 0L)
    pmatch(type, types, duplicates.ok = TRUE) else NA
  if (anyNA(idx))
    stop("'type' must be one or several of ",
         paste0('"', types, '"', collapse = ", "))
  type <- unique(types[idx])

  checkFlag(create)
  checkFlag(screen)

  .checkPositive(width)
  .checkPositive(height)
  .checkPositive(res)

  if (create) {
    if (missing(file) || !is.character(file) || length(file) != 1L ||
        is.na(file) || !nzchar(file))
      stop("'file' must be a single file path if 'create' is TRUE")
    if ("svg" %in% type && !capabilities("cairo"))
      stop("'type' = \"svg\" needs cairo support, which this R build lacks")
  }

  # the same RNG starting state for every output, and after the call the
  # state of a single evaluation
  hasSeed <- exists(".Random.seed", envir = globalenv(), inherits = FALSE)
  if (hasSeed)
    seed <- get(".Random.seed", envir = globalenv(), inherits = FALSE)

  draw <- function() {
    if (hasSeed)
      assign(".Random.seed", seed, envir = globalenv())
    out <- withVisible(eval(e, env))
    # only a visible result is drawn: print(p) or a grid drawing function
    # has drawn already and returns its object invisibly - drawing it again
    # would add a second page to a PDF.
    # grobs are drawn by grid.draw(), print() on a grob only describes it
    if (out$visible) {
      if (inherits(out$value, "grob")) {
        grid.newpage()
        grid.draw(out$value)
      } else if (inherits(out$value, c("ggplot", "trellis"))) {
        print(out$value)
      }
    }
    invisible(out$value)
  }

  files <- character(0)

  if (create) {

    files <- paste0(sub("\\.(png|tiff?|pdf|svg)$", "", file,
                        ignore.case = TRUE),
                    ".", type)

    prev <- dev.cur()

    for (i in seq_along(type)) {

      # the number of the device actually opened, not dev.cur(): if opening
      # fails, dev.cur() is still the caller's device, which the cleanup
      # below would then close. By number also because expr may open or
      # activate another device
      devExp <- .openExportDevice(type[i], files[i], width, height, res)

      tryCatch(draw(), finally = {
        if (devExp %in% dev.list())
          dev.off(devExp)
        # dev.off() makes the NEXT device current, not the previous one;
        # expr may also have closed the previous one
        if (prev > 1L && prev %in% dev.list())
          dev.set(prev)
      })
    }
  }

  if (!create || screen)
    draw()

  invisible(files)
}



# == internal helper functions =============================================

.openExportDevice <- function(type, file, width, height, res) {
  open <- switch(type,
    png = function() png(file, width = width, height = height,
                         units = "in", res = res),
    tif = function() tiff(file, width = width, height = height,
                          units = "in", res = res, compression = "lzw"),
    pdf = function() pdf(file, width = width, height = height),
    svg = function() svg(file, width = width, height = height)
  )
  .openDevice(open, gettextf("%s device for '%s'", type, file))
}


# Calls a device-opening function and returns the number of the device it
# opened. Some devices fail with a warning only and leave no device behind:
# svg() on macOS reports capabilities("cairo") as TRUE but cannot load the
# cairo module without XQuartz. That is turned into an error here, with the
# device's own warnings as the reason; warnings of a device that did open
# are passed on.
.openDevice <- function(open, label) {
  before <- dev.list()
  msgs   <- character(0)

  withCallingHandlers(open(), warning = function(w) {
    msgs <<- c(msgs, conditionMessage(w))
    invokeRestart("muffleWarning")
  })

  opened <- setdiff(dev.list(), before)

  if (length(opened) != 1L)
    stop(gettextf("could not open a %s%s", label,
                  if (length(msgs)) paste0(": ", paste(msgs, collapse = "; "))
                  else ""),
         domain = NA, call. = FALSE)

  for (m in msgs)
    warning(m, call. = FALSE)

  opened
}


.checkPositive <- function(x, name = deparse(substitute(x))) {
  if (!is.numeric(x) || length(x) != 1L || !is.finite(x) || x <= 0)
    stop(gettextf("'%s' must be a single finite positive number", name),
         domain = NA)
  invisible(x)
}
