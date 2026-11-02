snapshot_frequency_kernels <- function(object, time, frequency) {
  model <- snapshot_fitted_model(object)
  V <- snapshot_loadings(model, time)
  D <- snapshot_loadings(model, time, 1)
  DD <- snapshot_loadings(model, time, 2)
  out <- array(0 + 0i, c(length(frequency), 5, length(time)))
  for (i in seq_along(time)) for (k in seq_len(2)) {
    z <- frequency * V[i, k]
    cf <- snapshot_score_cf(model$score[[k]], z)
    if (any(Mod(cf) < 1e-10)) stop("A score characteristic function is near zero.", call. = FALSE)
    c1 <- snapshot_score_cf(model$score[[k]], z, 1)
    c2 <- snapshot_score_cf(model$score[[k]], z, 2)
    N1 <- c1 / cf + z
    N2 <- c2 / cf - (c1 / cf)^2 + 1
    out[, , i] <- out[, , i] + cbind(
      z * N1, z * N1 + z^2 * N2, frequency * D[i, k] * N1,
      frequency * D[i, k] * N1 + frequency^2 * V[i, k] * D[i, k] * N2,
      frequency * DD[i, k] * N1 + frequency^2 * D[i, k]^2 * N2)
  }
  dimnames(out) <- list(NULL, paste0("N", seq_len(5)), NULL)
  out
}
