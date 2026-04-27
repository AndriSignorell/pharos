
#' Symbolic Unit Conversion Engine
#'
#' Converts numeric values between units using a symbolic unit system,
#' SI-derived expansions, and graph-based conversion for non-SI units.
#'
#' Supports:
#' \itemize{
#'   \item SI base units (m, kg, s, A, K, mol, cd)
#'   \item Derived units (N, Pa, J, W, Hz)
#'   \item Prefixes (k, m, µ, etc.)
#'   \item Compound units (e.g. \code{"km/h"}, \code{"kg*m/s^2"})
#'   \item Unit powers (e.g. \code{"m2"}, \code{"s^-1"})
#'   \item Temperature conversion (C, F, K)
#' }
#'
#' The function internally:
#' \enumerate{
#'   \item Parses units into symbolic components
#'   \item Expands derived units (e.g. \code{N = kg*m/s^2})
#'   \item Computes dimensional vectors
#'   \item Applies prefix scaling
#'   \item Uses a graph search (Dijkstra) for non-SI conversions
#' }
#'
#' @param x Numeric value(s) to convert.
#' @param from Character string specifying the source unit.
#' @param to Character string specifying the target unit.
#' @param prefix Data frame of SI prefixes with columns
#'   \code{abbr} and \code{mult}.
#' @param units Data frame of unit conversion factors with columns
#'   \code{from}, \code{to}, and \code{fact}.
#'
#' @return Numeric value(s) converted to the target unit.
#'
#' @details
#' The function checks dimensional consistency before conversion.
#' If units are not compatible, an error is thrown.
#'
#' For non-SI units (e.g. \code{"mi"}, \code{"bar"}), conversion
#' paths are resolved via a graph representation of \code{d.units}.
#'
#' Temperature conversions are handled separately and do not use
#' multiplicative scaling.
#'
#' @examples
#' convUnit(100, "km/h", "m/s")
#' 
#' convUnit(1, "N", "kg*m/s^2")
#' convUnit(1, "Pa", "N/m^2")
#' convUnit(25, "C", "F")
#' convUnit(1, "ml", "l")
#'
#' @seealso \code{\link{unit}}
#'
#' @family topic.conversion
#' @concept unit-conversion
#' @concept symbolic-units


