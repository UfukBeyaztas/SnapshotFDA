snapshot_empirical_cumulants <- function(time, response, breaks = seq(0, 1, length.out = 11),
                                         bootstrap = 200, seed = NULL) {
  kstat <- function(y) {
    n <- length(y); d <- y - mean(y)
    m2 <- mean(d^2); m3 <- mean(d^3); m4 <- mean(d^4)
    c(kappa1 = mean(y), kappa2 = n / (n - 1) * m2,
      kappa3 = n^2 / ((n - 1) * (n - 2)) * m3,
      kappa4 = n^2 * ((n + 1) * m4 - 3 * (n - 1) * m2^2) / ((n - 1) * (n - 2) * (n - 3)))
  }
  snapshot_with_seed(seed, function() {
    bin <- cut(time, breaks, include.lowest = TRUE, labels = FALSE)
    rows <- lapply(seq_len(length(breaks) - 1), function(j) {
      y <- response[bin == j]
      if (length(y) < 8) return(NULL)
      est <- kstat(y)
      boot <- replicate(bootstrap, kstat(sample(y, replace = TRUE)))
      data.frame(lower = breaks[j], upper = breaks[j + 1], time = mean(time[bin == j]),
                 n = length(y), t(est), t(setNames(apply(boot, 1, sd), paste0("se_", names(est)))),
                 check.names = FALSE)
    })
    do.call(rbind, rows)
  })
}