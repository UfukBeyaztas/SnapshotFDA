snapshot_model <- function(mu_coef, v_coef, sigma2, score, spec = NULL) {
  if (!is.matrix(v_coef) || ncol(v_coef) != 2 || nrow(v_coef) < 1 ||
      any(!is.finite(v_coef)) || !is.numeric(mu_coef) || !length(mu_coef) ||
      any(!is.finite(mu_coef)) || length(score) != 2)
    stop("Supply mean coefficients, a two-column loading matrix, and two score laws.", call. = FALSE)
  snapshot_check_scalar(sigma2, "sigma2", 0)
  for (s in score) {
    if (!isTRUE(s$valid) || !length(s$weight) ||
        length(s$mean) != length(s$weight) || length(s$variance) != length(s$weight) ||
        any(!is.finite(c(s$weight, s$mean, s$variance))) ||
        any(s$weight < 0) || any(s$variance < 0) || abs(sum(s$weight) - 1) > 1e-9 ||
        abs(sum(s$weight * s$mean)) > 1e-8 ||
        abs(sum(s$weight * (s$variance + s$mean^2)) - 1) > 1e-8)
      stop("Score distributions must be centered and standardized.", call. = FALSE)
  }
  list(mu_coef = as.numeric(mu_coef), v_coef = v_coef, sigma2 = sigma2,
       score = score, valid = TRUE, spec = spec)
}