snapshot_bin_cumulants <- function(object, breaks = seq(0, 1, length.out = 11),
                                   nodes = NULL) {
  # Model cumulants for a uniform design within each bin. Average raw moments
  # first, then convert to cumulants; averaging conditional cumulants would
  # give a different quantity.
  if (length(breaks) < 2 || any(!is.finite(breaks)) || any(diff(breaks) <= 0) ||
      min(breaks) < 0 || max(breaks) > 1)
    stop("Supply increasing bin boundaries in [0,1].", call. = FALSE)
  model <- snapshot_fitted_model(object)
  if (is.null(nodes)) nodes <- max(8, 2 * max(length(model$mu_coef), nrow(model$v_coef)))
  quad <- snapshot_gauss_legendre(nodes)
  rows <- lapply(seq_len(length(breaks) - 1), function(j) {
    time <- breaks[j] + diff(breaks)[j] * quad$time
    K <- snapshot_cumulant_curves(model, time, 4)
    m <- K[, 1]; v <- K[, 2]; a <- K[, 3]; b <- K[, 4]
    raw <- cbind(m, v + m^2, a + 3 * m * v + m^3,
                 b + 4 * m * a + 3 * v^2 + 6 * m^2 * v + m^4)
    M <- drop(crossprod(quad$weight, raw))
    data.frame(lower = breaks[j], upper = breaks[j + 1],
               time = mean(breaks[j:(j + 1)]), kappa1 = M[1], kappa2 = M[2] - M[1]^2,
               kappa3 = M[3] - 3 * M[1] * M[2] + 2 * M[1]^3,
               kappa4 = M[4] - 4 * M[1] * M[3] - 3 * M[2]^2 +
                 12 * M[1]^2 * M[2] - 6 * M[1]^4)
  })
  do.call(rbind, rows)
}