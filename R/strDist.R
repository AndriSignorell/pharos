
#' Compute Distances Between Strings
#' 
#' \code{strDist} computes distances between strings following to Levenshtein
#' or Hamming method.
#' 
#' The function computes the Hamming and the Levenshtein (edit) distance of two
#' given strings (sequences). The Hamming distance between two vectors is the
#' number of mismatches between corresponding entries.
#' 
#' In case of the Hamming distance the two strings must have the same length.
#' 
#' In case of the Levenshtein (edit) distance a scoring and a trace-back matrix
#' are computed and are saved as attributes \code{"ScoringMatrix"} and
#' \code{"TraceBackMatrix"}.  The numbers in the trace-back matrix reflect
#' insertion of a gap in string \code{y} (1), match/mismatch (2), and
#' insertion of a gap in string \code{x} (3).
#' 
#' The edit distance is useful, but normalizing the distance to fall within the
#' interval \verb{[0,1]} is preferred because it is somewhat difficult to judge whether
#' an LD of for example 4 suggests a high or low degree of similarity.  The
#' method \code{"normlevenshtein"} for normalizing the LD is sensitive to this
#' scenario. In this implementation, the Levenshtein distance is transformed to
#' fall in this interval as follows: \deqn{lnd = 1 - \frac{ld}{max(length(x),
#' length(y))}}{lnd = 1 - ld / max(length(x), length(y))}
#' 
#' where \code{ld} is the edit distance and \code{max(length(x), length(y))}
#' denotes that we divide by the length of the larger of the two character
#' strings. This normalization, referred to as the Levenshtein normalized
#' distance (lnd), yields a statistic where 1 indicates perfect agreement
#' between the two strings, and a 0 denotes imperfect agreement. The closer a
#' value is to 1, the more certain we can be that the character strings are the
#' same; the closer to 0, the less certain.
#' 
#' @param x character vector, first string
#' @param y character vector, second string
#' @param method character, name of the distance method. This must be
#' \code{"levenshtein"}, \code{"normlevenshtein"} or \code{"hamming"}. Default
#' is \code{"levenshtein"}, the classical Levenshtein distance.
#' @param mismatch numeric, distance value for a mismatch between symbols
#' @param gap numeric, distance value for inserting a gap
#' @param ignoreCase if \code{FALSE} (default), the distance measure will be
#' case sensitive and if \code{TRUE}, case is ignored
#' 
#' @return \code{strDist} returns an object of class \code{"dist"}; cf.
#' \code{\link[stats]{dist}}.
#' 
#' @note For distances between strings and for string alignments see also
#' Bioconductor package \pkg{Biostrings}
#' 
#' @note Based on code by Matthias Kohl, adapted to conform to package standards. 
#' 
#' @seealso \code{\link[utils]{adist}}, \code{\link[stats]{dist}}
#' @references R. Merkl and S. Waack (2009) \emph{Bioinformatik Interaktiv}.
#' Wiley.
#' 
#' Harold C. Doran (2010) \emph{MiscPsycho. An R Package for Miscellaneous
#' Psychometric Analyses}



#' @examples
#' 
#' x <- "GACGGATTATG"
#' y <- "GATCGGAATAG"
#' ## Levenshtein distance
#' d <- strDist(x, y)
#' d
#' attr(d, "ScoringMatrix")
#' attr(d, "TraceBackMatrix")
#' 
#' ## Hamming distance
#' strDist(x, y, method="hamming")
#' 




#' @seealso
#' [string-overview] for an overview of all string utilities in pharos.
#'
#' @concept string-inspection
#' @concept numerical-methods
#'
#'
#' @export
strDist <- function(x, y,
                    method = "levenshtein",
                    mismatch = 1,
                    gap = 1,
                    ignoreCase = FALSE) {
  
  # source MKmisc, Author: Matthias Kohl
  
  method <- match.arg(method,
                      c("levenshtein", "normlevenshtein", "hamming"))
  
  if (!is.character(x))
    stop("Argument 'x' must be character.")
  
  if (!is.character(y))
    stop("Argument 'y' must be character.")
  
  if (length(x) == 0L)
    stop("Argument 'x' must not be empty.")
  
  if (length(y) == 0L)
    stop("Argument 'y' must not be empty.")
  
  if (ignoreCase) {
    x <- tolower(x)
    y <- tolower(y)
  }
  
  if (length(x) == 1L && nchar(x) > 1L)
    x1 <- strsplit(x, split = "", fixed = TRUE)[[1]]
  else
    x1 <- x
  
  if (length(y) == 1L && nchar(y) > 1L)
    y1 <- strsplit(y, split = "", fixed = TRUE)[[1]]
  else
    y1 <- y
  
  if (method %in% c("levenshtein", "normlevenshtein")) {
    
    m <- length(x1)
    n <- length(y1)
    
    D <- matrix(NA_real_, nrow = m + 1L, ncol = n + 1L)
    M <- matrix("",        nrow = m + 1L, ncol = n + 1L)
    
    D[, 1]  <- seq_len(m + 1L) * gap - 1L
    D[1, ]  <- seq_len(n + 1L) * gap - 1L
    D[1, 1] <- 0
    
    M[, 1]  <- "d"
    M[1, ]  <- "i"
    M[1, 1] <- "start"
    
    ops <- c("d", "m", "i")
    
    if (m > 0L && n > 0L) {
      
      for (i in seq.int(2L, m + 1L)) {
        
        for (j in seq.int(2L, n + 1L)) {
          
          dDel <- D[i - 1L, j] +
            gap
          
          dSub <- D[i - 1L, j - 1L] +
            (x1[i - 1L] != y1[j - 1L]) * mismatch
          
          dIns <- D[i, j - 1L] +
            gap
          
          D[i, j] <- min(dDel, dSub, dIns)
          
          wmin <- ops[which(c(dDel, dSub, dIns) == D[i, j])]
          
          if ("m" %in% wmin &&
              x1[i - 1L] != y1[j - 1L])
            wmin[wmin == "m"] <- "mm"
          
          M[i, j] <- paste(wmin, collapse = "/")
        }
      }
    }
    
    rownames(D) <- rownames(M) <- c("gap", x1)
    colnames(D) <- colnames(M) <- c("gap", y1)
    
    d <- D[m + 1L, n + 1L]
    
    if (method == "normlevenshtein")
      d <- 1 - d / max(m, n)
  }
  
  if (method == "hamming") {
    
    if (length(x1) != length(y1))
      stop(
        "Hamming distance is only defined for equal-length strings."
      )
    
    d <- sum(x1 != y1)
    
    D <- NULL
    M <- NULL
  }
  
  if (length(x) > 1L)
    x <- paste0(x, collapse = "")
  
  if (length(y) > 1L)
    y <- paste0(y, collapse = "")
  
  attr(d, "Size")            <- 2L
  attr(d, "Diag")            <- FALSE
  attr(d, "Labels")          <- c(x, y)
  attr(d, "Upper")           <- FALSE
  attr(d, "method")          <- method
  attr(d, "call")            <- match.call()
  attr(d, "ScoringMatrix")   <- D
  attr(d, "TraceBackMatrix") <- M
  
  class(d) <- c("stringDist", "dist")
  
  d
}
