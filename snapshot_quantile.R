snapshot_quantile <- function(object, time, probability = c(0.025, 0.5, 0.975)) {
  if (anyNA(probability) || any(probability < 0 | probability > 1))
    stop("Probabilities must lie in [0, 1].", call. = FALSE)
  model <- snapshot_fitted_model(object)
  comp <- snapshot_components(model, time)
  out <- matrix(NA_real_, length(time), length(probability))
  for (i in seq_along(time)) for (j in seq_along(probability)) {
    p <- probability[j]
    if (p == 0) out[i, j] <- -Inf
    else if (p == 1) out[i, j] <- Inf
    else {
      fn <- function(y) sum(comp$weight * pnorm((y - comp$mean[i, ]) /
                                                  sqrt(comp$variance[i, ]))) - p
      lo <- min(comp$mean[i, ] - 8 * sqrt(comp$variance[i, ]))
      hi <- max(comp$mean[i, ] + 8 * sqrt(comp$variance[i, ]))
      width <- max(1, hi - lo)
      while (fn(lo) > 0) { lo <- lo - width; width <- width * 2 }
      width <- max(1, hi - lo)
      while (fn(hi) < 0) { hi <- hi + width; width <- width * 2 }
      out[i, j] <- uniroot(fn, c(lo, hi), tol = 1e-9)$root
    }
  }
  colnames(out) <- paste0("p", probability)
  out
}