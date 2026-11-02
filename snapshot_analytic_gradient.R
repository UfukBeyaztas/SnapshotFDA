snapshot_analytic_gradient <- function(q, context, difference_step = 0.00001) {
  spec <- context$spec; layout <- context$layout
  model <- snapshot_decode(q, spec, layout)
  if (!model$valid)
    return(snapshot_central_gradient(function(p) snapshot_objective(p, context), q, difference_step))
  n <- nrow(context$data); y <- context$data$response
  mu <- drop(context$B_mu %*% model$mu_coef); V <- context$B_v %*% model$v_coef
  a <- V[, 1]; b <- V[, 2]
  s1 <- model$score[[1]]; s2 <- model$score[[2]]
  K1 <- length(s1$weight); K2 <- length(s2$weight)
  k1 <- rep(seq_len(K1), times = K2); k2 <- rep(seq_len(K2), each = K1)
  mean_c <- mu + outer(a, s1$mean[k1]) + outer(b, s2$mean[k2])
  var_c <- outer(a^2, s1$variance[k1]) + outer(b^2, s2$variance[k2]) + model$sigma2
  L0 <- -0.5 * (log(2 * pi) + log(var_c) + (y - mean_c)^2 / var_c)
  wc <- s1$weight[k1] * s2$weight[k2]
  # Normalize by the weighted terms. On a face of the atomic simplex a
  # zero-weight component can have the largest unweighted density by
  # hundreds of log units, and normalizing by it would underflow every
  # positive-weight term. log_p is the log density of snapshot_objective.
  Lw <- sweep(L0, 2, log(wc), "+")                       # -Inf for zero weights
  top <- Lw[cbind(seq_len(n), max.col(Lw, ties.method = "first"))]
  log_p <- top + log(rowSums(exp(Lw - top)))
  r <- exp(Lw - log_p)                                   # responsibilities
  ratio <- exp(L0 - log_p)                               # unweighted density over p
  e <- (y - mean_c) / var_c
  re <- r * e
  rh <- r * (e^2 - 1 / var_c) / 2
  g <- numeric(layout$length)
  g[layout$mu] <- crossprod(context$B_mu, rowSums(re))
  g[layout$v1] <- crossprod(context$B_v, drop(re %*% s1$mean[k1]) + 2 * a * drop(rh %*% s1$variance[k1]))
  g[layout$v2] <- crossprod(context$B_v, drop(re %*% s2$mean[k2]) + 2 * b * drop(rh %*% s2$variance[k2]))
  g[layout$noise] <- model$sigma2 * sum(rh)
  P1 <- outer(k1, seq_len(K1), "==") * 1; P2 <- outer(k2, seq_len(K2), "==") * 1
  # d log p_i / d w1_m = sum_l w2_l phi_{i,ml} / p_i, also when w1_m = 0
  D1 <- colSums(ratio %*% (P1 * s2$weight[k2]))
  D2 <- colSums(ratio %*% (P2 * s1$weight[k1]))
  # A zero-weight term can exceed the floating-point range on a face of the
  # simplex. The derivative there is then the bounded difference quotient
  # of Algorithm 1, the rule used by snapshot_central_gradient.
  if (any(!is.finite(c(D1, D2))) || max(abs(c(D1, D2))) > 1e10 * n)
    return(snapshot_central_gradient(function(p) snapshot_objective(p, context), q, difference_step))
  G1 <- drop(colSums(re * a) %*% P1); G2 <- drop(colSums(re * b) %*% P2)
  if (spec$sieve == "normal") {
    H1 <- drop(colSums(rh * a^2) %*% P1); H2 <- drop(colSums(rh * b^2) %*% P2)
    g[layout$score1] <- drop(snapshot_score_jacobian(s1$theta) %*% c(D1, G1, H1))
    g[layout$score2] <- drop(snapshot_score_jacobian(s2$theta) %*% c(D2, G2, H2))
  } else {
    for (k in 1:2) {
      s <- model$score[[k]]; D <- if (k == 1) D1 else D2; G <- if (k == 1) G1 else G2
      sd <- sqrt(s$raw_variance)
      dW <- D - (s$grid / sd) * sum(G) - ((s$grid - s$raw_mean)^2 / (2 * sd^2)) * sum(G * s$mean)
      g[if (k == 1) layout$score1 else layout$score2] <- (dW - sum(s$weight * dW)) / s$raw_sum
    }
  }
  -g / n * layout$width
}