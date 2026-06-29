
#' Confidence Interval Objects
#'
#' Converts common confidence interval representations into a standardized
#' \code{"ci"} object.
#'
#' A \code{ci} object is a data frame containing at least the columns
#' \code{est}, \code{lci}, and \code{uci}. Additional columns are interpreted
#' as grouping variables.
#'
#' The primary purpose of \code{as.CI()} is to remove ambiguity between
#' ordinary matrices and confidence interval data. For example, a
#' 3-column matrix may either represent three groups or the columns
#' \code{est}, \code{lci}, and \code{uci}. Wrapping the object in
#' \code{as.CI()} explicitly declares that the structure should be treated
#' as confidence interval data.
#'
#' @param x Object to convert.
#' @param ... Further arguments passed to methods.
#'
#' @name as.CI
#' @details
#' Supported inputs include:
#'
#' \itemize{
#'   \item Numeric matrices with three columns representing
#'         \code{est}, \code{lci}, and \code{uci}.
#'
#'   \item Data frames containing columns for estimate, lower confidence
#'         limit, and upper confidence limit.
#'
#'   \item Named lists where each element contains
#'         \code{c(est, lci, uci)}.
#'
#'   \item Results from \code{tapply()} where the applied function returns
#'         \code{c(est, lci, uci)}. Grouping dimensions are automatically
#'         converted to grouping variables.
#' }
#'
#' The returned object inherits from class \code{"ci"}.
#'
#' @return
#' A data frame of class \code{"ci"} with columns:
#'
#' \describe{
#'   \item{est}{Point estimate}
#'   \item{lci}{Lower confidence limit}
#'   \item{uci}{Upper confidence limit}
#' }
#'
#' Additional columns represent grouping variables.
#'
#' @examples
#'
#' # ----------------------------------------------------------
#' # matrix
#' # ----------------------------------------------------------
#'
#' x <- matrix(
#'   c(
#'     10, 20, 30,
#'      8, 18, 28,
#'     12, 22, 32
#'   ),
#'   ncol = 3
#' )
#'
#' as.CI(x)
#'
#' # ----------------------------------------------------------
#' # data frame
#' # ----------------------------------------------------------
#'
#' d <- data.frame(
#'   est = c(10, 20),
#'   lci = c(8, 18),
#'   uci = c(12, 22),
#'   sex = c("F", "M")
#' )
#'
#' as.CI(d)
#'
#' # ----------------------------------------------------------
#' # tapply result
#' # ----------------------------------------------------------
#'
#' \dontrun{
#' xci <- with(
#'   Pizza,
#'   tapply(
#'     temperature,
#'     driver,
#'     lumen::meanCI,
#'     na.rm = TRUE
#'   )
#' )
#'
#' plotDot(as.CI(xci))
#' }
#'
#' @seealso
#' \code{\link{plotDot}},
#' \code{\link{is.CI}}
#'
#' @family confidence-intervals
#' @concept confidence-intervals
#'

# ============================================================
# CI objects
# ============================================================

#' @family ci.objects  
#' @concept confidence-interval
#'
#'
#' @export
as.CI <- function(x, ...) {
  
  # ----------------------------------------------------------
  # tapply(..., meanCI) result
  # ----------------------------------------------------------
  
  if (is.list(x) &&
      !is.data.frame(x) &&
      !is.null(dim(x)))
    return(.as.CI.tapply(x))
  
  UseMethod("as.CI")
}


# ============================================================
# tapply helper
# ============================================================
.as.CI.tapply <- function(x) {
  
  dm <- dim(x)
  dn <- dimnames(x)
  
  vals <- do.call(
    rbind,
    unclass(x)
  )
  
  out <- as.data.frame(vals)
  
  names(out) <- c("est", "lci", "uci")
  
  # ---- grouping variables ----------------------------------
  
  if (length(dm) >= 1) {
    
    out$group1 <- rep(
      dn[[1]],
      times = prod(dm[-1])
    )
  }
  
  if (length(dm) >= 2) {
    
    out$group2 <- rep(
      dn[[2]],
      each = dm[1]
    )
  }
  
  if (length(dm) >= 3) {
    
    out$group3 <- rep(
      dn[[3]],
      each = prod(dm[1:2])
    )
  }
  
  class(out) <- c("CI", class(out))
  
  out
}


# ============================================================
# matrix
# ============================================================
#' @export

as.CI.matrix <- function(x, ...) {
  
  if (!is.numeric(x))
    stop(
      "CI matrix must be numeric."
    )
  
  if (ncol(x) != 3)
    stop(
      "CI matrix must have exactly 3 columns ",
      "(est, lci, uci)."
    )
  
  out <- as.data.frame(x)
  
  names(out) <- c("est", "lci", "uci")
  
  if (!is.null(rownames(x)))
    rownames(out) <- rownames(x)
  
  class(out) <- c("CI", class(out))
  
  out
}


# ============================================================
# data.frame
# ============================================================
#' @export

as.CI.data.frame <- function(
    x,
    estimate = "est",
    lower = "lci",
    upper = "uci",
    ...
) {
  
  est <- x[[estimate]]
  lci <- x[[lower]]
  uci <- x[[upper]]
  
  keep <- setdiff(
    names(x),
    c(estimate, lower, upper)
  )
  
  out <- data.frame(
    est = est,
    lci = lci,
    uci = uci,
    x[keep],
    check.names = FALSE
  )
  
  rownames(out) <- rownames(x)
  
  class(out) <- c("CI", class(out))
  
  out
}


# ============================================================
# list
# ============================================================
#' @export

as.CI.list <- function(x, ...) {
  
  if (!all(vapply(x, length, integer(1)) == 3))
    stop(
      "List elements must contain ",
      "(est, lci, uci)."
    )
  
  out <- as.data.frame(
    do.call(rbind, x)
  )
  
  names(out) <- c("est", "lci", "uci")
  
  if (!is.null(names(x)))
    rownames(out) <- names(x)
  
  class(out) <- c("CI", class(out))
  
  out
}


# ============================================================
# already ci
# ============================================================
#' @export

as.CI.CI <- function(x, ...) {
  x
}


# ============================================================
# default
# ============================================================
#' @export

as.CI.default <- function(x, ...) {
  
  stop(
    "Don't know how to convert object of class ",
    sQuote(class(x)[1]),
    " to a CI object."
  )
}


# ============================================================
# helper
# ============================================================

#' @rdname as.CI
#' @export
is.CI <- function(x) {
  inherits(x, "CI")
}

