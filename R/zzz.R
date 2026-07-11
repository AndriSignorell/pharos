


.onLoad <- function(libname, pkgname) {
  
  current <- getOption("lyra.theme", list())
  options(lyra.theme = utils::modifyList(.themeDefaults, current))
  
}
  



#' @useDynLib lyra, .registration = TRUE


#' @importFrom Rcpp sourceCpp
#' 
#' @importFrom graphics plot hist abline par points text axTicks axis grid layout lines mtext rect title polygon strheight strwidth clip  image grconvertX grconvertY segments barplot box matplot layout.show arrows plot.new plot.window close.screen screen split.screen rug curve contour persp boxplot cdplot frame spineplot
#'             
#' @importFrom grDevices rgb col2rgb rgb2hsv colors colorRampPalette xy.coords heat.colors dev.size gray.colors rainbow adjustcolor dev.off png dev.cur
#'             
#' @importFrom utils head tail combn readRegistry modifyList
#' 
#' @importFrom stats qt sd as.dendrogram dist hclust order.dendrogram filter relevel setNames is.ts time prop.test predict qnorm formula var model.frame model.response model.weights terms na.omit acf plot.ts pacf complete.cases dnorm quantile uniroot density as.formula chisq.test na.pass lm ftable median
#'             
#' @importFrom stringi stri_sub stri_length stri_pad stri_trim_both stri_extract_first_regex
#' 
#' @importFrom bedrock abind `%)(%` `%(]%` coalesceX moveAvg binaryTree combPairs decToHex isZero mergeArgs nDec naIf naReplace setNamesX recycle label `label<-` sortX revX resolveFormula isNA callIf midx getDotsArg linScale locf appendX isLowCardinality
#' 
#' @importFrom base64enc base64encode
#' 
NULL
