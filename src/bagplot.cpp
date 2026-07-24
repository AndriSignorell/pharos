

// bagplot.cpp
//
// Rcpp implementation of the bagplot (bivariate boxplot).
//
// Algorithm (Rousseeuw, Ruts & Tukey 1999):
//   1. Compute halfspace (Tukey) depth for every point.
//      Direct port of Fortran TUKDEPTH from the archived 'depth' package
//      (Rousseeuw & Ruts 1996, Applied Statistics 45, 516-526).
//   2. Tukey median = mean of all points with maximal depth (approximation
//      of the depth median; HALFMED would compute the exact one).
//   3. Bag: radial interpolation between the convex hulls of the depth
//      regions D_{k-1} and D_k (with #D_k <= floor(n/2) < #D_{k-1}),
//      so that the bag contains floor(n/2) observations.
//   4. Fence = bag inflated around the Tukey median by `factor`.
//      The fence is used for classification only and is never drawn.
//   5. Outliers = points outside the fence.
//   6. Loop = convex hull of the non-outlying points (inside the fence).
//
// Entry point: bagplot_compute_cpp(xy, factor, eps, dither)

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

// ------------------------------------------------------------------
//  ray_hull_dist: distance from interior point (cx,cy) to the boundary
//  of a convex polygon along direction (ux,uy). Returns max t with
//  (cx,cy) + t*(ux,uy) on an edge; 0 if no intersection (degenerate).
// ------------------------------------------------------------------
static double ray_hull_dist(double cx, double cy, double ux, double uy,
                            const std::vector<double>& vx,
                            const std::vector<double>& vy) {
  int m = (int)vx.size();
  double tmax = 0.0;
  for (int i = 0, j = m - 1; i < m; j = i++) {
    double ex = vx[i] - vx[j], ey = vy[i] - vy[j];
    double den = ux * ey - uy * ex;                 // cross(u, e)
    if (std::abs(den) < 1e-300) continue;           // ray parallel to edge
    double wx = vx[j] - cx, wy = vy[j] - cy;
    double t = (wx * ey - wy * ex) / den;           // along ray
    double s = (wx * uy - wy * ux) / den;           // along edge [0,1]
    if (t > 0.0 && s >= -1e-12 && s <= 1.0 + 1e-12)
      tmax = std::max(tmax, t);
  }
  return tmax;
}

