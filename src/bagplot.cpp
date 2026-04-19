

// bagplot.cpp
//
// Rcpp implementation of the bagplot (bivariate boxplot).
//
// Algorithm:
//   1. Compute halfspace (Tukey) depth for every point.
//      Direct port of Fortran TUKDEPTH from the archived 'depth' package
//      (Rousseeuw & Ruts 1996, Applied Statistics 45, 516-526).
//   2. Find k* = depth of the floor(n/2)-th deepest point (bag contains ~50%).
//   3. Bag   = convex hull of all points with depth >= k*.
//   4. Tukey median = mean of all points with maximal depth (argmax depth).
//   5. Loop  = inflate bag around the Tukey median by `factor`.
//   6. Outliers = points outside the loop polygon.
//
// Entry point: bagplot_compute(xy, factor, eps, dither)

#include <Rcpp.h>
#include <algorithm>
#include <vector>
#include <cmath>

using namespace Rcpp;

// ------------------------------------------------------------------
//  indexx: stable argsort ascending, returns 0-based permutation
// ------------------------------------------------------------------
static void indexx(int n, const std::vector<double>& a, std::vector<int>& idx) {
  idx.resize(n);
  for (int i = 0; i < n; ++i) idx[i] = i;
  std::stable_sort(idx.begin(), idx.end(),
                   [&](int p, int q){ return a[p] < a[q]; });
}


// ------------------------------------------------------------------
//  randm: machine-independent LCG from Fortran RANDM (period 2^16)
// ------------------------------------------------------------------
static void randm(int& nrun, double& ran) {
  nrun = nrun * 5761 + 999;
  int k = nrun / 65536;
  nrun -= k * 65536;
  ran  = (double)nrun / 65536.0;
}

// ------------------------------------------------------------------
//  tukdepth: halfspace depth of (u,v) in n-point cloud (x,y).
//
//  Direct translation of Fortran TUKDEPTH (Rousseeuw & Ruts 1996).
//  beta[0..n-1] and f[0..n-1] are work arrays (modified in place).
//  Returns integer depth count.
// ------------------------------------------------------------------
static int tukdepth(double u, double v,
                    int n,
                    const std::vector<double>& x,
                    const std::vector<double>& y,
                    std::vector<double>& beta,
                    std::vector<int>&    f,
                    double epsi) {
  if (n < 1) return 0;
  const double PI  = M_PI;
  const double PI2 = M_PI * 2.0;
  int nz = 0;
  
  // Build angle array
  for (int i = 0; i < n; ++i) {
    double d = std::sqrt((x[i]-u)*(x[i]-u) + (y[i]-v)*(y[i]-v));
    if (d <= epsi) { nz++; continue; }
    double xu = (x[i]-u)/d, yu = (y[i]-v)/d, ang;
    if (std::abs(xu) > std::abs(yu)) {
      if (x[i] >= u) { ang = std::asin(yu); if (ang < 0.0) ang += PI2; }
      else             ang = PI - std::asin(yu);
    } else {
      if (y[i] >= v)  ang = std::acos(xu);
      else             ang = PI2 - std::acos(xu);
    }
    if (ang >= PI2 - epsi) ang = 0.0;
    beta[i - nz] = ang;
  }
  
  int nn = n - nz;
  if (nn <= 1) return nz;
  
  // Sort beta, carry f
  {
    std::vector<int> idx;
    indexx(nn, beta, idx);
    std::vector<double> tb(nn); std::vector<int> tf(nn);
    for (int i = 0; i < nn; ++i) { tb[i] = beta[idx[i]]; tf[i] = f[idx[i]]; }
    for (int i = 0; i < nn; ++i) { beta[i] = tb[i]; f[i] = tf[i]; }
  }
  
  // Check if (u,v) is outside the data cloud
  double angle = beta[0] - beta[nn-1] + PI2;
  for (int i = 1; i < nn; ++i) angle = std::max(angle, beta[i] - beta[i-1]);
  if (angle > PI + epsi) return nz;
  
  // Shift smallest beta to 0, count nu
  angle = beta[0];
  int nu = 0;
  for (int i = 0; i < nn; ++i) {
    beta[i] -= angle;
    if (beta[i] < PI - epsi) nu++;
  }
  if (nu >= nn) return nz;
  
  // Mergesort betas with antipodal angles, update F array
  int ja = 0, jb = 0;
  double alphk = beta[0], betak = beta[nu] - PI;
  int nn2 = nn * 2, pidx = nu, nf = nn;
  
  for (int j = 0; j < nn2; ++j) {
    if (alphk + epsi < betak) {
      nf++;
      if (ja < nn-1) { ja++; alphk = beta[ja]; } else alphk = PI2 + 1.0;
    } else {
      pidx++;
      if (pidx == nn) { pidx = 0; nf -= nn; }
      f[pidx] = nf;
      if (jb < nn-1) {
        jb++;
        betak = (jb + nu < nn) ? beta[jb+nu] - PI : beta[jb+nu-nn] + PI;
      } else betak = PI2 + 1.0;
    }
  }
  
  // Compute halfspace depth from F array
  int gi = 0, numh = std::min(f[0], nn - f[0]);
  angle = beta[0]; int ja2 = 0;
  for (int i = 1; i < nn; ++i) {
    if (beta[i] <= angle + epsi) ja2++;
    else { gi += ja2 + 1; ja2 = 0; angle = beta[i]; }
    int ki = f[i] - gi;
    numh = std::min(numh, std::min(ki, nn - ki));
  }
  return numh + nz;
}

