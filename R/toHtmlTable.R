
#' Render a matrix as an HTML table
#'
#' Converts a matrix (or vector) to a \verb{<table>} HTML fragment, with
#' optional row/column headers, caption, per-column alignment and widths.
#' The result has class \code{c("html", "character")} (see
#' \code{\link{as.html}}) and prints as a formatted text table via
#' \code{\link{preview.html}}.
#'
#' @param m a matrix or vector
#' @param sepCol logical; if \code{TRUE}, insert a narrow empty separator
#'   column between each pair of columns
#' @param caption table caption text
#' @param bodyAlign horizontal alignment of body cells
#'   (\code{"left"}, \code{"center"}, \code{"right"}), recycled to the
#'   number of columns
#' @param valign vertical alignment of body cells (HTML \code{valign}
#'   attribute: \code{"top"}, \code{"middle"}, \code{"bottom"}), recycled
#'   to the number of columns
#' @param width column width(s) (HTML \code{width} attribute), recycled
#'   to the number of columns including an optional rowname column; use
#'   \code{NA} for columns without an explicit width
#' @param cellpadding HTML \code{cellpadding} attribute
#' @param border HTML \code{border} attribute
#' @param tableWidth overall table width (HTML \code{width} attribute on
#'   \verb{<table>}), or \code{NA} for none
#' @param captionAlign horizontal alignment of the header row cells
#' @param frame logical; if \code{TRUE}, draw outer frame and group rules
#'   (\code{frame="hsides" rules="groups"})
#'
#' @return an object of class \code{c("html", "character")}
#'
#' @seealso [bedrock::appendEnum]
#'
#'
#' @family html  
#'
#' @export
toHtmlTable <- function(m, sepCol = FALSE, caption = "", bodyAlign = "center",
                        valign = "top", width = NULL, cellpadding = 3,
                        border = 0, tableWidth = NA,
                        captionAlign = "center", frame = TRUE) {
  
  has_rownames <- (!is.null(dimnames(m)) && !is.null(dimnames(m)[[1]])) * 1
  
  if (!is.null(width)) {
    # width is recycled for all columns, potentially adding a rownames column first
    width <- rep(width, length.out = (ncol(m) + has_rownames))
    nowidth <- is.na(width)
    
    width <- gettextf('width=%s', dQuote(width, q = FALSE))
    width[nowidth] <- ""
  } else {
    width <- rep("", length.out = (ncol(m) + has_rownames))
  }
  
  bodyAlign <- rep(bodyAlign, length.out = ncol(m))
  bodyAlign <- t(replicate(n = nrow(m), bodyAlign))
  
  valign <- rep(valign, length.out = ncol(m))
  valign <- t(replicate(n = nrow(m), valign))
  
  trow <- function(z) gettextf("<tr>%s</tr>", paste(z, collapse = ""))
  
  tt <- structure(gettextf('<td %s style="text-align: %s;" valign="%s" >%s</td>',
                           if (has_rownames)
                             t(replicate(expr = (width), n = nrow(m)))[, -1]
                           else
                             t(replicate(expr = (width), n = nrow(m))),
                           bodyAlign, valign, unname(m)), .Dim = dim(m))
  
  col_x <- NA_character_
  
  if (!is.null(dimnames(m))) {
    
    if (!is.null(dimnames(m)[[1]])) {
      tt <- cbind(rownames(m), tt)
      tt[, 1] <- gettextf('<b>%s</b>', tt[, 1])
      tt[, 1] <- gettextf('<td style="text-align: left;">%s</td>', tt[, 1])
    }
    
    if (!is.null(dimnames(m)[[2]])) {
      
      col_x <- colnames(m)
      
      if (!is.null(dimnames(m)[[1]]))
        col_x <- c(if (is.null(names(dimnames(m))[[1]])) "" else names(dimnames(m))[1], col_x)
      
      col_x <- gettextf('<b>%s</b>', col_x)
      col_x <- gettextf('<td %s style="text-align: %s;">%s</td>', width, captionAlign, col_x)
    }
  }
  
  if (sepCol) {
    j <- 0
    for (i in head(seq_len(ncol(tt)), -1)) {
      tt <- appendX(tt, values = '<td>&nbsp;</td>', after = i + j)
      j <- j + 1
    }
  }
  
  res <- gettextf('<table border=%s cellpadding=%s data-mce-style="background-color: #e1e7e9;"%s %s>%s
                 <tbody>%s %s</tbody></table>',
                  dQuote(border, q = FALSE),
                  dQuote(cellpadding, q = FALSE),
                  ifelse(identical(tableWidth, NA), "", tableWidth),
                  ifelse(frame, 'frame="hsides" rules="groups"', ""),
                  ifelse(caption == "", "", gettextf('<caption>%s</caption>', caption)),
                  ifelse(identical(col_x, NA_character_), "",
                         gettextf("<thead> <tr> %s </tr> </thead>", paste(col_x, collapse = "\n"))),
                  paste(apply(tt, 1, trow), collapse = "\n"))
  
  as.html(res)
  
}

