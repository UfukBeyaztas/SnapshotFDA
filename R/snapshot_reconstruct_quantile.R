snapshot_reconstruct_quantile <- function(object, time, response,
                                          grid = seq(0, 1, length.out = 101),
                                          probability = c(0.05, 0.5, 0.95)) {
  model <- snapshot_fitted_model(object)
  snapshot_data(time, response)
  comp <- snapshot_components(model, time)
  logp <- snapshot_component_log_density(comp, response)
  posterior <- exp(logp - snapshot_row_log_sum_exp(logp))
  mu <- snapshot_mean(model, grid); V <- snapshot_loadings(model, grid)
  K <- ncol(posterior)
  out <- array(NA_real_, c(length(time), length(grid), length(probability)),
               dimnames = list(NULL, NULL, paste0("p", probability)))
  for (i in seq_along(time)) {
    M <- S <- matrix(0, length(grid), K)
    for (k in seq_len(K)) {
      j <- comp$index$k1[k]; l <- comp$index$k2[k]
      a <- c(model$score[[1]]$mean[j], model$score[[2]]$mean[l])
      d <- c(model$score[[1]]$variance[j], model$score[[2]]$variance[l])
      b <- comp$V[i, ] * d
      m <- a + b * (response[i] - comp$mean[i, k]) / comp$variance[i, k]
      Sk <- diag(d, 2) - tcrossprod(b) / comp$variance[i, k]
      M[, k] <- mu + drop(V %*% m)
      S[, k] <- pmax(0, rowSums((V %*% Sk) * V))
    }
    out[i, , ] <- snapshot_mixture_quantile(posterior[i, ], M, S, probability)
  }
  list(grid = grid, quantile = out, probability = probability)
}
