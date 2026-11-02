snapshot_spec <- function(degree = 2, mean_degree = degree,
                          sieve = c("normal", "atomic"),
                          A = 3, rho = 1.5, A_mu = 2.5, rho_mu = 1.5,
                          sigma2_min = 0.01, sigma2_max = 3,
                          alpha_min = 0.01, gamma_min = 0.0001,
                          tau_min = 0.02, nd_min = 0.002,
                          c0 = 0.3, M0 = 10,
                          w_min = 0.1, b_max = 6, r_max = 3,
                          nd_points = 401) {
  sieve <- match.arg(sieve)
  snapshot_check_scalar(degree, "degree", 1, integer = TRUE)
  snapshot_check_scalar(mean_degree, "mean_degree", 1, integer = TRUE)
  if (sieve == "atomic" && mean_degree != degree)
    stop("The atomic sieve requires mean_degree = degree.", call. = FALSE)
  for (nm in c("A", "A_mu", "sigma2_min", "alpha_min", "gamma_min",
               "tau_min", "nd_min", "c0", "M0", "b_max")) {
    snapshot_check_scalar(get(nm), nm, 0, strict_lower = TRUE)
  }
  for (nm in c("rho", "rho_mu", "r_max"))
    snapshot_check_scalar(get(nm), nm, 1, strict_lower = TRUE)
  snapshot_check_scalar(sigma2_max, "sigma2_max", sigma2_min, strict_lower = TRUE)
  snapshot_check_scalar(w_min, "w_min", 0, 0.5, strict_lower = TRUE)
  if (w_min == 0.5 || alpha_min >= 1 || gamma_min >= 1 || M0 <= 1)
    stop("Use w_min < 1/2, alpha_min,gamma_min < 1, and M0 > 1.", call. = FALSE)
  snapshot_check_scalar(nd_points, "nd_points", 3, integer = TRUE)
  out <- as.list(environment())
  out <- out[c("degree", "mean_degree", "sieve", "A", "rho", "A_mu", "rho_mu",
               "sigma2_min", "sigma2_max", "alpha_min", "gamma_min", "tau_min",
               "nd_min", "c0", "M0", "w_min", "b_max", "r_max", "nd_points")]
  out$mixture_box <- c(qlogis(1 - w_min), b_max, log(r_max))
  out$grid <- if (sieve == "atomic") seq(-degree^2, degree^2) / degree else NULL
  max_mean <- sqrt((1 - w_min) / w_min) * b_max / sqrt(1 + b_max^2)
  max_variance <- max(1, r_max^2 / (w_min * r_max^2 + 1 - w_min))
  out$normal_moment_bound <- 2 * exp(c0 * max_mean + c0^2 * max_variance / 2)
  out$moment_constraints <- sieve == "atomic" || M0 < out$normal_moment_bound
  class(out) <- "snapshot_spec"
  out
}
