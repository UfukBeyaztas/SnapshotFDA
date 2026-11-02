snapshot_mixture_quantile <- function(weight, mean, variance, probability, iterations = 60) {
  if (!is.matrix(mean)) mean <- matrix(mean, 1)
  if (!is.matrix(variance)) variance <- matrix(variance, 1)
  sd <- sqrt(pmax(variance, 0))
  cdf <- function(y) {
    z <- (y - mean) / sd
    z[sd == 0] <- ifelse((y - mean)[sd == 0] >= 0, Inf, -Inf)
    drop(pnorm(z) %*% weight)
  }
  spread <- 10 * pmax(sd, 1e-8)
  lo <- apply(mean - spread, 1, min) - 1; hi <- apply(mean + spread, 1, max) + 1
  out <- matrix(NA_real_, nrow(mean), length(probability))
  for (j in seq_along(probability)) {
    a <- lo; b <- hi
    for (it in seq_len(iterations)) {
      m <- (a + b) / 2
      up <- cdf(m) >= probability[j]
      b[up] <- m[up]; a[!up] <- m[!up]
    }
    out[, j] <- b
  }
  colnames(out) <- paste0("p", probability)
  out
}
