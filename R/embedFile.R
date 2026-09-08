
#' Base64-encode a file
#'
#' The building block behind [as.img()] and
#' [as.fileLink()]: reads a file and returns its contents
#' base64-encoded, ready to be placed in a data URI or in any container
#' format that carries binary payloads as text.
#'
#' @param path path to an existing file
#'
#' @return a single character string
#'
#' @examples
#' fn <- tempfile(fileext = ".txt")
#' writeLines("hello", fn)
#' substr(embedFile(fn), 1, 8)
#' unlink(fn)
#'
#' @family html
#' @concept html
#'
#' @export
embedFile <- function(path) {

  if (length(path) != 1L || !is.character(path))
    stop("'path' must be a single file name")
  if (!file.exists(path))
    stop(gettextf("file not found: %s", path))

  base64enc::base64encode(path)
}


#' Link to a self-contained embedded file
#'
#' Turns a file into a download link that carries the file with it: the
#' contents travel base64-encoded inside the `href`, so the resulting
#' HTML needs no server and no accompanying assets. The counterpart of
#' [as.img()] for non-image files -- a data set next to a table,
#' a script next to its output.
#'
#' Browsers limit the size of a data URI, so this suits spreadsheets and
#' text files rather than large binaries.
#'
#' @param path path to an existing file
#' @param label link text; defaults to the file name
#' @param type MIME type; guessed from the extension when `NULL`
#'
#' @return an object of class `c("html", "character")`
#'
#' @examples
#' fn <- tempfile(fileext = ".csv")
#' write.csv(head(iris), fn, row.names = FALSE)
#' as.fileLink(fn, label = "iris")
#' unlink(fn)
#'
#' @family html
#' @concept html
#'
#' @export
as.fileLink <- function(path, label = NULL, type = NULL) {

  name <- basename(path)

  if (is.null(type))
    type <- switch(tolower(tools::file_ext(path)),
                   "xlsx" = paste0("application/vnd.openxmlformats-",
                                   "officedocument.spreadsheetml.sheet"),
                   "xls"  = "application/vnd.ms-excel",
                   "csv"  = "text/csv",
                   "txt"  = "text/plain",
                   "pdf"  = "application/pdf",
                   "application/octet-stream")

  as.html(gettextf('<a href="data:%s;base64,%s" download="%s">%s</a>',
                   type, embedFile(path), name,
                   if (is.null(label)) name else label))
}


#' Escape HTML special characters
#'
#' Replaces the three characters that would otherwise be read as markup.
#' Use it on any text of unknown origin -- a variable label, a file name,
#' a user-supplied caption -- before pasting it into HTML or XML.
#'
#' Quotes are escaped as well when `attribute = TRUE`, which is
#' required for text placed inside an attribute value rather than between
#' tags.
#'
#' @param x a character vector
#' @param attribute logical; also escape single and double quotes
#'
#' @return a character vector of the same length
#'
#' @examples
#' escapeHtml("Anteil < 5% & steigend")
#' escapeHtml('say "hi"', attribute = TRUE)
#'
#' @family html
#' @concept html
#'
#' @export
escapeHtml <- function(x, attribute = FALSE) {

  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)

  if (attribute) {
    x <- gsub('"', "&quot;", x, fixed = TRUE)
    x <- gsub("'", "&#39;", x, fixed = TRUE)
  }

  x
}
