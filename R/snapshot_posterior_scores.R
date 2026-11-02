snapshot_posterior_scores <- function(object, time, response) {
  model <- snapshot_fitted_model(object)
  snapshot_data(time, response)
  comp <- snapshot_components(model, time)
  logp <- snapshot_component_log_density(comp, response)
  posterior <- exp(logp - snapshot_row_log_sum_exp(logp))
  n <- length(time); K <- ncol(posterior)
  # Within component k the scores given Y are normal with mean m and
  # covariance diag(d) - b b' / var_k, b = V diag(d); the three distinct
  # entries of the second moments are accumulated over subjects at once.
  means <- matrix(0, n, 2)
  second11 <- second12 <- second22 <- numeric(n)
  for (k in seq_len(K)) {
    j <- comp$index$k1[k]; l <- comp$index$k2[k]
    a <- c(model$score[[1]]$mean[j], model$score[[2]]$mean[l])
    d <- c(model$score[[1]]$variance[j], model$score[[2]]$variance[l])
    b <- sweep(comp$V, 2, d, "*")
    m <- matrix(a, n, 2, byrow = TRUE) + b * ((response - comp$mean[, k]) / comp$variance[, k])
    p <- posterior[, k]; v <- comp$variance[, k]
    means <- means + m * p
    second11 <- second11 + p * (d[1] - b[, 1]^2 / v + m[, 1]^2)
    second12 <- second12 + p * (m[, 1] * m[, 2] - b[, 1] * b[, 2] / v)
    second22 <- second22 + p * (d[2] - b[, 2]^2 / v + m[, 2]^2)
  }
  covariance <- array(0, c(2, 2, n))
  covariance[1, 1, ] <- second11 - means[, 1]^2
  covariance[1, 2, ] <- covariance[2, 1, ] <- second12 - means[, 1] * means[, 2]
  covariance[2, 2, ] <- second22 - means[, 2]^2
  list(mean = means, covariance = covariance, mixture_probability = posterior)
}
