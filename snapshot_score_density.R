snapshot_score_density <- function(score, x) {
  if (!isTRUE(score$valid)) stop("Invalid score distribution.", call. = FALSE)
  if (any(score$variance <= 0))
    stop("An atomic score law has no density; use its atoms (mean) and weights.", call. = FALSE)
  out <- numeric(length(x))
  for (j in seq_along(score$weight))
    out <- out + score$weight[j] * dnorm(x, score$mean[j], sqrt(score$variance[j]))
  out
}