// ------------------------------------------------------------------
//  compute_all_depths: halfspace depth for every point
// ------------------------------------------------------------------
static std::vector<int> compute_all_depths(int n,
                                           const std::vector<double>& x,
                                           const std::vector<double>& y,
                                           double eps) {
  std::vector<double> beta(n);
  std::vector<int>    f(n, 0), depths(n);
  for (int i = 0; i < n; ++i) {
    std::fill(f.begin(), f.end(), 0);
    depths[i] = tukdepth(x[i], y[i], n, x, y, beta, f, eps);
  }
  return depths;
}

// ------------------------------------------------------------------
//  convex_hull: Andrew's monotone chain algorithm.
//  Input:  pts = list of (x,y) pairs (indices into x/y arrays).
//  Output: hull_idx = indices (into pts) of hull vertices, CCW order.
// ------------------------------------------------------------------
static std::vector<int> convex_hull(const std::vector<double>& px,
                                    const std::vector<double>& py) {
  int n = (int)px.size();
  if (n == 0) return {};
  if (n == 1) return {0};
  if (n == 2) return {0, 1};
  
  // Sort by x, then y
  std::vector<int> idx(n);
  for (int i = 0; i < n; ++i) idx[i] = i;
  std::sort(idx.begin(), idx.end(), [&](int a, int b){
    return px[a] < px[b] || (px[a] == px[b] && py[a] < py[b]);
  });
  
  auto cross = [&](int O, int A, int B) -> double {
    return (px[A]-px[O])*(py[B]-py[O]) - (py[A]-py[O])*(px[B]-px[O]);
  };
  
  std::vector<int> hull;
  // Lower hull
  for (int i = 0; i < n; ++i) {
    while (hull.size() >= 2 && cross(hull[hull.size()-2], hull[hull.size()-1], idx[i]) <= 0)
      hull.pop_back();
    hull.push_back(idx[i]);
  }
  // Upper hull
  int lower_size = (int)hull.size() + 1;
  for (int i = n-2; i >= 0; --i) {
    while ((int)hull.size() >= lower_size && cross(hull[hull.size()-2], hull[hull.size()-1], idx[i]) <= 0)
      hull.pop_back();
    hull.push_back(idx[i]);
  }
  hull.pop_back();  // last point == first
  return hull;
}

