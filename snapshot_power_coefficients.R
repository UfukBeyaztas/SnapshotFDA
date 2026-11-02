snapshot_power_coefficients <- function(coef, polynomials = NULL) {
  if (is.null(polynomials)) polynomials <- snapshot_chebyshev_polynomials(length(coef) - 1)
  out <- rep(0, length(coef))
  for (j in seq_along(coef)) {
    p <- polynomials[[j]]
    out[seq_along(p)] <- out[seq_along(p)] + coef[j] * p
  }
  out
}