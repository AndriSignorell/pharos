#' Animate a Plot
#'
#' Evaluates a plot call repeatedly while one or more running parameters
#' step through their values.
#'
#' The plot call is captured unevaluated, so it can be handed over directly
#' or by means of the native pipe (`plot(...) |> animate(i = 1:10)`).
#' Each frame is drawn within [grDevices::dev.hold()] /
#' [grDevices::dev.flush()] to avoid flickering. The time needed for
#' drawing is deducted from `delay`, such that the frame rate stays
#' constant as long as drawing is faster than `delay`.
#'
#' @param expr the plot call (or a `{}` block of several calls) containing
#'   the running parameter(s).
#' @param ... the running parameters as named vectors or lists, e.g.
#'   `i = 1:20`. Several parameters are stepped through in parallel and
#'   recycled to the longest one. Names must be unique, empty parameters
#'   are not allowed.
#' @param delay time per frame in seconds, a single finite, non-negative
#'   number.
#' @param loops number of runs, a non-negative whole number. `Inf` repeats
#'   until interrupted.
#'
#' @return The number of frames per run, invisibly.
#'
#' @examples
#' \donttest{
#' x <- cumsum(rnorm(100))
#' animate(plot(x[1:i], type = "l", xlim = c(1, 100), ylim = range(x)),
#'         i = 2:100, delay = 0.05)
#'
#' # two parameters running in parallel, using the pipe
#' curve(dnorm(x, mean = m), -6, 6, col = col, lwd = 2, ylim = c(0, 0.4)) |>
#'   animate(m = seq(-3, 3, 0.25), col = hcl.colors(25), delay = 0.1)
#' }
#'
#' @export
animate <- function(expr, ..., delay = 0.2, loops = 1) {

  expr <- substitute(expr)
  env <- parent.frame()
  pars <- list(...)

  if (!length(pars) || is.null(names(pars)) || !all(nzchar(names(pars))) ||
      anyDuplicated(names(pars)))
    stop("running parameters must be uniquely named, ",
         "e.g. animate(plot(1:i), i = 2:10)")
  if (any(lengths(pars) == 0L))
    stop("running parameters must not be empty")
  if (!is.numeric(delay) || length(delay) != 1L || !is.finite(delay) ||
      delay < 0)
    stop("'delay' must be a single finite, non-negative number")
  if (!is.numeric(loops) || length(loops) != 1L || is.na(loops) ||
      loops < 0 || loops != trunc(loops))
    stop("'loops' must be a single non-negative whole number or Inf")

  n <- max(lengths(pars))
  # recycle by index, as rep_len() would drop classes (e.g. Date)
  pars <- lapply(pars, function(x) x[rep_len(seq_along(x), n)])

  drawFrame <- function(k) {
    res <- withVisible(eval(expr, lapply(pars, `[[`, k), env))
    # grid based plots (ggplot2, lattice) are only drawn when printed
    if (res$visible && inherits(res$value, c("ggplot", "trellis")))
      print(res$value)
  }

  run <- 0
  while (run < loops) {
    for (k in seq_len(n)) {
      start <- proc.time()[["elapsed"]]
      grDevices::dev.hold()
      tryCatch(drawFrame(k), finally = grDevices::dev.flush())
      Sys.sleep(max(0, delay - (proc.time()[["elapsed"]] - start)))
    }
    run <- run + 1
  }

  invisible(n)
}
