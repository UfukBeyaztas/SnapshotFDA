snapshot_log_density_values <- function(model, time, response, B_mu = NULL, B_v = NULL,
                                        max_cells = 1000000) {
  n <- length(time)
  if (is.null(B_mu)) B_mu <- snapshot_chebyshev(time, length(model$mu_coef) - 1)
  if (is.null(B_v)) B_v <- snapshot_chebyshev(time, nrow(model$v_coef) - 1)
  components <- as.double(sum(model$score[[1]]$weight > 0)) *
    sum(model$score[[2]]$weight > 0)
  batch_size <- max(1, min(n, floor(max_cells / components)))
  out <- numeric(n)
  for (first in seq(1, n, by = batch_size)) {
    use <- first:min(n, first + batch_size - 1)
    comp <- snapshot_components(model, time[use], B_mu[use, , drop = FALSE],
                                B_v[use, , drop = FALSE])
    out[use] <- snapshot_row_log_sum_exp(snapshot_component_log_density(comp, response[use]))
  }
  out
}