snapshot_ode_coefficients <- function(object, time, tolerance = 1e-8) {
  V <- snapshot_loadings(object, time)
  D <- snapshot_loadings(object, time, 1)
  DD <- snapshot_loadings(object, time, 2)
  ell <- D / V
  dell <- DD / V - ell^2
  valid <- apply(abs(V) > tolerance, 1, all) & abs(ell[, 1] - ell[, 2]) > tolerance
  xi <- matrix(NA_real_, length(time), 4)
  a <- ell[valid, 1]; b <- ell[valid, 2]
  da <- dell[valid, 1]; db <- dell[valid, 2]
  xi[valid, ] <- cbind((a * db - b * da) / (a - b), -a * b,
                       (da - db) / (a - b), a + b)
  colnames(xi) <- paste0("xi", seq_len(4))
  list(time = time, xi = xi, logarithmic_derivative = ell, valid = valid)
}
