snapshot_score_cumulants <- function(score, max_order = 8) {
  snapshot_check_scalar(max_order, "max_order", 2, 20, integer = TRUE)
  moments <- numeric(max_order + 1); moments[1] <- 1
  for (j in seq_along(score$weight)) {
    a <- numeric(max_order + 1); a[1] <- 1; a[2] <- score$mean[j]
    for (r in 2:max_order)
      a[r + 1] <- score$mean[j] * a[r] + (r - 1) * score$variance[j] * a[r - 1]
    moments <- moments + score$weight[j] * c(0, a[-1])
  }
  cumulants <- numeric(max_order)
  for (r in seq_len(max_order)) {
    z <- moments[r + 1]
    if (r >= 2) for (k in seq_len(r - 1))
      z <- z - choose(r - 1, k - 1) * cumulants[k] * moments[r - k + 1]
    cumulants[r] <- z
  }
  names(cumulants) <- paste0("kappa", seq_len(max_order))
  list(moment = moments, cumulant = cumulants)
}
