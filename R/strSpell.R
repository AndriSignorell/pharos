#' Spell Strings Using Phonetic Alphabets
#'
#' Converts characters in a string into their corresponding phonetic
#' representations using either the NATO phonetic alphabet or Morse code.
#'
#' @param x a character vector (typically of length 1)
#' @param upr character string used as a prefix for uppercase letters.
#'   Default is \code{"CAP"}. If \code{NA}, no prefix is added.
#' @param type character string specifying the encoding system:
#' \itemize{
#'   \item \code{"NATO"}: NATO phonetic alphabet (default)
#'   \item \code{"Morse"}: Morse code
#' }
#'
#' @return A character vector with each character of \code{x} replaced by its
#'   phonetic representation.
#'
#' @details
#' Letters (A–Z, a–z) and digits (0–9) are mapped to their corresponding
#' phonetic representations. Other characters are returned unchanged.
#'
#' For \code{type = "NATO"}, uppercase letters can optionally be prefixed
#' (e.g., \code{"CAP Alfa"}) to distinguish them from lowercase letters.
#'
#' The function uses Unicode-aware character splitting via
#' \code{\link[stringi]{stri_split_boundaries}}.
#'
#' @seealso \code{\link{strTrim}},
#'   \code{\link[stringi]{stri_split_boundaries}}
#'
#' @examples
#' # NATO spelling
#' strSpell("ABC")
#'
#' # with digits
#' strSpell("A1B2")
#'
#' # Morse code
#' strSpell("SOS", type = "Morse")
#'
#' # without uppercase prefix
#' strSpell("ABC", upr = NA)
#'



#' @seealso
#' [string-overview] for an overview of all string utilities in lyra.
#'
#' @concept string-manipulation
#' @concept phonetic-encoding
#'
#'
#' @export
strSpell <- function(x, upr = "CAP", type = c("NATO", "Morse")) {
  
  type <- match.arg(type)
  upr <- naReplace(upr, "")
  
  chars <- stringi::stri_split_boundaries(x, type = "character")[[1]]
  
  if (type == "NATO") {
    
    letters_map <- setNames(
      c("Alfa","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel",
        "India","Juliett","Kilo","Lima","Mike","November","Oscar","Papa",
        "Quebec","Romeo","Sierra","Tango","Uniform","Victor","Whiskey",
        "Xray","Yankee","Zulu"),
      LETTERS
    )
    
    letters_map_lower <- setNames(letters_map, tolower(LETTERS))
    
    digits_map <- setNames(
      c("Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine"),
      as.character(0:9)
    )
    
    res <- sapply(chars, function(ch) {
      if (ch %in% LETTERS) {
        if (!is.na(upr)) paste(upr, letters_map[ch]) else letters_map[ch]
      } else if (ch %in% tolower(LETTERS)) {
        letters_map_lower[ch]
      } else if (ch %in% names(digits_map)) {
        digits_map[ch]
      } else {
        ch
      }
    })
    
  } else {
    
    letters_map <- setNames(
      c(".-","-...","-.-.","-..",".","..-.","--.","....","..",".---",
        "-.-",".-..","--","-.","---",".--.","--.-",".-.","...","-",
        "..-","...-",".--","-..-","-.--","--.."),
      LETTERS
    )
    
    letters_map_lower <- setNames(letters_map, tolower(LETTERS))
    
    digits_map <- setNames(
      c("-----",".----","..---","...--","....-",".....",
        "-....","--...","---..","----."),
      as.character(0:9)
    )
    
    res <- sapply(chars, function(ch) {
      if (ch %in% LETTERS) {
        letters_map[ch]
      } else if (ch %in% tolower(LETTERS)) {
        letters_map_lower[ch]
      } else if (ch %in% names(digits_map)) {
        digits_map[ch]
      } else {
        ch
      }
    })
  }
  
  strTrim(res)
}
