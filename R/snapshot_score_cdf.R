snapshot_score_cdf <- function(score, x) {
  if (!isTRUE(score$valid)) stop("Invalid score distribution.", call. = FALSE)
  out <- numeric(length(x))
  for (j in seq_along(score$weight)) {
    if (score$weight[j] == 0) next
    out <- out + score$weight[j] * if (score$variance[j] > 0)
      pnorm((x - score$mean[j]) / sqrt(score$variance[j])) else as.numeric(x >= score$mean[j])
  }
  out
}
