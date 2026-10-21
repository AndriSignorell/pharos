
#include <Rcpp.h>
#include <iomanip>
#include <sstream>
#include <cmath>
using namespace Rcpp;

// Hilfsfunktion: Rundung auf 10er, 100er etc.
double round_to_power(double value, int power) {
  double factor = std::pow(10.0, -power);
  return std::round(value / factor) * factor;
}

// [[Rcpp::export]]
CharacterVector formatNum_cpp(NumericVector x,
                          Nullable<IntegerVector> digits = R_NilValue,
                          Nullable<IntegerVector> leadDigits = R_NilValue,
                          Nullable<CharacterVector> bigMark = R_NilValue,
                          Nullable<CharacterVector> decimalMark = R_NilValue,
                          int sciBig = 9999,
                          int sciSmall = -9999) {
  
  int n = x.size();
  
  // Whether 'digits' was supplied matters further down: the default rule
  // below counts DECIMALS for fixed notation, which is the wrong quantity
  // once a value ends up in scientific notation.
  const bool digitsSupplied = digits.isNotNull();
  
  // digits: default = 7 signifikante Stellen
  IntegerVector dig(n);
  if (digits.isNotNull()) {
    IntegerVector dvec(digits);
    // i % 0 is undefined behaviour: an empty 'digits' (integer(0)) must be
    // caught here, before the recycling loop. The check on nd further down
    // only sees 'dig', which always has length n.
    const R_xlen_t ndv = dvec.size();
    if (n > 0 && ndv == 0)
      stop("'digits' must not be empty");
    // NA_integer_ is INT_MIN and would reach std::pow(10, d) below; an NA
    // as the number of digits is an invalid argument, not a missing value
    for (R_xlen_t j = 0; j < ndv; ++j)
      if (dvec[j] == NA_INTEGER)
        stop("'digits' must not contain NA");
    for (int i = 0; i < n; ++i) dig[i] = dvec[i % ndv];
  } else {
    for (int i = 0; i < n; ++i) {
      if (NumericVector::is_na(x[i]) || !R_FINITE(x[i])) {
        // (int) std::floor(std::log10(Inf)) below would be a cast of an
        // out-of-range value, i.e. undefined behaviour
        dig[i] = 7;
      } else if (x[i] == 0) {
        dig[i] = 6;
      } else {
        double absx = std::abs(x[i]);
        int magnitude = (int)std::floor(std::log10(absx));
        dig[i] = std::max(0, 7 - magnitude - 1);
      }
    }
  }
  
  // leadDigits: default = 0
  IntegerVector ldig = leadDigits.isNotNull() ? IntegerVector(leadDigits) : IntegerVector::create(0);
  for (R_xlen_t j = 0; j < ldig.size(); ++j)
    if (ldig[j] == NA_INTEGER)
      stop("'leadDigits' must not contain NA");
  
  // bigMark: default = ""
  CharacterVector bmark = bigMark.isNotNull() ? CharacterVector(bigMark) : CharacterVector::create("");
  
  // decimalMark: default = getOption("OutDec")
  CharacterVector dmark;
  if (decimalMark.isNotNull()) {
    dmark = CharacterVector(decimalMark);
  } else {
    Environment base("package:base");
    Function getOption = base["getOption"];
    dmark = CharacterVector::create(as<std::string>(getOption("OutDec")));
  }
  
  int nd = dig.size();
  int nl = ldig.size();
  int nb = bmark.size();
  int ndm = dmark.size();
  
  // i % 0 is undefined behaviour, and a zero-length argument is easy to
  // produce from R (leadDigits = integer(0)). 'digits' is checked above,
  // before it is recycled into 'dig' (nd == n here).
  if (n > 0 && (nl == 0 || nb == 0 || ndm == 0))
    stop("'leadDigits', 'bigMark' and 'decimalMark' must not be empty");
  
  CharacterVector result(n);
  
  for (int i = 0; i < n; ++i) {
    double val = x[i];
    if (NumericVector::is_na(val)) {
      result[i] = NA_STRING;
      continue;
    }
    
    int d = dig[i % nd];
    int l = ldig[i % nl];
    std::string bm = as<std::string>(bmark[i % nb]);
    std::string dm = as<std::string>(dmark[i % ndm]);
    
    // Inf reached the scientific branch below and came out as the C++
    // spelling "inf"; R writes "Inf". NaN never gets here - is_na() above
    // covers it, in step with is.na() on the R side.
    if (!R_FINITE(val)) {
      result[i] = val > 0 ? "Inf" : "-Inf";
      continue;
    }
    
    double abs_val = std::abs(val);
    std::ostringstream ss;
    
    bool use_sci = false;
    if (abs_val > 0) {
      double log10val = std::log10(abs_val);
      use_sci = (log10val >= sciBig) || (log10val < sciSmall);
    }
    
    if (use_sci) {
      // Wissenschaftliche Notation.
      // The default 'd' is the number of DECIMALS for fixed notation. In
      // scientific notation setprecision() counts the decimals of the
      // MANTISSA, so that rule collapses: a value of 1e15 got d = 0 and
      // printed as "1e+15", a value of 1e-9 got d = 15 and printed as
      // "1.234500000000000e-09". Without an explicit 'digits' we therefore
      // ask for 7 significant digits, i.e. 6 mantissa decimals - R's
      // default. An explicit 'digits' keeps its meaning (fmt = "e").
      const int sciPrec = digitsSupplied ? std::max(d, 0) : 6;
      ss << std::scientific << std::setprecision(sciPrec) << val;
      std::string sci_str = ss.str();
      
      // OutDec ersetzen
      if (dm != ".") {
        size_t dot = sci_str.find('.');
        if (dot != std::string::npos) {
          sci_str.replace(dot, 1, dm);
        }
      }
      result[i] = sci_str;
      continue;
    }
    
    // Normale Formatierung mit Rundung
    double rounded_val;
    int effective_digits;
    
    if (d >= 0) {
      rounded_val = std::round(val * std::pow(10.0, d)) / std::pow(10.0, d);
      effective_digits = d;
    } else {
      rounded_val = round_to_power(val, d);
      effective_digits = 0;
    }
    
    ss << std::fixed << std::setprecision(effective_digits) << std::abs(rounded_val);
    std::string num = ss.str();
    
    size_t dot_pos = num.find('.');
    std::string int_part = dot_pos != std::string::npos ? num.substr(0, dot_pos) : num;
    std::string dec_part = dot_pos != std::string::npos ? num.substr(dot_pos + 1) : "";
    
    if ((int)int_part.length() < l) {
      int_part = std::string(l - int_part.length(), '0') + int_part;
    }
    
    std::string grouped;
    int len = int_part.length();
    for (int j = 0; j < len; ++j) {
      grouped += int_part[j];
      if ((len - j - 1) % 3 == 0 && j != len - 1) {
        grouped += bm;
      }
    }
    
    std::string full = grouped;
    if (effective_digits > 0) {
      full += dm + dec_part;
    }
    
    if (l == 0) {
      // erase leading digits if leadDigits == 0
      if (full.rfind("0" + dm, 0) == 0) {
        full.erase(0, 1);            // "0.23" -> ".23"
      }
    }
    
    if (rounded_val < 0) {
      full = "-" + full;
    }
    
    result[i] = full;
  }
  
  return result;
}
