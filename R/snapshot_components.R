snapshot_components <- function(model, time, B_mu = NULL, B_v = NULL) {
  time <- snapshot_check_time(time)
  if (!isTRUE(model$valid)) stop("Invalid score distribution.", call. = FALSE)
  if (is.null(B_mu)) B_mu <- snapshot_chebyshev(time, length(model$mu_coef) - 1)
  if (is.null(B_v)) B_v <- snapshot_chebyshev(time, nrow(model$v_coef) - 1)
  mu <- drop(B_mu %*% model$mu_coef); V <- B_v %*% model$v_coef
  s1 <- model$score[[1]]; s2 <- model$score[[2]]
  active1 <- which(s1$weight > 0); active2 <- which(s2$weight > 0)
  ij <- list(k1 = rep(active1, times = length(active2)),
             k2 = rep(active2, each = length(active1)))
  weight <- s1$weight[ij$k1] * s2$weight[ij$k2]
  means <- outer(V[, 1], s1$mean[ij$k1]) + outer(V[, 2], s2$mean[ij$k2]) + mu
  variances <- outer(V[, 1]^2, s1$variance[ij$k1]) +
    outer(V[, 2]^2, s2$variance[ij$k2]) + model$sigma2
  list(weight = weight, mean = means, variance = variances, index = ij,
       mu = mu, V = V)
}
