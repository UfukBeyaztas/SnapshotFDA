snapshot_starting_values <- function(context, n_start) {
  layout <- context$layout
  ols <- lm.fit(context$B_mu, context$data$response)$coefficients
  ols[!is.finite(ols)] <- 0
  mu_q <- pmin(1, pmax(-1, ols / layout$width[layout$mu]))
  residual <- context$data$response - drop(context$B_mu %*% (mu_q * layout$width[layout$mu]))
  sigma <- min(context$spec$sigma2_max, max(context$spec$sigma2_min,
                                            mean(residual^2) / 4))
  noise_q <- (log(sigma) - layout$center[layout$noise]) / layout$width[layout$noise]
  starts <- vector("list", n_start)
  for (i in seq_len(n_start)) {
    q <- runif(layout$length, -0.5, 0.5)
    q[layout$mu] <- mu_q; q[layout$noise] <- noise_q
    starts[[i]] <- q
  }
  starts
}