// ==================================================================
//  bagplot_compute_cpp — exported R entry point
// ==================================================================
// [[Rcpp::export]]
List bagplot_compute_cpp(NumericMatrix xy,
                         double factor = 3.0,
                         double eps    = 1e-8,
                         bool   dither = true) {

  int n = xy.nrow();
  if (n < 3) stop("bagplot_compute_cpp: need at least 3 data points.");

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
  int max_d = *std::max_element(depths.begin(), depths.end());

  // ---- 2. Tukey median: mean of all points with maximal depth ----
  // Approximation of the depth median (exact: HALFMED). The mean of the
  // deepest points lies inside every depth-region hull, so it is a valid
  // center for the radial interpolation below.
  double med_x = 0.0, med_y = 0.0;
  {
    int cnt = 0;
    for (int i = 0; i < n; ++i)
      if (depths[i] == max_d) { med_x += x[i]; med_y += y[i]; cnt++; }
    med_x /= cnt; med_y /= cnt;
  }

  // ---- 3. Bag: interpolate depth-region hulls to floor(n/2) points ----
  // counts[k] = #D_k = number of points with depth >= k (decreasing in k)
  std::vector<int> counts(max_d + 2, 0);
  for (int i = 0; i < n; ++i)
    for (int k = 1; k <= depths[i]; ++k) counts[k]++;

  int half = std::max(3, (int)std::floor(n / 2.0));
  int k1 = max_d;                          // smallest region with #D_k <= half
  for (int k = 1; k <= max_d; ++k)
    if (counts[k] <= half) { k1 = k; break; }
  int k0 = k1 - 1;                          // #D_{k0} > half (k0 >= 1 since counts[1] = n)

  std::vector<double> in_x, in_y, out_x_, out_y_;
  bool ties_only = false;
  if (counts[k1] > half) {
    // massive ties: even the deepest region exceeds half -> bag = hull(D_max)
    k0 = k1 = max_d;
    ties_only = true;
  }
  for (int i = 0; i < n; ++i) {
    if (depths[i] >= k1) { in_x.push_back(x[i]);  in_y.push_back(y[i]); }
    if (depths[i] >= k0) { out_x_.push_back(x[i]); out_y_.push_back(y[i]); }
  }

  // hull polygons of the inner (D_{k1}) and outer (D_{k0}) regions
  auto hullPoly = [](const std::vector<double>& hx, const std::vector<double>& hy,
                     std::vector<double>& vx, std::vector<double>& vy) {
    std::vector<int> h = convex_hull(hx, hy);
    vx.clear(); vy.clear();
    for (int id : h) { vx.push_back(hx[id]); vy.push_back(hy[id]); }
  };
  std::vector<double> ivx, ivy, ovx, ovy;
  hullPoly(in_x,  in_y,  ivx, ivy);
  hullPoly(out_x_, out_y_, ovx, ovy);

  // Degenerate data (collinear): outer hull not a polygon -> no regions
  if ((int)ovx.size() < 3) {
    NumericMatrix e(0, 2);
    colnames(e) = CharacterVector::create("x", "y");
    NumericVector dep_r(n);
    for (int i = 0; i < n; ++i) dep_r[i] = depths[i];
    return List::create(
      Named("center")   = NumericVector::create(med_x, med_y),
      Named("depth")    = k1,
      Named("bag")      = e,
      Named("fence")    = clone(e),
      Named("loop")     = clone(e),
      Named("outliers") = clone(e),
      Named("depths")   = dep_r
    );
  }

  // interpolation directions: all hull vertex angles around the Tukey median
  std::vector<double> angs;
  for (size_t i = 0; i < ovx.size(); ++i)
    angs.push_back(std::atan2(ovy[i] - med_y, ovx[i] - med_x));
  for (size_t i = 0; i < ivx.size(); ++i)
    angs.push_back(std::atan2(ivy[i] - med_y, ivx[i] - med_x));
  std::sort(angs.begin(), angs.end());
  angs.erase(std::unique(angs.begin(), angs.end()), angs.end());

  // radial distances to both hull boundaries per direction
  int na = (int)angs.size();
  bool inner_poly = (int)ivx.size() >= 3;
  std::vector<double> ca(na), sa(na), r0(na), r1(na);
  for (int i = 0; i < na; ++i) {
    ca[i] = std::cos(angs[i]); sa[i] = std::sin(angs[i]);
    r0[i] = ray_hull_dist(med_x, med_y, ca[i], sa[i], ovx, ovy);
    r1[i] = inner_poly ? ray_hull_dist(med_x, med_y, ca[i], sa[i], ivx, ivy) : 0.0;
  }

  // Interpolated polygon P(mu): r = r1 + mu*(r0 - r1), mu in [0,1].
  // The point count in P(mu) grows monotonically from #D_{k1} (<= half)
  // to #D_{k0} (> half). Instead of the linear lambda from the region
  // counts (which only approximates the target), calibrate mu by binary
  // search so that the bag contains exactly floor(n/2) observations
  // (up to ties on the boundary).
  auto bagCount = [&](double mu, std::vector<double>& px, std::vector<double>& py) {
    px.resize(na); py.resize(na);
    for (int i = 0; i < na; ++i) {
      double r = r1[i] + mu * (r0[i] - r1[i]);
      px[i] = med_x + r * ca[i];
      py[i] = med_y + r * sa[i];
    }
    int cnt = 0;
    for (int i = 0; i < n; ++i)
      if (point_in_polygon(x[i], y[i], px, py, eps)) cnt++;
    return cnt;
  };

  std::vector<double> bag_x, bag_y;
  if (ties_only) {
    bagCount(0.0, bag_x, bag_y);            // bag = inner hull
  } else {
    double lo = 0.0, hi = 1.0;
    for (int it = 0; it < 40; ++it) {       // smallest mu with count >= half
      double mid = 0.5 * (lo + hi);
      std::vector<double> px, py;
      if (bagCount(mid, px, py) >= half) hi = mid; else lo = mid;
    }
    bagCount(hi, bag_x, bag_y);
  }
  // ensure convex, ordered polygon
  {
    std::vector<double> tx, ty;
    hullPoly(bag_x, bag_y, tx, ty);
    if (tx.size() >= 3) { bag_x = tx; bag_y = ty; }
  }

  int nb = (int)bag_x.size();

  // ---- 4. Fence: inflate bag around the Tukey median (never drawn) ----
  std::vector<double> fence_x(nb), fence_y(nb);
  for (int i = 0; i < nb; ++i) {
    fence_x[i] = med_x + factor * (bag_x[i] - med_x);
    fence_y[i] = med_y + factor * (bag_y[i] - med_y);
  }

  // ---- 5. Outliers: points outside the fence ----
  // ---- 6. Loop: convex hull of the points inside the fence ----
  std::vector<int> out_idx;
  std::vector<double> keep_x, keep_y;
  for (int i = 0; i < n; ++i) {
    if (point_in_polygon(x[i], y[i], fence_x, fence_y, eps)) {
      keep_x.push_back(xy(i,0)); keep_y.push_back(xy(i,1));
    } else {
      out_idx.push_back(i);
    }
  }
  std::vector<double> loop_x, loop_y;
  hullPoly(keep_x, keep_y, loop_x, loop_y);

  // ---- Build result matrices ----
  auto asMat = [](const std::vector<double>& mx, const std::vector<double>& my) {
    int m = (int)mx.size();
    NumericMatrix out(m, 2);
    for (int i = 0; i < m; ++i) { out(i,0) = mx[i]; out(i,1) = my[i]; }
    colnames(out) = CharacterVector::create("x", "y");
    return out;
  };

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
    Named("depth")    = k1,
    Named("bag")      = asMat(bag_x, bag_y),
    Named("fence")    = asMat(fence_x, fence_y),
    Named("loop")     = asMat(loop_x, loop_y),
    Named("outliers") = out_mat,
    Named("depths")   = dep_r
  );
}
