snapshot_frequency_gram <- function(object, time, frequency_radius = NULL,
                                    nodes = 80, rank_tolerance = 1e-10) {
  model <- snapshot_fitted_model(object)
  if (is.null(model$spec))
    stop("Supply a fitted model with its compact-class constants.", call. = FALSE)
  spec <- model$spec
  # |M(z)-1| <= |z| M0 / {e(c0-|z|)} < 1 on this conservative disc.
  zero_free_radius <- spec$c0 / (4 * spec$M0)
  loading_bound <- spec$A * spec$rho / (spec$rho - 1)
  safe_radius <- 0.9 * zero_free_radius / loading_bound
  if (is.null(frequency_radius)) frequency_radius <- safe_radius
  snapshot_check_scalar(frequency_radius, "frequency_radius", 0, strict_lower = TRUE)
  quad <- snapshot_gauss_legendre(nodes)
  u <- frequency_radius * (2 * quad$time - 1)
  weights <- 2 * frequency_radius * quad$weight
  kernels <- snapshot_frequency_kernels(model, time, u)
  G <- array(NA_real_, c(4, 4, length(time)))
  xi <- matrix(NA_real_, length(time), 4)
  rank <- numeric(length(time)); minimum <- numeric(length(time))
  condition <- numeric(length(time)); imaginary <- numeric(length(time))
  for (i in seq_along(time)) {
    M <- kernels[, , i]
    A <- rbind(Re(M[, 1:4] * sqrt(weights)), Im(M[, 1:4] * sqrt(weights)))
    b <- c(Re(M[, 5] * sqrt(weights)), Im(M[, 5] * sqrt(weights)))
    sv <- svd(A, nu = 4, nv = 4)
    rank[i] <- sum(sv$d > rank_tolerance * sv$d[1])
    G[, , i] <- crossprod(A)
    minimum[i] <- min(sv$d)^2
    condition[i] <- if (min(sv$d) == 0) Inf else (max(sv$d) / min(sv$d))^2
    if (rank[i] == 4) xi[i, ] <- drop(sv$v %*% (crossprod(sv$u, b) / sv$d))
    full <- Conj(t(M)) %*% (M * weights)
    imaginary[i] <- max(abs(Im(full)))
  }
  list(time = time, gram = G, xi = xi, numerical_rank = rank,
       smallest_eigenvalue = minimum, condition_number = condition,
       imaginary_residual = imaginary, frequency_radius = frequency_radius,
       conservative_analytic_radius_satisfied = frequency_radius <= safe_radius)
}
