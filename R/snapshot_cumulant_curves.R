snapshot_cumulant_curves <- function(object, time, max_order = 8, derivative = 0) {
  snapshot_check_scalar(max_order, "max_order", 2, 20, integer = TRUE)
  snapshot_check_scalar(derivative, "derivative", 0, 2, integer = TRUE)
  model <- snapshot_fitted_model(object)
  V <- snapshot_loadings(model, time)
  D <- snapshot_loadings(model, time, 1)
  DD <- snapshot_loadings(model, time, 2)
  cumulants <- lapply(model$score, function(s) snapshot_score_cumulants(s, max_order)$cumulant)
  out <- matrix(0, length(time), max_order)
  out[, 1] <- drop(snapshot_chebyshev(time, length(model$mu_coef) - 1, derivative) %*%
                     model$mu_coef)
  for (r in 2:max_order) {
    term <- switch(derivative + 1, V^r, r * V^(r - 1) * D,
                   r * ((r - 1) * V^(r - 2) * D^2 + V^(r - 1) * DD))
    out[, r] <- drop(term %*% c(cumulants[[1]][r], cumulants[[2]][r]))
  }
  if (derivative == 0) out[, 2] <- out[, 2] + model$sigma2
  colnames(out) <- paste0("kappa", seq_len(max_order))
  out
}
