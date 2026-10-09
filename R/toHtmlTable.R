
#' Render a matrix as an HTML table
#'
#' Converts a matrix (or vector) to a \verb{<table>} HTML fragment, with
#' optional row/column headers, caption, per-column alignment and widths.
#' The result has class `c("html", "character")` (see
#' [asHtml()]) and prints as a formatted text table via
#' [preview.html()].
#'
#' @param m a matrix or vector
#' @param sepCol logical; if `TRUE`, insert a narrow empty separator
#'   column between each pair of columns
#' @param caption table caption text
#' @param bodyAlign horizontal alignment of body cells
#'   (`"left"`, `"center"`, `"right"`), recycled to the
#'   number of columns
#' @param vAlign vertical alignment of body cells (HTML `valign`
#'   attribute: `"top"`, `"middle"`, `"bottom"`), recycled
#'   to the number of columns
#' @param width column width(s) (HTML `width` attribute), recycled
#'   to the number of columns including an optional rowname column; use
#'   `NA` for columns without an explicit width
#' @param cellPadding HTML `cellpadding` attribute
#' @param border HTML `border` attribute
#' @param tableWidth overall table width (HTML `width` attribute on
#'   \verb{<table>}), or `NA` for none
#' @param captionAlign horizontal alignment of the header row cells
#' @param frame logical; if `TRUE`, draw outer frame and group rules
#'   (`frame="hsides" rules="groups"`)
#' @param rowNames logical; render the row names as a leading header
#'   column. Ignored when `m` has none
#' @param colNames logical; render the column names as a header row.
#'   Ignored when `m` has none
#'
#' @return an object of class `c("html", "character")`
#'
#' @examples
#' m <- matrix(c(12.3, 4.56, 7.8, 91.2), nrow = 2,
#'             dimnames = list(c("a", "b"), c("mean", "sd")))
#'
#' # the HTML fragment ...
#' (h <- toHtmlTable(m, caption = "Summary"))
#'
#' # ... and its rendering as text
#' preview(h)
#'
#' # formatted cells, right aligned, without the row names
#' preview(toHtmlTable(fm(m, digits = 1), rowNames = FALSE, bodyAlign = "right"))
#'
#' @seealso [bedrock::appendEnum]
#'
#'
#' @family html  
#'
#' @export
toHtmlTable <- function(m, sepCol = FALSE, caption = "", bodyAlign = "center",
                        vAlign = "top", width = NULL, cellPadding = 3,
                        border = 0, tableWidth = NA,
                        captionAlign = "center", frame = TRUE,
                        rowNames = TRUE, colNames = TRUE) {
  
  # a vector is a one-column table; without this, .Dim below is NULL and
  # the row assembly fails
  if (!is.matrix(m))
    m <- as.matrix(m)
  
  # cbind() readily invents dimnames from the names of its arguments, so
  # callers assembling a table programmatically must be able to say no
  if (!rowNames && !is.null(dimnames(m)))
    rownames(m) <- NULL
  if (!colNames && !is.null(dimnames(m)))
    colnames(m) <- NULL
  
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
  
  vAlign <- rep(vAlign, length.out = ncol(m))
  vAlign <- t(replicate(n = nrow(m), vAlign))
  
  trow <- function(z) gettextf("<tr>%s</tr>", paste(z, collapse = ""))
  
  tt <- structure(gettextf('<td %s style="text-align: %s;" valign="%s" >%s</td>',
                           if (has_rownames)
                             t(replicate(expr = (width), n = nrow(m)))[, -1]
                           else
                             t(replicate(expr = (width), n = nrow(m))),
                           bodyAlign, vAlign, unname(m)), .Dim = dim(m))
  
  col_x <- NA_character_
  
  if (!is.null(dimnames(m))) {
    
    if (!is.null(dimnames(m)[[1]])) {
      tt <- cbind(rownames(m), tt)
      tt[, 1] <- gettextf('<b>%s</b>', tt[, 1])
      tt[, 1] <- gettextf('<td style="text-align: left;">%s</td>', tt[, 1])
    }
    
    if (!is.null(dimnames(m)[[2]])) {
      
      col_x <- colnames(m)
      
      # the corner cell carries the name of the row dimension, if it has
      # one; note the single bracket -- names(dimnames(m)) is NULL for the
      # ordinary case of a matrix whose dimensions are unnamed, and [[1]]
      # on NULL is an error, not an empty result
      if (!is.null(dimnames(m)[[1]])) {
        corner <- names(dimnames(m))[1]
        col_x <- c(if (is.null(corner) || is.na(corner)) "" else corner, col_x)
      }
      
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
                  dQuote(cellPadding, q = FALSE),
                  ifelse(identical(tableWidth, NA), "", tableWidth),
                  ifelse(frame, 'frame="hsides" rules="groups"', ""),
                  ifelse(caption == "", "", gettextf('<caption>%s</caption>', caption)),
                  ifelse(identical(col_x, NA_character_), "",
                         gettextf("<thead> <tr> %s </tr> </thead>", paste(col_x, collapse = "\n"))),
                  paste(apply(tt, 1, trow), collapse = "\n"))
  
  asHtml(res)
  
}

