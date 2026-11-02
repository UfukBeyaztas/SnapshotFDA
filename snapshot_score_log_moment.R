snapshot_score_log_moment <- function(score, c0) {
  if (!isTRUE(score$valid)) return(Inf)
  terms <- rep(-Inf, length(score$weight))
  for (j in which(score$weight > 0)) {
    m <- score$mean[j]; s2 <- score$variance[j]
    if (s2 == 0) value <- c0 * abs(m)
    else {
      sd <- sqrt(s2)
      value <- snapshot_log_sum_exp(c(
        c0 * m + c0^2 * s2 / 2 + pnorm(m / sd + c0 * sd, log.p = TRUE),
        -c0 * m + c0^2 * s2 / 2 + pnorm(-m / sd + c0 * sd, log.p = TRUE)))
    }
    terms[j] <- log(score$weight[j]) + value
  }
  snapshot_log_sum_exp(terms)
}