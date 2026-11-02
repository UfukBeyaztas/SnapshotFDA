snapshot_central_gradient <- function(fn, q, step = 0.00001) {
  gradient <- numeric(length(q))
  for (j in seq_along(q)) {
    a <- q; b <- q
    a[j] <- min(1, q[j] + step); b[j] <- max(-1, q[j] - step)
    gradient[j] <- (fn(a) - fn(b)) / (a[j] - b[j])
  }
  gradient
}