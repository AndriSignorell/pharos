
#' Confidence Interval Objects
#'
#' Converts common confidence interval representations into a standardized
#' object of class `"CI"`. The standardized representation removes the
#' ambiguity between ordinary numeric data and confidence interval data.
#'
#' @param x object to convert or, for `isCI()`, object to test
#' @param estimate name of the data-frame column containing the point estimates
#' @param lower name of the data-frame column containing the lower confidence
#'   limits
#' @param upper name of the data-frame column containing the upper confidence
#'   limits
#' @param ... further arguments passed to methods
#'
#' @details
#' A `"CI"` object is a data frame containing the columns `est`,
#' `lci`, and `uci`. Additional columns are retained and can be used
#' as grouping variables by functions such as [plotDot()].
#'
#' The primary purpose of `as.CI()` is to declare explicitly that an
#' object contains estimates and confidence limits. For example, a numeric
#' matrix with three columns is normally ambiguous: its columns may represent
#' three groups or the estimate, lower limit, and upper limit. Passing the
#' matrix to `as.CI()` declares that its columns have the latter meaning.
#'
#' Supported inputs are:
#' \itemize{
#'   \item a numeric matrix with exactly three columns, interpreted in the
#'     order `est`, `lci`, and `uci`
#'   \item a data frame containing columns for the estimates and confidence
#'     limits; their names can be specified with `estimate`,
#'     `lower`, and `upper`
#'   \item a list in which every element contains three values representing
#'     `c(est, lci, uci)`
#'   \item an array-like result from [tapply()] in which every cell
#'     contains `c(est, lci, uci)`; its dimensions are converted to
#'     grouping variables
#'   \item an existing `"CI"` object, which is returned unchanged
#' }
#'
#' The standardized object can be passed directly to [plotDot()] to
#' display the estimates and their confidence intervals. This is particularly
#' useful for matrices, because a bare matrix supplied to `plotDot()` is
#' interpreted as grouped estimates rather than as confidence interval data.
#'
#' @return `as.CI()` returns a data frame of class `"CI"` containing
#'   the columns `est`, `lci`, and `uci`, followed by any
#'   grouping columns; `isCI()` returns a single logical value
#'
#' @examples
#' # matrix containing estimate, lower limit, and upper limit
#' x <- matrix(
#'   c(
#'     10, 20, 30,
#'      8, 18, 28,
#'     12, 22, 32
#'   ),
#'   ncol = 3,
#'   dimnames = list(
#'     c("A", "B", "C"),
#'     c("est", "lci", "uci")
#'   )
#' )
#'
#' ci <- as.CI(x)
#' ci
#' isCI(ci)
#'
#' # display the estimates and confidence intervals
#' plotDot(ci)
#'
#' # data frame using the standard column names
#' d <- data.frame(
#'   est = c(10, 20),
#'   lci = c(8, 18),
#'   uci = c(12, 22),
#'   sex = c("F", "M")
#' )
#'
#' as.CI(d)
#'
#' # data frame using different column names
#' d <- data.frame(
#'   item = c("A", "B"),
#'   estimate = c(10, 20),
#'   lower = c(8, 18),
#'   upper = c(12, 22)
#' )
#'
#' as.CI(
#'   d,
#'   estimate = "estimate",
#'   lower = "lower",
#'   upper = "upper"
#' )
#'
#' # confidence intervals returned by tapply()
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
#' @seealso [plotDot()], [fmCI()]
#' @concept confidence-interval
#' @export
#'

# ============================================================
# CI objects
# ============================================================

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
#' @rdname as.CI
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
#' @rdname as.CI
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
#' @rdname as.CI
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
#' @rdname as.CI
#' @export
as.CI.CI <- function(x, ...) {
  x
}


# ============================================================
# default
# ============================================================
#' @rdname as.CI
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
isCI <- function(x) {
  inherits(x, "CI")
}

