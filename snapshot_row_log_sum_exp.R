snapshot_row_log_sum_exp <- function(x) {
  if (!is.matrix(x)) x <- matrix(x, nrow = 1)
  a <- x[, 1]
  if (ncol(x) > 1) for (j in 2:ncol(x)) a <- pmax(a, x[, j])
  good <- is.finite(a)
  out <- a
  if (any(good)) out[good] <- a[good] + log(rowSums(exp(x[good, , drop = FALSE] - a[good])))
  out
}