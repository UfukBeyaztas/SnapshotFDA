snapshot_score_jacobian <- function(theta) {
  # Rows: theta_1, theta_2, theta_3. Columns: (w_1, w_2, m_1, m_2, s2_1, s2_2)
  # of snapshot_normal_score(theta), differentiated in closed form.
  s <- snapshot_normal_score(theta)
  w <- s$weight[1]; b <- theta[2]; r2 <- exp(2 * theta[3])
  dw <- w * (1 - w)
  h <- sqrt((1 - w) / w)
  slope <- (1 + b^2)^(-3 / 2)
  D <- (1 + b^2) * (w * r2 + 1 - w)
  dD <- c((1 + b^2) * (r2 - 1) * dw, 2 * b * (w * r2 + 1 - w), 2 * (1 + b^2) * w * r2)
  J <- matrix(0, 3, 6)
  J[1, 1:2] <- c(dw, -dw)
  J[1, 3:4] <- c(-s$mean[1] / 2, s$mean[2] / 2)
  J[2, 3:4] <- c(h * slope, -slope / h)
  J[, 5] <- -s$variance[1] * dD / D
  J[, 6] <- -s$variance[2] * dD / D
  J[3, 5] <- J[3, 5] + 2 * s$variance[1]
  J
}