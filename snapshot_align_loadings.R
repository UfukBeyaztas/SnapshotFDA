snapshot_align_loadings <- function(estimate, truth, weights = rep(1, nrow(truth))) {
  if (!all(dim(estimate) == dim(truth)) || ncol(truth) != 2)
    stop("Both loading matrices must have two columns on the same grid.", call. = FALSE)
  best <- Inf; aligned <- estimate; chosen <- NULL
  for (p in list(c(1, 2), c(2, 1))) for (a in c(-1, 1)) for (b in c(-1, 1)) {
    v <- sweep(estimate[, p, drop = FALSE], 2, c(a, b), "*")
    loss <- sum(weights * rowSums((v - truth)^2))
    if (loss < best) { best <- loss; aligned <- v; chosen <- list(permutation = p, sign = c(a, b)) }
  }
  list(loadings = aligned, integrated_squared_error = best, transformation = chosen)
}