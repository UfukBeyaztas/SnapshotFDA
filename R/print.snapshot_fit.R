print.snapshot_fit <- function(x, ...) {
  cat("Snapshot FDA (", x$spec$sieve, " sieve)\n", sep = "")
  cat(x$status, "\n")
  cat("Subjects:", x$n, " Loading degree:", x$spec$degree,
      " Mean degree:", x$spec$mean_degree, "\n")
  if (x$success) {
    cat("Log-likelihood:", format(x$loglik, digits = 8),
        " Noise variance:", format(x$model$sigma2, digits = 6), "\n")
    cat("Constraint violation:", format(x$diagnostics$primal_violation, digits = 3),
        " Projected stationarity:", format(x$diagnostics$stationarity, digits = 3), "\n")
  }
  cat("Elapsed seconds:", round(x$elapsed, 2), "\n")
  invisible(x)
}
