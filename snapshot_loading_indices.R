snapshot_loading_indices <- function(v_coef, quadrature = NULL, polynomials = NULL) {
  J <- nrow(v_coef) - 1
  if (is.null(quadrature)) quadrature <- snapshot_gauss_legendre(2 * J + 2)
  V <- snapshot_chebyshev(quadrature$time, J) %*% v_coef
  alpha <- snapshot_normalized_gram(V, quadrature$weight)
  gamma <- snapshot_normalized_gram(cbind(1, V^2), quadrature$weight)
  tau <- lapply(seq_len(2), function(k) snapshot_tau(v_coef[, k], polynomials))
  list(alpha = alpha$index, gamma = gamma$index,
       tau = min(vapply(tau, function(z) z$value, numeric(1))),
       tau_details = tau, alpha_matrix = alpha$matrix, gamma_matrix = gamma$matrix)
}