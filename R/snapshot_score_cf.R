snapshot_score_cf <- function(score, u, derivative = 0) {
  if (!isTRUE(score$valid)) return(rep(NA_complex_, length(u)))
  if (!derivative %in% 0:2) stop("derivative must be 0, 1, or 2.", call. = FALSE)
  out <- rep(0 + 0i, length(u))
  for (j in which(score$weight > 0)) {
    z <- exp(1i * u * score$mean[j] - u^2 * score$variance[j] / 2)
    d <- 1i * score$mean[j] - u * score$variance[j]
    if (derivative == 1) z <- z * d
    if (derivative == 2) z <- z * (d^2 - score$variance[j])
    out <- out + score$weight[j] * z
  }
  out
}
