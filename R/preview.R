
#' Preview an Object
#'
#' Generic function for an explicit, on-demand preview of an object, as
#' distinct from \code{print()}. \code{preview()} exists for object types
#' where \code{print()} is shared with another package's S3 generic
#' dispatch (e.g. class \code{"html"}, used both by \pkg{pharos} and
#' \pkg{htmltools} for genuinely different purposes), so that registering
#' an own \code{print.*} method would silently overwrite - or be
#' overwritten by - the other package's behaviour.
#'
#' @param x object to preview.
#' @param ... further arguments passed to methods.
#'
#' @details
#' The default method simply calls \code{print()}, so \code{preview()} is
#' always safe to call even for types with no dedicated method.
#'
#' @seealso \code{\link{as.html}}
#'

#' @family graphics.utils  
#' @concept annotation
#'
#'
#' @export
preview <- function(x, ...) {
  UseMethod("preview")
}

#' @rdname preview
#' @export
preview.default <- function(x, ...) {
  print(x, ...)
}


#' Print HTML markup as readable text
#'
#' Renders an \code{"html"} object as text in the console: tags are
#' stripped or translated (\verb{<sub>}/\verb{<sup>} become
#' \verb{_}/\verb{^}, \verb{<b>}/\verb{<strong>}/\verb{<i>}/\verb{<em>}
#' become bold/italic via ANSI codes), common HTML entities
#' (\verb{&nbsp;}, \verb{&beta;}, ...) are decoded, and \verb{<table>}
#' blocks are rendered as aligned text tables.
#'
#' If output does not support ANSI styling, bold/italic markup is
#' rendered as plain text (handled automatically by \pkg{cli}).
#'
#' @param x an object of class \code{"html"}
#' @param ... further arguments, currently unused (kept for
#'   consistency with \code{\link{print}})
#'
#' @return \code{x}, invisibly
#'
#' @export
preview.html <- function(x, ...) {
  
  bold   <- cli::style_bold
  italic <- cli::style_italic
  strip_ansi <- cli::ansi_strip
  
  # --- Hilfsfunktion: HTML zu ANSI-Text (für Fliesstext) ---
  html_format <- function(z) {
    z <- gsub("&nbsp;", " ", z, fixed = TRUE)
    z <- gsub("&beta;", "\u03b2", z)
    z <- gsub("&varepsilon;", "\u03b5", z)
    z <- gsub("&sigma;", "\u03c3", z)
    z <- gsub("<sub>(.*?)</sub>", "_\\1", z)
    z <- gsub("<sup>(.*?)</sup>", "^\\1", z)
    z <- gsub("(?i)<(b|strong)>(.*?)</\\1>", bold("\\2"), z, perl = TRUE)
    z <- gsub("(?i)<(i|em)>(.*?)</\\1>", italic("\\2"), z, perl = TRUE)
    z <- gsub("<br\\s*/?>", "\n", z)
    z <- gsub("<[^>]+>", "", z)
    z <- gsub("\\s+", " ", z)
    trimws(z)
  }
  
  # --- Tabellen extrahieren ---
  tables <- regmatches(x, gregexpr("(?is)<table.*?</table>", x, perl = TRUE))[[1]]
  split_parts <- unlist(strsplit(x, "(?is)<table.*?</table>", perl = TRUE))
  
  render_table <- function(tbl_html) {
    thead <- regmatches(tbl_html, gregexpr("(?is)<thead>.*?</thead>", tbl_html,
                                           perl = TRUE, ignore.case = TRUE))[[1]]
    header_data <- NULL
    if (length(thead) > 0) {
      header_cells <- unlist(regmatches(thead, gregexpr("<t[dh][^>]*>.*?</t[dh]>", thead,
                                                        perl = TRUE, ignore.case = TRUE)))
      header_cells <- gsub("<t[dh][^>]*>(.*?)</t[dh]>", "\\1", header_cells, ignore.case = TRUE)
      header_data <- html_format(header_cells)
    }
    
    rows <- unlist(regmatches(tbl_html, gregexpr("<tr>.*?</tr>", tbl_html,
                                                 perl = TRUE, ignore.case = TRUE)))
    table_data <- lapply(rows, function(r) {
      cells <- unlist(regmatches(r, gregexpr("<t[dh][^>]*>.*?</t[dh]>", r,
                                             perl = TRUE, ignore.case = TRUE)))
      if (length(cells) == 0) return(character(0))
      cells <- gsub("<t[dh][^>]*>(.*?)</t[dh]>", "\\1", cells, ignore.case = TRUE)
      html_format(cells)
    })
    
    table_data <- table_data[lengths(table_data) > 0]
    if (!is.null(header_data)) table_data <- append(list(header_data), table_data)
    
    n_cols <- max(lengths(table_data))
    table_data <- lapply(table_data, function(r) {
      length(r) <- n_cols
      r[is.na(r)] <- ""
      r
    })
    col_widths <- sapply(seq_len(n_cols), function(i) {
      max(nchar(strip_ansi(vapply(table_data, function(r) r[[i]], ""))))
    })
    
    render_row <- function(row) {
      paste(mapply(function(z, w) format(z, width = w, justify = "left"), row, col_widths),
            collapse = " | ")
    }
    
    header <- render_row(table_data[[1]])
    sep <- paste(mapply(function(w) paste(rep("-", w), collapse = ""), col_widths), collapse = "-+-")
    body <- vapply(table_data[-1], render_row, character(1))
    
    paste(c(bold(header), sep, body), collapse = "\n")
  }
  
  output_parts <- character(0)
  for (i in seq_along(split_parts)) {
    text_block <- html_format(split_parts[i])
    if (nzchar(text_block)) output_parts <- c(output_parts, text_block)
    if (i <= length(tables)) {
      output_parts <- c(output_parts, render_table(tables[i]))
    }
  }
  
  cat(paste(output_parts, collapse = "\n\n"), "\n")
  
  invisible(x)
}