// ------------------------------------------------------------------
//  point_in_polygon: ray-casting test with boundary tolerance.
//  Points on or very near the polygon edge are treated as inside.
// ------------------------------------------------------------------
static bool point_in_polygon(double px, double py,
                             const std::vector<double>& vx,
                             const std::vector<double>& vy,
                             double eps = 1e-10) {
  int n = (int)vx.size();
  if (n < 3) return false;
  bool inside = false;
  for (int i = 0, j = n-1; i < n; j = i++) {
    // Check if point is on this edge (within tolerance)
    double ex = vx[j]-vx[i], ey = vy[j]-vy[i];
    double len2 = ex*ex + ey*ey;
    if (len2 > 0) {
      double t = ((px-vx[i])*ex + (py-vy[i])*ey) / len2;
      if (t >= 0.0 && t <= 1.0) {
        double cx = vx[i] + t*ex - px;
        double cy = vy[i] + t*ey - py;
        if (cx*cx + cy*cy <= eps*eps) return true;  // on edge
      }
    }
    // Standard ray-casting (using <= to include boundary)
    if (((vy[i] > py) != (vy[j] > py)) &&
        (px <= (vx[j]-vx[i]) * (py-vy[i]) / (vy[j]-vy[i]) + vx[i]))
      inside = !inside;
  }
  return inside;
}

