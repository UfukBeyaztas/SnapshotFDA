snapshot_tau <- function(coef, polynomials = NULL) {
  p <- snapshot_power_coefficients(coef, polynomials)
  d <- snapshot_poly_derivative(p)
  dd <- snapshot_poly_derivative(d)
  candidates <- unique(c(0, 1, snapshot_real_roots(d),
                         snapshot_real_roots(snapshot_poly_add(p, dd))))
  val <- snapshot_poly_value(p, candidates)^2 + snapshot_poly_value(d, candidates)^2
  list(value = sqrt(max(0, min(val))), time = candidates[which.min(val)],
       candidates = candidates)
}