#' @export
convUnit <- local({
  
  expr_cache <- new.env(parent = emptyenv())

  .same_dim <- function(a, b) {
    if (any(is.na(a)) || any(is.na(b))) return(FALSE)
    identical(unname(a), unname(b))
  }
  
  # -----------------------------
  # persistent state
  # -----------------------------
  edges_cache <- NULL
  edges_sig   <- NULL
  
  # -----------------------------
  # dimensions (once)
  # -----------------------------
  zero_dim <- function() c(L=0,M=0,T=0,I=0,Th=0,N=0,J=0)
  
  add_dim <- function(a,b) {
    out <- zero_dim()
    for(n in names(out)) out[n] <- (a[n] %||% 0) + (b[n] %||% 0)
    out
  }
  
  mul_dim <- function(a,k) a * k
  
  # -----------------------------
  # symbol definitions (once)
  # -----------------------------
  sym_defs <- list(
    m   = list(dim = c(L=1,M=0,T=0,I=0,Th=0,N=0,J=0)),
    kg  = list(dim = c(L=0,M=1,T=0,I=0,Th=0,N=0,J=0)),
    s   = list(dim = c(L=0,M=0,T=1,I=0,Th=0,N=0,J=0)),
    A   = list(dim = c(L=0,M=0,T=0,I=1,Th=0,N=0,J=0)),
    K   = list(dim = c(L=0,M=0,T=0,I=0,Th=1,N=0,J=0)),  # compound units only
    mol = list(dim = c(L=0,M=0,T=0,I=0,Th=0,N=1,J=0)),
    cd  = list(dim = c(L=0,M=0,T=0,I=0,Th=0,N=0,J=1)),
    Hz  = list(expr="1/s"),
    N   = list(expr="kg*m/s^2"),
    Pa  = list(expr="N/m^2"),
    J   = list(expr="N*m"),
    W   = list(expr="J/s")
  )
  
  # -----------------------------
  # graph builder with signature
  # -----------------------------
  build_edges <- function(d.units) {
    sig <- paste(d.units$from, d.units$to, d.units$fact, collapse="|")
    if (is.null(edges_cache) || edges_sig != sig) {
      edges_cache <<- rbind(
        data.frame(from=as.character(d.units$from),
                   to=as.character(d.units$to),
                   w=log(d.units$fact)),
        data.frame(from=as.character(d.units$to),
                   to=as.character(d.units$from),
                   w=-log(d.units$fact))
      )
      edges_sig <<- sig
    }
    edges_cache
  }
  
  # -----------------------------
  # graph conversion (SAFE)
  # -----------------------------
  convert_graph <- function(from, to, edges) {
    nodes <- unique(c(edges$from, edges$to))
    if (!(from %in% nodes)) stop(paste("Unknown unit in graph:", from))
    if (!(to   %in% nodes)) return(NA)
    dist    <- setNames(rep(Inf,   length(nodes)), nodes)
    visited <- setNames(rep(FALSE, length(nodes)), nodes)
    dist[from] <- 0
    repeat {
      cur <- names(which.min(ifelse(visited, Inf, dist)))
      if (length(cur)==0 || is.infinite(dist[cur])) break
      if (cur == to) break
      visited[cur] <- TRUE
      idx <- which(edges$from == cur)
      for (i in idx) {
        nxt <- edges$to[i]
        alt <- dist[cur] + edges$w[i]
        if (alt < dist[nxt]) dist[nxt] <- alt
      }
    }
    if (is.infinite(dist[to])) return(NA)
    exp(dist[to])
  }
  
  # -----------------------------
  # parsing (once)
  # -----------------------------
  split_power <- function(u) {
    m <- regexpr("(-?\\d+)$", u)
    if (m[1] == -1) return(list(unit=u, pow=1))
    pow  <- as.numeric(substr(u, m[1], nchar(u)))
    base <- substr(u, 1, m[1]-1)
    base <- sub("\\^$", "", base)
    list(unit=base, pow=pow)
  }
  
  parse <- function(u) {
    parts <- strsplit(u, "/", fixed=TRUE)[[1]]
    num <- strsplit(parts[1], "\\*")[[1]]
    den <- if (length(parts) > 1)
      unlist(lapply(parts[-1], function(x) strsplit(x, "\\*")[[1]]))
    else character(0)
    list(num=num, den=den)
  }
  
  # -----------------------------
  # FIX: distribute power into expression
  # e.g. "kg*m/s^2", pow=2  →  "kg^2*m^2/s^4"
  # -----------------------------
  distribute_pow <- function(expr, pow) {
    if (pow == 1) return(expr)
    p <- parse(expr)
    apply_pow <- function(tok) {
      sp <- split_power(tok)
      new_pow <- sp$pow * pow
      if (new_pow == 1) sp$unit else paste0(sp$unit, "^", new_pow)
    }
    num <- sapply(p$num, apply_pow)
    den <- sapply(p$den, apply_pow)
    paste0(
      paste(num, collapse="*"),
      if (length(den) > 0) paste0("/", paste(den, collapse="*")) else ""
    )
  }
  
  # -----------------------------
  # symbolic expansion (FIX 1: no brackets)
  # -----------------------------
  
  expand_unit <- function(u, depth=0) {
    
    expand_token <- function(tok, sign=1) {
      sp   <- split_power(tok)
      base <- sp$unit
      pow  <- sp$pow
      if (!(base %in% names(sym_defs))) return(list(num=tok, den=character(0)))
      expr <- sym_defs[[base]]$expr
      if (is.null(expr)) {
        t <- if(pow==1) base else paste0(base,"^",pow)
        return(list(num=t, den=character(0)))
      }
      expanded <- expand_unit(expr, depth+1)
      dist     <- distribute_pow(expanded, pow)
      p2       <- parse(dist)
      list(num=p2$num, den=p2$den)
    }
  
    if (depth > 10) stop("Expansion too deep")
    p   <- parse(u)
    out_num <- character(0)
    out_den <- character(0)
    
    for (tok in p$num) {
      r <- expand_token(tok, depth)
      out_num <- c(out_num, r$num)
      out_den <- c(out_den, r$den)
    }
    
    for (tok in p$den) {
      sp  <- split_power(tok)
      r   <- expand_token(paste0(sp$unit,"^",-sp$pow), depth)
      out_num <- c(out_num, r$num)
      out_den <- c(out_den, r$den)
    }
    paste0(
      paste(out_num, collapse="*"),
      if(length(out_den)>0) paste0("/", paste(out_den, collapse="*")) else ""
    )
  }
  
  # -----------------------------
  # MAIN FUNCTION
  # -----------------------------
  function(x, from, to, 
           prefix = NULL, 
           units = NULL) {
    
    if (is.null(prefix)) prefix <- d.prefix
    if (is.null(units))  units  <- d.units
    
    stopifnot(is.numeric(x), is.character(from), is.character(to))
    
    edges       <- build_edges(units)
    graph_nodes <- unique(c(edges$from, edges$to))
    
    known_units <- unique(c(names(sym_defs), 
                            as.character(units$from), 
                            as.character(units$to)))
    
    # ---------------------------
    # prefix splitting
    # ---------------------------
    split_prefix <- function(u) {
      if (u == "1")  return(list(mult=1, unit=u))
      if (u == "kg") return(list(mult=1, unit="kg"))   # protect kg
      if (u %in% known_units) return(list(mult=1, unit=u))
      
      pattern <- "^(da|[YZEPTGMkhdcmunpfazy])"
      m <- regexpr(pattern, u)
      
      if (m[1] == -1) return(list(mult=1, unit=u))
      
      pref <- substr(u, m[1], m[1] + attr(m,"match.length")-1)
      
      base <- substr(u, attr(m,"match.length")+1, nchar(u))
      
      if (!(base %in% known_units)) return(list(mult=1, unit=u))
      
      mult <- prefix$mult[match(pref, prefix$abbr)]
      if (is.na(mult)) return(list(mult=1, unit=u))
      list(mult=mult, unit=base)
    }
    
    # ---------------------------
    # unit evaluation
    # ---------------------------
    eval_unit <- function(u) {
      
      u   <- expand_unit(u) 
      p   <- parse(u)
      total_dim  <- zero_dim()
      total_mult <- 1
      
      candidates <- graph_nodes[vapply(graph_nodes, function(n) {
        split_power(n)$unit %in% names(sym_defs)
      }, logical(1))]
      
      
      process <- function(parts, sign=1) {
        for (x in parts) {
          if (x == "1") next
          sp   <- split_power(x)
          pr   <- split_prefix(sp$unit)
          base <- pr$unit
          pow  <- sp$pow * sign
          
          if (base %in% names(sym_defs)) {
            d <- sym_defs[[base]]$dim %||% zero_dim()
            total_dim  <<- add_dim(total_dim, mul_dim(d, pow))
          }
          
          total_mult <<- total_mult * unname(pr$mult ^ pow)
          
          if (!(base %in% names(sym_defs))) {
            
            if (!(base %in% graph_nodes))
              stop(paste("Unknown unit:", base))

            vals <- vapply(candidates,
                           function(t) convert_graph(base, t, edges),
                           numeric(1))
            ok <- which(!is.na(vals))
            if (length(ok) == 0) stop(paste("Unknown unit:", base))
            if (length(ok) >  1) warning(paste("Ambiguous mapping for", base))
            
            target <- candidates[ok[1]]
            val    <- vals[ok[1]]
            
            total_mult <<- total_mult * unname(val ^ pow)
            sp_t    <- split_power(target)
            base_t  <- sp_t$unit
            
            pow_t   <- sp_t$pow
            d_t <- sym_defs[[base_t]]$dim
            if (is.null(d_t)) {
              # derived (expr): Pa, N, J, W, Hz
              expr <- sym_defs[[base_t]]$expr
              
              if (exists(expr, envir = expr_cache, inherits = FALSE)) {
                d_t <- expr_cache[[expr]]
              } else {
                d_t <- eval_unit(expr)$dim
                expr_cache[[expr]] <- d_t
              }
              
            }
            target_dim <- mul_dim(d_t, pow_t)
            total_dim  <<- add_dim(total_dim, mul_dim(target_dim, pow))
            
          }
        }
      }
      
      process(p$num, +1)
      process(p$den, -1)
      list(dim=total_dim, mult=total_mult)
    }
    
    # ---------------------------
    # temperature special case
    # ---------------------------
    if (from %in% c("C","F","K") || to %in% c("C","F","K")) {
      toK <- function(v,u) switch(u,
                                  C = v + 273.15,
                                  F = (v - 32) * 5/9 + 273.15,
                                  K = v,
                                  stop("Invalid temperature unit")
      )
      fromK <- function(v,u) switch(u,
                                    C = v - 273.15,
                                    F = (v - 273.15) * 9/5 + 32,
                                    K = v,
                                    stop("Invalid temperature unit")
      )
      return(fromK(toK(x, from), to))
    }
    
    u_from <- eval_unit(from)
    u_to   <- eval_unit(to)
    
    if (!.same_dim(u_from$dim, u_to$dim))
      stop("Units not dimensionally compatible")
    
    x * u_from$mult / u_to$mult
  }
})