// ==================================================================
//  bagplot_compute — exported R entry point
// ==================================================================
// [[Rcpp::export]]
List bagplot_compute(NumericMatrix xy,
                     double factor = 3.0,
                     double eps    = 1e-8,
                     bool   dither = true) {
  
  int n = xy.nrow();
  if (n < 3) stop("bagplot_compute: need at least 3 data points.");
  
  std::vector<double> x(n), y(n);
  for (int i = 0; i < n; ++i) { x[i] = xy(i,0); y[i] = xy(i,1); }
  
  // Tiny dithering to break exact ties / collinearities
  if (dither) {
    double sx = 0, sy = 0;
    for (int i = 0; i < n; ++i) { sx += x[i]; sy += y[i]; }
    sx /= n; sy /= n;
    double vx = 0, vy = 0;
    for (int i = 0; i < n; ++i) {
      vx += (x[i]-sx)*(x[i]-sx); vy += (y[i]-sy)*(y[i]-sy);
    }
    double noise = eps * std::max(std::sqrt(vx/n), std::sqrt(vy/n)) * 100.0;
    int nrun = 12345;
    for (int i = 0; i < n; ++i) {
      double r;
      randm(nrun, r); x[i] += (r - 0.5) * noise;
      randm(nrun, r); y[i] += (r - 0.5) * noise;
    }
  }
  
  // ---- 1. Halfspace depth of every point ----
  std::vector<int> depths = compute_all_depths(n, x, y, eps);
  
  // ---- 2. Find median depth k* ----
  // The bag contains the innermost 50% of points (by halfspace depth).
  // k* = depth of the floor(n/2)-th deepest point.
  // Ties are handled by taking all points with depth >= k*.
  int k_star = 1;
  {
    std::vector<int> sd(depths);
    std::sort(sd.begin(), sd.end(), std::greater<int>());
    int rank50 = std::max(1, (int)std::floor(n / 2.0));
    k_star = sd[rank50 - 1];
    // Ensure at least 3 points in the bag (needed for a polygon)
    for (int k = k_star; k >= 1; --k) {
      int cnt = 0;
      for (int i = 0; i < n; ++i) if (depths[i] >= k) cnt++;
      if (cnt >= 3) { k_star = k; break; }
    }
  }
  
  // ---- 3. Bag = convex hull of points with depth >= k* ----
  std::vector<double> inner_x, inner_y;
  for (int i = 0; i < n; ++i) {
    if (depths[i] >= k_star) {
      inner_x.push_back(x[i]);
      inner_y.push_back(y[i]);
    }
  }
  
  std::vector<int> hull = convex_hull(inner_x, inner_y);
  std::vector<double> bag_x(hull.size()), bag_y(hull.size());
  for (int i = 0; i < (int)hull.size(); ++i) {
    bag_x[i] = inner_x[hull[i]];
    bag_y[i] = inner_y[hull[i]];
  }
  
  // Edge case: hull has fewer than 3 vertices (collinear / degenerate data)
  // -> no polygon possible, skip outlier detection
  if ((int)hull.size() < 3) {
    NumericMatrix bag_mat(0, 2), loop_mat(0, 2), out_mat(0, 2);
    colnames(bag_mat)  = CharacterVector::create("x", "y");
    colnames(loop_mat) = CharacterVector::create("x", "y");
    colnames(out_mat)  = CharacterVector::create("x", "y");
    NumericVector dep_r(n);
    for (int i = 0; i < n; ++i) dep_r[i] = depths[i];
    double mx = 0, my = 0;
    int max_d = *std::max_element(depths.begin(), depths.end()), cnt = 0;
    for (int i = 0; i < n; ++i) if (depths[i]==max_d) { mx+=x[i]; my+=y[i]; cnt++; }
    return List::create(
      Named("center")   = NumericVector::create(mx/cnt, my/cnt),
      Named("depth")    = k_star,
      Named("bag")      = bag_mat,
      Named("loop")     = loop_mat,
      Named("outliers") = out_mat,
      Named("depths")   = dep_r
    );
  }
  
  // ---- 4. Tukey median = mean of all points with maximal depth ----
  // This is the correct definition: argmax_{x} depth(x),
  // averaged over ties. Using the bag centroid would be biased
  // for skewed distributions (centroid shifts toward the tail).
  double med_x = 0.0, med_y = 0.0;
  {
    int max_d = *std::max_element(depths.begin(), depths.end());
    int cnt = 0;
    for (int i = 0; i < n; ++i) {
      if (depths[i] == max_d) {
        med_x += x[i];
        med_y += y[i];
        cnt++;
      }
    }
    med_x /= cnt;
    med_y /= cnt;
  }
  
  // ---- 5. Loop = inflate bag around Tukey median by factor ----
  int nb = (int)bag_x.size();
  std::vector<double> loop_x(nb), loop_y(nb);
  for (int i = 0; i < nb; ++i) {
    loop_x[i] = med_x + factor * (bag_x[i] - med_x);
    loop_y[i] = med_y + factor * (bag_y[i] - med_y);
  }
  
  // ---- 6. Outliers: original points outside loop ----
  std::vector<int> out_idx;
  for (int i = 0; i < n; ++i) {
    double xi = xy(i,0), yi = xy(i,1);
    if (!point_in_polygon(xi, yi, loop_x, loop_y, eps))
      out_idx.push_back(i);
  }
  
  // ---- Build result matrices ----
  NumericMatrix bag_mat(nb, 2);
  for (int i = 0; i < nb; ++i) { bag_mat(i,0) = bag_x[i]; bag_mat(i,1) = bag_y[i]; }
  colnames(bag_mat) = CharacterVector::create("x", "y");
  
  NumericMatrix loop_mat(nb, 2);
  for (int i = 0; i < nb; ++i) { loop_mat(i,0) = loop_x[i]; loop_mat(i,1) = loop_y[i]; }
  colnames(loop_mat) = CharacterVector::create("x", "y");
  
  int no = (int)out_idx.size();
  NumericMatrix out_mat(no, 2);
  for (int i = 0; i < no; ++i) {
    out_mat(i,0) = xy(out_idx[i], 0);
    out_mat(i,1) = xy(out_idx[i], 1);
  }
  colnames(out_mat) = CharacterVector::create("x", "y");
  
  NumericVector dep_r(n);
  for (int i = 0; i < n; ++i) dep_r[i] = depths[i];
  
  return List::create(
    Named("center")   = NumericVector::create(med_x, med_y),
    Named("depth")    = k_star,
    Named("bag")      = bag_mat,
    Named("loop")     = loop_mat,
    Named("outliers") = out_mat,
    Named("depths")   = dep_r
  );
}

